#using Soss
using HypercubeTransform
import Distributions
const Dists = Distributions
import MeasureTheory
const MT = MeasureTheory

using Test

@testset "HypercubeTransform.jl" begin
    # Write your tests here.
    tests = [
        "transform",
        "composite",
        #"soss"
    ]
    res = map(tests) do t
        @eval module $(Symbol("Test_", t))
            include($t*".jl")
        end
        return
    end

end
