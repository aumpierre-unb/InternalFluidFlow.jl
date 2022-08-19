#=
h=40;D=10;L=2.3e3;thks=0.025;g=981;mu=.0089;rho=.989;
epsn=thks/D

(Re,f)=hDeps2fRe(h,D,L,epsn,g,mu,rho)
v=Re*mu/rho/D
Q=v*(pi/4*D^2)

(Re,f)=hveps2fRe(h,v,L,epsn,g,mu,rho)
D=Re*mu/rho/v
Q=v*(pi/4*D^2)

(Re,f)=hQeps2fRe(h,Q,L,epsn,g,mu,rho)
D=Re*mu/rho/v
v=Q/(pi/4*D^2)

(Re,f)=hQthk2fRe(h,Q,L,thks,g,mu,rho)
D=Q*rho/(pi/4)/Re/mu
v=Q/(pi/4*D^2)
epsn=thks/D
=#

using Plots

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
    # # e.g. Compute the Darcy friction factor f given
    # # the Reynolds number Re=1.2e5 and
    # # the default smooth condition, eps=0:
    # f=Re2f(1.2e5,:,true)
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

function f2Re(f, eps=0, fig=false)
    # [Re]=f2Re(f,[eps[,s]]) computes
    # the Reynolds number Re, given
    # the Darcy friction factor f and
    # the relative roughness eps for
    # for laminar regime and,
    # when possible, also
    # for turbulent regime.
    # By default eps=2e-3.
    # If eps>5e-2, execution is aborted.
    # If s=true is given,a schematic Moody diagram
    #  is plotted as a graphical representation
    #  of the computation.
    #
    # # e.g. Compute Reynolds number Re for
    # # Darcy friction factor f=0.028 and
    # # relative roughness eps=0.001.
    # # In this case, both laminar and turbulent
    # # solutions are possible:
    # f=0.028;eps=0.001;
    # Re=f2Re(f,eps)
    # # Alternatively:
    # Re=f2Re(0.028,0.001)
    # # This call computes Re given
    # # f=0.028 and eps=0.001 and
    # # displays a schematic Moody Diagram:
    # Re=f2Re(0.028,0.001,true)
    #
    # # e.g. Compute the Reynolds number Re given
    # # the Darcy friction factor f=0.023 and
    # # the default smooth condition, eps=0.
    # # In this case, only the turbulent
    # # solution is possible:
    # Re=f2Re(0.028,0.001,true)
    #
    # # e.g. Compute the Reynolds number Re given
    # # the Darcy friction factor f=0.028 and
    # # the default smooth condition, eps=0:
    # Re=f2Re(0.028,:,true)
    #
    # See also: Re2f, hDeps2fRe, hveps2fRe, hvthk2fRe, hQeps2fRe, hQthk2fRe
    if eps > 5e-2
        eps = 5e-2
    end
    Re = []
    fD = []
    if 64 / f < 2.3e3
        Re = [Re; 64 / f]
        fD = [fD; f]
    end
    if f > (2 * log10(3.7 / eps))^-2
        function foo(Re)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re / sqrt(f))
        end
        r = bissecao(foo, 1e3, 1e8, 1e-4)
        if r > 2.5e3
            Re = [Re; r]
            fD = [fD; f]
        end
    end
    if !isempty(fD) & fig
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
        display(plot!([1e2; 1e8], [f; f],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return Re
end

function hDeps2fRe(h, D, L, eps, g, mu, rho, fig=false)
    # [Re,f]=hDeps2fRe(h,D,L,eps,g,mu,rho[,s]) computes
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
    # [Re,f]=hDeps2fRe(h,D,L,eps,g,mu,rho)
    # thk=eps*D #pipe's roughness
    # v=Re*mu/rho/D #flow speed
    # Q=v*(pi/4*D^2) #volumetric flow rate
    # # Alternatively:
    # [Re,f]=hDeps2fRe(40,10,2500,0.0025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # [Re,f]=hDeps2fRe(40,10,2500,0.0025,981,0.0089,0.989,true)
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
    # [Re,f]=hDeps2fRe(40,0.7,2500,0.0025,981,0.0089,0.989,true)
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

function hveps2fRe(h, v, L, eps, g, mu, rho, fig=false)
    # [Re,f]=hveps2fRe(h,v,L,eps,g,mu,rho[,s]) computes
    # the Reynolds number Re and
    # the Darcy friction factor f, given
    # the head loss h,
    # the flow speed v,
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
    # # the flow speed v=100 cm/s,
    # # the pipe's length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc:
    # h=40;v=110;L=2500;eps=0.0025;g=981;mu=0.0089;rho=0.989;
    # [Re,f]=hveps2fRe(h,v,L,eps,g,mu,rho)
    # D=Re*mu/rho/v #pipe's hydraulic diameter
    # thk=eps*D #pipe's roughness
    # Q=v*(pi/4*D^2) #volumetric flow rate
    # # Alternatively:
    # [Re,f]=hveps2fRe(40,100,2500,0.0025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # [Re,f]=hveps2fRe(40,100,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the flow speed v=20 cm/s,
    # # the pipe's length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # [Re,f]=hveps2fRe(40,20,2500,0.0025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=40 cm,
    # # the flow speed v=27 cm/s,
    # # the pipe's length L=2500 cm and
    # # relative roughness eps=0.0025,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # [Re,f]=hveps2fRe(40,27,2500,0.0025,981,0.0089,0.989,true)
    #
    # See also: Re2f, f2Re, hDeps2fRe, hvthk2fRe, hQeps2fRe, hQthk2fRe
    M = 2 * g * mu * h / v^3 / rho / L
    isturb = true
    Re = 1e4
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
                break
            end
        end
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

function hvthk2fRe(h, v, L, thk, g, mu, rho, fig=false)
    # [Re,f]=hvthk2fRe(h,v,L,thk,g,mu,rho[,s]) computes
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
    # [Re,f]=hvthk2fRe(h,v,L,eps,g,mu,rho)
    # D=Re*mu/rho/v #pipe's hydraulic diameter
    # eps=thk/D #pipe's relative roughness
    # Q=v*(pi/4*D^2) #volumetric flow rate
    # # Alternatively:
    # [Re,f]=hvthk2fRe(40,100,2500,0.005,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # [Re,f]=hvthk2fRe(40,100,2500,0.0025,981,0.0089,0.989,true)
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
    # [Re,f]=hvthk2fRe(40,20,2500,0.0025,981,0.0089,0.989,true)
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
    # [Re,f]=hvthk2fRe(40,27,2500,0.0025,981,0.0089,0.989,true)
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

function hQeps2fRe(h, Q, L, eps, g, mu, rho, fig=false)
    # [Re,f]=hQeps2fRe(h,Q,L,eps,g,mu,rho[,s]) computes
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
    # [Re,f]=hQeps2fRe(h,Q,L,eps,g,mu,rho)
    # D=Q*rho/(pi/4)/Re/mu #pipe's hydraulic diameter
    # thk=eps*D #pipe's roughness
    # v=Q/(pi/4*D^2) #flow speed
    # # Alternatively:
    # [Re,f]=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # [Re,f]=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989,true)
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
    # [Re,f]=hQeps2fRe(40,8600,2500,0.0025,981,0.0089,0.989,true)
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
        turb(eps / 5)
        turb(eps / 2)
        turb(eps)
        turb(eps * 2)
        turb(eps * 5)
        display(plot!([Re], [f],
            seriestype=:scatter,
            color=:red))
        display(plot!([Re / 10; Re * 10], [P / (Re / 10)^5; P / (Re * 10)^5],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end

function hQthk2fRe(h, Q, L, thk, g, mu, rho, fig=false)
    # [Re,f]=hQthk2fRe(h,Q,L,thk,g,mu,rho[,s]) computes
    # the Reynolds number Re and
    # the Darcy friction factor f, given
    # the head loss h,
    # the volumetric flow Q,
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
    # # the volumetric flow rate Q=8600 cc/s,
    # # the pipe's length L=2500 cm and
    # # roughness thk=0.025 cm,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc:
    # h=40;Q=8600;L=2500;thk=0.025;g=981;mu=0.0089;rho=0.989;
    # [Re,f]=hQthk2fRe(h,Q,L,thk,g,mu,rho)
    # D=Q*rho/(pi/4)/Re/mu #pipe's hydraulic diameter
    # eps=thk/D #pipe's relative roughness
    # v=Q/(pi/4*D^2) #flow speed
    # # Alternatively:
    # [Re,f]=hQthk2fRe(40,8600,2500,0.025,981,0.0089,0.989)
    # # This call computes Re and f for the given inputs and
    # # displays a schematic Moody Diagram:
    # [Re,f]=hQthk2fRe(40,8600,2500,0.025,981,0.0089,0.989,true)
    #
    # # e.g. Compute the Reynolds number Re and
    # # the Darcy friction factor f, given
    # # the head loss h=15 cm,
    # # the volumetric flow rate Q=20 cc/s,
    # # the pipe's length L=2500 cm and
    # # roughness thk=0.0025 cm,
    # # the gravitational acceleration g=981 cm/s/s, and
    # # the fluid's dynamic viscosity mu=0.0089 g/cm/s and
    # # density rho=0.989 g/cc, and
    # # display a schematic Moody Diagram:
    # [Re,f]=hQthk2fRe(15,20,2500,0.0025,981,0.0089,0.989,true)
    #
    # See also: Re2f, f2Re, hDeps2fRe, hveps2fRe, hvthk2fRe, hQeps2fRe
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (mu / rho)^5 / L
    Re = (P / 64)^(1 / 4)
    f = 64 / Re
    if Re > 2.3e3
        Re = 1e4
        f = P / Re^5
        D = rho * Q / Re / mu / (pi / 4)
        eps = thk / D
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
            f = P / Re^5
            D = rho * Q / Re / mu / (pi / 4)
            eps = thk / D
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
        display(plot!([Re / 10; Re * 10], [P / (Re / 10)^5; P / (Re * 10)^5],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end

function laminar()
    Re = [500; 4000]
    f = 64 ./ Re
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end

function turb(eps)
    Re = []
    f = []
    N = 51
    for i in 1:N
        w = log10(2e3) + (i - 1) * (log10(1e8) - log10(2e3)) / (N - 1)
        Re = [Re; 10^w]
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re[end] / sqrt(f))
        end
        f = [f; bissecao(foo, 6e-4, 1e-1, 1e-4)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end

function smooth()
    Re = []
    f = []
    N = 31
    for i = 1:N
        w = log10(2e3) + (i - 1) * (log10(1e7) - log10(2e3)) / (N - 1)
        Re = [Re; 10^w]
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(2.51 / Re[end] / sqrt(f))
        end
        f = [f; bissecao(foo, 6e-3, 1e-1, 1e-4)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end

function rough()
    eps = []
    f = []
    Re = []
    N = 31
    for i = 1:N
        w = log10(4e-5) + (i - 1) * (log10(5e-2) - log10(4e-5)) / (N - 1)
        eps = [eps; 10^w]
        f = [f; 1.01 * (2 * log10(3.7 / eps[end]))^-2]
        z = f2Re(f[end], eps[end])
        Re = [Re; z[end]]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end

function bissecao(foo, x1, x2, tol)
    while abs(foo(x2)) > tol
        x = (x1 + x2) / 2
        if foo(x) * foo(x1) > 0
            x1 = x
        else
            x2 = x
        end
    end
    return x2
end
