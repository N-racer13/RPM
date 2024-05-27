function Urep = U_rep(q, CB, max_r)
    eta = 20;
    Urep = zeros(size(q));
    for i = 1:numel(CB)
        % Get closest point to object
       [closest_i, distance_i] = closest_obs(q, CB{i});
        % Calculate repulsive field
       delta_r = (q - closest_i)/distance_i;
       if distance_i <= max_r
           Urep = Urep + eta*(1/max_r - 1/distance_i)*(distance_i^(-2))*delta_r;
       else
           % Urep = 0;
       end
    end
end