using Documenter
using SenseHat

makedocs(
    sitename = "SenseHat",
    format = Documenter.HTML(),
    modules = [SenseHat],
    pages = [
        "index.md",
        "API Docs" => "api.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
