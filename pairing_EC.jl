using ITensors
using LinearAlgebra
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
 if abs(energy-o.last_energy)/abs(energy) < o.energy_tol
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



function hamilton(sites,N,G)

  ϵ = fill(0.0, N)
  for i in 1:N
    ϵ[i]=i
  end
  
  ampo = OpSum()

  for i in 1:N
    ampo .+= ϵ[i], "Ntot", i  
    for j in 1:N
      ampo .+= -G, "Cdagup", i, "Cdagdn", i, "Cdn", j, "Cup", j
    end
  end

  H = MPO(ampo, sites)

  return H

end
  

function Richardson(sites,N,Nlev,N_part,G;dim_spectrum=1)

  H=hamilton(sites,N,G)

  @show maxlinkdim(H)

  H = splitblocks(linkinds, H)

  
  ψ₀₀ = ["Emp" for n in 1:Nlev]


  fermisc=Int.(N_part/2)
  
  for i in 1:fermisc
    ψ₀₀[i] = "UpDn"
  end

  ehf=0
  for i in 1:fermisc
    ehf += 2i-G
  end
  
  H=H-ehf*MPO(sites, "Id")


  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as ψ₀₀
  ψ₀ = productMPS(sites,ψ₀₀)

  # Check total number of particles:
  @show flux(ψ₀)


  #######################
  #   DMRG calculation  #
  #######################

  sweeps = Sweeps(100)
  setmaxdim!(sweeps, 5000)
  setcutoff!(sweeps, 1E-10)
  setnoise!(sweeps,1E-10)

    etol = 1E-8
    obs = DemoObserver(etol)

  energy, ψ = dmrg(H, ψ₀,sweeps; observer=obs)
  ψ₀=ψ 


  println("\nGround State Energy = $energy")

  if(dim_spectrum==1) 
    return ψ₀
  else
  
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

  

N=100        # SC levels

Nlev=N

sites = siteinds("Electron", Nlev; conserve_qns=true)

N_part=N

G_EC=[0.1*0.18224,0.6*0.18224,1.5*0.18224]
dim_EC=length(G_EC)

ψ_ec=Array{MPS}(undef,dim_EC)

  for i in 1:dim_EC
      G=G_EC[i]
      ψ_ec[i]= Richardson(sites,N,Nlev,N_part,G)
  end  

  for i in 2:dim_EC
    for j in 1:i-1
    ψ_ec[i]=ψ_ec[i]-inner(ψ_ec[j]',ψ_ec[i])*ψ_ec[j]
    end
    ψ_ec[i]=ψ_ec[i]/sqrt(inner(ψ_ec[i]',ψ_ec[i]))
  end

  ϵ = fill(0.0, N)
  for i in 1:N
    ϵ[i]=i
  end
  
  ampo = OpSum()
  for i in 1:N
    ampo .+= ϵ[i], "Ntot", i  
  end

  H_0 = MPO(ampo, sites)
  
  ampo = OpSum()
  for i in 1:N
    for j in 1:N
      ampo .+= "Cdagup", i, "Cdagdn", i, "Cdn", j, "Cup", j
    end
  end
  H_1 = MPO(ampo, sites)



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

  E_gs_G=Array{Float64}(undef,20)
  
  for i in 1:20
  
    G=i*0.1*0.18224

    E_gs=h_0 - G * h_1

    ehf=0
    for j in 1:Int.(N_part/2)
      ehf += 2j-G
    end

    EC_gs=eigvals(E_gs)

    E_gs_G[i]=EC_gs[1]-ehf
    
  end

  @show E_gs_G


return nothing
end