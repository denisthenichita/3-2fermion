using ITensors

let
  N = 20


  sites = siteinds(n->isodd(n) ? "Electron" : "Electron",N; conserve_qns=true)

  ampo = OpSum()
  ampo += "Cdagup", 1, "Cup", 3
  ampo += "Cdagup", 3, "Cup", 1

  H = MPO(ampo, sites)

  sweeps = Sweeps(6)
  setmaxdim!(sweeps, 100)
  setcutoff!(sweeps, 1E-12)
  setnoise!(sweeps,1E-6)
  state = ["Emp" for n in 1:N]
  state[1]="UpDn"

  psi0 = randomMPS(sites, state, 10)

  # Check total number of particles:
  @show flux(psi0)

  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps)

  println("\nGround State Energy = $energy")
end