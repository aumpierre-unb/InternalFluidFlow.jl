using Plots

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
    # [f]=Re2f(Re,[eps[,s]]) computes
    # the Darcy friction f factor, given
    # the Reynolds number Re and
    # the relative roughness eps.
    # By default, tube is assumed to be smooth, eps=0.
    # If eps>5e-2, eps is reset to 5e-2.
    # If s=true is given,a schematic Moody diagram
    #  is plotted as a graphical representation
    #  of the computation.
    #
    # # e.g. Compute the Darcy friction factor f given
    # # the Reynolds number Re=1.2e5 and
    # # the relative roughness eps=0.001:
    # Re=1.2e5;eps=0.001;
    # f=Re2f(Re,eps)
    # # Alternatively:
    # f=Re2f(1.2e5,0.001)
    # # This call computes f given
    # # Re=1.2e5 and eps=0.001 and
    # # displays a schematic Moody Diagram:
    # f=Re2f(1.2e5,0.001,true)
    #
    # See also: f2Re, hDeps2fRe, hveps2fRe, hvthk2fRe, hQeps2fRe, hQthk2fRe
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
        plot(xlabel="Re",
            ylabel="f",
            xlims=(1e2, 1e8),
            ylims=(6e-3, 1e-1),
            legend=false,
            framestyle=:box,
            scale=:log10,
            grid=:true,
            minorgrid=:true)
        laminar()
        turb(eps)
        if eps == 0
            turb(1e-5)
        elseif eps * 3 < 5e-2
            turb(eps * 3)
        else
            turb(eps / 2)
        end
        if eps == 0
            turb(1e-4)
        elseif eps * 10 < 5e-2
            turb(eps * 10)
        else
            turb(eps / 7)
        end
        if eps == 0
            turb(1e-3)
        else
            turb(eps / 3)
        end
        if eps == 0
            turb(6e-3)
        else
            turb(eps / 10)
        end
        rough()
        if eps != 0
            smooth()
        end
        display(plot!([Re], [f],
            seriestype=:scatter,
            color=:red))
        display(plot!([Re; Re], [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return f
end

# function laminar()
#     Re = [500; 4000]
#     f = 64 ./ Re
#     display(plot!(Re, f,
#         seriestype=:line,
#         color=:black))
# end

# function turb(eps)
#     Re = []
#     f = []
#     N = 51
#     for i in 1:N
#         w = log10(2e3) + (i - 1) * (log10(1e8) - log10(2e3)) / (N - 1)
#         Re = [Re; 10^w]
#         function foo(f)
#             return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re[end] / sqrt(f))
#         end
#         f = [f; bissecao(foo, 6e-4, 1e-1, 1e-4)]
#     end
#     display(plot!(Re, f,
#         seriestype=:line,
#         color=:black))
# end

# function smooth()
#     Re = []
#     f = []
#     N = 31
#     for i = 1:N
#         w = log10(2e3) + (i - 1) * (log10(1e7) - log10(2e3)) / (N - 1)
#         Re = [Re; 10^w]
#         function foo(f)
#             return 1 / sqrt(f) + 2 * log10(2.51 / Re[end] / sqrt(f))
#         end
#         f = [f; bissecao(foo, 6e-3, 1e-1, 1e-4)]
#     end
#     display(plot!(Re, f,
#         seriestype=:line,
#         color=:blue))
# end

# function rough()
#     eps = []
#     f = []
#     Re = []
#     N = 31
#     for i = 1:N
#         w = log10(4e-5) + (i - 1) * (log10(5e-2) - log10(4e-5)) / (N - 1)
#         eps = [eps; 10^w]
#         f = [f; 1.01 * (2 * log10(3.7 / eps[end]))^-2]
#         z = f2Re(f[end], eps[end])
#         Re = [Re; z[end]]
#     end
#     display(plot!(Re, f,
#         seriestype=:line,
#         color=:blue))
# end

# function bissecao(foo, x1, x2, tol)
#     while abs(foo(x2)) > tol
#         x = (x1 + x2) / 2
#         if foo(x) * foo(x1) > 0
#             x1 = x
#         else
#             x2 = x
#         end
#     end
#     return x2
# end