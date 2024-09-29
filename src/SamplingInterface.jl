
"""
    ReservoirSample([rng], T, method = AlgRSWRSKIP())
    ReservoirSample([rng], T, wfunc, method = AlgWRSWRSKIP())
    ReservoirSample([rng], T, n::Int, method = AlgL(); ordered = false)
    ReservoirSample([rng], T, wfunc, n::Int, method = AlgAExpJ(); ordered = false)

Initializes a reservoir sample which can then be fitted with [`fit!`](@ref).
The first signature represents a sample where only a single element is collected.
A weight function `wfunc` can be passed to apply weighted sampling. Look at the
[`Algorithms`](@ref) section for the supported methods.
"""
function ReservoirSample(T, method::ReservoirAlgorithm = AlgRSWRSKIP())
    return ReservoirSample(Random.default_rng(), T, method, MutSample())
end
function ReservoirSample(rng::AbstractRNG, T, method::ReservoirAlgorithm = AlgRSWRSKIP())
    return ReservoirSample(rng, T, method, MutSample())
end
function ReservoirSample(T, wv, method::ReservoirAlgorithm = AlgWRSWRSKIP())
    return ReservoirSample(Random.default_rng(), T, wv, method, MutSample())
end
function ReservoirSample(rng::AbstractRNG, T, wv, method::ReservoirAlgorithm = AlgWRSWRSKIP())
    return ReservoirSample(rng, T, wv, method, MutSample())
end
Base.@constprop :aggressive function ReservoirSample(T, n::Integer, method::ReservoirAlgorithm=AlgL(); 
        ordered = false)
    return ReservoirSample(Random.default_rng(), T, n, method, MutSample(), ordered ? Ord() : Unord())
end
Base.@constprop :aggressive function ReservoirSample(rng::AbstractRNG, T, n::Integer, 
        method::ReservoirAlgorithm=AlgL(); ordered = false)
    return ReservoirSample(rng, T, n, method, MutSample(), ordered ? Ord() : Unord())
end
Base.@constprop :aggressive function ReservoirSample(T, wv, n::Integer, 
        method::ReservoirAlgorithm=algAExpJ(); ordered = false)
    return ReservoirSample(Random.default_rng(), T, wv, n, method, MutSample(), ordered ? Ord() : Unord())
end
Base.@constprop :aggressive function ReservoirSample(rng::AbstractRNG, T, wv, n::Integer, 
        method::ReservoirAlgorithm=algAExpJ(); ordered = false)
    return ReservoirSample(rng, T, wv, n, method, MutSample(), ordered ? Ord() : Unord())
end

"""
    fit!(rs::AbstractReservoirSample, el)

Updates the reservoir sample by taking into account the element passed.
"""
@inline OnlineStatsBase.fit!(s::AbstractReservoirSample, el) = OnlineStatsBase._fit!(s, el)

"""
    value(rs::AbstractReservoirSample)

Returns the elements collected in the sample at the current 
sampling stage.

Note that even if the sampling respects the schema it is assigned
when [`ReservoirSample`](@ref) is instantiated, some ordering in 
the sample can be more probable than others. To represent each one 
with the same probability call `shuffle!` over the result.
"""
OnlineStatsBase.value(s::AbstractReservoirSample) = error("Abstract version")

"""
    ordvalue(rs::AbstractReservoirSample)

Returns the elements collected in the sample at the current 
sampling stage in the order they were collected. This applies
only when `ordered = true` is passed in [`ReservoirSample`](@ref).
"""
ordvalue(s::AbstractReservoirSample) = error("Not an ordered sample")

"""
    nobs(rs::AbstractReservoirSample)

Returns the total number of elements that have been observed so far 
during the sampling process.
"""
OnlineStatsBase.nobs(s::AbstractReservoirSample) = s.seen_k

