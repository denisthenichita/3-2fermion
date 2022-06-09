"""
    space(::SiteType"3/2fermion"; 
          conserve_qns = false, trying things out
          conserve_sz = conserve_qns,
          conserve_nf = conserve_qns,
          conserve_nfparity = conserve_qns,
          qnname_sz = "Sz",
          qnname_nf = "Nf",
          qnname_nfparity = "NfParity")
Create the Hilbert space for a site of type "3/2fermion".
Optionally specify the conserved symmetries and their quantum number labels.
"""

function space(::SiteType"3/2fermion"; 
               conserve_qns = false,
               conserve_sz = conserve_qns,
               conserve_nf = conserve_qns,
               conserve_nfparity = conserve_qns,
               qnname_sz = "Sz",
               qnname_nf = "Nf",
               qnname_nfparity = "NfParity",
              )
  if !isnothing(conserve_parity)
    conserve_nfparity = conserve_parity
  end
  if conserve_sz && conserve_nf
    return [
       QN((qnname_nf,0,-1),(qnname_sz, 0)) => 1
       QN((qnname_nf,1,-1),(qnname_sz,+1)) => 1
       QN((qnname_nf,1,-1),(qnname_sz,-1)) => 1
       QN((qnname_nf,2,-1),(qnname_sz, 0)) => 1
      ]
  elseif conserve_nf
    return [
       QN(qnname_nf,0,-1) => 1
       QN(qnname_nf,1,-1) => 2
       QN(qnname_nf,2,-1) => 1
      ]
  elseif conserve_sz
    return [
       QN((qnname_sz, 0),(qnname_nfparity,0,-2)) => 1
       QN((qnname_sz,+1),(qnname_nfparity,1,-2)) => 1
       QN((qnname_sz,-1),(qnname_nfparity,1,-2)) => 1
       QN((qnname_sz, 0),(qnname_nfparity,0,-2)) => 1
      ]
  elseif conserve_nfparity
    return [
       QN(qnname_nfparity,0,-2) => 1
       QN(qnname_nfparity,1,-2) => 2
       QN(qnname_nfparity,0,-2) => 1
      ]
  end
  return 4
end

state(::SiteType"3/2fermion",::StateName"Emp")          = 1
state(::SiteType"3/2fermion",::StateName"Up3")          = 2
state(::SiteType"3/2fermion",::StateName"Up1")          = 3
state(::SiteType"3/2fermion",::StateName"Dn1")          = 4
state(::SiteType"3/2fermion",::StateName"Dn3")          = 5
state(::SiteType"3/2fermion",::StateName"Up3Up1")       = 6
state(::SiteType"3/2fermion",::StateName"Up3Dn1")       = 7
state(::SiteType"3/2fermion",::StateName"Up3Dn3")       = 8
state(::SiteType"3/2fermion",::StateName"Up1Dn1")       = 9
state(::SiteType"3/2fermion",::StateName"Up1Dn3")       = 10
state(::SiteType"3/2fermion",::StateName"Dn1Dn3")       = 11
state(::SiteType"3/2fermion",::StateName"Up3Up1Dn1")    = 12
state(::SiteType"3/2fermion",::StateName"Up3Up1Dn3")    = 13
state(::SiteType"3/2fermion",::StateName"Up3Dn1Dn3")    = 14
state(::SiteType"3/2fermion",::StateName"Up1Dn1Dn3")    = 15
state(::SiteType"3/2fermion",::StateName"Up3Up1Dn1Dn3") = 16

