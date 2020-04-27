include("../headers.jl")
using UnicodePlots
using PyPlot
using DelimitedFiles

γvals = LinRange(0.7,0.9,20)
nvals = Int.([1e2, 1e3, 1e4])
# nvals = Int.([1e2, 1e3])
p = 3
navg = 300
# navg = 50
k = 1e-3

E = [zeros(length(γvals)) for _ in eachindex(nvals)]

for (i,n) in enumerate(nvals)
    for (j,γ) in enumerate(γvals)
        for _ in 1:navg
            FG = pspingraph(n, round(Int, γ*n), p)
            ms!(FG, maxiter=1e3, nmin=10, k=k)
            E[i][j] += energy(FG)
        end
        println("γ=$(round(γ,digits=2)) completed")
        E[i][j] /= navg*n
    end
    println("  n=$(n) completed")
end

PyPlot.close("all")
for (i,n) in enumerate(nvals)
    PyPlot.plot(γvals, E[i], "o-", markersize=4, linewidth=1)
end

ax1 = PyPlot.gca()
ax1.axvline(0.818469, c="r", ls="--", lw=0.8)
ax1.set_title("GS energy density. Averages over $navg instances. p=$p")
ax1.set_xlabel("γ")
ax1.set_ylabel("Energy / N")
PyPlot.plt.:legend(vcat("N = " .* string.(nvals),L"\gamma_d = 0.818469"))
PyPlot.plt.savefig("../images/energyo.png")


for (i,n) in enumerate(nvals)
    if i == 1
        global myplt = lineplot(γvals, E[i],
        title = "GS energy density. Averages over $navg instances. p=$p",
        name = "N="*string(nvals[i]),
        xlabel = "γ", canvas = DotCanvas)
    end
    if i > 1
        lineplot!(myplt, γvals, E[i],
        name = "N="*string(nvals[i]))
    end
end

open("energy.txt", "w") do io
   writedlm(io, nvals)
   writedlm(io, γvals)
   writedlm(io, E)
end

print("\a")
myplt
