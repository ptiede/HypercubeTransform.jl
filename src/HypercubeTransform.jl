module HypercubeTransform

using ArgCheck: @argcheck
using ComponentArrays
import Distributions
const Dists = Distributions
using Distributions: quantile, cdf
using LinearAlgebra
using PDMats: unwhiten, whiten
using Tricks: static_hasmethod
using DocStringExtensions
using Bijectors
import Bijectors: transform, bijector
using ChangesOfVariables: ChangesOfVariables, with_logabsdet_jacobian
using InverseFunctions: inverse
using Random: AbstractRNG
using PrecompileTools

export transform, inverse, dimension, ascube, asflat, transform_and_logjac, transform_logdensity, NamedDist

include("utility.jl")
include("transform.jl")
include("inverse.jl")
include("composite.jl")
include("asflat.jl")
include("named.jl")


@setup_workload begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.product_distribution([Dists.Normal(), Dists.Normal()])
    d = Dists.Gamma()
    pos = [0.5, 0.5, 0.5, 0.5, 0.1]

    nc = ascube((;a,b, c, d))

    nf = Bijectors.transformed(NamedDist(;a,b,c,d))

    # pn = transform(nc, pos)

    # pnf = transform(nf, rand(nf))
end


#function __init__()
 #   @require Soss="8ce77f84-9b61-11e8-39ff-d17a774bf41c" include("soss.jl")
#end

end #module
