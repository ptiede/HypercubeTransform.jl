import Distributions as Dists
import MeasureTheory as MT
using HyperCubeTransform
using Test

@testset "Scalar" begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.Gamma()

    ca = ascube(a)
    cb = ascube(b)
    cc = ascube(c)

    @test transform(ca, 0.5) == 0.0
    @test transform(cb, 0.5) == 0.5
    @test transform(cc, 0.5) == Dists.quantile(c, 0.5)

    @inferred Float64 transform(ca, 0.5)
end

@testset "ArrayHC" begin
    d = Dists.Product([Dists.Normal(), Dists.Uniform(), Dists.Normal()])
    m = MT.For(d.v) do p
            return p
    end
    cd = ascube(d)
    cm = ascube(m)
    @test transform(cd, [0.5,0.5,0.5]) == transform(cm, [0.5,0.5,0.5])
    cc = ascube.(d.v)
    @test transform.(cc, [0.5,0.5,0.5]) == transform(cd, [0.5,0.5,0.5])
    @inferred Vector{Float64} transform(cm, [0.5, 0.5, 0.5])
end
