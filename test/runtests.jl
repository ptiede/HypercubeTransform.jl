#using Soss
using HypercubeTransform
import Distributions
const Dists = Distributions
using Statistics
using ComponentArrays

using Test

@testset "HypercubeTransform.jl" begin
    # Write your tests here.
    tests = [
        "transform",
        "composite",
        "delta"
        #"soss"
    ]
    res = map(tests) do t
        include("$t.jl")
        return
    end

end
