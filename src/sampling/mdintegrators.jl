
using StaticArrays

export VelocityVerlet, LangevinBAOAB

abstract type AbstractIntegrator <: AbstractSampler end

abstract type HamiltonianIntegrator <: AbstractIntegrator end 

abstract type ThermostatIntegrator <: HamiltonianIntegrator end 

mutable struct Hstate{T,A}
    at::A
    F::Vector{SVector{3,T}} # force
end

state(d::HamiltonianIntegrator, at::AbstractAtoms, V::AbstractCalculator) = Hstate(at, V) 

Hstate(at::AbstractAtoms, V::AbstractCalculator) = Hstate(at, forces(V,at))

mutable struct VelocityVerlet{T} <: HamiltonianIntegrator where {T <: Real}
    β::T
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

O_step!(d::LangevinIntegrator, at::AbstractAtoms) = set_momenta!(at, d.α .* at.P + d.ζ * sqrt.(at.M) .* randn(SVector{3,Float64}, length(at)) )

mutable struct LangevinBAOAB{T} <: LangevinIntegrator where {T <: Real}  
    β::T        # Inverse Temperature 
    h::T        # Step size 
    α::T        # Integrator parameters
    ζ::T        # Integrator parameters 
end

LangevinBAOAB(h::T; β::T=1.0, γ::T=1.0) where {T<:Real} = LangevinBAOAB(β, h, exp(-h *γ ), sqrt( 1.0/β * (1-exp(-2*h*γ))))

function step!(d::LangevinBAOAB, V::AbstractCalculator, s::Hstate) 
    B_step!(d, s.at, s.F, .5)
    A_step!(d, s.at, .5)
    O_step!(d, s.at)
    A_step!(d, s.at, .5)
    s.F = forces(V, s.at)
    B_step!(d, s.at, s.F, .5)
end

