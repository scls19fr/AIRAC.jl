using AIRAC
using Documenter

makedocs(;
    modules=[AIRAC],
    authors="Sébastien Celles <s.celles@gmail.com> and contributors",
    repo="https://github.com/scls19fr/AIRAC.jl/blob/{commit}{path}#L{line}",
    sitename="AIRAC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://scls19fr.github.io/AIRAC.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/scls19fr/AIRAC.jl",
)
