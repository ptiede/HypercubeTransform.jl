using TransformVariables
using NamedTupleTools

@inline function asflat(d::Dists.RealInterval)
    lb = isfinite(d.lb) ? d.lb : -∞
    ub = isfinite(d.lb) ? d.ub : ∞
    return as(Real, lb, ub)
end

@inline asflat(m::Dists.ContinuousUnivariateDistribution) = asflat(Dists.support(m))

@inline asflat(d::Dists.Dirichlet) = TransformVariables.UnitSimplex(length(d.alpha))

@inline asflat(d::Dists.MvNormal) = as(Vector, length(d.μ))

@inline function asflat(d::Dists.Product{A,T,V}) where {A,T<:Dists.ContinuousUnivariateDistribution, V}
    @assert !Base.isabstracttype(T) "$d is abstract type this isn't a homogenous product dist which isn't currently supported"
    as(Vector, asflat(d.v[1]), length(d.v))
end

@inline asflat(d::MT.ProductMeasure) = as(Vector, asflat(first(MT.marginals(d))), length(d.pars))

@inline asflat(d::NamedTuple) = as(prototype(d)(asflat.(fieldvalues(d))))
@inline asflat(d::Tuple) = as(asflat.(d))
