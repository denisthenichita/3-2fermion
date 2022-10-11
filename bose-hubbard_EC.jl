using ITensors
using LinearAlgebra
using Plots
BLAS.set_num_threads(1)
ITensors.Strided.disable_threads()

using_threaded_blocksparse = ITensors.enable_threaded_blocksparse()
  
mutable struct DemoObserver <: AbstractObserver
  energy_tol::Float64
  last_energy::Float64

  DemoObserver(energy_tol=0.0) = new(energy_tol,1000.0)
end

function ITensors.checkdone!(o::DemoObserver;kwargs...)
 sw = kwargs[:sweep]
 energy = kwargs[:energy]
 if abs(energy-o.last_energy) < o.energy_tol
   println("Stopping DMRG after sweep $sw")
   return true
 end
 # Otherwise, update last_energy and keep going
 o.last_energy = energy
 return false
end

function ITensors.measure!(o::DemoObserver; kwargs...)
 energy = kwargs[:energy]
 sweep = kwargs[:sweep]
 bond = kwargs[:bond]
 outputlevel = kwargs[:outputlevel]

 if outputlevel > 0
   #println("Sweep $sweep at bond $bond, the energy is $energy")
 end
end


function H_U(sites)
# partea care inmulteste U in Hamiltonian:
# Hamiltonianul total se scrie H_tot=ham_0+ U * H_U
    N=length(sites)
    ampo = OpSum()
    for i in 1:N
        ampo += (1/2), "N", i, "N", i
        ampo += (-1/2), "N", i
      end
    H=MPO(ampo, sites)
    return H

    end

function ham_0(sites,t)
# partea care nu depinde de U:
# Hamiltonianul total se scrie H_tot=ham_0+ U * H_U
    N=length(sites)

    ampo = OpSum()
    for b in 1:(N - 1)
      ampo += -t, "Adag", b, "A", b + 1
      ampo += -t, "Adag", b + 1, "A", b
    end
  
    ampo += -t, "Adag", 1, "A", N
    ampo += -t, "Adag", N, "A", 1
  
    H = MPO(ampo, sites)

    return H

end

function hamilton(sites,t,U)
#Hamiltonianul total
    
    N=length(sites)

    ampo = OpSum()
    for b in 1:(N - 1)
      ampo += -t, "Adag", b, "A", b + 1
      ampo += -t, "Adag", b + 1, "A", b
    end
  
    ampo += -t, "Adag", 1, "A", N
    ampo += -t, "Adag", N, "A", 1
  
    for i in 1:N
      ampo += U/2, "N", i, "N", i
      ampo += -U/2, "N", i
    end
    H = MPO(ampo, sites)
  return H

end


function occupations(ψ)

    sites=siteinds(ψ)
    N=length(sites)
    occ = fill(0.0, N)
    for j in 1:N
      orthogonalize!(ψ, j)
      psidag_j = dag(prime(ψ[j], "Site"))
      occ[j] = scalar(psidag_j * op(sites, "N", j) * ψ[j])
  
    end
  
    println("Density:")
    for j in 1:N
      println("$j $(occ[j])")
    end
    println()

    return occ
end
  

function solve_Hubbard(sites,N_part,t,U;dim_spectrum=1)
  
  N=length(sites)

  H=hamilton(sites,t,U)

  @show maxlinkdim(H)

  H = splitblocks(linkinds, H)

  state = ["0" for n in 1:N]

  n0=Int.(N/5)

  for i in 1:4
    state[i*n0]="1"
  end


  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as ψ₀₀
  ψ₀ = productMPS(sites,state)

  # Check total number of particles:
  @show flux(ψ₀)


  #######################
  #   DMRG calculation  #
  #######################

  sweeps = Sweeps(100)
  setmaxdim!(sweeps, 2000)
  setcutoff!(sweeps, 1E-8)
  setnoise!(sweeps,1E-8)

    etol = 1E-3
    obs = DemoObserver(etol)

  energy, ψ = dmrg(H, ψ₀,sweeps; observer=obs)
  ψ₀=ψ 

  #############
  #  Results  #
  #############



  occupations(ψ)

  println("\nGround State Energy = $energy")

  if(dim_spectrum==1) 
    return ψ₀
  else

    ### EXCITED STATES ###
  
    ψn=fill(ψ₀, dim_spectrum)
  
  for i in 2:dim_spectrum
    weight = 100

    ψ_init = randomMPS(sites,ψ₀₀)

    E,ψ_exc = dmrg(H,ψn[1:i-1],ψ_init,sweeps; weight=weight, observer=obs, outputlevel=1)

    ψn[i]=ψ_exc

    @show flux(ψ_exc)

    avgE2 = inner(H,ψ_exc,H,ψ_exc)
    avgE = inner(ψ_exc',H,ψ_exc)
    var = sqrt(abs(avgE2 -avgE^2))
    println("\n √(<H²>-<H>²)  = $var")

  
    # Check ψ is orthogonal to all ψ before it

    for j in 1:i-1
        println("\n |<ψn$(j)|ψn$(i)>|  = $(abs(inner(ψn[j]',ψn[i])))")
    end

  end
end

    return ψn

end

let

  

N=30     
N_part=4

sites = siteinds("Qudit", N; dim=N_part+1, conserve_number=true)


t=1


U_EC=[-1,-1.5,-2]

dim_EC=length(U_EC)

ψ_ec=Array{MPS}(undef,dim_EC)

occs=Array{Float64}(undef,N,dim_EC)

x=1:N

  for i in 1:dim_EC
      U=U_EC[i]
      ψ_ec[i]= solve_Hubbard(sites,N_part,t,U)
      occs[:,i]=occupations(ψ_ec[i])
  end 

 
  #savefig( plot(x, occs, layout = (dim_EC, 1)),"Fig_BH.png")
  
  #Gram-Schimdt orthogonalization

  for i in 2:dim_EC
    for j in 1:i-1
    ψ_ec[i]=ψ_ec[i]-inner(ψ_ec[j]',ψ_ec[i])*ψ_ec[j]
    end
    ψ_ec[i]=ψ_ec[i]/sqrt(inner(ψ_ec[i]',ψ_ec[i]))
    occs[:,i]=occupations(ψ_ec[i])
  end

  #savefig( plot(x, occs, layout = (dim_EC, 1)),"Fig_BH_2.png")

  

  H_0=ham_0(sites,t)
  H_1= H_U(sites)


  h_0=Array{Float64}(undef,dim_EC,dim_EC)
  h_1=Array{Float64}(undef,dim_EC,dim_EC)


  @time begin
  for i in 1:dim_EC
  for j in i:dim_EC
      h_0[i,j]   =inner(ψ_ec[i]',H_0,ψ_ec[j])
      h_1[i,j]   =inner(ψ_ec[i]',H_1,ψ_ec[j])

      h_0[j,i]   =h_0[i,j]  
      h_1[j,i]   =h_1[i,j]  
  end
  end 
  end
  
  EC_gs=Array{Float64}(undef,dim_EC,dim_EC)

  E_gs_U=Array{Float64}(undef,100)

  U_max=-5
  for i in 1:100
  
    U=i*U_max/100

    E_gs=h_0 + U * h_1
  
    EC_gs=eigvals(E_gs)

    E_gs_U[i]=EC_gs[1]
    
  end

  ev=eigvecs(h_0 + U_max * h_1)
  @show ev[1,1:dim_EC]

  @show E_gs_U[1]
  ψ=  solve_Hubbard(sites,N_part,t,U_max)
  
return nothing
end