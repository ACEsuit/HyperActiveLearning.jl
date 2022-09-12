
struct UniformRandomInitializer <: Initializer end

function get_config(::UniformRandomInitializer, data) 
    d_index = rand(1:length(data))
    at = deepcopy(data[d_index].at)
    return at 
end