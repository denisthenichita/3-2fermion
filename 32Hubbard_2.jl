using ITensors

let
  N=8

  sites = siteinds("Electron",N; conserve_qns=true)

  ampo = OpSum()

  for b in 1:(Int.(N/2)-1)
    ampo += -1, "Cdagup", b, "Cup", b+2
    ampo += -1, "Cdagup", b + 2, "Cup", b
  end


  H = MPO(ampo, sites)
  
  sweeps = Sweeps(8)
  setmaxdim!(sweeps, 2000)
  setcutoff!(sweeps, 1E-12)

  state = ["Emp" for n in 1:N]
  state[1]="UpDn"

  psi0 = randomMPS(sites, state)
  
  # Check total number of particles:
  @show flux(psi0)

  # Start DMRG calculation:
  energy, psi = dmrg(H, psi0, sweeps)

  println("\nGround State Energy = $energy")

end





