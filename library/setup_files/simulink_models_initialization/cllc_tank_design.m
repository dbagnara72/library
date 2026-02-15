function cllc_tank = cllc_tank_design(fres, udc, pnom)

    cllc_tank.Ls = (udc^2/(2*pi*fres)/pnom*pi/4);
    cllc_tank.Cs = 1/cllc_tank.Ls/(2*pi*fres)^2;

end