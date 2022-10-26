module EC_DMRG

export main

using ITensors
using LinearAlgebra
using DelimitedFiles

BLAS.set_num_threads(1)
ITensors.Strided.disable_threads()
using_threaded_blocksparse = ITensors.enable_threaded_blocksparse()

cutoff = 1E-15
etol   = 1E-11


L=40 #levels (EVEN NUMBER!!!!)


sites = siteinds("Electron", L;conserve_qns=true)    

N_part=L
fermi=Int.(N_part/2)

n_G=100

G_cr = 0.22210

t = 1
U = -8

G_min=0.0
G_max=10.0*G_cr

dim_EC_max=2

norm_sv_threshold = 1E-15

error_threshold = 1E-3

ψ_ec      = Array{MPS}(undef,dim_EC_max)
H_ψ_ec    = Array{MPS}(undef,3,dim_EC_max)

h_mat     = fill(0.0,(3,3,dim_EC_max,dim_EC_max))
h_mat_red = fill(0.0,(3,3,dim_EC_max,dim_EC_max))
errors    = fill(0.0,(n_G))

indices_EC= fill(0,(dim_EC_max+1))


  
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



function h_part(j,sites)

  if(j==1)
    return MPO(sites, "Id")
  end

  if(j==2)
    # H_hopping
    
    ampo = OpSum()
    for b_phys in 1:(L - 1)
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

    ehf=0.0
    for i in 1:fermi
      ehf += 2.0*convert(Float64,i)
    end
    H=MPO(ampo, sites)-ehf*MPO(sites, "Id")
    return H
  end

  if(j==3)
    # H_density
    ampo = OpSum()
    for b_phys in 1:N_phys
        b=2*b_phys-1
        ampo += (U/2), "Ntot", b, "Ntot", b 
        ampo += (U/2), "Ntot", b+1, "Ntot", b+1 
        ampo += U, "Ntot", b, "Ntot", b+1 
      end
    return MPO(ampo, sites)
  end



end

function cff(j,G,E_EC)

  if(j==1)
    cof=-E_EC
  end

  if(j==2)
    cof=1.0
  end

  if(j==3)
    cof=-G
  end

  return cof
end


function total_Hamiltonian(sites,G)

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

  #ehf=0.0
  #for i in 1:fermi
  #  ehf += 2.0*convert(Float64,i)-G
  #end
  H=MPO(ampo, sites)
  #H=H-ehf*MPO(sites, "Id")
  H = splitblocks(linkinds, H)
  
  return H
end

function richardson_dmrg(sites,G,ψ_init)

  cutoff = 1E-15
  maxdim = [10,20,60,60,60,80,80,100,100,100,100,100,100,100,100,100,200,200,200,200,200,200]
  maxdim_5k=  [500 for j=1:100]
  # vcat is a Julia function that merges vectors:
  maxdim = vcat(maxdim,maxdim_5k)

  nsweeps = length(maxdim)
  noise=fill(1E-8,nsweeps)

 
  obs = DemoObserver(etol)

  H=total_Hamiltonian(sites,G)

  E₀, ψ₀ = dmrg(H,ψ_init; nsweeps, cutoff, maxdim,noise,observer=obs, outputlevel=1)

  @show flux(ψ₀)

  println("\nGround State Energy = $E₀")

  return ψ₀

end



 function compute_error_red(i_G,dim_EC)

    #first check that i_G is not one of the basis sampling points
    is_in_basis=false
    for j in 1:dim_EC_max
      if(i_G==indices_EC[j])
        is_in_basis=true
        break
      end
    end

    if(is_in_basis)

      return 1E-30
    
    else    

      G=G_min+(i_G-1.0)*(G_max-G_min)/(n_G-1.0)

      #reduced Hamiltonian matrix
      E_gs= fill(0.0,(dim_EC,dim_EC))
      for j in 2:3
        E_gs += cff(j,G,0.0)* h_mat_red[1,j,1:dim_EC,1:dim_EC]
      end    

      eig=eigen(E_gs[1:dim_EC,1:dim_EC])
    
      ev=eig.vectors;
      EC_gs=eig.values;
    
      ev = ev[:, sortperm(EC_gs)]
      EC_gs=sort(EC_gs)

      ee=EC_gs[1]
      EC_gs_v=ev[1:dim_EC,1]

      err=0.0
      for j1 in 1:3
        for j2 in 1:3
          for m in 1:dim_EC
            for n in 1:dim_EC
              err += EC_gs_v[m]*EC_gs_v[n]*cff(j1,G,ee)*cff(j2,G,ee)*h_mat_red[j1,j2,m,n]
            end
          end
        end
      end

      if(err<0.0 && err>-1E-5)
        err=1E-8
      end
      return err
    end
  
  end




