using ITensors
using LinearAlgebra
include("32fermion.jl")
#
# DMRG calculation of the extended Hubbard model
# ground state wavefunction, and spin densities
#

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
   println("Sweep $sweep at bond $bond, the energy is $energy")
 end
end

let

  ITensors.Strided.set_num_threads(1)
  BLAS.set_num_threads(1)
  ITensors.disable_threaded_blocksparse()

  N = 72
  Npart = 72
  t = 1
  U = -2

  sites = siteinds("3/2fermion", N; conserve_qns=true)

  ampo = OpSum()

  for b in 1:(N - 1)
    ampo += -t, "Cdagup3", b, "Cup3", b + 1
    ampo += -t, "Cdagup3", b + 1, "Cup3", b
    #ampo += -t, "Cdagup1", b, "Cup1", b + 1
    #ampo += -t, "Cdagup1", b + 1, "Cup1", b
    #ampo += -t, "Cdagdn1", b, "Cdn1", b + 1
    #ampo += -t, "Cdagdn1", b + 1, "Cdn1", b
    #ampo += -t, "Cdagdn3", b, "Cdn3", b + 1
    #ampo += -t, "Cdagdn3", b + 1, "Cdn3", b
  end

  for b in 1:N
    ampo .+= (U/2), "Ntot", b, "Ntot", b 
  end
  H = MPO(ampo, sites)
  #H = splitblocks(linkinds, H)

  sweeps = Sweeps(20)
  setmaxdim!(sweeps, 2000)
  setcutoff!(sweeps, 1E-10)
  setnoise!(sweeps,1E-3)



  state = ["Emp" for n in 1:N]
  for i in 1:Int.(Npart/4)
    state[i]="Up3Up1Dn1Dn3"
  end

  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as `state`
  psi0 = randomMPS(sites, state)
  
  # Check total number of particles:
  @show flux(psi0)
  etol = 1E-9

  obs = DemoObserver(etol)

  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps;observer=obs, outputlevel=2)

  println("\nGround State Energy = $energy")
end



