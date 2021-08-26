using Soss
using HyperCubeTransform
using Test

@testset "HyperCubeTransform.jl" begin
    # Write your tests here.
    tests = [
        "transform",
        "composite",
        "soss"
    ]
    res = map(tests) do t
        @eval module $(Symbol("Test_", t))
            include($t*".jl")
        end
        return
    end

end