function main()

hh=Array{MPO}(undef,3)

for i in 1:3
  hh[i]=h_part(i,sites) 
end

#starting self-learning value
indices_EC[1]=1
G_EC=0.0  


ψ₀₀ = ["Emp" for n in 1:L]
  
for i in 1:fermi
  ψ₀₀[i] = "UpDn"
end

ψ_init = randomMPS(sites,ψ₀₀)


for dim_EC in 1:dim_EC_max

  @show dim_EC

  ψ_ec[dim_EC]=richardson_dmrg(sites,G_EC,ψ_init)
  
  println(" ")
  print("Hⱼ|ξₙ⟩")
  using_threaded_blocksparse = ITensors.disable_threaded_blocksparse()

  @time begin
    Threads.@threads for i in 1:3
      H_ψ_ec[i,dim_EC]=apply(hh[i], ψ_ec[dim_EC]; cutoff=1e-30)
    end
  end
  print("⟨Hⱼξₙ|Hⱼ'ξₙ'⟩")

  @time begin
      Threads.@threads for index_3D in CartesianIndices((dim_EC,3,3))
  
        h_mat[Tuple(index_3D)[2],Tuple(index_3D)[3],dim_EC,Tuple(index_3D)[1]]=
                            inner(H_ψ_ec[Tuple(index_3D)[2],dim_EC],H_ψ_ec[Tuple(index_3D)[3],Tuple(index_3D)[1]])
      end
  
      for j in 1:dim_EC
      for i1 in 1:3
      for i2 in 1:3
      
          h_mat[i1,i2,j,dim_EC]= h_mat[i2,i1,dim_EC,j]
      
      end
      end
      end 
  end
  using_threaded_blocksparse = ITensors.enable_threaded_blocksparse()


  
  #overlap matrix diagonalization
  eig=eigen(h_mat[1,1,1:dim_EC,1:dim_EC])

  norm_eig_vecs = eig.vectors;

  for i in 1:dim_EC

    nrm=0.0
    for k in 1:dim_EC
    for k2 in 1:dim_EC
        nrm+=norm_eig_vecs[k,i]*norm_eig_vecs[k2,i]*h_mat[1,1,k,k2]
    end
    end

    norm_eig_vecs[:,i]=norm_eig_vecs[:,i]/sqrt(nrm)
  end

  norm_eig_vals = eig.values;
  #@show norm_eig_vals

  k=0
  for i in 1:dim_EC
    k+=1
    if(real(norm_eig_vals[i])>norm_sv_threshold)
        break
    end
  end
  dim_EC_red=dim_EC-k+1

  @show dim_EC_red

  #h_mat_red: basis change from psi to psi'
    for j1 in 1:dim_EC_red
    for j2 in 1:dim_EC_red

    for i1 in 1:3
    for i2 in 1:3
  
          h_mat_red[i1,i2,j1,j2]= 0.0
          
          for n in 1:dim_EC
            for np in 1:dim_EC
                h_mat_red[i1,i2,j1,j2] += norm_eig_vecs[n,dim_EC-j1+1]*norm_eig_vecs[np,dim_EC-j2+1]*h_mat[i1,i2,n,np]
            end
        end
  
    end
    end
    end 
    end

  println(" ")
  print("error scan")
  @time begin
    Threads.@threads for i_G in 1:n_G
      errors[i_G] = compute_error_red(i_G,dim_EC_red)
    end 
  end


  err_max, max_pos = findmax(errors)
  @show max_pos

  G_EC=G_min+(max_pos-1)*(G_max-G_min)/(n_G-1)

  indices_EC[dim_EC+1]=max_pos
  @show indices_EC[1:dim_EC+1]

  #find the closest old sampling point to the new sampling point
  #the "exact" state us taken as the starting point for dmrg 
  dist_min=n_G+10
  i_in=1
  for i in 1:dim_EC
    dist=abs(max_pos-indices_EC[i])
    if(dist<dist_min)
      dist_min=dist
      i_in=i
    end
  end
  ψ_init=ψ_ec[i_in]

  print("")
  @show sqrt(err_max)
  @show G_EC

  open("pairing_selflearn_"*string(L)*".txt", "a") do g  # "w" for writing, "a" for appending
   
    for i_G in 1:n_G
      write(g,"$(sqrt(errors[i_G])) ")
    end
    write(g,"\n")
  end

  open("pairing_selflearn_err_max_"*string(L)*".txt", "a") do g  # "w" for writing, "a" for appending
    write(g,"$(sqrt(err_max))  \n")
  end


  if(sqrt(err_max) < error_threshold)
    @show dim_EC_red
    break
  end
  
  end


  return nothing
end

end;


let
import .EC_DMRG

@time begin
EC_DMRG.main()
end
end