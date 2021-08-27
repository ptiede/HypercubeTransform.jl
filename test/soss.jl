using Soss
using HyperCubeTransform
import Distributions as Dists
import MeasureTheory as MT
using Test

@testset "Soss" begin
    m1 = @model begin
        a~Dists.Normal()
        b~Dists.Uniform()
        c~Dists.Gamma()
        return a*b/c
    end

    m2 = @model m1 begin
        z ~ m1
    end

    h2 = hform(m2(m1=m1()))
    h1 = hform(m1())
    @test dimension(h2) == dimension(h1)
    pos = [0.5, 0.5, 0.5]
    @test transform(h1, pos) == transform(h2, pos)[1]
    @inferred transform(h2, pos)
end