"""
    Base.empty!(rs::AbstractReservoirSample)

Resets the reservoir sample to its initial state. 
Useful to avoid allocating a new sample in some cases.
"""
function Base.empty!(::AbstractReservoirSample)
    error("Abstract Version")
end

"""
    itsample([rng], iter, method = AlgRSWRSKIP())
    itsample([rng], iter, wfunc, method = AlgWRSWRSKIP())

Return a random element of the iterator, optionally specifying a `rng` 
(which defaults to `Random.default_rng()`) and a function `wfunc` which
accept each element as input and outputs the corresponding weight.
If the iterator is empty, it returns `nothing`.

-----

    itsample([rng], iter, n::Int, method = AlgL(); ordered = false)
    itsample([rng], iter, wfunc, n::Int, method = AlgAExpJ(); ordered = false)

Return a vector of `n` random elements of the iterator, 
optionally specifying a `rng` (which defaults to `Random.default_rng()`)
a weight function `wfunc` and a `method`. `ordered` dictates whether an 
ordered sample (also called a sequential sample, i.e. a sample where items 
appear in the same order as in `iter`) must be collected.

If the iterator has less than `n` elements, in the case of sampling without
replacement, it returns a vector of those elements.
"""
function itsample(iter, method = AlgRSWRSKIP(); iter_type = infer_eltype(iter))
    return itsample(Random.default_rng(), iter, method; iter_type)
end
function itsample(iter, n::Int, method = AlgL(); iter_type = infer_eltype(iter), ordered = false)
    return itsample(Random.default_rng(), iter, n, method; ordered)
end
function itsample(iter, wv::Function, method = AlgWRSWRSKIP(); iter_type = infer_eltype(iter))
    return itsample(Random.default_rng(), iter, wv, method)
end
function itsample(iter, wv::Function, n::Int, method = AlgAExpJ(); iter_type = infer_eltype(iter), 
        ordered = false)
    return itsample(Random.default_rng(), iter, wv, n, method; iter_type, ordered)
end
Base.@constprop :aggressive function itsample(rng::AbstractRNG, iter, method = AlgRSWRSKIP();
        iter_type = infer_eltype(iter))
    if Base.IteratorSize(iter) isa Base.SizeUnknown
        s = ReservoirSample(rng, iter_type, method, ImmutSample())
        return update_all!(s, iter)
    else 
        return sortedindices_sample(rng, iter)
    end
end
Base.@constprop :aggressive function itsample(rng::AbstractRNG, iter, n::Int, method = AlgL(); 
        iter_type = infer_eltype(iter), ordered = false)
    if Base.IteratorSize(iter) isa Base.SizeUnknown
        s = ReservoirSample(rng, iter_type, n, method, ImmutSample(), ordered ? Ord() : Unord())
        return update_all!(s, iter, ordered)::Vector{iter_type}
    else
        replace = method isa AlgL || method isa AlgR ? false : true
        sortedindices_sample(rng, iter, n; iter_type, replace, ordered)::Vector{iter_type}
    end
end
function itsample(rng::AbstractRNG, iter, wv::Function, method = AlgWRSWRSKIP(); iter_type = infer_eltype(iter))
    s = ReservoirSample(rng, iter_type, wv, method, ImmutSample())
    return update_all!(s, iter)
end
Base.@constprop :aggressive function itsample(rng::AbstractRNG, iter, wv::Function, n::Int, method = AlgAExpJ(); 
        iter_type = infer_eltype(iter), ordered = false)
    s = ReservoirSample(rng, iter_type, wv, n, method, ImmutSample(), ordered ? Ord() : Unord())
    return update_all!(s, iter, ordered)
end

function update_all!(s, iter)
    for x in iter
        s = fit!(s, x)
    end
    return value(s)
end
function update_all!(s, iter, ordered)
    for x in iter
        s = fit!(s, x)
    end
    return ordered ? ordvalue(s) : shuffle!(s.rng, value(s))
end
