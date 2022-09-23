

function update_V!(hv::AbstractHALPotential, V::PIPotential)
    hv.V = V
end

struct HALComitteePotential{T} <: AbstractHALPotential
    V::PIPotential
    uc::UncertaintyMeasure
    weights::SVector{T,2}
    HALComitteePotential{T}(V, uc, weights) where {T<:Real} =  (assert_has_co(V); new(V,uc,weights))
end
HALComitteePotential(V, uc, weights::SVector{T}) where {T<:Real}= HALComitteePotential{T}(V, uc, weights)
HALComitteePotential(V, uc; ω = 1.0, τ=1.0) where {T<:Real} = HALComitteePotential(V, uc,  SVector{2,T}([ω,τ]))

"""
    set_τ!(hv::HALComitteePotential, τ::T) where {T<:Real}

TBW
"""
function set_τ!(hv::HALComitteePotential, τ::T) where {T<:Real}
    hv.weights = SVector{2,T}([hv.weights[1],τ])
end

function set_ω!(hv::HALComitteePotential, τ::T) where {T<:Real}
    hv.weights = SVector{2,T}([ω,hv.weights[2]])
end

function energy(hv::HALComitteePotential, at::AbstractAtoms)
    E = energy(hv.V, at)
    uc = uncertainty(uc, hv.V, at)
    return hv.weights[1] * E - hv.weights[2] * uc
end

function forces(hv::HALComitteePotential, at::AbstractAtoms)
    F = forces(hv.V, at)
    uc_grad = grad_uncertainty(hv.uc, hv.V, at)
    return hv.weights[1] * F + hv.weights[2] * uc_grad
end





