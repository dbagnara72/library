function dab_tank = dab_tank_design(fpwm, fres, udc, pnom)

    dab_tank.Ls = (udc^2/fpwm/pnom/4/pi);
    dab_tank.Cs = 1/dab_tank.Ls/(2*pi*fres)^2;

end