import Distributions
const Dists = Distributions
import MeasureTheory
const MT = MeasureTheory
using HypercubeTransform
using Test


@testset "TupleHC" begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.product_distribution([Dists.Normal(), Dists.Normal()])
    d = Dists.Gamma()
    pos = [0.5, 0.5, 0.5, 0.5, 0.1]

    tc = ascube((a, b, c, d))
    nc = ascube((;a,b, c, d))

    dncnc = (a=(;a, b), b = (;c, d=(d, c)))
    tncnc = ascube(dncnc)
    x = rand(dimension(tncnc))
    p = transform(tncnc, x)
    @test inverse(tncnc, p) ≈ x

    tf = asflat((a,b,c,d))
    nf = asflat((;a,b,c,d))

    pt = transform(tc, pos)
    pn = transform(nc, pos)

    ptf = transform(tf, pos)
    pnf = transform(nf, pos)
    println(pnf)

    @test inverse(tc, pt) ≈ pos
    @test inverse(nc, pn) ≈ pos

    @test inverse(tf, ptf) ≈ pos
    @test inverse(nf, pnf) ≈ pos

    @test dimension(tc) == length(pos)
    @test transform(tc, pos) == values(transform(nc, pos))


    @inferred NTuple{3, Float64} transform(tc, pos)
end
