using Plots
include("bissecao.jl")
include("figure.jl")

# Follow these steps in the console:
# https://invenia.github.io/PkgTemplates.jl/stable/
# using Pkg
# Pkg.add("PkgTemplates")
# using PkgTemplates
# t = Template(;
#     user="aumpierre-unb",
#     authors="Alexandre Umpierre <aumpierre@gmail.com>",
#     license="MIT",
#     authors=["Alexandre Umpierre"],
#     plugins=[Git(),GitHubActions(),])
# t("InternalFluidFlow")

function Re2f(Re, eps=0, fig=false)
    if eps > 5e-2
        eps = 5e-2
    end
    if Re < 2.3e3
        f = 64 / Re
    else
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re / sqrt(f))
        end
        f = bissecao(foo, 6e-3, 1e-1, 1e-4)
    end
    if fig
        figure(eps)
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([Re; Re], [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return f
end
