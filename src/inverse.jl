

struct HasCDF end
struct NoCDF end
has_cdf(::ScalarHC{D}) where {D} = static_hasmethod(cdf, Tuple{D,Float64}) ? HasCDF() : NoCDF()

"""
    `$(FUNCTIONNAME)(c::AbstractHypercubeTransform, p)`
Transforms from the parameter space `p`, to the unit hypercube
defined by the transformation `c`.

The behavior of this function depends on the nature of `c`.
 - If `c` is a <: Distributions.Distributions and has a cdf method
this will just call the cdf function. If no cdf function is defined
then a custom transformation depending on the type of `c` will be called. If
no custom transformation exists then an error will be raised.
 - If `c` is a Tuple of transformations then inverse will iterate through the
 tuple using a similar method to the
 [TransformVariables.jl](https://github.com/tpapp/TransformVariables.jl) method.
"""
function TV.inverse(c::AbstractHypercubeTransform, x)
    TV.inverse!(Vector{inverse_eltype(c, x)}(undef, dimension(c)), c, x)
end

function TV.inverse!(x::AbstractVector, c::AbstractHypercubeTransform, y)
    _step_inverse!(x, firstindex(x), c, y)
    return x
end

function _inverse(c::AbstractHypercubeTransform, x)
    return _inverse(has_cdf(c), c, x)
end

@inline function _inverse(::HasCDF, c::AbstractHypercubeTransform, x)
    return cdf(dist(c), x)
end

@inline function _inverse(::NoCDF, c::AbstractHypercubeTransform, x)
    throw("No cdf for distribution $(c.dist), implement _inverse manually")
end
