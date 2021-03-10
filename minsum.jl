# One iteration of min-sum algo
function msiter!(FG::FactorGraph)
    # Random scheduling
    for f in randperm(length(FG.Fneigs))
        for (v_idx, v) in enumerate(FG.Fneigs[f])
            # Subtract message from belief
            FG.b[v] = FG.b[v] - FG.mfv[f][v_idx]
            # Update message
            aux = vcat(FG.J[f], [FG.b[vprime]-FG.mfv[f][vprime_idx]
                for (vprime_idx,vprime) in enumerate(FG.Fneigs[f]) if vprime_idx != v_idx])
            # Apply formula
            FG.mfv[f][v_idx] = prod(sign, aux)*minimum(abs, aux)
            # Update belief after updating the message
            FG.b[v] = FG.b[v] + FG.mfv[f][v_idx]
        end
    end
    return guesses(FG)
end

# Return guesses for each variable's value
function guesses(FG::FactorGraph)
    return sign.(FG.b)
end

# Min-Sum algo
function ms!(FG::FactorGraph; maxiter=Int(1e4), nmin=10,
    k=0.0) # Soft decimation factor
    newguesses = zeros(FG.n)
    oldguesses = guesses(FG)
    n = 0   # number of consecutive times for which the guesses are left unchanged by one MS iteration
    for it in 1:maxiter
        newguesses = msiter!(FG)
        if newguesses == oldguesses
            n += 1
            n >= nmin && return :converged, it
        elseif energy(FG,newguesses) == 0.0
            return :converged, it
        else
            n=0
        end
        oldguesses = newguesses
        # Soft decimation
        FG.b .+= k*FG.b
    end
    return :unconverged, maxiter
end

# Find the ground state and return its energy
function energy(FG::FactorGraph, x=guesses(FG))
    return reduce(+,1 - FG.J[f]*prod(x[v] for v in FG.Fneigs[f])
        for f in eachindex(FG.Fneigs) if factdegree(FG,f)>0; init=0.0)
end
