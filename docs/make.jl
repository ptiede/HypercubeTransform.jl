using HyperCubeTransform
using Documenter

DocMeta.setdocmeta!(HyperCubeTransform, :DocTestSetup, :(using HyperCubeTransform); recursive=true)

makedocs(;
    modules=[HyperCubeTransform],
    authors="ptiede <ptiede91@gmail.com> and contributors",
    repo="https://github.com/ptiede/HyperCubeTransform.jl/blob/{commit}{path}#{line}",
    sitename="HyperCubeTransform.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ptiede.github.io/HyperCubeTransform.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ptiede/HyperCubeTransform.jl",
)
