module HyperActiveLearning

# Write your package code here.

abstract type ModelFit end 
abstract type UncertaintyMeasure end
abstract type CombinationRule end

# Functions to be implemented for concrete sub-types 

function update!(mf::ModelFit, data::Array{D}) end

function update!(mf::ModelFit, data::Array{D}, data_new::D) end


function evaluate(mf::ModelFit, x)::T 
    # returns predicted value of model at x  
end 

function evaluate_d(mf::ModelFit, x)::Array{T} 
    # returns gradient of model prediction at x
end 

function evaluate(mf::ModelFit, uc::UncertaintyMeasure, x)::T 
    # returns value of uncertainty measure at predictor value x 
end 

function evaluate_d(mf::ModelFit, uc::UncertaintyMeasure, x)::Array{T} 
    # returns gradient value of uncertainty at predictor value x
end 

function evaluate(cr::CombinationRule, mf::ModelFit, uc::UncertaintyMeasure, x)::T
    # returns value of biased potential at cfg  
end 

function evaluate_d(cr::CombinationRule, mf::ModelFit, uc::UncertaintyMeasure, cfg)::Array{Real} 
    # returns gradient of biased potential at cfg 
end 


abstract type TerminationCriterion end

function terminate(h::HAL, x)::Bool end


abstract type DrivingDynamics end
abstract type HighFidelityModel end

abstract type AbstractHAL end
struct HAL # make HAL parametric type and dispatch on 
    modelfit::ModelFit
    uncertainty::UncertaintyMeasure
    cr::CombinationRule
    tc::TerminationCriterion
    dd::DrivingDynamics
    hf::HighFidelityModel
    data
end


# how to initialize dd::DrivingDynamics ? 
function step!(h::HAL, )

function run!(hal::AbstracHAL)


while(!terminate(hal)) 
    
    explore(hal, hal.modelfit) # modelfit needs 
    
    
    update!(modelfit, new_data)



end

end


function explore(hal, modelfit)
    

end

