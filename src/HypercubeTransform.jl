module HypercubeTransform

using ArgCheck: @argcheck
using ChainRulesCore
import Distributions
const Dists = Distributions
using Distributions: quantile, cdf
using LinearAlgebra
using PDMats: unwhiten, whiten
using Tricks: static_hasmethod
using DocStringExtensions
import TransformVariables: as, transform, inverse, inverse!, inverse_eltype, dimension, ∞, transform_and_logjac
import TransformVariables
const TV = TransformVariables
using Random: AbstractRNG
using PrecompileTools

export transform, inverse, dimension, ascube, asflat, transform_and_logjac, transform_logdensity

include("utility.jl")
include("transform.jl")
include("inverse.jl")
include("composite.jl")
include("asflat.jl")
include("namedist.jl")
include("componentdist.jl")
include("component_transform.jl")
include("delta.jl")

@setup_workload begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.product_distribution([Dists.Normal(), Dists.Normal()])
    d = Dists.Gamma()
    pos = [0.5, 0.5, 0.5, 0.5, 0.1]

    tc = ascube((a, b, c, d))
    nc = ascube((; a, b, c, d))

    tf = asflat((a, b, c, d))
    nf = asflat((; a, b, c, d))

    pt = transform(tc, pos)
    pn = transform(nc, pos)

    ptf = transform(tf, pos)
    pnf = transform(nf, pos)
end


#function __init__()
#   @require Soss="8ce77f84-9b61-11e8-39ff-d17a774bf41c" include("soss.jl")
#end

end #module
