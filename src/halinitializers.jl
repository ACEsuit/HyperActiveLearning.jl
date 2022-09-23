
struct UniformRandomInitializer <: Initializer end

function sample_config(::UniformRandomInitializer, halstate) 
    data = halstate[:data]
    d_index = rand(1:length(data))
    at = deepcopy(data[d_index].at)
    return at 
end