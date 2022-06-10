using ITensors
#
# DMRG calculation of the extended Hubbard model
# ground state wavefunction, and spin densities
#

let
  N_phys=16
  N = 2*N_phys
  Npart = 32
  t = 1.0
  U = 2.0

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
  
  sweeps = Sweeps(8)
  setmaxdim!(sweeps, 2000)
  setcutoff!(sweeps, 1E-12)


  state = ["Emp" for n in 1:N]
  for i in 1:Int.(Npart/2)
    state[i]="UpDn"
  end

  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as `state`
  psi0 = randomMPS(sites, state, 10)
  
  # Check total number of particles:
  @show flux(psi0)


  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps)

  println("\nGround State Energy = $energy")
end



