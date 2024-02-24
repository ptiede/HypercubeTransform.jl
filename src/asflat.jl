
"""
    asflat(d::Distribution)

Computes the transformation of the support of the distribution `d` such that the
variables live on ℝⁿ where n is the dimension of the problem. This is essentially
what Turing and Stan do when reparameterizing the model.

The returned object is a `TransformVariables.AbstractTransform` object and follows that
interface. Please see the [TransformVariable docs](https://www.tamaspapp.eu/TransformVariables.jl/stable/)
for more information.
"""
function asflat end

asflat(d::Distributions.Distribution) = TransformedDistribution(d)
