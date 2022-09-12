


function sample!(sampler::AbstractSampler, an::AnnealingScheme, tc::TerminationCriterion, state::AbstractState, V::AbstractHALPotential; outp::OutputCollector=nothing )
    t = 1
    while(terminate(tc, sampler, V, state, t))
        anneal!(an, sampler, V, state, t)   
        step!(sampler, V, state)
        feed!(outp, V, state, t)     
    end
    # feed final configuration into outputscheduler
    feed!(outp, V, state, t)  
    return state
end


function sample(hal::SimpleHALalgorithm, data, V)
    at0 = get_config(hal.init, data) 
    state = init
    sample!(hal.sampler, hal.an, hal.tc, state, V; outp)
end