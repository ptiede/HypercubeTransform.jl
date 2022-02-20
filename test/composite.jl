import Distributions
const Dists = Distributions
import MeasureTheory
const MT = MeasureTheory
using HypercubeTransform
using Test


@testset "TupleHC" begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.Product([Dists.Normal(), Dists.Normal()])
    d = Dists.Gamma()
    pos = [0.5, 0.5, 0.5, 0.5, 0.0]

    tc = ascube((a, b, c, d))
    nc = ascube((;a,b, c, d))

    pt = transform(tc, pos)
    pn = transform(nc, pos)

    @test inverse(tc, pt) ≈ pos
    @test inverse(nc, pn) ≈ pos

    @test dimension(tc) == length(pos)
    println(transform(tc, pos))
    @test transform(tc, pos) == values(transform(nc, pos))


    @inferred NTuple{3, Float64} transform(tc, pos)
end
