


abstract type AbstractHALPotential end

struct HALComitteePotential <: AbstractHALPotential
    V::PIPotential
    uc::UncertaintyMeasure
    weights::SVector{T,2}
    function HALComitteePotential(V, uc, weights)
        assert_has_co(V) 
        return new(V,uc,weights)
    end
end

HALComitteePotential(V, uc, τ::T) where {T<:Real} = HALComitteePotential(V, uc,  SVector{2,T}([1.0,τ]))

function energy(hv::HALComitteePotential, at::AbstractAtoms)
    E = energy(hv.V, at)
    uc = uncertainty(uc, hv.V, at)
    return hv.weights[1] * E - hv.weights[2] * uc
end

function force(halV::HALComitteePotential, at::AbstractAtoms)
    F = force(V, at)
    uc_force = - grad_uncertainty(uc, V, at)
    return hv.weights[1] * F - hv.weights[2] * uc_force
end


struct type σEnergy <: UncertaintyMeasure end

function uncertainty(::σEnergy, V::PIPotential, at::AbstractAtoms)
    return  sum(co_energy(V, at))
end

