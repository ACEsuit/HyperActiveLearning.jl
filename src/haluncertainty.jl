


struct σEnergy <: UncertaintyMeasure end

function uncertainty(::σEnergy, V::PIPotential, at::AbstractAtoms)
    return sqrt(mean((co_energy(V, at) - energy(V, at)).^2 ))
    # if co_mean
    #     Nc = ncommittee(V)
    #     return sqrt(1/(Nc-1) * sum.((co_energy(V, at) - mean.(co_energy(V, at))).^2 ))
    # else
    #     return sqrt(mean((co_energy(V, at) - energy(V, at)).^2 ))
    # end
end

function grad_uncertainty(ucm::σEnergy, V::PIPotential, at::AbstractAtoms)
    uc = uncertainty(ucm, V, at)
    return mean((co_forces(V, at) - forces(V, at)).*(co_energy(V, at) - energy(V, at) )) / uc
end
