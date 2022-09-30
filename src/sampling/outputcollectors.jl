

"""
The output collector `BasicOutput` collects the sampler `state` and the corresponding 
iteration `t` at a frequency specified by the variable `thinning`.

"""
mutable struct BasicOutput{S} <: OutputCollector
    states::Array{S}
    times::Array{<:Int}
    thinning::Int
end

function BasicOutput(state0,thinning=1)
    return BasicOutput([deepcopy(state0)],[0], thinning)
end

function feed!(outp::BasicOutput, V, state, t)
    if t % outp.thinning == 0
        push!(outp.states, deepcopy(state)) 
        push!(outp.times, t)
    end
end


"""
Other general purpose output collectors should be defined here:
"""

