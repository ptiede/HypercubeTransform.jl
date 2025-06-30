export DeltaDist

"""
    DeltaDist(x0)

Creates a Delta (aka Dirac Delta) distribution centered at the point `x0`.
This distribution is typically used to represent a fixed value in the parameter space
and is often used in Bayesian inference to represent a parameter that is known with certainty.

## Warning
The `logpdf` always returns zero. This is because its purpose is to represent a fixed value in 
the parameter space, and thus we do not want it to directly compute to the probability density of the posterior. 

## Example
```julia-repl
julia> d = DeltaDist(5.0)
julia> rand(d) == 5.0
true
julia> logpdf(d, 0.0)
0.0
```
"""
struct DeltaDist{T} <: Dists.ContinuousMultivariateDistribution
    x0::T
end

Base.length(d::DeltaDist{<:Number}) = 1
Base.length(d::DeltaDist{<:AbstractArray}) = length(d.x0)
Base.eltype(::DeltaDist{T}) where {T <: Number} = T
Base.eltype(::DeltaDist{<:AbstractArray{T}}) where {T} = T
Dists.insupport(d::DeltaDist, x) = true # always in support because we don't want to error out

function Dists.logpdf(::DeltaDist{T}, x::Real) where {T <: Real}
    return zero(T) # Ignore the case when we equal since that is measure zero anyways
end

function Dists.__logpdf(d::DeltaDist{<:AbstractArray{T}}, x::AbstractArray{T}) where {T <: Real}
    @assert length(x) == length(d.x0) "Input vector must be the same length as the delta distribution"
    return zero(eltype(x))
end

function Dists.product_distribution(dists::AbstractVector{<:DeltaDist})
    x0 = mapreduce(x -> x.x0, vcat, dists)
    return DeltaDist(x0)
end

function Dists.rand(rng::AbstractRNG, d::DeltaDist{<:Real})
    return d.x0 # always return the same value
end

function Dists._rand!(::AbstractRNG, d::DeltaDist{<:AbstractArray{T}}, x::AbstractArray{T}) where {T <: Real}
    @assert length(x) == length(d.x0) "Input vector must be the same length as the delta distribution"
    x .= d.x0 # always return the same value
    return x
end

asflat(d::DeltaDist) = TV.Constant(d.x0)
ascube(d::DeltaDist) = TV.Constant(d.x0)

function _step_transform(t::TransformVariables.Constant, x::Vector{Float64}, i::Int64)
   y, _, index2 = TV.transform_with(TV.NoLogJac(), t, x, i)
   return y, index2
end

function _step_inverse!(x, index, t::TransformVariables.Constant, y)
   index2 = TV.inverse_at!(x, index, t, y)
   return index2
end


