function [x1,y1,theta1] = odometry(x0,y0,theta0,t0,rotl0,rotr0,t1,rotl1,rotr1)
    R = 0.028;
    D = 0.12;
    if(t1 <= t0)
        x1 = x0;
        y1 = y0;
        theta1 = theta0;
    else
        incRotl = deg2rad(double(rotl1 - rotl0));
        incRotr = deg2rad(double(rotr1 - rotr0));
        div = (incRotl*R + incRotr*R)/2.0;
        x1 = x0 + div * cos(theta0);
        y1 = y0 + div * sin(theta0);
        theta1 = theta0 + (incRotr*R - incRotl*R)/D;
    end
end