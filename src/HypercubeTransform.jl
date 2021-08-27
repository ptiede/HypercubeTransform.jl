module HypercubeTransform

using Requires: @require
import Distributions as Dists
using Distributions: quantile
import MeasureTheory as MT
using MLStyle
using GeneralizedGenerated
using Tricks: static_hasmethod
using DocStringExtensions

export transform, HypercubeTransform, dimension, ascube

include("utility.jl")
include("transform.jl")
include("composite.jl")

function __init__()
    @require Soss="8ce77f84-9b61-11e8-39ff-d17a774bf41c" include("soss.jl")
end

end #module
