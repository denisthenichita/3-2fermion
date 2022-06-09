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
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 2,s=> 2]  = 1
  Op[s'=> 6,s=> 6]  = 1
  Op[s'=> 7,s=> 7]  = 1
  Op[s'=> 8,s=> 8]  = 1
  Op[s'=>12,s=>12]  = 1
  Op[s'=>13,s=>13]  = 1
  Op[s'=>14,s=>14]  = 1
  Op[s'=>16,s=>16]  = 1
end

function ITensors.op(
             ::OpName"Nup1",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 3,s=> 3]  = 1
  Op[s'=> 6,s=> 6]  = 1
  Op[s'=> 9,s=> 9]  = 1
  Op[s'=>10,s=>10]  = 1
  Op[s'=>12,s=>12]  = 1
  Op[s'=>13,s=>13]  = 1
  Op[s'=>15,s=>15]  = 1
  Op[s'=>16,s=>16]  = 1
end

function ITensors.op(
             ::OpName"Ndn1",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 4,s=> 4]  = 1
  Op[s'=> 7,s=> 7]  = 1
  Op[s'=> 9,s=> 9]  = 1
  Op[s'=>11,s=>11]  = 1
  Op[s'=>12,s=>12]  = 1
  Op[s'=>14,s=>14]  = 1
  Op[s'=>15,s=>15]  = 1
  Op[s'=>16,s=>16]  = 1
end

function ITensors.op(
  ::OpName"Ndn3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 5,s=> 5]  = 1
  Op[s'=> 8,s=> 8]  = 1
  Op[s'=>10,s=>10]  = 1
  Op[s'=>11,s=>11]  = 1
  Op[s'=>13,s=>13]  = 1
  Op[s'=>14,s=>14]  = 1
  Op[s'=>15,s=>15]  = 1
  Op[s'=>16,s=>16]  = 1
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
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 2,s=> 1]  = 1
  Op[s'=> 6,s=> 3]  = 1
  Op[s'=> 7,s=> 4]  = 1
  Op[s'=> 8,s=> 5]  = 1
  Op[s'=>12,s=> 9]  = 1
  Op[s'=>13,s=>10]  = 1
  Op[s'=>14,s=>11]  = 1
  Op[s'=>16,s=>15]  = 1
end

function ITensors.op(
  ::OpName"Cup3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 1,s=> 2]  = 1
  Op[s'=> 3,s=> 6]  = 1
  Op[s'=> 4,s=> 7]  = 1
  Op[s'=> 5,s=> 8]  = 1
  Op[s'=> 9,s=>12]  = 1
  Op[s'=>10,s=>13]  = 1
  Op[s'=>11,s=>14]  = 1
  Op[s'=>15,s=>16]  = 1
end

function ITensors.op(
  ::OpName"Cdagup1",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 3,s=> 1]  = 1
  Op[s'=> 6,s=> 2]  = -1
  Op[s'=> 9,s=> 4]  = 1
  Op[s'=>10,s=> 5]  = 1
  Op[s'=>12,s=> 7]  = -1
  Op[s'=>13,s=> 8]  = -1
  Op[s'=>15,s=>11]  = 1
  Op[s'=>16,s=>14]  = -1
end

function ITensors.op(
  ::OpName"Cup1",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=>1,s=>3]    = 1
  Op[s'=>2,s=>6]    = -1
  Op[s'=>4,s=>9]    = 1
  Op[s'=>5,s=>10]   = 1
  Op[s'=>7,s=>12]   = -1
  Op[s'=>8,s=>13]   = -1
  Op[s'=>11,s=>15]  = 1
  Op[s'=>14,s=>16]  = -1
end

function ITensors.op(
  ::OpName"Cdagdn1",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 4,s=> 1]  = 1
  Op[s'=> 7,s=> 2]  = -1
  Op[s'=> 9,s=> 3]  = -1
  Op[s'=>11,s=> 5]  = 1
  Op[s'=>12,s=> 6]  = 1
  Op[s'=>14,s=> 8]  = -1
  Op[s'=>15,s=>10]  = -1
  Op[s'=>16,s=>13]  = 1
end

function ITensors.op(
  ::OpName"Cdn1",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=>1,s=>4]    = 1
  Op[s'=>2,s=>7]    = -1
  Op[s'=>3,s=>9]    = -1
  Op[s'=>5,s=>11]   = 1
  Op[s'=>6,s=>12]   = 1
  Op[s'=>8,s=>14]   = -1
  Op[s'=>10,s=>15]  = -1
  Op[s'=>13,s=>16]  = 1
end

function ITensors.op(
  ::OpName"Cdn3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 5,s=> 1]  = 1
  Op[s'=> 8,s=> 2]  = -1
  Op[s'=>10,s=> 3]  = -1
  Op[s'=>11,s=> 4]  = -1
  Op[s'=>13,s=> 6]  = 1
  Op[s'=>14,s=> 7]  = 1
  Op[s'=>15,s=> 9]  = 1
  Op[s'=>16,s=>12]  = -1
end

function ITensors.op(
  ::OpName"Cdagdn3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=>1,s=>5]    = 1
  Op[s'=>2,s=>8]    = -1
  Op[s'=>3,s=>10]   = -1
  Op[s'=>4,s=>11]   = -1
  Op[s'=>6,s=>13]   = 1
  Op[s'=>7,s=>14]   = 1
  Op[s'=>9,s=>15]   = 1
  Op[s'=>12,s=>16]  = -1
end

function ITensors.op(
  ::OpName"Cdn3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=>1,s=>5]    = 1
  Op[s'=>2,s=>8]    = -1
  Op[s'=>3,s=>10]   = -1
  Op[s'=>4,s=>11]   = -1
  Op[s'=>6,s=>13]   = 1
  Op[s'=>7,s=>14]   = 1
  Op[s'=>9,s=>15]   = 1
  Op[s'=>12,s=>16]  = -1
end


function ITensors.op(
             ::OpName"Sz",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 2,s=> 2] =  +1.5
  Op[s'=> 3,s=> 3] =  +0.5
  Op[s'=> 4,s=> 4] =  -0.5
  Op[s'=> 5,s=> 5] =  -1.5
  Op[s'=> 6,s=> 6] =  +2
  Op[s'=> 7,s=> 7] =  +1
  Op[s'=> 8,s=> 8] =   0
  Op[s'=> 9,s=> 9] =   0
  Op[s'=>10,s=>10] =  -1
  Op[s'=>11,s=>11] =  -2
  Op[s'=>12,s=>12] =  +1.5
  Op[s'=>13,s=>13] =  +0.5
  Op[s'=>14,s=>14] =  -0.5
  Op[s'=>15,s=>15] =  -1.5
  Op[s'=>16,s=>16] =   0
end



ITensors.has_fermion_string(::OpName"Cup3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagup3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cup1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagup1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdn1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagdn1", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdn3", ::SiteType"3/2fermion") = true
ITensors.has_fermion_string(::OpName"Cdagdn3", ::SiteType"3/2fermion") = true
