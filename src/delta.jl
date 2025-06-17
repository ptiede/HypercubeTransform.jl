export DeltaDist

struct DeltaDist{T} <: Dists.ContinuousMultivariateDistribution
    x0::T
end

Base.length(d::DeltaDist{<:Number}) = 1
Base.length(d::DeltaDist{<:AbstractArray}) = length(d.x0)
Base.eltype(::DeltaDist{T}) where {T<:Number} = T
Base.eltype(::DeltaDist{<:AbstractArray{T}}) where {T} = T
Dists.insupport(d::DeltaDist, x) = true # always in support because we don't want to error out

function Dists.logpdf(::DeltaDist{T}, x::Real) where {T<:Real}
    return zero(T) # Ignore the case when we equal since that is measure zero anyways
end

function Dists.__logpdf(d::DeltaDist{<:AbstractArray{T}}, x::AbstractArray{T}) where {T<:Real}
    @assert length(x) == length(d.x0) "Input vector must be the same length as the delta distribution"
    return zero(eltype(x))
end

function Dists.product_distribution(dists::AbstractVector{<:DeltaDist})
    x0 = mapreduce(x->x.x0, vcat, dists)
    return DeltaDist(x0)
end

function Dists.rand(rng::AbstractRNG, d::DeltaDist{<:Real})
    return d.x0 # always return the same value
end

function Dists._rand!(::AbstractRNG, d::DeltaDist{<:AbstractArray{T}}, x::AbstractArray{T}) where {T<:Real}
    @assert length(x) == length(d.x0) "Input vector must be the same length as the delta distribution"
    x .= d.x0 # always return the same value
    return x
end

asflat(d::DeltaDist) = TV.Constant(d.x0)
ascube(d::DeltaDist) = TV.Constant(d.x0)






