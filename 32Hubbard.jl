using ITensors

#
# DMRG calculation of the extended Hubbard model
# ground state wavefunction, and spin densities
#

let
  N = 20
  Npart = 10
  t = 1.0
  U = 1.0

  sites = siteinds("3/2fermion", N; conserve_qns=true)

  ampo = OpSum()
  for b in 1:(N - 1)
    ampo += -t, "Cdagup3", b, "Cup3", b + 1
    ampo += -t, "Cdagup3", b + 1, "Cup3", b
    ampo += -t, "Cdagup1", b, "Cup1", b + 1
    ampo += -t, "Cdagup1", b + 1, "Cup1", b
    ampo += -t, "Cdagdn1", b, "Cdn1", b + 1
    ampo += -t, "Cdagdn1", b + 1, "Cdn1", b
    ampo += -t, "Cdagdn3", b, "Cdn3", b + 1
    ampo += -t, "Cdagdn3", b + 1, "Cdn3", b
  end
  for b in 1:N
    ampo += (U/2), "Ntot", b, "Ntot", b 
  end
  H = MPO(ampo, sites)

  sweeps = Sweeps(6)
  setmaxdim!(sweeps, 50, 100, 200, 400, 800, 800)
  setcutoff!(sweeps, 1E-12)
  @show sweeps

  state = ["Emp" for n in 1:N]
  p = Npart
  for i in 1:Int.(Npart/4)
    state[i]="⇑↑↓⇓"
  end

  # Initialize wavefunction to be bond 
  # dimension 10 random MPS with number
  # of particles the same as `state`
  psi0 = randomMPS(sites, state, 10)

  # Check total number of particles:
  @show flux(psi0)

  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps)

  upd = fill(0.0, N)
  dnd = fill(0.0, N)
  

  println("\nGround State Energy = $energy")
end



