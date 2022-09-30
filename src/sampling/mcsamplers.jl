
"""
Simple Metropolis-Hastings sampler whose step function implements species swaps by permuting atom indices.
"""
mutable struct MHSpeciesSwap{T} <: AbstractSampler
    β::T    # inverse temperature
end

mutable struct MHstate{T,A}
    at::A
    E::T
end

MHstate(at::AbstractAtoms, E::T) where {T<:Real}= Hstate(at, E, true)
MHstate(at::AbstractAtoms, V::AbstractCalculator) = MHstate(at, energy(V, at), true)

state(d::MHSpeciesSwap, at::AbstractAtoms,  V::AbstractCalculator) =  MHstate(at, V)


"""
    step!(d::MHSpeciesSwap, V, state)

The stepper function randomly swaps the atom species and then accept or rejects 
the transition based on an MH criterion such that the Gibb density of the Gibbs-Boltzman distribution with density 
```math
propto exp(-beta [U(R) + P^T M^{-1}P )
```
is preserved. 


    Argument requirements: 
        1. The type of `V` must implement `energy(V, at::AbstractAtoms)::Real`
        2. The sampler `state` variable must have fields of name and type `at::AbstractAtoms`, `E::Real`, and `acc::Bool`

"""

function step!(d::MHSpeciesSwap, V, state)
    at = state.at
    perm = 1:length(at)
    while all(at.Z == at.Z[perm])
        perm = shuffle(perm)
    end
    at.Z = at.Z[perm]
    E_prop = energy(V,at)
    p_acc = exp( d.β * (state.E - E_prop ))
    if rand() <= p_acc
        at.Z = at.Z[perm] # if accepted reverse proposal  
        d.E = E_prop
    end
    return acc
end