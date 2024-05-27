function state = growUnicycle(state,us,uw,dt)
    if uw ~= 0
        state(1) = state(1) + (us/uw)*(sin(state(3) + uw*dt) - sin(state(3)));
        state(2) = state(2) + (us/uw)*(cos(state(3)) - cos(state(3) + uw*dt));
        state(3) = state(3) + uw*dt;
    else
        state(1) = state(1) + us*dt*cos(state(3));
        state(2) = state(2) + us*dt*sin(state(3));
    end
end