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
  ITensors.enable_threaded_blocksparse()

  N_phys=10
  N = 2*N_phys
  Npart = N_phys
  t = 1
  U = -8

  sites = siteinds(n->isodd(n) ? "Electron" : "Electron3",N; conserve_qns=true)

  ampo = OpSum()

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
  H = splitblocks(linkinds, H)
  
  sweeps = Sweeps(100)
  setmaxdim!(sweeps, 5000)
  setcutoff!(sweeps, 1E-10)
  setnoise!(sweeps,1E-1)


  state = ["Emp" for n in 1:N]
  

  for i in 1:5
    if i%2==1
        state[i]="Up"
    end
  end

  for i in 6:10
    if i%2==0
        state[i]="UpDn"
    end
end

  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as `state`
  psi0 = randomMPS(sites, state)
  
  # Check total number of particles:
  @show flux(psi0)


  etol = 1E-6
  obs = DemoObserver(etol)

  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps; observer=obs)

  println("\nGround State Energy = $energy")

  ################## <A3/2>
  ampo = OpSum()

  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo += "Nup", b+1
    ampo -= "Nup", b+1, "Ndn", b+1
    ampo -= "Ndn", b, "Nup", b+1
    ampo -= "Nup", b, "Nup", b+1
    ampo += "Nup", b, "Nup", b+1, "Ndn", b+1
    ampo += "Nup", b, "Ndn", b, "Nup", b+1 
    ampo += "Ndn", b, "Nup", b+1, "Ndn", b+1  
    ampo -= "Nup", b, "Ndn", b, "Nup", b+1, "Ndn", b+1    
  end

  A=MPO(ampo,sites)

  avgA = inner(psi',A,psi)/N_phys
  println("\n<A3/2> = $avgA")
 
  ################## <A1/2>
  ampo = OpSum()

  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo += "Nup", b
    ampo -= "Nup", b, "Ndn", b+1
    ampo -= "Ndn", b, "Nup", b
    ampo -= "Nup", b+1, "Nup", b
    ampo += "Nup", b+1, "Nup", b, "Ndn", b+1
    ampo += "Nup", b+1, "Ndn", b, "Nup", b 
    ampo += "Ndn", b, "Nup", b, "Ndn", b+1  
    ampo -= "Nup", b+1, "Ndn", b, "Nup", b, "Ndn", b+1    
  end

  A12=MPO(ampo,sites)

  avgA12 = inner(psi',A12,psi)/N_phys
  println("\n<A1/2> = $avgA12")
  
  
  ################## <P2,2>
  ampo = OpSum()

  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo += "Nup", b, "Nup", b+1
    ampo -= "Nup", b, "Nup", b+1, "Ndn", b+1
    ampo -= "Nup", b, "Ndn", b, "Nup", b+1   
    ampo += "Nup", b, "Ndn", b, "Nup", b+1, "Ndn", b+1    
  end

  P=MPO(ampo,sites)

  avgP = inner(psi',P,psi)/N_phys
  println("\n<P2,2> = $avgP")
  
  ################## <T3/2>
  ampo = OpSum()

  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo += "Nup", b, "Ndn", b, "Nup", b+1  
    ampo -= "Nup", b, "Ndn", b, "Nup", b+1, "Ndn", b+1    
  end

  T=MPO(ampo,sites)

  avgT = inner(psi',T,psi)/N_phys
  println("\n<T3/2> = $avgT")


  ################## <Qi> vs i
  
  avgQ = zeros(Float64, N_phys)

  for b_phys in 1:N_phys
    b=2*b_phys-1
    # the n's for different alpha&i commute between them
    ampo = OpSum()
    ampo += "Nup", b, "Ndn", b, "Nup", b+1, "Ndn", b+1 
    Q=MPO(ampo,sites)
    avgQ[b_phys] = inner(psi',Q,psi) 
  end

  #b = 1:N_phys
  #plottt = plot(b,avgQ)
  #savefig(plotQ,"Fig4.png") 

  ################## <A3/2i> vs i
  
  avgA32 = zeros(Float64, N_phys)

  for b_phys in 1:N_phys
    b=2*b_phys-1
    # the n's for different alpha&i commute between them
    ampo = OpSum()
    ampo += "Nup", b+1
    ampo -= "Nup", b+1, "Ndn", b+1
    ampo -= "Ndn", b, "Nup", b+1
    ampo -= "Nup", b, "Nup", b+1
    ampo += "Nup", b, "Nup", b+1, "Ndn", b+1
    ampo += "Nup", b, "Ndn", b, "Nup", b+1 
    ampo += "Ndn", b, "Nup", b+1, "Ndn", b+1  
    ampo -= "Nup", b, "Ndn", b, "Nup", b+1, "Ndn", b+1  
    A=MPO(ampo,sites)
    avgA32[b_phys] = inner(psi',A,psi) 
  end

  b = 1:N_phys
  plotQA = plot(b,[avgA32,avgQ],label = ["A3/2" "Q"])
  savefig(plotQA,"Fig4.png")
  

  ################## p*L = sum alpha*<n>
  ampo = OpSum()

  for b_phys in 1:N_phys
    b=2*b_phys-1
    ampo +=  1/2,"Nup", b  
    ampo +=  3/2,"Nup", b+1
    ampo +=  -1/2,"Ndn", b  
    ampo +=  -3/2,"Ndn", b+1    
  end

  pL=MPO(ampo,sites)

  avgpL = inner(psi',pL,psi)
  println("\n pL = $avgpL")

  

end
