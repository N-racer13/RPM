function state = growUnicycle2(state,vel,alpha,action,dt)
    g = [cos(state(3)) -sin(state(3)) state(1);sin(state(3)) cos(state(3)) state(2);0 0 1];
    z_hat = [0 -action*alpha vel; action*alpha 0 0; 0 0 0]*dt;
    newstate = g*expm(z_hat);
    state = [newstate([1,2],3);atan2(newstate(2,1),newstate(1,1))];
end