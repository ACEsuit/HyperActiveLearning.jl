using HyperActiveLearning
using Documenter

DocMeta.setdocmeta!(HyperActiveLearning, :DocTestSetup, :(using HyperActiveLearning); recursive=true)

makedocs(;
    modules=[HyperActiveLearning],
    authors="Christoph Ortner <christophortner0@gmail.com> and contributors (pleae add your names)",
    repo="https://github.com/ACEsuit/HyperActiveLearning.jl/blob/{commit}{path}#{line}",
    sitename="HyperActiveLearning.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ACEsuit.github.io/HyperActiveLearning.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ACEsuit/HyperActiveLearning.jl",
    devbranch="main",
)
