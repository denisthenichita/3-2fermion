using ITensors

function ITensors.space(
  ::SiteType"Proton";
  conserve_qns=false,
  conserve_sz=conserve_qns,
  conserve_nf=conserve_qns,
  conserve_nfparity=conserve_qns,
  qnname_sz="Sz",
  qnname_nf="Np",
  qnname_nfparity="NpParity",
  # Deprecated
  conserve_parity=nothing,
)
  if !isnothing(conserve_parity)
    conserve_nfparity = conserve_parity
  end
  if conserve_sz && conserve_nf
    return [
      QN((qnname_nf, 0, -1), (qnname_sz, 0)) => 1
      QN((qnname_nf, 1, -1), (qnname_sz, +1)) => 1
      QN((qnname_nf, 1, -1), (qnname_sz, -1)) => 1
      QN((qnname_nf, 2, -1), (qnname_sz, 0)) => 1
    ]
  elseif conserve_nf
    return [
      QN(qnname_nf, 0, -1) => 1
      QN(qnname_nf, 1, -1) => 2
      QN(qnname_nf, 2, -1) => 1
    ]
  elseif conserve_sz
    return [
      QN((qnname_sz, 0), (qnname_nfparity, 0, -2)) => 1
      QN((qnname_sz, +1), (qnname_nfparity, 1, -2)) => 1
      QN((qnname_sz, -1), (qnname_nfparity, 1, -2)) => 1
      QN((qnname_sz, 0), (qnname_nfparity, 0, -2)) => 1
    ]
  elseif conserve_nfparity
    return [
      QN(qnname_nfparity, 0, -2) => 1
      QN(qnname_nfparity, 1, -2) => 2
      QN(qnname_nfparity, 0, -2) => 1
    ]
  end
  return 4
end

ITensors.val(::ValName"Emp", ::SiteType"Proton") = 1
ITensors.val(::ValName"Up", ::SiteType"Proton") = 2
ITensors.val(::ValName"Dn", ::SiteType"Proton") = 3
ITensors.val(::ValName"UpDn", ::SiteType"Proton") = 4
ITensors.val(::ValName"0", st::SiteType"Proton") = val(ValName("Emp"), st)
ITensors.val(::ValName"↑", st::SiteType"Proton") = val(ValName("Up"), st)
ITensors.val(::ValName"↓", st::SiteType"Proton") = val(ValName("Dn"), st)
ITensors.val(::ValName"↑↓", st::SiteType"Proton") = val(ValName("UpDn"), st)

ITensors.state(::StateName"Emp", ::SiteType"Proton") = [1.0, 0, 0, 0]
ITensors.state(::StateName"Up", ::SiteType"Proton") = [0.0, 1, 0, 0]
ITensors.state(::StateName"Dn", ::SiteType"Proton") = [0.0, 0, 1, 0]
ITensors.state(::StateName"UpDn", ::SiteType"Proton") = [0.0, 0, 0, 1]
ITensors.state(::StateName"0", st::SiteType"Proton") = state(StateName("Emp"), st)
ITensors.state(::StateName"↑", st::SiteType"Proton") = state(StateName("Up"), st)
ITensors.state(::StateName"↓", st::SiteType"Proton") = state(StateName("Dn"), st)
ITensors.state(::StateName"↑↓", st::SiteType"Proton") = state(StateName("UpDn"), st)

alias(::OpName"c↑") = OpName("Cup")
alias(::OpName"c↓") = OpName("Cdn")
alias(::OpName"c†↑") = OpName("Cdagup")
alias(::OpName"c†↓") = OpName("Cdagdn")
alias(::OpName"n↑") = OpName("Nup")
alias(::OpName"n↓") = OpName("Ndn")
alias(::OpName"n↑↓") = OpName("Nupdn")
alias(::OpName"ntot") = OpName("Ntot")
alias(::OpName"F↑") = OpName("Fup")
alias(::OpName"F↓") = OpName("Fdn")

function ITensors.op(::OpName"Nup", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 1.0
  ]
end
function ITensors.op(on::OpName"n↑", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Ndn", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 1.0
  ]
