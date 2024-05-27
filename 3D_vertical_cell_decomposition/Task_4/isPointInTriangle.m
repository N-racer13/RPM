function isInTriangle = isPointInTriangle(point, v1, v2, v3)
    % Formula from W. Heidrich, Journal of Graphics, GPU, and Game Tools,Volume 10, Issue 3, 2005.
    u = v2 - v1;
    v = v3 - v1;
    n = cross(u, v);
    w = point-v1;
    gamma = dot(cross(u, w), n)/norm(n)^2;
    beta = dot(cross(w, v), n)/norm(n)^2;
    alfa = 1 - gamma - beta;

    isInTriangle = (alfa >= 0 && alfa <= 1 && beta >= 0 && beta <= 1 && gamma >= 0 && gamma <= 1);
end