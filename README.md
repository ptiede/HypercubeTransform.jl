# HypercubeTransform

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ptiede.github.io/HypercubeTransform.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ptiede.github.io/HypercubeTransform.jl/dev)
[![Build Status](https://github.com/ptiede/HypercubeTransform.jl/workflows/CI/badge.svg)](https://github.com/ptiede/HypercubeTransform.jl/actions)
[![codecov](https://codecov.io/gh/ptiede/HypercubeTransform.jl/graph/badge.svg?token=1FIQV6P5ZJ)](https://codecov.io/gh/ptiede/HypercubeTransform.jl)[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl)

We love to use nested sampling with the [Event Horizon Telescope (EHT)](http://eventhorizontelescope.org/), but it is rather annoying to constantly write the prior transformation. This package will do that for you. It does this by first looking at the types of the 
distribution and constructing a transformation function. 


**MORE TO COME**

## Example
```julia
using Distributions
using HypercubeTransform
priors = (a=Normal(0.0 ,5.0), b = Uniform(-10.0, 10.0), c=Product([Cauchy(), Gamma()]))
hc = ascube(priors)

transform(hc, rand(length(priors)))
```