end
function ITensors.op(on::OpName"n↓", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Nupdn", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 1.0
  ]
end
function ITensors.op(on::OpName"n↑↓", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Ntot", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 2.0
  ]
end
function ITensors.op(on::OpName"ntot", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Cup", ::SiteType"Proton")
  return [
    0.0 1.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 1.0
    0.0 0.0 0.0 0.0
  ]
end
function ITensors.op(on::OpName"c↑", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Cdagup", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    1.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 1.0 0.0
  ]
end
function ITensors.op(on::OpName"c†↑", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Cdn", ::SiteType"Proton")
  return [
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 -1.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
  ]
end
function ITensors.op(on::OpName"c↓", st::SiteType"Proton")
  return op(alias(on), st)
end

function ITensors.op(::OpName"Cdagdn", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    1.0 0.0 0.0 0.0
    0.0 -1.0 0.0 0.0
  ]
end
function ITensors.op(::OpName"c†↓", st::SiteType"Proton")
  return op(OpName("Cdagdn"), st)
end

function ITensors.op(::OpName"Aup", ::SiteType"Proton")
  return [
    0.0 1.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 1.0
    0.0 0.0 0.0 0.0
  ]
end
function ITensors.op(::OpName"a↑", st::SiteType"Proton")
  return op(OpName("Aup"), st)
end

function ITensors.op(::OpName"Adagup", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    1.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    0.0 0.0 1.0 0.0
  ]
end
function ITensors.op(::OpName"a†↑", st::SiteType"Proton")
  return op(OpName("Adagup"), st)
end

function ITensors.op(::OpName"Adn", ::SiteType"Proton")
  return [
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 1.0
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
  ]
end
function ITensors.op(::OpName"a↓", st::SiteType"Proton")
  return op(OpName("Adn"), st)
end

function ITensors.op(::OpName"Adagdn", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 0.0 0.0 0.0
    1.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
  ]
end
function ITensors.op(::OpName"a†↓", st::SiteType"Proton")
  return op(OpName("Adagdn"), st)
end

function ITensors.op(::OpName"F", ::SiteType"Proton")
  return [
    1.0 0.0 0.0 0.0
    0.0 -1.0 0.0 0.0
    0.0 0.0 -1.0 0.0
    0.0 0.0 0.0 1.0
  ]
end

function ITensors.op(::OpName"Fup", ::SiteType"Proton")
  return [
    1.0 0.0 0.0 0.0
    0.0 -1.0 0.0 0.0
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 -1.0
  ]
end
function ITensors.op(::OpName"F↑", st::SiteType"Proton")
  return op(OpName("Fup"), st)
end

function ITensors.op(::OpName"Fdn", ::SiteType"Proton")
  return [
    1.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
    0.0 0.0 -1.0 0.0
    0.0 0.0 0.0 -1.0
  ]
end
function ITensors.op(::OpName"F↓", st::SiteType"Proton")
  return op(OpName("Fdn"), st)
end

function ITensors.op(::OpName"Sz", ::SiteType"Proton")
  return [
    0.0 0.0 0.0 0.0
    0.0 0.5 0.0 0.0
    0.0 0.0 -0.5 0.0
    0.0 0.0 0.0 0.0
  ]
end


ITensors.has_fermion_string(::OpName"Cup", ::SiteType"Proton") = true
function ITensors.has_fermion_string(on::OpName"c↑", st::SiteType"Proton")
  return has_fermion_string(alias(on), st)
end
ITensors.has_fermion_string(::OpName"Cdagup", ::SiteType"Proton") = true
function ITensors.has_fermion_string(on::OpName"c†↑", st::SiteType"Proton")
  return has_fermion_string(alias(on), st)
end
ITensors.has_fermion_string(::OpName"Cdn", ::SiteType"Proton") = true
function ITensors.has_fermion_string(on::OpName"c↓", st::SiteType"Proton")
  return has_fermion_string(alias(on), st)
end
ITensors.has_fermion_string(::OpName"Cdagdn", ::SiteType"Proton") = true
function ITensors.has_fermion_string(on::OpName"c†↓", st::SiteType"Proton")
  return has_fermion_string(alias(on), st)
end