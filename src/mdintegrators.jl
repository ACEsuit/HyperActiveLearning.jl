begin module MDIntegrators

using JuLip, ACE1
using ACE1: AbstractCalculator
using StaticArrays

export VelocityVerlet, LangevinBAOAB, step!

abstract type AbstractIntegrator end

abstract type HamiltonianIntegrator <: AbstractIntegrator end 

abstract type ThermostatIntegrator <: HamiltonianIntegrator end 

mutable struct Hstate{T,A}
    at::A
    F::Vector{SVector{3,T}} # force
    E::T
end

Hstate(at::AbstractAtoms, E::T, V::AbstractCalculator) where {T<:Real}= Hstate(at, forces(V,at), E)
Hstate(at::AbstractAtoms, F::Vector{SVector{3,T}} , V::AbstractCalculator) where {T<:Real}= Hstate(at, F, energy(V,at))
Hstate(at::AbstractAtoms, V::AbstractCalculator) = Hstate(at, forces(V,at), energy(V,at))

mutable struct VelocityVerlet{T} <: HamiltonianDynamics where {T <: Real}
    h::T                        # step size
end

B_step!(d::HamiltonianIntegrator, at::AbstractAtoms, F::Vector{SVector{3,T}}, hf::T=1.0) where {T<:Real} = set_momenta!(at, at.P + hf * d.h * F)
A_step!(d::HamiltonianIntegrator, at::AbstractAtoms, hf::T=1.0) where {T<:Real} = set_positions!(at, at.X + hf * d.h * at.P./at.M)

function step!(d::VelocityVerlet, V::AbstractCalculator, s::Hstate) #V::SitePotential (e.g. FSModel)
    B_step!(d, s.at, s.F, .5)
    A_step!(d, s.at, 1.0)
    s.F = forces(V, s.at)
    B_step!(d, s.at, .5)
end

abstract type LangevinIntegrator <: ThermostatIntegrator end

O_step!(d::LangevinIntegrator, at::AbstractAtoms) = set_momenta!(at, d.α .* at.P + d.ζ * sqrt.(at.M) .* randn(ACE.SVector{3,Float64}, length(at)) )

mutable struct LangevinBAOAB{T} <: LangevinIntegrator where {T <: Real}  
    h::T        # Step size 
    β::T        # Inverse Temperature 
    α::T        # Integrator parameters
    ζ::T        # Integrator parameters 
end

LangevinBAOAB(h::T, V, at::AbstractAtoms; γ::T=1.0, β::T=1.0) where {T<:Real} = LangevinBAOAB(h, β, exp(-h *γ ), sqrt( 1.0/β * (1-exp(-2*h*γ))))

function step!(d::LangevinBAOAB, V::AbstractCalculator, s::Hstate) 
    B_step!(d, s.at, s.F, .5)
    A_step!(d, s.at, .5)
    O_step!(d, s.at)
    A_step!(d, s.at, .5)
    s.F = forces(V, s.at)
    B_step!(d, s.at, s.F, .5)
end


end