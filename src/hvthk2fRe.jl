using Plots

function hvthk2fRe(h, v, L, thk, g, mu, rho, fig=false)
    # Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho[,s]) computes
    # the Reynolds number Re and
    # the Darcy friction factor f, given
    # the head loss h,
    # the flow speed v,
    # the tube length L,
    # the roughness thk,
    # the gravitational accelaration g,
    # the fluid's dynamic viscosity mu and
    # the fluid's density rho.
    # If s=true is given,a schematic Moody diagram
    #  is plotted as a graphical representation
    #  of the computation.
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the flow speed v=100 cm/s,
    # # the pipe's length L=2500 cm and
    # # roughness thk=0.0025 cm,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc:
    # h=40;v=110;L=2500;eps=0.0025;g=981;mu=0.0089;rho=0.989;
    # Re,f=hvthk2fRe(h,v,L,eps,g,mu,rho)
    # D=Re*mu/rho/v #pipe's hydraulic diameter
    # eps=thk/D #pipe's relative roughness
    # Q=v*(pi/4*D^2) #volumetric flow rate
    # # Alternatively:
    # Re,f=hvthk2fRe(40,100,2500,0.005,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # Re,f=hvthk2fRe(40,100,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the flow speed v=20 cm/s,
    # # the pipe's length L=2500 cm and
    # # roughness thk=0.0025 cm,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # Re,f=hvthk2fRe(40,20,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the flow speed v=27 cm/s,
    # # the pipe's length L=2500 cm and
    # # roughness thk=0.0025 cm,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # Re,f=hvthk2fRe(40,27,2500,0.0025,981,0.0089,0.989,true)
    #
    # See also: Re2f, f2Re, hDeps2fRe, hveps2fRe, hQeps2fRe, hQthk2fRe
    M = 2 * g * mu * h / v^3 / rho / L
    isturb = true
    Re = 1e4
    f = M * Re
    D = Re * mu / v / rho
    eps = thk / D
    f = 64 / Re
    while abs(f - Re * M) / f > 5e-3
        if f - Re * M > 0
            Re = Re * 1.02
        else
            Re = Re * 0.98
            if Re < 2.3e3
                isturb = false
                Re = sqrt(64 / M)
                f = 64 / Re
                D = Re * mu / v / rho
                eps = thk / D
                break
            end
        end
        f = M * Re
        D = Re * mu / v / rho
        eps = thk / D
        f = Re2f(Re, eps)
    end
    if isturb && sqrt(64 / M) < 2.3e3
        Re = [sqrt(64 / M); Re]
        f = [64 / sqrt(64 / M); f]
    end
    if fig
        plot(xlabel="Re",
            ylabel="f",
            xlims=(1e2, 1e7),
            ylims=(6e-3, 1e-1),
            legend=false,
            framestyle=:box,
            scale=:log10,
            grid=:true,
            minorgrid=:true)
        laminar()
        turb(eps / 5)
        turb(eps / 2)
        turb(eps)
        turb(eps * 2)
        turb(eps * 5)
        display(plot!([Re], [f],
            seriestype=:scatter,
            color=:red))
        display(plot!([Re / 10; Re * 10], [M * Re / 10; M * Re * 10],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
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