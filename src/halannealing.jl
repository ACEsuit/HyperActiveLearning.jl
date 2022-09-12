

struct HalForceAnneal <: AnnealingScheme
    schedule 
end

HalForceAnneal() = HalForceAnneal(t -> sqrt(t))

function anneal!(annealing::HalForceAnneal, sampler, V::AbstractHALPotential, state, t::Int) 
    set_τ!(hv::HALComitteePotential, annealing.schedule(t)) 
end