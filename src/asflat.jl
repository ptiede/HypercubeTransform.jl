using TransformVariables
using NamedTupleTools


@inline function asflat(d::Dists.RealInterval)
    lb = isfinite(d.lb) ? d.lb : -TV.∞
    ub = isfinite(d.ub) ? d.ub : TV.∞
    return as(Real, lb, ub)
end

@inline asflat(m::Dists.ContinuousUnivariateDistribution) = asflat(Dists.support(m))

@inline asflat(d::Dists.Dirichlet) = TransformVariables.UnitSimplex(length(d.alpha))

@inline asflat(d::Dists.MvNormal) = as(Vector, length(d.μ))

@inline asflat(d::Dists.MvLogNormal) = as(Vector, as(Real, 0, ∞), length(d))
@inline asflat(::Dists.LogNormal) = as(Real, 0, ∞)

@inline function asflat(d::Dists.Product{A,T,V}) where {A,T<:Dists.ContinuousUnivariateDistribution, V}
    @assert !Base.isabstracttype(T) "$d is abstract type this isn't a homogenous product dist which isn't currently supported"
    as(Vector, asflat(first(d.v)), length(d.v))
end

@inline asflat(d::NamedTuple) = as(prototype(d)(asflat.(fieldvalues(d))))
@inline asflat(d::Tuple) = as(asflat.(d))

# using Bijectors: bijector, NamedBijector, with_logabsdet_jacobian
# import Bijectors
# const BJ = Bijectors
# using ModelWrappers
# using NamedTupleTools


# struct FlatTransform{F,B}
#     fwd::F
#     bck::B
#     dim::Int
# end

# dimension(tr::FlatTransform) = tr.dim

# function transform(tr::FlatTransform, x)
#     tr.fwd(x)
# end

# function TV.inverse(tr::FlatTransform, x)
#     tr.bck(x)
# end

# function transform_and_logjac(t::FlatTransform, x::AbstractVector)
#     with_logabsdet_jacobian(t.fwd, x)
# end


# struct NamedFlatTransform{T,F1,F2}
#     bij::T
#     flat::F1
#     unflatten::F2
# end

# dimension(tr::NamedFlatTransform) = dimension(tr.bij)

# @inline function asflat(m::Dists.Distribution)
#     bck = bijector(m)
#     fwd = BJ.inverse(bck)
#     FlatTransform(fwd, bck, length(m))
# end

# @inline function asflat(m::NamedTuple)
#     nms = prototype(m)
#     dists = fieldvalues(m)
#     bck = NamedBijector(nms(bijector.(dists)))
#     fwd = BJ.inverse(bck)

#     # now construct the named tuple test
#     p0 = nms(rand.(dists))
#     flat, unflatten = construct_flatten(FlattenDefault(), UnflattenFlexible(), p0)
#     x0 = flat(p0)
#     bij = FlatTransform(fwd, bck, length(x0))

#     return NamedFlatTransform(bij, flat, unflatten)
# end


# function transform_and_logjac(t::NamedFlatTransform, x::AbstractVector)
#     with_logabsdet_jacobian(t.bij.fwd, t.unflatten(x))
# end

# function transform(t::NamedFlatTransform, x::AbstractVector)
#     t.bij.fwd(t.unflatten(x))
# end

# function TV.inverse(t::NamedFlatTransform, x::NamedTuple)
#     t.flat(t.bij.bck(x))
# end
