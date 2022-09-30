module Samplers

using Random
using JuLIP, ACE1

export AbstractSampler, AnnealingScheme, TerminationCriterion, sample, sample!



"""
Any concrete subtype  S <:AbstractSampler is required to 

    1. implement the methods `step!(d::S, V, state::ST)::ST`
    2. implement the method state(d::S, at,  V) that returns a state of a type that is compatible with the sampler 
    3. have the field \beta, and implement the method `set_temperature!(d::S, temp::T) where {T<:Real}` that sets 
        the value of \beta and potentially modifies any dependent field variables accordingly. 

"""
abstract type AbstractSampler end

"""
    set_temperature!(d::AbstractSampler, temp::T) where {T<:Real}

Fallback function for any sampler that don't have any temperature dependent field variables.
"""
function set_temperature!(d::AbstractSampler, temp::T) where {T<:Real}
    d.β = 1/temp
end

include("./mcsamplers.jl") # various Monte Carlo samplers
include("./mdintegrators.jl") # various MD integrators 

abstract type AnnealingScheme end

struct NoAnneal <: AnnealingScheme end

function anneal!(::NoAnneal, sampler, V, state, t) end


abstract type TerminationCriterion end

struct MaxIt <: TerminationCriterion
    Nsamples::Int
end

terminate(tc, sampler, V, state, t) = (t > tc.Nsamples)

"""
Any concrete subtype of the abstract type `OutputCollector` must implement the method 
`feed!(outp::OutputCollector, V, state, t::Number)`, that processes 
any information provided by 
        1. the calculator `V`,
        2. the current state `state` of the sampler,
        3. the iteration/time `t`.   
"""
abstract type OutputCollector end
include("./outputcollectors.jl")


"""
Simple sampling function that 
"""
function sample(d::AbstractSampler, at::AbstractAtoms, V, Nsamples::Int; 
                annealingscheme = NoAnneal(), 
                thinning=1)
    state0 = state(d, at, V)            
    outp = BasicOutput(state0,thinning)            
    tc = MaxIt(Nsamples)
    sample!(d, state0, V, tc, annealingscheme; outp=outp)
    return outp
end

"""
General purpose sampling function 
"""
function sample!(sampler::AbstractSampler, state, V, tc::TerminationCriterion, annealingscheme=NoAnneal(); outp::OutputCollector )
    t = 1
    while(!terminate(tc, sampler, V, state, t))
        anneal!(annealingscheme, sampler, V, state, t)   
        step!(sampler, V, state)
        feed!(outp, V, state, t)     
        t+=1
    end
    return state
end












end

