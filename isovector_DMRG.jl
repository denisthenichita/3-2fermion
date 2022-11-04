using ITensors
using LinearAlgebra
include("neutron.jl")
include("proton.jl")
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



function hamilton(sites)
  
  N=length(sites)

  #neutrons sites: 1,3,5,7,...,N-3,N-1
  #protons  sites: 2,4,6,8,...,N-2,N

  ampo = OpSum()

  for i in 1:2:N-1
    ampo .+= (i-1)/2, "Ntot", i    # neutron single particle energies
    ampo .+= (i-1)/2, "Ntot", i+1  # proton  single particle energies
  end
  
  for i in 1:2:N-1
    for j in 1:2:N-1
      ampo .+= V_pot((i+1)/2,(j+1)/2)  , "Cdagup", i  , "Cdagdn", i  , "Cdn", j  , "Cup", j   #nn pairing

      ampo .+= V_pot((i+1)/2,(j+1)/2)  , "Cdagup", i+1, "Cdagdn", i+1, "Cdn", j+1, "Cup", j+1 #pp pairing

      ampo .+= V_pot((i+1)/2,(j+1)/2)/2, "Cdagup", i  , "Cdagdn", i+1, "Cdn", j+1, "Cup", j   #iv pn pairing
      ampo .+= V_pot((i+1)/2,(j+1)/2)/2, "Cdagup", i  , "Cdagdn", i+1, "Cdn", j  , "Cup", j+1 #iv pn pairing
      ampo .+= V_pot((i+1)/2,(j+1)/2)/2, "Cdagup", i+1, "Cdagdn", i  , "Cdn", j+1, "Cup", j   #iv pn pairing
      ampo .+= V_pot((i+1)/2,(j+1)/2)/2, "Cdagup", i+1, "Cdagdn", i  , "Cdn", j  , "Cup", j+1 #iv pn pairing
    end
  end

  return MPO(ampo, sites)

end

function N_n(sites)

  ampo = OpSum()

  for i in 1:2:length(sites)-1
    ampo .+= "Ntot", i  
  end

  return MPO(ampo, sites)

end

function N_p(sites)
  
  ampo = OpSum()

  for i in 2:2:length(sites)
    ampo .+= "Ntot", i  
  end

  return MPO(ampo, sites)

end


function V_pot(i,j)
  G=-.5
  return G 
end

function solve_ground_state(sites,no_n,no_p)

  H=hamilton(sites)

  @show maxlinkdim(H)

  H = splitblocks(linkinds, H)



  N=length(sites)

  ψ₀₀ = ["Emp" for n in 1:N]

  for i in 1:2:no_n-1
    ψ₀₀[i] = "UpDn"
  end

  for i in 2:2:no_p
    ψ₀₀[i] = "UpDn"
  end

  ehf=0.0
  for i in 1:2:min(no_p,no_n)-1
    ehf += 4*(i-1)/2+3*V_pot(i,i)
  end

  for i in min(no_p,no_n)+1:2:max(no_p,no_n)-1
    ehf += 2*(i-1)/2+V_pot(i,i)
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
  setmaxdim!(sweeps, 10,20,30,50,100,200,200,1000,2000,3000)
  setcutoff!(sweeps, 1E-10)
  setnoise!(sweeps,1E-10)

    etol = 1E-6
    obs = DemoObserver(etol)

  energy, ψ = dmrg(H, ψ₀,sweeps; observer=obs)

  println("\nCorrelation energy = $energy")

  
  return ψ

end

let

L=20        # energy levels

sites = siteinds(n->isodd(n) ? "Neutron" : "Proton",2*L; conserve_qns=true)

no_n=10
no_p=8

ψ=solve_ground_state(sites,no_n,no_p)

@show inner(ψ,N_n(sites),ψ)
@show inner(ψ,N_p(sites),ψ)  

return nothing
end