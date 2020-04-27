include("../headers.jl")
using UnicodePlots
using PyPlot
using DelimitedFiles

γvals = LinRange(0.75,1.25,17)
nvals = 2 .^ [5,6,7]
p = 3
navg = 1000

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

close("all")
for (i,n) in enumerate(nvals)
    plt.plot(γvals, sat[i], "o-", markersize=4, linewidth=1)
end
# figure("sat")
plt.:title("Fraction of solvable instances")
plt.:xlabel("γ")
plt.:ylabel("Fraction of solvable instances")
plt.:legend("N = " .* string.(nvals))
plt.savefig("../images/sat.png")


for (i,n) in enumerate(nvals)
    if i == 1
        global myplt = lineplot(γvals, sat[i],
        title = "Fraction of solvable instances",
        name = "n="*string(nvals[i]),
        xlabel = "γ", canvas = DotCanvas)
    elseif i > 1
        lineplot!(myplt, γvals, sat[i],
        name = "n="*string(nvals[i]))
    end
end

open("sat.txt", "w") do io
   writedlm(io, sat)
end

print("\a")

myplt
