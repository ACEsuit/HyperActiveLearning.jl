
struct UCThreshold{T} <: TerminationCriterion where {T<:Real}
    maxuc::T
end

function terminate(tc::UCThreshold, sampler, V::AbstractHALPotential, state, t)
    return (uncertainty(V, state.at) > tc.maxuc ? true : false)
end
