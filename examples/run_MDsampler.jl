
using HyperActiveLearning
using JuLIP, Random

V = StillingerWeber()
Random.seed!(2)
n = 3
at = rattle!(bulk(:Si, cubic=true) * n, 0.1)

using HyperActiveLearning.Samplers
d = LangevinBAOAB(.1;γ=0.0)
Nsamples = 10000 
outp = @time sample(d, at, V, Nsamples, thinning=1);

using Plots
E_traj = [energy(V,s.at) for s in outp.states];

kinE(at) = .5 * sum(sum(p.^2)/m for (m,p) in zip(at.M,at.P))

hamiltonian_traj = [energy(V,s.at) + kinE(s.at) for s in outp.states]

# Test whether Velocity Verlet is energy preserving
Plots.plot(outp.times, hamiltonian_traj, label="Hamiltonian",xlabel="Time")
