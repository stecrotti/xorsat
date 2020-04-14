include("../headers.jl")
using UnicodePlots
using PyPlot

γvals = LinRange(0.6,1.5,20)
# nvals = Int.([1e2, 1e3, 1e4])
nvals = [8, 32, 128]
p = 3
# navg = 100
navg = 500
k = 1e-3

sat = [zeros(length(γvals)) for _ in eachindex(nvals)]

for (i,n) in enumerate(nvals)
    for (j,γ) in enumerate(γvals)
        for _ in 1:navg
            FG = pspingraph(n, round(Int, γ*n), p)
            sat[i][j] += convert(Int,issolvable(FG))
        end
        println("γ=$(round(γ,digits=2)) completed")
    end
    sat[i] /= navg
    println("  n=$(n) completed")
end

PyPlot.close("all")
for (i,n) in enumerate(nvals)
    plot(γvals, sat[i], "o-", markersize=4, linewidth=1)
end

plt.:title = "Fraction of solvable instances"
plt.:xlabel = "γ"
plt.:ylabel = "Fraction of solvable instances"
plt.:legend("n = " .* string.(nvals))
plt.savefig("../images/satisfiability.png")


for (i,n) in enumerate(nvals)
    if i == 1
        global myplt = lineplot(γvals, sat[i],
        title = "Fraction of solvable instances",
        name = "n="*string(nvals[i]),
        xlabel = "γ", canvas = DotCanvas)
    end
    if i > 1
        lineplot!(myplt, γvals, sat[i],
        name = "n="*string(nvals[i]))
    end
end

print("\a")

myplt
