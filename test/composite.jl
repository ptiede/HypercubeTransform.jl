import Distributions
const Dists = Distributions
using HypercubeTransform
using Test
using ComponentArrays



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
    d1 = NamedDist((a=Dists.Normal(), b = Dists.Uniform(), c = Dists.MvNormal(ones(2))))
    @test length(d1) == 3
    @test propertynames(d1) == (:a, :b, :c)
    @test d1.a == Dists.Normal()
    x1 = rand(d1)
    @test rand(d1, 2) isa Vector{<:NamedTuple}
    @test size(rand(d1, 2)) == (2,)
    rand(d1, 20, 21)
    @test Dists.logpdf(d1, x1) ≈ Dists.logpdf(d1.a, x1.a) + Dists.logpdf(d1.b, x1.b) + Dists.logpdf(d1.c, x1.c)

    dists = getfield(d1, :dists)
    xt = (b = 0.5, a = 1.0, c = [-0.5, 0.6])
    @test Dists.logpdf(d1, xt) ≈ Dists.logpdf(d1.a, xt.a) + Dists.logpdf(d1.b, xt.b) + Dists.logpdf(d1.c, xt.c)

    d2 = NamedDist(a=(Dists.Uniform(), Dists.Normal()), b = Dists.Beta(), c = [Dists.Uniform(), Dists.Uniform()], d = (a=Dists.Normal(), b = Dists.MvNormal(ones(2))))
    @inferred Dists.logpdf(d2, rand(d2))
    p0 = (a=(0.5, 0.5), b = 0.5, c = [0.25, 0.75], d = (a = 0.1, b = fill(0.1, 2)))
    @test typeof(p0) == typeof(rand(d2))
    tf = asflat(d2)
    tc = ascube(d2)
    @inferred transform(tf, randn(dimension(tf)))
    # @inferred TV.transform(tc, rand(dimension(tc)))
    show(d1)
    show(d2)

end

@testset "TupleDist" begin
    d1 = TupleDist((Dists.Normal(), Dists.Uniform(), Dists.MvNormal(ones(2))))
    @test length(d1) == 3
    @test length(rand(d1, 2)) == 2
    @test size(rand(d1, 2, 3)) == (2, 3)
end

@testset "ComponentDist" begin
    dnt = NamedDist((a=Dists.Normal(), b = Dists.Uniform(), c = Dists.MvNormal(ones(2))))
    dcp = ComponentDist((a=Dists.Normal(), b = Dists.Uniform(), c = Dists.MvNormal(ones(2))))
    @test propertynames(dcp) == (:a, :b, :c)
    @test dcp.a == Dists.Normal()
    x1 = rand(dcp)
    @test rand(dcp) isa ComponentArray
    @test Dists.logpdf(dcp, x1) ≈ Dists.logpdf(dcp.a, x1.a) + Dists.logpdf(dcp.b, x1.b) + Dists.logpdf(dcp.c, x1.c)



    dists = getfield(dcp, :dists)
    xt = ComponentArray((b = 0.5, a = 1.0, c = [-0.5, 0.6]))
    @test Dists.logpdf(dcp, xt) ≈ Dists.logpdf(dcp.a, xt.a) + Dists.logpdf(dcp.b, xt.b) + Dists.logpdf(dcp.c, xt.c)
    @test Dists.logpdf(dcp, xt) ≈ Dists.logpdf(dnt, NamedTuple(xt))

    # Now test gradients
    tcp = asflat(dcp)
    tnt = asflat(dnt)

    fcp = let tcp = tcp, dcp = dcp
        x->begin
            y, lj = transform_and_logjac(tcp, x)
            return Dists.logpdf(dcp, y) + lj
            end
        end

    fnt = let tnt = tnt, dnt = dnt
        x->begin
               y, lj = transform_and_logjac(tnt, x)
               return Dists.logpdf(dnt, y) + lj
            end
        end

    show(IOBuffer(), MIME"text/plain"(), dcp)
    show(IOBuffer(), MIME"text/plain"(), tcp)

    x = randn(dimension(tcp))
    @test fcp(x) ≈ fnt(x)

    @test inverse(tcp, transform(tcp, x)) ≈ x

    # d2 = ComponentDist(a=(Dists.Uniform(), Dists.Normal()), b = Dists.Beta(), c = [Dists.Uniform(), Dists.Uniform()], d = (a=Dists.Normal(), b = Dists.MvNormal(ones(2))))
    # @inferred Dists.logpdf(d2, rand(d2))
    # p0 = ComponentVector((a=(0.5, 0.5), b = 0.5, c = [0.25, 0.75], d = (a = 0.1, b = fill(0.1, 2))))
    # @test typeof(p0) == typeof(rand(d2))
    # tf = asflat(d2)
    # @inferred transform(tf, randn(dimension(tf)))

end
