var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = HypercubeTransform","category":"page"},{"location":"#HypercubeTransform","page":"Home","title":"HypercubeTransform","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for HypercubeTransform.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [HypercubeTransform]","category":"page"},{"location":"#HypercubeTransform.ascube","page":"Home","title":"HypercubeTransform.ascube","text":"`ascube(c)`\n\nConstructs the object that contains the necessary information to move from the unit hypercube to the distribution space. This is the usual function to use when construct the transformation.\n\nThere are a few different behaviors depending on the type of the object.\n\nIf c::Distribution then this will store the distributions.\nIf c::Tuple{AbstractHypercubeTransform} then this will store the tuple\n\nExamples\n\nascube(Normal())\nascube(MultivariateNormal())\nascube((Normal(), Normal(2.0)))\nascube( (α = Uniform(), β = Normal()) )\n\n\n\n\n\n","category":"function"},{"location":"#HypercubeTransform.transform_tuple-Tuple{Tuple{Vararg{HypercubeTransform.AbstractHypercubeTransform, N}} where N, Any, Any}","page":"Home","title":"HypercubeTransform.transform_tuple","text":"transform_tuple(tt, x, index)\n\n\nHelper function that steps through the transformation tuple\n\n\n\n\n\n","category":"method"},{"location":"#TransformVariables.dimension","page":"Home","title":"TransformVariables.dimension","text":"`dimension(c::AbstractHypercubeTransform)`\n\nReturns the dimension of the hypercube transform.\n\n\n\n\n\n","category":"function"},{"location":"#TransformVariables.inverse-Tuple{HypercubeTransform.AbstractHypercubeTransform, Any}","page":"Home","title":"TransformVariables.inverse","text":"`inverse(c::AbstractHypercubeTransform, p)`\n\nTransforms from the parameter space p, to the unit hypercube defined by the transformation c.\n\nThe behavior of this function depends on the nature of c.\n\nIf c is a <: Distributions.Distributions and has a cdf method\n\nthis will just call the cdf function. If no cdf function is defined then a custom transformation depending on the type of c will be called. If no custom transformation exists then an error will be raised.\n\nIf c is a Tuple of transformations then inverse will iterate through the\n\ntuple using a similar method to the  TransformVariables.jl method.\n\n\n\n\n\n","category":"method"},{"location":"#TransformVariables.transform","page":"Home","title":"TransformVariables.transform","text":"`transform(c::AbstractHypercubeTransform, p)`\n\nTransforms from the hypercube with coordinates p, to the parameter space defined by the transformation c.\n\nThe behavior of this function depends on the nature of c.\n\nIf c is a <: Distributions.Distributions and has a quantile method\n\nthis will just call the quantile function. If no quantile function is defined then a custom transformation depending on the type of c will be called. If no custom transformation exists then an error will be raised.\n\nIf c is a Tuple of transformations then transform will iterate through the\n\ntuple using a similar method to the  TransformVariables.jl method.\n\n\n\n\n\n","category":"function"},{"location":"#TransformVariables.transform-Tuple{HypercubeTransform.AbstractHypercubeTransform, Any}","page":"Home","title":"TransformVariables.transform","text":"transform(c, x)\n\n\nComputes the transformation from the unit hypercube to the distribution space.\n\n\n\n\n\n","category":"method"}]
}