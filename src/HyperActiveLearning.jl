module HyperActiveLearning

using ACE1
using StaticArrays

"""
abstract type UncertaintyMeasure end

Each concrete subtype `UC <: UncertaintyMeasure`  must implement `uncertainty(::UC, ::PIPotential, ::AbstractAtoms)` 
and `grad_uncertainty(::UC, ::PIPotential, ::AbstractAtoms)`
"""

abstract type UncertaintyMeasure end
include("./haluncertainty.jl")

"""
abstract type AbstractHALPotential <: AbstractCalculator end

Each concrete subtype must implement the methods `set_τ!`, `set_ω!`, `energy`, `uncertainty`, (also `forces`, and `grad_uncertainty`)
"""
abstract type AbstractHALPotential <: AbstractCalculator end
include("./halpotentials.jl")

abstract type ModelFit end

abstract type CFModelFit <: ModelFit end # Bayesian posterior distribution of Bayesian Model fit in closed-form 

abstract type MCModelFit <: ModelFit end # Monte-Carlo / Committee approximation of the posterior distribution of a Bayesan Model fit
include("./modelfits.jl")

abstract type AbstractSampler end
include("./halsamplers.jl")

abstract type AnnealingScheme end
include("./halannealing.jl")

abstract type TerminationCriterion end
include("./haltermination.jl")

abstract type Initializer end
include("./halinitializers.jl")

abstract type HighFidelityModel end
include("./highflidelity.jl")

struct HALSampler
    sampler::AbstractSampler
    tc::TerminationCriterion
    an::AnnealingScheme
    in::Initializer 
end


"""
Any concrete subtype of HALState should include any relevant data to perform 1)  
"""
abstract type AbstractHALState end
"""
Each HAL state should have 
"""

struct HALAlgorithm
    halsampler::HALSampler # specifies how the HAL potential is explored 
    modelfit::ModelFit # specifies the (potentially state dependent) fitting procedure 
    halpot::AbstractHALPotential 
    outpc::OutputCollector
    halschedule::AbstractHALScheduler
end

function step!(hal::HALAlgorithm, halstate::AbstractHALState, hfm::HighFidelityModel)
    # fit model according to the current HAL state
    fit!(hal.modelfit, halstate)
    # update the HAL potential accordingly 
    set_V!(hal.halpot, get_V(ha.modelfit))
    # sample from HAL sampler
    sample!(hal.halsampler, hal.halpot, hal.outpc)
    # 
    at = newconfig(hal.outpc)
    new_data = evaluate(hfm, at)
    # append 
    return newstate(halstate, new_data, hal.outpc)
end

function run!(hal::HALAlgorithm, halstate::AbstractHALState; maxit = 10) #modelfit::ModelFit, hs::HALSampler, init::Initializer, halstate, hsoutp::OutputCollector, haoutp::OutputCollector)
    # update model fit
    fit!(modelfit, halstate)
    i = 0
    while(!terminate(hal.halschedule, halstate) && i < maxit)
        step!(hal, halstate)
        feed!(hal.halschedule, halstate)
        i+=1
    end
end



end