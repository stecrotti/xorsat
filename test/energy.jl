include("../headers.jl")
using PyPlot

γ_interval = LinRange(0.0,1.0,11)
N_values = Int.([1e3, 1e4])
p=3
N_avg = 10

E = [zeros(length(γ_interval)) for N in N_values]

for (i,N) in enumerate(N_values)
    for (j,γ) in enumerate(γ_interval)
        for n in 1:N_avg
            FG = pspingraph(N, trunc(Int, γ*N),p)
            ms!(FG, maxiter=1e3, nmin=30)
            E[i][j] += energy(FG)
        end
        println("γ=$(round(γ,digits=2)) completed")
        E[i][j] /= N_avg
    end
    println("  N=$(N) completed")
end

for (i,N) in enumerate(N_values)
    plot(γ_interval,E[i]./N,"-o", markersize=5)
end

grid();
plt.:xlabel("γ")
plt.:ylabel("Energy / N")
plt.:xlim((-0.05, 1.05))
plt.:title("GS energy density")
plt.:legend(["N="*string(N) for N in N_values]);
