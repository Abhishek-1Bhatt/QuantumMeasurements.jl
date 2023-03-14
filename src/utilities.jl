measure_state_probs(p) = ket -> begin
    probs = ket.*ket.*p
    return probs/sum(probs)
end

function measure_state(probs, ket)
    ind = rand(Categorical(probs(ket)))
    return ind 
end

state(params,ket) = measure_state(measure_state_probs(params), ket)

measure_overlap(ψ, ρ) = abs(dagger(ψ)*ρ)

function measure(ket, params=rand(length(ket.basis)), n=1000)

    meas_state = state(params, abs.(ket.data))
    overlap = measure_overlap(ket, basisstate(ket.basis, meas_state))
    samples = [derivative_estimate(p -> state(p, abs.(ket.data)), params) for i in 1:n]
    derivative = mean(samples) #d𝔼[state]/dparams
    
    return overlap, derivative
end