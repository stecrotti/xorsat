struct MS
end


function onebpiter!(FG::FactorGraph, algo::BP)
    for f in randperm(length(FG.Fneigs))
        for (v_idx, v) in enumerate(FG.Fneigs[f])
            # Divide message from belief
            FG.b[v] = FG.b[v] / FG.mfv[f][v_idx]
            # Define functions for weighted convolution
            funclist = Fun[]
            for (vprime_idx,vprime) in enumerate(FG.Fneigs[f])
                if vprime != v
                    func = FG.fields[vprime] ./ FG.mfv[f][vprime_idx]
                    # adjust for weights
                    func .= func[FG.mult[FG.mult[FG.hfv[f][v_idx],FG.gfinv[FG.hfv[f][vprime_idx]]],:]]
                    push!(funclist, func)
                end
            end
            FG.mfv[f][v_idx] = reduce((f1,f2)->gfconv!(f3,f1,f2), funclist, init=neutral)
            FG.mfv[f][v_idx] ./= sum(FG.mfv[f][v_idx])
            # Update belief after updating the message
            FG.fields[v] .= FG.fields[v] .* FG.mfv[f][v_idx]
        end
    end
    return (FG)
end
