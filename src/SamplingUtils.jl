
struct TypeS end
struct TypeUnion end

@hybrid struct RefVal{T}
    value::T
    RefVal{T}() where T = new{T}()
    RefVal(value::T) where T = new{T}(value)
end

function infer_eltype(itr)
    T1, T2 = eltype(itr), Base.@default_eltype(itr)
    ifelse(T2 !== Union{} && T2 <: T1, T2, T1)
end

struct SeqSampleIterWR{R}
    rng::R
    N::Int
    n::Int
end

@inline function Base.iterate(s::SeqSampleIterWR)
    curmax = -log(Float64(s.N)) + randexp(s.rng)/s.n
    return (s.N - ceil(Int, exp(-curmax)) + 1, (s.n-1, curmax))
end
@inline function Base.iterate(s::SeqSampleIterWR, state)
    state[1] == 0 && return nothing
    curmax = state[2] + randexp(s.rng)/state[1]
    return (s.N - ceil(Int, exp(-curmax)) + 1, (state[1]-1, curmax))
end

Base.IteratorEltype(::SeqSampleIterWR) = Base.HasEltype()
Base.eltype(::SeqSampleIterWR) = Int
Base.IteratorSize(::SeqSampleIterWR) = Base.HasLength()
Base.length(s::SeqSampleIterWR) = s.n

# courtesy of StatsBase.jl for part of the implementation
struct SeqSampleIter{R}
    rng::R
    N::Int
    n::Int
    alpha::Float64
    function SeqSampleIter(rng::R, N, n) where R
        alpha = 1/13
        new{R}(rng, N, n, alpha)
    end
end

@inline function Base.iterate(it::SeqSampleIter)
    i = 0
    q1 = it.N - it.n + 1
    q2 = q1 / it.N
    vprime = exp(-randexp(it.rng)/it.n)
    threshold = it.alpha * it.n
    s, vprime = skip(it.rng, it.n, it.N, vprime, q1, q2)
    i, nv, Nv, q1, q2, threshold = new_state(it, s, i, it.n, it.N, q1, q2, threshold)
    return (i, (i, nv, Nv, q1, q2, threshold, vprime))
end
@inline function Base.iterate(it::SeqSampleIter, state)
    i, nv, Nv, q1, q2, threshold, vprime = state
    if nv > 1
        s, vprime = skip(it.rng, nv, Nv, vprime, q1, q2)
        i, nv, Nv, q1, q2, threshold = new_state(it, s, i, nv, Nv, q1, q2, threshold)
        return (i, (i, nv, Nv, q1, q2, threshold, vprime))
    else
        nv === 0 && return nothing
        s = trunc(Int, Nv * vprime)
        i += s+1
        nv -= 1
        return (i, (i, nv, Nv, q1, q2, threshold, vprime))
    end
end

@inline function skip(rng, n, N, vprime, q1, q2)
    local s
    while true
        local X
        while true
            X = N*(1-vprime)
            s = trunc(Int, X)
            s < q1 && break
            vprime = exp(-randexp(rng)/n)
        end

        y = rand(rng)/q2
        lhs = exp(log(y)/(n-1))
        rhs = ((q1-s)/q1) * (N/(N-X))

        if lhs <= rhs
            vprime = lhs/rhs
            break
        end

        if n-1 > s
            bottom = N-n
            limit = N-s
        else
            bottom = N-s-1
            limit = q1
        end

        top = N-1

        while top >= limit
            y *= top/bottom
            bottom -= 1
            top -= 1
        end

        if log(y) < (n-1)*(log(N)-log(N-X))
            vprime = exp(-randexp(rng)/(n-1))
            break
        end
        vprime = exp(-randexp(rng)/n)
    end
    return s, vprime
end 

@inline function new_state(it, s, i, nv, Nv, q1, q2, threshold)
    i += s+1
    Nv -= s+1
    nv -= 1
    q1 -= s
    q2 = q1/Nv
    threshold -= it.alpha
    return i, nv, Nv, q1, q2, threshold
end

@inline function seqsample_a(rng::AbstractRNG, n, k)
    if k > 1
        i = 0
        q = (n-k)/n
        while q > rand(rng)
            i += 1
            n -= 1
            q *= (n-k)/n
        end
        return i, n
    else
        return trunc(Int, n * rand(rng)), n
    end
end

Base.IteratorEltype(::SeqSampleIter) = Base.HasEltype()
Base.eltype(::SeqSampleIter) = Int
Base.IteratorSize(::SeqSampleIter) = Base.HasLength()
Base.length(s::SeqSampleIter) = s.n