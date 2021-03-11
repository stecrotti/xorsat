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

function pspinmatrix(n::Int, m::Int, p::Int; rnd = collect(1:n))
    H = falses(m, n)
    for f in 1:m
        for v in randsubset(n, p, rnd)
            H[f,v] = true
        end
    end
    J = (-1).^bitrand(m)
    H,J
end

function rrefGF2!(H)
    (m,n) = size(H)
    # Initialize pivot to zero
    indep = Int[]
    p = 0
    for c = 1:n
        nz = findfirst(!iszero, @views H[p+1:end,c])
        if nz === nothing
            continue
        else
            p += 1
            push!(indep, c)
            # Get a 1 on the diagonal
            if nz != 1
                H[p,:], H[nz+p-1,:] = H[nz+p-1,:], H[p,:]
            end
            # Apply row-wise xor to rows above and below the pivot
            for r = [1:p-1; p+1:m]
                if H[r,c] != 0
                    for cc in c:n
                        H[r,cc] = xor(H[r,cc], H[p,cc])
                    end
                end
            end
            if p == m 
                break
            end
        end
    end
    return H, indep
end

function issolvable(fg::FactorGraph)
    issolvable(adjmat(fg), fg.J)
end

function issolvable(H,J)
    HJ = [H J.==1]
    rrefGF2!(HJ)
    for r in size(HJ,1):-1:1
        if iszero(HJ[r,1:end-1])
            HJ[r,end]==1 && return false 
        else
            return true
        end
    end
end

function issolvable_old(fg::FactorGraph)
    H = adjmat(fg) 
    rankGF2(H) == rankGF2([H fg.J.==1])
end

function rankGF2(H::AbstractArray{Int,2})
    m,n = size(H)
    H,indep = rrefGF2!(H)
    # compute number of nonzero rows
    nnz = 0
    for r in m:-1:1
        if iszero(H[r,:])
            nnz += 1
        else
            return m - nnz
        end
    end
end


# Convert spin variable to boolean
function spin2bool(s::Real)
    return convert(Bool,(s+1)/2)
end

function spin2int(s::Real)
    return convert(int,(s+1)/2)
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
