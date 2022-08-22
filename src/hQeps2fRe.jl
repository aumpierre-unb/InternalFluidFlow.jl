using Plots
include("Re2f.jl")
include("laminar.jl")
include("turb.jl")
include("smooth.jl")
include("rough.jl")

function hQeps2fRe(h, Q, L, eps, g, mu, rho, fig=false)
    # Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho[,s]) computes
    # the Reynolds number Re and
    # the Darcy friction factor f, given
    # the head loss h,
    # the volumetric flow Q,
    # the tube length L,
    # the relative roughness eps,
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
    # # the volumetric flow rate Q=8600 cc/s,
    # # the pipe's length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc:
    # h=40;Q=8600;L=2500;eps=0.0025;g=981;mu=0.0089;rho=0.989;
    # Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho)
    # D=Q*rho/(pi/4)/Re/mu #pipe's hydraulic diameter
    # thk=eps*D #pipe's roughness
    # v=Q/(pi/4*D^2) #flow speed
    # # Alternatively:
    # Re,f=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # Re,f=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=10 cm,
    # # the volumetric flow rate Q=20 cc/s,
    # # the pipe's length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # Re,f=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989,true)
    #
    # See also: Re2f, f2Re, hDeps2fRe, hveps2fRe, hvthk2fRe, hQthk2fRe
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (mu / rho)^5 / L
    Re = (P / 64)^(1 / 4)
    f = 64 / Re
    if Re > 2.3e3
        Re = 1e4
        f = Re2f(Re, eps)
        while abs(f - P / Re^5) / f > 5e-3
            if f - P / Re^5 < 0
                Re = Re * 1.02
            else
                Re = Re * 0.98
                if Re < 2.3e3
                    Re = (P / 64)^(1 / 4)
                    f = 64 / Re
                    break
                end
            end
            f = Re2f(Re, eps)
        end
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
        turb(eps)
        if eps < 1e-4
            turb(1e-5)
        else
            turb(eps / 3)
        end
        if eps < 1e-4
            turb(1e-4)
        else
            turb(eps / 10)
        end
        if eps < 1e-4
            turb(1e-3)
        elseif eps * 3 > 5e-2
            turb(5e-2)
        else
            turb(eps * 3)
        end
        if eps < 1e-4
            turb(5e-3)
        elseif eps * 10 > 5e-2
            turb(eps / 6)
        else
            turb(eps * 10)
        end
        rough()
        if eps != 0
            smooth()
        end
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([Re / 10; Re * 10], [P / (Re / 10)^5; P / (Re * 10)^5],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end
