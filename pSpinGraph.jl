# Convert spin variable to boolean
function spin2bool(s::Real)
    return convert(Bool,(s+1)/2)
end

<<<<<<< HEAD
function spin2int(s::Real)
    return convert(int,(s+1)/2)
end

# returns a random subset of 1:N, of size p, with no repetitions
=======
# Return a random subset of 1:N, of size p, no repetitions
>>>>>>> 4c3b4e0b31f9a26b0a94b285bbee58219b656e64
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

# Construct a factor graph for a random instance of the p-spin problem
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


<<<<<<< HEAD
function issolvable(H::Array{Int,2}, J::Vector{Int})
    gf2mult = OffsetArray([0 0; 0 1], 0:1, 0:1)
    gf2div = OffsetArray([0;1], 0:1, 1:1)
    return gfrank(H, 2)==gfrank([H J], 2)
end

function issolvable(FG::FactorGraph)
    return issolvable(adjmat(FG), spin2int.(FG.J))
end

"""Reduce matrix over GF(q) to row echelon form"""
function gfref!(H::Array{Int,2},
                q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])

    !ispow(q, 2) && error("q must be a power of 2")
    !isgfq(H, q) && error("Matrix H has values outside GF(q) with q=$q")
    (m,n) = size(H)
    # Initialize pivot to zero
    p = 0
    for c = 1:n
        if iszero(H[p+1:end,c])
            continue
        else
            p += 1
            # sort rows of H so that all zeros in the c-th column are at the bottom
            H[p:end,:] .= sortslices(H[p:end,:], dims=1, rev=true,
                lt=(row1,row2)->row1[c]==0)
            # Normalize row of the pivot to make it 1
            H[p,:] .= gfdiv[H[p,:], H[p,c]]
            # Apply row-wise xor to rows below the pivot
            for r = p+1:m
                if H[r,c] != 0
                    # Adjust to make pivot 1
                    f = gfdiv[H[p,c], H[r,c]]
                    H[r,:] .= xor.(gfmult[f, H[r,:]], H[p,:])
                end
            end
            p == m && break
        end
    end
end

function gfcef!(H::Array{Int,2},
                q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])
    H .= permutedims(gfref(permutedims(H), q, gfmult, gfdiv))
end

function gfref(H::Array{Int,2},
                q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])
    tmp = copy(H)
    gfref!(tmp, q, gfmult, gfdiv)
    return tmp
end

function gfcef(H::Array{Int,2},
                q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])
    tmp = copy(H)
    gfcef!(tmp, q, gfmult, gfdiv)
    return tmp
end

function gfrank(H::Array{Int,2}, q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])
    # Reduce to row echelon form
    Href = gfref(H, q, gfmult, gfdiv)
    # Count number of all-zero rows
    nonzero = [!all(Href[r,:] .== 0) for r in 1:size(H,1)]
    # Sum
    return sum(nonzero)
end

function gfnullspace(H::Array{Int,2}, q::Int=2,
                gfmult::OffsetArray{Int,2}=gftables(q)[1],
                gfdiv::OffsetArray{Int,2}=gftables(q)[3])
    nrows,ncols = size(H)
    dimker = ncols - gfrank(H, q, gfmult, gfdiv)
    # As in https://en.wikipedia.org/wiki/Kernel_(linear_algebra)#Computation_by_Gaussian_elimination
    HI = [H; I]
    HIcef = gfcef(HI, q)
    ns = HIcef[nrows+1:end, end-dimker+1:end]
    return ns
end

function ispow(x::Int, b::Int)
    if x > 0
        return isinteger(log(b,x))
    else
        return false
    end
end

function isgfq(X, q::Int)
    for x in X
        if (x<0 || x>q-1 || !isinteger(x))
            return false
        end
    end
    return true
end

function gftables(q::Int, arbitrary_mult::Bool=false)
    if q==2
        elems = [0,1]
    else
        error("Not supported")
    end
    M = [findfirst(isequal(x*y),elems)-1 for x in elems, y in elems]
    mult = OffsetArray(M, 0:q-1, 0:q-1)
    if arbitrary_mult
        gfinv = zeros(Int, q-1)
        for r in 1:q-1
            mult[r, 1:q-1] .= shuffle(mult[r, 1:q-1])
        end

    else
        gfinv = [findfirst(isequal(1), mult[r,1:end]) for r in 1:q-1]
    end
end

####### OLD STUFF, PROBABLY NOT WORKING
=======
### GAUSSIAN ELIMINATION ON GF(2)
# Reduce to Echelon form and compute the rank to determine whether the system is solvable
>>>>>>> 4c3b4e0b31f9a26b0a94b285bbee58219b656e64

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
    return m - count(isequal(zeros(eltype(H),n)), eachrow(H))
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