state(st::SiteType"3/2fermion",::StateName"0")    = state(st,StateName("Emp"))
state(st::SiteType"3/2fermion",::StateName"⇑")    = state(st,StateName("Up3"))
state(st::SiteType"3/2fermion",::StateName"↑")    = state(st,StateName("Up1"))
state(st::SiteType"3/2fermion",::StateName"↓")    = state(st,StateName("Dn1"))
state(st::SiteType"3/2fermion",::StateName"⇓")    = state(st,StateName("Dn3"))
state(st::SiteType"3/2fermion",::StateName"⇑↑")   = state(st,StateName("Up3Up1"))
state(st::SiteType"3/2fermion",::StateName"⇑↓")   = state(st,StateName("Up3Dn1"))
state(st::SiteType"3/2fermion",::StateName"⇑⇓")   = state(st,StateName("Up3Dn3"))
state(st::SiteType"3/2fermion",::StateName"↑↓")   = state(st,StateName("Up1Dn1"))
state(st::SiteType"3/2fermion",::StateName"↑⇓")   = state(st,StateName("Up1Dn3"))
state(st::SiteType"3/2fermion",::StateName"↓⇓")   = state(st,StateName("Dn1Dn3"))
state(st::SiteType"3/2fermion",::StateName"⇑↑↓")  = state(st,StateName("Up3Up1Dn1"))
state(st::SiteType"3/2fermion",::StateName"⇑↑⇓")  = state(st,StateName("Up3Up1Dn3"))
state(st::SiteType"3/2fermion",::StateName"⇑↓⇓")  = state(st,StateName("Up3Dn1Dn3"))
state(st::SiteType"3/2fermion",::StateName"↑↓⇓")  = state(st,StateName("Up1Dn1Dn3"))
state(st::SiteType"3/2fermion",::StateName"⇑↑↓⇓") = state(st,StateName("Up3Up1Dn1Dn3"))


