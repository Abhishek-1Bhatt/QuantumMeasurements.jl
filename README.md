# QuantumMeasurements.jl
Here I try to demonstrate the stochastic differentiation of the expected state of a ket with respect to some parameters of the measurement operator, i.e.,

    d𝔼[state]/dparams

This has been implemented with the help of StochasticAD.jl. Since, StochasticAD does not support differentiation of functions with intermediate values which are not `<:Real`, the ket states used for this demo can only be `Float64` rather than `ComplexF64`. This is the case by default with QuantumOptics.jl kets where the imaginary part is zero by default.

## Demo

```julia
using QuantumMeasurements, Statistics

basis = FockBasis(4)
alpha = 0.4
x = coherentstate(basis, alpha)

params = rand(length(basis))
ket = abs.(x.data)

#probabilites, state
probs = measure_state_probs(params)(ket)
state_meas = measure_state(measure_state_probs(params), ket)
state_meas = state(params, ket)

#overlap 
measured_state = state(params, ket)
overlap = measure_overlap(x, basisstate(basis, measured_state))

#differentiation
stochastic_triple(p -> state(p, ket), params)
derivative_estimate(p -> state(p, ket), params)
samples = [derivative_estimate(p -> state(p, ket), params) for i in 1:1000]
derivative = mean(samples) #d𝔼[state]/dparams

#direct call to measure function
overlap, dEst_dp = measure(x)
overlap, dEst_dp = measure(x, rand(length(basis)), 400)
```
