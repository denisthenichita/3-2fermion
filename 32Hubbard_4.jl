using ITensors
using LinearAlgebra
using Plots

include("electron3.jl")
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
   #println("Sweep $sweep at bond $bond, the energy is $energy")
 end
end

let

  ITensors.Strided.set_num_threads(1)
  BLAS.set_num_threads(1)
  ITensors.disable_threaded_blocksparse()

  N_phys=10
  N = 2*N_phys
  t = 1
  U = -2
  μ=-4
  B=4

  sites = siteinds(n->isodd(n) ? "Electron" : "Electron3",N)
  
  sweeps = Sweeps(20)
  setmaxdim!(sweeps, 5000)
  setcutoff!(sweeps, 1E-10)
  setnoise!(sweeps,1E-6)

  etol = 1E-6
  obs = DemoObserver(etol)
  
  
  ampo = OpSum()

  for b in 1: N
    ampo+= -μ, "Ntot",b
    ampo+= -B, "Sz",b
  end


  for b_phys in 1:(N_phys - 1)
    b=2*b_phys-1
    ampo += -t, "Cdagup", b, "Cup", b + 2
    ampo += -t, "Cdagup", b + 2, "Cup", b
    ampo += -t, "Cdagup", b+1, "Cup", b + 3
    ampo += -t, "Cdagup", b + 3, "Cup", b+1
    ampo += -t, "Cdagdn", b, "Cdn", b + 2
    ampo += -t, "Cdagdn", b + 2, "Cdn", b
    ampo += -t, "Cdagdn", b+1, "Cdn", b + 3
    ampo += -t, "Cdagdn", b + 3, "Cdn", b+1
  end
  
  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo += (U/2), "Ntot", b, "Ntot", b 
    ampo += (U/2), "Ntot", b+1, "Ntot", b+1 
    ampo += U, "Ntot", b, "Ntot", b+1 
  end

  H = MPO(ampo, sites)

  ψ₀ = randomMPS(sites)
  # Start DMRG calculation:
  energy, ψ = dmrg(H,  ψ₀, sweeps; observer=obs)

  println("\nGround State Energy = $energy")


  ampo = OpSum()
  for b in 1: N
    ampo+= "Ntot",b
  end

  Npart=MPO(ampo,sites)
  @show inner(ψ',Npart,ψ)

  ampo = OpSum()
  for b in 1: N
    ampo+= "Sz",b
  end

  Sz=MPO(ampo,sites)
  @show inner(ψ',Sz,ψ)
  
  return nothing
end
