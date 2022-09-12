module HyperActiveLearning


"""
abstract type UncertaintyMeasure end

Each concrete subtype `UC <: UncertaintyMeasure`  must implement `uncertainty(::UC, ::PIPotential, ::AbstractAtoms)` 
and `grad_uncertainty(::UC, ::PIPotential, ::AbstractAtoms)`
"""

abstract type UncertaintyMeasure end
inculde("./src/haluncertainty.jl")

"""
abstract type AbstractHALPotential <: AbstractCalculator end

Each concrete subtype must implement the methods `set_τ!`, `set_ω!`, `energy`, `uncertainty`, (also `forces`, and `grad_uncertainty`)
"""
abstract type AbstractHALPotential <: AbstractCalculator end

inlcude("./src/halpotentials.jl")



abstract type AbstractSampler end
include("./halsamplers.jl")

abstract type AnnealingScheme end
include("./halannealing.jl")

abstract type TerminationCriterion end
include("./haltermination.jl")

abstract type Initializer end
include("./halinitializers.jl")


struct HALSampler
    sampler::AbstractSampler
    tc::TerminationCriterion
    an::AnnealingScheme
end

function halrun(hs::HALSampler, init::Initializer, data, hsoutp::OutputCollector, haoutp::OutputCollector)
    
end

