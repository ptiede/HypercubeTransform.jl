# HypercubeTransform

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ptiede.github.io/HypercubeTransform.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ptiede.github.io/HypercubeTransform.jl/dev)
[![Build Status](https://github.com/ptiede/HypercubeTransform.jl/workflows/CI/badge.svg)](https://github.com/ptiede/HypercubeTransform.jl/actions)
[![Coverage](https://coveralls.io/repos/github/ptiede/HypercubeTransform.jl/badge.svg?branch=master)](https://coveralls.io/github/ptiede/HypercubeTransform.jl?branch=master)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

We love to use nested sampling with the EHT, but it is rather annoying to constantly write the prior transformation. This package will do that for you. It does this by first looking at the types of the 
distribution and constructing a transformation function. This also can be automated with Soss.jl.
