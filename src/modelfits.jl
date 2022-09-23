

# abstract type CFModelFit <: ModelFit end # Bayesian posterior distribution of Bayesian Model fit in closed-form 

# abstract type MCModelFit <: ModelFit end # Monte-Carlo / Committee approximation of the posterior distribution of a Bayesan Model fit

"""
should implement the methods 

"""

function fit!(mf::MCModelFit, data ) end

function fit!(mf::CFModelFit, data ) end

function update!(mf::ModelFit, data::Array{D}, new_data::D ) where {D}
    fit!(mf, push!(data, new_data))
end


"""

"""

# mutable struct HSPriorFit <: MCModelFit
#     hs::HorseShoe
#     sample_traj
#     maxit::Int
#     N_committee::Int
# end
