using Plots
include("Re2f.jl")
include("laminar.jl")
include("turb.jl")
include("smooth.jl")
include("rough.jl")

function hDeps2fRe(h, D, L, eps, g, mu, rho, fig=false)
    # Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,s]) computes
    # the Reynolds number Re and
    # the Darcy friction factor f, given
    # thehead loss h,
    # the hydraullic diameter D,
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
    # # the pipe's hydraulic diameter D=10 cm,
    # # length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc:
    # h=40;D=10;L=2500;eps=0.0025;g=981;mu=0.0089;rho=0.989;
    # Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho)
    # thk=eps*D #pipe's roughness
    # v=Re*mu/rho/D #flow speed
    # Q=v*(pi/4*D^2) #volumetric flow rate
    # # Alternatively:
    # Re,f=hDeps2fRe(40,10,2500,0.0025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # Re,f=hDeps2fRe(40,10,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the pipe's hydraulic diameter D=0.7 cm,
    # # length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # Re,f=hDeps2fRe(40,0.7,2500,0.0025,981,0.0089,0.989,true)
    #
    # See also: Re2f, f2Re, hveps2fRe, hvthk2fRe, hQeps2fRe, hQthk2fRe
    K = 2 * g * h * rho^2 * D^3 / mu^2 / L
    islam = true
    Re = K / 64
    f = 64 / Re
    if Re > 2.3e3
        islam = false
        Re = 1e4
        f = Re2f(Re, eps)
        while abs(f - K / Re^2) / f > 5e-3
            if f - K / Re^2 < 0
                Re = Re * 1.02
            else
                Re = Re * 0.98
                if Re < 2.3e3
                    islam = true
                    Re = K / 64
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
        turb(eps / 5)
        turb(eps / 2)
        turb(eps)
        turb(eps * 2)
        turb(eps * 5)
        display(plot!([Re], [f],
            seriestype=:scatter,
            color=:red))
        display(plot!([Re / 10; Re * 10], [K / (Re / 10)^2; K / (Re * 10)^2],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end
