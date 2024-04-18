import Distributions
const Dists = Distributions
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

@testset "NamedDist" begin
    d1 = NamedDist((a=Normal(), b = Uniform(), c = MvNormal(ones(2))))
    @test propertynames(d1) == (:a, :b, :c)
    @test d1.a == Normal()
    x1 = rand(d1)
    @test rand(d1, 2) isa Vector{<:NamedTuple}
    @test size(rand(d1, 2)) == (2,)
    rand(d1, 20, 21)
    @test logpdf(d1, x1) ≈ logpdf(d1.a, x1.a) + logpdf(d1.b, x1.b) + logpdf(d1.c, x1.c)

    dists = getfield(d1, :dists)
    xt = (b = 0.5, a = 1.0, c = [-0.5, 0.6])
    @test logpdf(d1, xt) ≈ logpdf(d1.a, xt.a) + logpdf(d1.b, xt.b) + logpdf(d1.c, xt.c)

    d2 = NamedDist(a=(Uniform(), Normal()), b = Beta(), c = [Uniform(), Uniform()], d = (a=Normal(), b = ImageUniform(2, 2)))
    @inferred logdensityof(d2, rand(d2))
    p0 = (a=(0.5, 0.5), b = 0.5, c = [0.25, 0.75], d = (a = 0.1, b = fill(0.1, 2, 2)))
    @test typeof(p0) == typeof(rand(d2))
    tf = asflat(d2)
    # tc = ascube(d2)
    @inferred TV.transform(tf, randn(dimension(tf)))
    # @inferred TV.transform(tc, rand(dimension(tc)))
    show(d1)
    show(d2)

end
