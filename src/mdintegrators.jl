begin module MDIntegrators

using JuLip, ACE1
using ACE1: AbstractCalculator

export VelocityVerlet, LangevinBAOAB, step!

abstract type AbstractIntegrator end

abstract type HamiltonianIntegrator <: AbstractIntegrator end 

abstract type ThermostatIntegrator <: HamiltonianIntegrator end 

mutable struct VelocityVerlet{T} <: HamiltonianDynamics where {T <: Real}
    F::Vector{ACE.SVector{3,T}} # force
    h::T                        # step size
end

VelocityVerlet(h::Float64, V::AbstractCalculator, at::AbstractAtoms) = VelocityVerlet(forces(V, at), h)

B_step!(d::HamiltonianIntegrator, at::AbstractAtoms, hf::T=1.0) where {T<:Real} = set_momenta!(at, at.P + hf * d.h * d.F)
A_step!(d::HamiltonianIntegrator, at::AbstractAtoms, hf::T=1.0) where {T<:Real} = set_positions!(at, at.X + hf * d.h * at.P./at.M)

function step!(s::VelocityVerlet, V::AbstractCalculator, at::AbstractAtoms) #V::SitePotential (e.g. FSModel)
    B_step!(s, at, .5)
    A_step!(s, at, 1.0)
    s.F = forces(V, at)
    B_step!(s, at, .5)
end

abstract type LangevinIntegrator <: ThermostatIntegrator end

O_step!(d::LangevinIntegrator, at::AbstractAtoms) = set_momenta!(at, d.α .* at.P + d.ζ * sqrt.(at.M) .* randn(ACE.SVector{3,Float64}, length(at)) )

mutable struct LangevinBAOAB{T} <: LangevinIntegrator where {T <: Real}  
    h::T        # Step size 
    F::Vector{SVector{3,T}}           # Force vector
    β::T        # Inverse Temperature 
    α::T        # Integrator parameters
    ζ::T        # Integrator parameters 
end

LangevinBAOAB(h::T, V, at::AbstractAtoms; γ::T=1.0, β::T=1.0) where {T<:Real} = LangevinBAOAB(h, forces(V, at), β, exp(-h *γ ), sqrt( 1.0/β * (1-exp(-2*h*γ))))

function step!(d::LangevinBAOAB, V::AbstractCalculator, at::AbstractAtoms) 
    B_step!(d, at, .5)
    A_step!(d, at, .5)
    O_step!(d, at)
    A_step!(d, at, .5)
    d.F = forces(V, at)
    B_step!(d, at, .5)
end


end