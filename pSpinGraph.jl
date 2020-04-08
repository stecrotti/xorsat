# returns a random subset of 1:N, of size p, with no repetitions
function randsubset(n::Int, p::Int, vec=collect(1:N))
    n < p && error("Susbet size cannot be larger than n")
    output = zeros(Int,p)
    for i in 1:p
        r = rand(1:n+1-i)
        output[i] = vec[r]
        vec[r], vec[n+1-i] = vec[n+1-i], vec[r]
    end
    return output
end

# constructs a factor graph for a random instance of the pspin problem
function pspingraph(n::Int, m::Int, p::Int; sigma=1e-5)
    # vector vec (used in subroutine rand_subset) is passed as argument -> no
    #  need to create it each time pspingraph is called
    vec = collect(1:n)
    Vneigs = [Int[] for v in 1:n]
    Fneigs = [Int[] for f in 1:m]
    mfv = [zeros(0) for f in 1:m]
    # Small random fields to break the symmetry
    h = randn(n) * sigma
    # Initialize beliefs equal to the fields
    b = copy(h)
    # generate random couplings
    J = (-1).^bitrand(m)
    # Assign neighbors and initialize messages
    for f in 1:m
        for v in randsubset(n, p, vec)
            push!(Fneigs[f], v)
            push!(Vneigs[v], f)
            push!(mfv[f], 0.0)
        end
    end
    return FactorGraph(n, m, Vneigs ,Fneigs, J, h, mfv, b)
end
