function U_r = U_rep( pt , Opoints)
% Parameters
eta = 0.1;
Q = 1.5;
U_r = [ 0 ; 0 ];
% Potential field calculation for every object line
for i = 1:1:size(Opoints, 3)
    Opoint_i = Opoints( : , : , i );
    % Closest point on object line to control point
    [closest_point, distance] = closestEdgePointToPoint([Opoint_i(:, 1), Opoint_i(:, 2) ], pt );
    for j = 2:1:size(Opoint_i, 2) - 1
        [closest_temp, distance_temp] = closestEdgePointToPoint([Opoint_i(:, j), Opoint_i(:, j+1)], pt);
        if distance_temp < distance
            closest_point = closest_temp;
            distance = distance_temp;
        end
    end
    if distance <= Q
        U_r = U_r + eta*(1/Q - 1/distance)*(1/distance^2)*(pt - closest_point)/distance;
    else
        U_r = U_r + [0; 0];
    end
end
end