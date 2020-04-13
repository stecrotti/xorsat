include("../headers.jl")
using PyPlot

γvals = LinRange(0.75,1.0,100)
n = Int(1e4)
p = 3
navg = 200
Nc = zeros(length(γvals))
Mc = zeros(length(γvals))
for (j,γ) in enumerate(γvals)
    for _ in 1:navg
        FG = pspingraph(n, trunc(Int, γ*n),p)
        lr!(FG)
        Nc[j] += nvars(FG)
        Mc[j] += nfacts(FG)
    end
    Nc[j] /= navg
    Mc[j] /= navg
    # on-screen messages
    j%10 == 0 && println("γ = ", round(γ,digits=3)," completed")
end

plot(γvals, Nc/n, "ko", markersize=2)
plot(γvals, Mc/n, "go", markersize=2)
plt.:xlabel("γ")
plt.:legend(["Nc/N", "Mc/N"])
plt.:title("Normalized number of nodes and hyperedges in the core\n
            N=$n. Average over $navg instances")
tight_layout()
plt.savefig("../images/core.png")
