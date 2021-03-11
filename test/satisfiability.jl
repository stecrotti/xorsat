include("../headers.jl")
using Plots, ProgressMeter

# γvals = LinRange(22/32,35/32,14)
γvals = LinRange(104/128,130/128,28)
nvals = 2 .^ [8,9,10,11]
const p = 3
navg = 2000

sat = [zeros(length(γvals)) for _ in eachindex(nvals)]

for (i,n) in enumerate(nvals)
    println("\n\n####### n = $n #######\n")
    rnd = collect(1:n)
    for (j,γ) in enumerate(γvals)
        m = round(Int, γ*n)
        for _ in 1:navg
            # fg = pspingraph(n, m, p)
            # sat[i][j] += convert(Int,issolvable(fg))
            H,J = pspinmatrix(n,m,p, rnd=rnd)
            sat[i][j] += convert(Int,issolvable(H,J))
        end
        println("γ = $(round(γ,digits=2)) completed")
    end
    sat[i] /= navg
end

plt = Plots.Plot()
for (i,n) in enumerate(nvals)
    plot!(plt, γvals, sat[i], label="N=$n")
end
vline!([0.917935], label="γc")
plt
savefig("../images/sat.png")