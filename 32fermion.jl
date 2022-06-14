using ITensors

function ITensors.space(
               ::SiteType"3/2fermion"; 
               conserve_qns = false,
               conserve_sz = conserve_qns,
               conserve_nf = conserve_qns,
               qnname_sz = "Sz",
               qnname_nf = "Nf",
              )
  if conserve_sz && conserve_nf
    return [
       QN((qnname_nf,0,-1),(qnname_sz, 0)) => 1

       QN((qnname_nf,1,-1),(qnname_sz,+3)) => 1
       QN((qnname_nf,1,-1),(qnname_sz,+1)) => 1
       QN((qnname_nf,1,-1),(qnname_sz,-1)) => 1
       QN((qnname_nf,1,-1),(qnname_sz,-3)) => 1

       QN((qnname_nf,2,-1),(qnname_sz,+4)) => 1
       QN((qnname_nf,2,-1),(qnname_sz,+2)) => 1
       QN((qnname_nf,2,-1),(qnname_sz, 0)) => 2
       QN((qnname_nf,2,-1),(qnname_sz,-2)) => 1
       QN((qnname_nf,2,-1),(qnname_sz,-4)) => 1

       QN((qnname_nf,3,-1),(qnname_sz,+3)) => 1
       QN((qnname_nf,3,-1),(qnname_sz,+1)) => 1
       QN((qnname_nf,3,-1),(qnname_sz,-1)) => 1
       QN((qnname_nf,3,-1),(qnname_sz,-3)) => 1

       QN((qnname_nf,4,-1),(qnname_sz, 0)) => 1
      ]
  elseif conserve_nf
    return [
       QN(qnname_nf,0,-1) => 1
       QN(qnname_nf,1,-1) => 4
       QN(qnname_nf,2,-1) => 6
       QN(qnname_nf,3,-1) => 4
       QN(qnname_nf,4,-1) => 1
      ]
  elseif conserve_sz
    return [
       QN((qnname_sz, 0)) => 4
       QN((qnname_sz,+1)) => 2
       QN((qnname_sz,-1)) => 2
       QN((qnname_sz,+2)) => 1
       QN((qnname_sz,-2)) => 1
       QN((qnname_sz,+3)) => 2
       QN((qnname_sz,-3)) => 2
       QN((qnname_sz,+4)) => 1
       QN((qnname_sz,-4)) => 1      
       ]
  end
  return 16
end

ITensors.val(::ValName"Emp"         ,::SiteType"3/2fermion") = 1
ITensors.val(::ValName"Up3"         ,::SiteType"3/2fermion") =2
ITensors.val(::ValName"Up1"         ,::SiteType"3/2fermion") = 3
ITensors.val(::ValName"Dn1"         ,::SiteType"3/2fermion") = 4
ITensors.val(::ValName"Dn3"         ,::SiteType"3/2fermion") = 5
ITensors.val(::ValName"Up3Up1"      ,::SiteType"3/2fermion") = 6
ITensors.val(::ValName"Up3Dn1"      ,::SiteType"3/2fermion") = 7
ITensors.val(::ValName"Up3Dn3"      ,::SiteType"3/2fermion") = 8
ITensors.val(::ValName"Up1Dn1"      ,::SiteType"3/2fermion") = 9
ITensors.val(::ValName"Up1Dn3"      ,::SiteType"3/2fermion") = 10
ITensors.val(::ValName"Dn1Dn3"      ,::SiteType"3/2fermion") = 11
ITensors.val(::ValName"Up3Up1Dn1"   ,::SiteType"3/2fermion") = 12
ITensors.val(::ValName"Up3Up1Dn3"   ,::SiteType"3/2fermion") = 13
ITensors.val(::ValName"Up3Dn1Dn3"   ,::SiteType"3/2fermion") = 14
ITensors.val(::ValName"Up1Dn1Dn3"   ,::SiteType"3/2fermion") = 15
ITensors.val(::ValName"Up3Up1Dn1Dn3",::SiteType"3/2fermion") = 16

ITensors.state(::StateName"Emp"         ,::SiteType"3/2fermion" ) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up3"         ,::SiteType"3/2fermion" ) = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up1"         ,::SiteType"3/2fermion" ) = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Dn1"         ,::SiteType"3/2fermion" ) = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Dn3"         ,::SiteType"3/2fermion" ) = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up3Up1"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up3Dn1"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up3Dn3"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up1Dn1"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]
ITensors.state(::StateName"Up1Dn3"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0]
ITensors.state(::StateName"Dn1Dn3"      ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0]
ITensors.state(::StateName"Up3Up1Dn1"   ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0]
ITensors.state(::StateName"Up3Up1Dn3"   ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0]
ITensors.state(::StateName"Up3Dn1Dn3"   ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0]
ITensors.state(::StateName"Up1Dn1Dn3"   ,::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0]
ITensors.state(::StateName"Up3Up1Dn1Dn3",::SiteType"3/2fermion" ) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]

function ITensors.op(
             ::OpName"Nup3",
             ::SiteType"3/2fermion"
             )
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
             ]
end

function ITensors.op(
             ::OpName"Nup1",
             ::SiteType"3/2fermion"
             )
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
             ]
end

function ITensors.op(
             ::OpName"Ndn1",
             ::SiteType"3/2fermion"
             )
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1              
             ]
end

function ITensors.op(
             ::OpName"Ndn3",
             ::SiteType"3/2fermion"
             )
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1              
             ]
end



function ITensors.op(
             ::OpName"Ntot",
             ::SiteType"3/2fermion")
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4
             ]
end

function ITensors.op(
             ::OpName"Cdagup3",
             ::SiteType"3/2fermion"
             )
             return [
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0         
             ]
end

function ITensors.op(
  ::OpName"Cup3",
  ::SiteType"3/2fermion"
  )
               return [
                0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0                
             ]
end

function ITensors.op(
  ::OpName"Cdagup1",
  ::SiteType"3/2fermion")
return[
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0
]
end

function ITensors.op(
  ::OpName"Cup1",
  ::SiteType"3/2fermion"
   )
  return[
                0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  ]
end

function ITensors.op(
  ::OpName"Cdagdn1",
  ::SiteType"3/2fermion"
  )
return[
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0  
]
end

function ITensors.op(
  ::OpName"Cdn1",
  ::SiteType"3/2fermion"
  )
return[
                0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]
end

function ITensors.op(
  ::OpName"Cdagdn3",
  ::SiteType"3/2fermion")
  return[
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0
  ]
end


function ITensors.op(
  ::OpName"Cdn3",
  ::SiteType"3/2fermion")
  return[
                0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  ]
end


function ITensors.op(
             ::OpName"Sz",
             ::SiteType"3/2fermion"
             )
  return[
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 1.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 -1.5 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 -2 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 1.5 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 -0.5 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1.5 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  ]
end



ITensors.has_fermion_string(::OpName"Cup3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagup3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cup1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagup1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdn1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagdn1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdn3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagdn3", ::SiteType"3/2fermion") = true
