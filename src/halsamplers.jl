



function sample(hal::HALsampler, halstate; thinning=1)
    at0 = sample_config(hal.init, halstate) 
    state = init(hal.sampler, at0)
    sample!(hal.sampler, hal.an, hal.tc, state, V; outp)
end
