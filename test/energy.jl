include("../headers.jl")
using UnicodePlots, DelimitedFiles

γvals = LinRange(0.0,1.0,21)
nvals = Int.([1e2, 1e3, 1e4])
p = 3
navg = 200
k = 1e-3

E = [zeros(length(γvals)) for _ in eachindex(nvals)]

for (i,n) in enumerate(nvals)
    for (j,γ) in enumerate(γvals)
        for _ in 1:navg
            FG = pspingraph(n, round(Int, γ*n), p)
            ms!(FG, maxiter=1e3, nmin=10, k=1e-3)
            E[i][j] += energy(FG)
        end
        println("γ=$(round(γ,digits=2)) completed")
        E[i][j] /= navg*n
    end
    println("  n=$(n) completed")
end

for (i,n) in enumerate(nvals)
    if i == 1
        global plt = lineplot(γvals, E[i],
        title = "GS energy density",
        name = "n="*string(nvals[i]),
        xlabel = "γ", canvas = DotCanvas)
    end
    if i > 1
        lineplot!(plt, γvals, E[i],
        name = "n="*string(nvals[i]))
    end
end
print("\a")
plt
