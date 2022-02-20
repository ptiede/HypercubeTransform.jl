using HypercubeTransform
using Documenter

DocMeta.setdocmeta!(HypercubeTransform, :DocTestSetup, :(using HypercubeTransform); recursive=true)

makedocs(;
    modules=[HypercubeTransform],
    authors="ptiede <ptiede91@gmail.com> and contributors",
    repo="https://github.com/ptiede/HypercubeTransform.jl/blob/{commit}{path}#{line}",
    sitename="HypercubeTransform.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ptiede.github.io/HypercubeTransform.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ptiede/HypercubeTransform.jl",
    devbranch = "main"
)
