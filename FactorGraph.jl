struct FactorGraph{T<:AbstractFloat}
    n::Int                              # number of variable nodes
    m::Int                              # number of factor nodes
    Vneigs::Vector{Vector{Int}}         # neighbors of variable nodes.
    Fneigs::Vector{Vector{Int}}         # neighbors of factor nodes (containing only factor nodes)
    J::Vector{Int}                      # Factors
    h::Vector{T}                        # Prior probabilities in the form of external fields
    mfv::Vector{Vector{T}}              # Messages from factor to variable
    b::Vector{T}                        # Beliefs
end

# Basic constructor for empty object
function FactorGraph(n::Int, m::Int)
    Vneigs = [Int[] for v in 1:n]
    Fneigs = [Int[] for f in 1:m]
    J = zeros(Int,n)
    h = zeros(n)
    mfv = Vector{Vector{eltype(h)}}()
    b = zeros(n)
    return FactorGraph(n, m, Vneigs, Fneigs, J, h, mfv, b)
end

function adjmat(FG::FactorGraph)
    H=zeros(Int,FG.m, FG.n)
    for f in 1:FG.m
        for v in FG.Fneigs[f]
            H[f,v] = 1
        end
    end
    return H
end

function Base.show(io::IO, FG::FactorGraph)
    for f in eachindex(FG.Fneigs)
        println(io, FG.Fneigs[f], "    ", FG.J[f])
    end
end

# Degree of variable node
function vardegree(FG::FactorGraph, v::Int)
    v > FG.n && error("Variable $v is not in the graph")
    return length(FG.Vneigs[v])
end

# Degree of factor node
function factdegree(FG::FactorGraph, f::Int)
    f > FG.m && error("Factor $f is not in the graph")
    return length(FG.Fneigs[f])
end

vardegrees(FG::FactorGraph) = [vardegree(FG,v) for v in eachindex(FG.Vneigs)]
factdegrees(FG::FactorGraph) = [factdegree(FG,f) for f in eachindex(FG.Fneigs)]

# deletes elements in vec that are equal to val
function deleteval!(vec::Vector{T}, val::T) where T
    deleteat!(vec, findall(x->x==val, vec))
end

# Delete factor f
# If f is not provided, delete one factor at random from the ones with degree > 0
function deletefact!(FG::FactorGraph, f::Int=rand(filter(ff -> factdegree(FG,ff)!=0, 1:FG.m)))
    for v in FG.Fneigs[f]
        # delete factor from its neighbors' lists
        deleteval!(FG.Vneigs[v],f)
    end
    # delete messages from f
    FG.mfv[f] = Float64[]
    # delete factor f
    FG.Fneigs[f] = []
    return f
end

# Delete variable v
# If f is not provided, delete one variable at random from the ones with degree > 0
function deletevar!(FG::FactorGraph, v::Int=rand(filter(vv -> vardegree(FG,vv)!=0, 1:FG.n)))
    for f in eachindex(FG.Fneigs)
        # delete i from its neighbors' neighbor lists
        v_idx = findall(isequal(v), FG.Fneigs[f])
        deleteat!(FG.Fneigs[f],v_idx)
        # delete messages to v
        deleteat!(FG.mfv[f], v_idx)
    end
    # delete node v
    FG.Vneigs[v] = []
    return v
end

# Leaf removal
function lr!(FG::FactorGraph)
    flag = false    # raised if there are still leaves to remove
    for v in eachindex(FG.Vneigs)
        if vardegree(FG,v)==1
            deletefact!(FG, FG.Vneigs[v][1])
            flag = true
        end
    end
    flag && lr!(FG)
    nothing
end

# Remove only 1 leaf
function onelr!(FG::FactorGraph, idx::Vector{Int}=randperm(FG.n))
    for v in idx
        if vardegree(FG,v)==1
            deletefact!(FG, FG.Vneigs[v][1])
            deletevar!(FG, v)
            return v
        end
    end
    return 0
end

# The following 2 are used to get the number of variables or factors left in
# the graph, which might be different from n,m, i.e. the original ones

function nvars(FG::FactorGraph)   # number of variables in the core
    Nvars = 0
    for v in FG.Vneigs
        v != [] && (Nvars += 1)
    end
    return Nvars
end

function nfacts(FG::FactorGraph)    # number of hyperedges in the core
     Nfact = 0
     Fneigs = FG.Fneigs
     for f in Fneigs
         f != [] && (Nfact += 1)
     end
     return Nfact
end
