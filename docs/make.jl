using HyperActiveLearning
using Documenter

DocMeta.setdocmeta!(HyperActiveLearning, :DocTestSetup, :(using HyperActiveLearning); recursive=true)

makedocs(;
    modules=[HyperActiveLearning],
    authors="Christoph Ortner <c.ortner@warwick.ac.uk> and contributors",
    repo="https://github.com/cortner/HyperActiveLearning.jl/blob/{commit}{path}#{line}",
    sitename="HyperActiveLearning.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cortner.github.io/HyperActiveLearning.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cortner/HyperActiveLearning.jl",
    devbranch="main",
)
