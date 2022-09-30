

# abstract type CFModelFit <: ModelFit end # Bayesian posterior distribution of Bayesian Model fit in closed-form 

# abstract type MCModelFit <: ModelFit end # Monte-Carlo / Committee approximation of the posterior distribution of a Bayesan Model fit

abstract type ModelFit end

abstract type CFModelFit <: ModelFit end # Bayesian posterior distribution of Bayesian Model fit in closed-form 

abstract type MCModelFit <: ModelFit end # Monte-Carlo / Committee approximation of the posterior distribution of a Bayesan Model fit


"""
    fit!(mf::MCModelFit, data )

Fits a regression model to the data 
"""

function fit!(mf::MCModelFit, data ) end

"""
    get_V(mf::MCModelFit)

Returns a committe model 
"""
function get_V(mf::MCModelFit; N_comittee=10) end

function update!(mf::ModelFit, data::Array{D}, new_data::D ) where {D}
    fit!(mf, push!(data, new_data))
end


"""

"""

mutable struct MCACEFit <: MCModelFit
    solver
    basis
end


function fit!(mf::MCACEFit, data ) 

end

function get_V(mf::MCACEFit; N_comittee=10) end

function update!(mf::MCACEFit, data::Array{D}, new_data::D ) where {D}
    
end




# mutable struct HSPriorFit <: MCModelFit
#     hs::HorseShoe
#     sample_traj
#     maxit::Int
#     N_committee::Int
# end
