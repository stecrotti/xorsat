function spin2bool(s::Real)
    return convert(Bool,(s+1)/2)
end

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

function gf2ref!(H::BitArray{2})
    m,n = size(H)
    for c in 1:n
        H .= sortslices(H, dims=1, rev=true)
        for r in c+1:m
            if H[r,c]==1
                H[r,:] .= xor.(H[r,:], H[c,:])
            else
                break
            end
        end
    end
    return H
end

function gf2rref!(H::BitArray{2})
    gf2ref!(H)
    m,n = size(H)
    nonzerorow = findlast(!isequal(zeros(eltype(H),n)), [H[r,:] for r in 1:m])
    for c in findfirst(H[nonzerorow,:]):-1:1
        pivotrow = findlast(H[:,c])
        if pivotrow != nothing
            for r in pivotrow-1:-1:1
                H[r,c]==1 && (H[r,:] .= xor.(H[r,:], H[pivotrow,:]))
            end
        end
    end
    return H
end

function gf2ref!(H::Array{Int,2})
    B = convert.(Bool,H)
    H .= convert.(Int,gf2ref!(B))
    return H
end

function gf2ref(H::Union{BitArray{2},Array{Int,2}})
    B = copy(H)
    return gf2ref!(B)
end

function gf2rank(H::Union{BitArray{2},Array{Int,2}})
    m,n = size(H)
    gf2ref!(H)
    return m - count(isequal(zeros(eltype(H),n)), H[r,:] for r in 1:m)
end

function gf2rref!(H::Array{Int,2})
    B = convert.(Bool,H)
    H .= convert.(Int,gf2rref!(B))
    return H
end

function gf2rref(H::Union{BitArray{2},Array{Int,2}})
    B = copy(H)
    return gf2rref!(B)
end

function issolvable(H::Union{BitArray{2},Array{Int,2}}, J::Union{BitArray{1},Vector{Int}})
    return gf2rank(H)==gf2rank([H J])
end

function issolvable(FG::FactorGraph)
    return issolvable(convert.(Bool,adjmat(FG)), spin2bool.(FG.J))
end