function op!(Op::ITensor,
             ::OpName"Nup3",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 2,s=> 2]  = 1.0
  Op[s'=> 6,s=> 6]  = 1.0
  Op[s'=> 7,s=> 7]  = 1.0
  Op[s'=> 8,s=> 8]  = 1.0
  Op[s'=>12,s=>12]  = 1.0
  Op[s'=>13,s=>13]  = 1.0
  Op[s'=>14,s=>14]  = 1.0
  Op[s'=>16,s=>16]  = 1.0
end

function op!(Op::ITensor,
             ::OpName"Nup1",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 3,s=> 3]  = 1.0
  Op[s'=> 6,s=> 6]  = 1.0
  Op[s'=> 9,s=> 9]  = 1.0
  Op[s'=>10,s=>10]  = 1.0
  Op[s'=>12,s=>12]  = 1.0
  Op[s'=>13,s=>13]  = 1.0
  Op[s'=>15,s=>15]  = 1.0
  Op[s'=>16,s=>16]  = 1.0
end

function op!(Op::ITensor,
             ::OpName"Ndn1",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 4,s=> 4]  = 1.0
  Op[s'=> 7,s=> 7]  = 1.0
  Op[s'=> 9,s=> 9]  = 1.0
  Op[s'=>11,s=>11]  = 1.0
  Op[s'=>12,s=>12]  = 1.0
  Op[s'=>14,s=>14]  = 1.0
  Op[s'=>15,s=>15]  = 1.0
  Op[s'=>16,s=>16]  = 1.0
end

function op!(Op::ITensor,
  ::OpName"Ndn3",
  ::SiteType"3/2fermion",
  s::Index)
  Op[s'=> 5,s=> 5]  = 1.0
  Op[s'=> 8,s=> 8]  = 1.0
  Op[s'=>10,s=>10]  = 1.0
  Op[s'=>11,s=>11]  = 1.0
  Op[s'=>13,s=>13]  = 1.0
  Op[s'=>14,s=>14]  = 1.0
  Op[s'=>15,s=>15]  = 1.0
  Op[s'=>16,s=>16]  = 1.0
end



function op!(Op::ITensor,
             ::OpName"Ntot",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=> 2,s=> 2] = 1.0
  Op[s'=> 3,s=> 3] = 1.0
  Op[s'=> 4,s=> 4] = 1.0
  Op[s'=> 5,s=> 5] = 1.0
  Op[s'=> 6,s=> 6] = 2.0
  Op[s'=> 7,s=> 7] = 2.0
  Op[s'=> 8,s=> 8] = 2.0
  Op[s'=> 9,s=> 9] = 2.0
  Op[s'=>10,s=>10] = 2.0
  Op[s'=>11,s=>11] = 2.0
  Op[s'=>12,s=>12] = 3.0
  Op[s'=>13,s=>13] = 3.0
  Op[s'=>14,s=>14] = 3.0
  Op[s'=>15,s=>15] = 3.0
  Op[s'=>16,s=>16] = 4.0
end

function op!(Op::ITensor,
             ::OpName"Cup",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>2] = 1.0
  Op[s'=>3,s=>4] = 1.0
end

function op!(Op::ITensor,
             ::OpName"Cdagup",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>2,s=>1] = 1.0
  Op[s'=>4,s=>3] = 1.0
end

function op!(Op::ITensor,
             ::OpName"Cdn",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>3] = 1.0
  Op[s'=>2,s=>4] = -1.0
end

function op!(Op::ITensor,
             ::OpName"Cdagdn",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>3,s=>1] = 1.0
  Op[s'=>4,s=>2] = -1.0
end

function op!(Op::ITensor,
             ::OpName"Aup",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>2] = 1.0
  Op[s'=>3,s=>4] = 1.0
end

function op!(Op::ITensor,
             ::OpName"Adagup",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>2,s=>1] = 1.0
  Op[s'=>4,s=>3] = 1.0
end

function op!(Op::ITensor,
             ::OpName"Adn",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>3] = 1.0
  Op[s'=>2,s=>4] = 1.0
end

function op!(Op::ITensor,
             ::OpName"Adagdn",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>3,s=>1] = 1.0
  Op[s'=>2,s=>4] = 1.0
end

function op!(Op::ITensor,
             ::OpName"F",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>1] = +1.0
  Op[s'=>2,s=>2] = -1.0
  Op[s'=>3,s=>3] = -1.0
  Op[s'=>4,s=>4] = +1.0
end

function op!(Op::ITensor,
             ::OpName"Fup",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>1] = +1.0
  Op[s'=>2,s=>2] = -1.0
  Op[s'=>3,s=>3] = +1.0
  Op[s'=>4,s=>4] = -1.0
end

function op!(Op::ITensor,
             ::OpName"Fdn",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>1,s=>1] = +1.0
  Op[s'=>2,s=>2] = +1.0
  Op[s'=>3,s=>3] = -1.0
  Op[s'=>4,s=>4] = -1.0
end

function op!(Op::ITensor,
             ::OpName"Sz",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>2,s=>2] = +0.5
  Op[s'=>3,s=>3] = -0.5
end

op!(Op::ITensor,
    ::OpName"Sᶻ",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("Sz"),st,s)

function op!(Op::ITensor,
             ::OpName"Sx",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>2,s=>3] = 0.5
  Op[s'=>3,s=>2] = 0.5
end

op!(Op::ITensor,
    ::OpName"Sˣ",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("Sx"),st,s)

function op!(Op::ITensor,
             ::OpName"S+",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>2,s=>3] = 1.0
end

op!(Op::ITensor,
    ::OpName"S⁺",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S+"),st,s)
op!(Op::ITensor,
    ::OpName"Sp",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S+"),st,s)
op!(Op::ITensor,
    ::OpName"Splus",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S+"),st,s)

function op!(Op::ITensor,
             ::OpName"S-",
             ::SiteType"3/2fermion",
             s::Index)
  Op[s'=>3,s=>2] = 1.0
end

op!(Op::ITensor,
    ::OpName"S⁻",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S-"),st,s)
op!(Op::ITensor,
    ::OpName"Sm",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S-"),st,s)
op!(Op::ITensor,
    ::OpName"Sminus",
    st::SiteType"3/2fermion",
    s::Index) = op!(Op,OpName("S-"),st,s)


has_fermion_string(::OpName"Cup", ::SiteType"3/2fermion") = true
has_fermion_string(::OpName"Cdagup", ::SiteType"3/2fermion") = true
has_fermion_string(::OpName"Cdn", ::SiteType"3/2fermion") = true
has_fermion_string(::OpName"Cdagdn", ::SiteType"3/2fermion") = true
