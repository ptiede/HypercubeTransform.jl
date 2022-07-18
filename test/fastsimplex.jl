using Test
using HypercubeTransform
using ChainRulesTestUtils
import TransformVariables as TV

@testset "FastSimplex rrule" begin
    t = FastSimplex(10)
    y = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

    #test_rrule(TV.transform_with, TV.NoLogJac(), t, y, 0)
    test_rrule(TV.transform_with, TV.LogJac(), t, y, 0)
end
