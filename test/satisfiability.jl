include("../headers.jl")
using UnicodePlots
using PyPlot
using DelimitedFiles

γvals = LinRange(22/32,35/32,14)
nvals = 2 .^ [6,7,8]
const p = 3
navg = 500

sat = [zeros(length(γvals)) for _ in eachindex(nvals)]

for (i,n) in enumerate(nvals)
    println("\n\n####### n = $n #######\n")
    for (j,γ) in enumerate(γvals)
        for _ in 1:navg
            FG = pspingraph(n, round(Int, γ*n), p)
            sat[i][j] += convert(Int,issolvable(FG))
        end
        println("γ = $(round(γ,digits=2)) completed")
    end
    sat[i] /= navg
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
tight_layout()
plt.savefig("../images/sat3.png")


for (i,n) in enumerate(nvals)
    if i == 1
        global myplt = lineplot(γvals, sat[i],
        title = "Fraction of solvable instances",
        name = "n="*string(nvals[i]),
        xlabel = "γ", canvas = DotCanvas,
        width=80, height = 30)
    elseif i > 1
        lineplot!(myplt, γvals, sat[i],
        name = "n="*string(nvals[i]))
    end
end

open("sat3.txt", "w") do io
   writedlm(io, sat)
end

print("\a")

lineplot!(myplt, ones(10),collect(0:0.1:0.9))
myplt
