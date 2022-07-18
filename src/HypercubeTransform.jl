module HypercubeTransform

using ArgCheck: @argcheck
import Distributions
const Dists = Distributions
using Distributions: quantile, cdf
using LinearAlgebra
import MeasureTheory
const MT = MeasureTheory
#using MLStyle
#using GeneralizedGenerated
using PDMats: unwhiten, whiten
using Tricks: static_hasmethod
using DocStringExtensions
import TransformVariables: as, transform, inverse, inverse!, inverse_eltype, dimension, ∞, transform_and_logjac
import TransformVariables
const TV = TransformVariables
using Random: AbstractRNG
export transform, inverse, dimension, ascube, asflat, transform_and_logjac, transform_logdensity

include("utility.jl")
include("transform.jl")
include("inverse.jl")
include("composite.jl")
include("asflat.jl")
include("fastsimplex.jl")

#function __init__()
 #   @require Soss="8ce77f84-9b61-11e8-39ff-d17a774bf41c" include("soss.jl")
#end

end #module
