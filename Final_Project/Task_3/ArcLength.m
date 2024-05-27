function len = ArcLength(V1,V2,r,dir)
    %dir: 1 = left, -1 = right
    theta = atan2(V2(2),V2(1)) - atan2(V1(2),V1(1));
    if theta < 0 && dir == 1
        theta = theta+2*pi;
    elseif theta > 0 && dir ==  -1
        theta = theta - 2*pi;
    end
    len = theta*r;
end