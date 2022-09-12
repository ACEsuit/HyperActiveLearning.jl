using Random



# function sample!(d::AbstractSampler, at::AbstractAtoms, V::AbstractCalculator; outps::Outputcollector=nothing)
#     sample!(d, initstate(d, at), V, at; outp=outp)
# end

# function sample!(d::AbstractSampler, at::AbstractAtoms, V::AbstractCalculator; outps::Outputcollector=nothing, outp::OutputSchd )
#     while(terminate(term, d,s,V, an))
#         step!(d, s)
#         feed!(outp, s)        
#     end
# end






"""
halinfo["at_init"]
halinfo["at_new"] 

halinfo["uc_new"] 
halinfo["i_init"] 
halinfo["outp"]

"""



function set_temperature!(d::AbstractSampler, temp::T) where {T<:Real}
    d.β = 1/temp
end

mutable struct MHSpeciesSwap{T} <: AbstractSampler
    β::T    # inverse temperature
end

mutable struct MHstate{T,A}
    at::A
    E::T
    acc::Bool
end

MHstate(at::AbstractAtoms, E::T) where {T<:Real}= Hstate(at, E, true)
MHstate(at::AbstractAtoms, V::AbstractCalculator) = MHstate(at, energy(V, at), true)



function step!(d::MHSpeciesSwap, V::AbstractCalculator, s::MHstate)
    at = s.at
    perm = 1:length(at)
    while all(at.Z == at.Z[perm])
        perm = shuffle(perm)
    end
    at.Z = at.Z[perm]
    E_prop = energy(V,at)
    p_acc = exp( d.β * (s.E - E_prop ))
    if rand() <= p_acc
        at.Z = at.Z[perm] # if accepted reverse proposal  
        d.E = E_prop
    end
end







