function plot_arc(t1,t2,c,rout,rin,mod)
    t = linspace(t1,t2);
    x = [rout*cos(t), rin*cos(flip(t))] + c(1);
    y = [rout*sin(t), rin*sin(flip(t))] + c(2);
    x = [x x(1)];
    y = [y y(1)];
    fill(x,y,mod);
end