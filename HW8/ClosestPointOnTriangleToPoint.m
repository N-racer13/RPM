function [closest_pt, vor, edge] = ClosestPointOnTriangleToPoint(triangle, p)
    % Assign triangle points
    a = triangle(:,1);
    b = triangle(:,2);
    c = triangle(:,3);

    % Get edge vectors     
    ab = b - a;
    ba = a - b;
    ac = c - a; 
    ca = a - c;
    bc = c - b;
    cb = b - c;
    
    % Point to edges vectors
    ap = p - a;
    bp = p - b;
    cp = p - c;

    % Voronoi regions criteria
    vor.a = (dot(ab, ap) <= 0) & (dot(ac, ap) <= 0);
    vor.b = (dot(bc, bp) <= 0) & (dot(ba, bp) <= 0);
    vor.c = (dot(ca, cp) <= 0) & (dot(cb, cp) <= 0);
            
    % Edge regions criteria
    edge.ab = (dot(cross(cross([bc; 0], [ba; 0]), [ba; 0]), [bp; 0]) >= 0) & (dot(ap, ab) >= 0) & (dot(bp, ba) >= 0);
    edge.bc = (dot(cross(cross([ca; 0], [cb; 0]), [cb; 0]), [cp; 0]) >= 0) & (dot(bp, bc) >= 0) & (dot(cp, cb) >= 0);
    edge.ca = (dot(cross(cross([ab; 0], [ac; 0]), [ac; 0]), [ap; 0]) >= 0) & (dot(cp, ca) >= 0) & (dot(ap, ac) >= 0);
                     
    % Closest point based on criteria
    if vor.a
        closest_pt = triangle(:,1);
    elseif vor.b
        closest_pt = triangle(:,2);
    elseif vor.c
        closest_pt = triangle(:,3);
    elseif edge.ab
        closest_pt = (eye(2) - ba * ba'/dot(ba, ba)) * triangle(:,1) + p;
    elseif edge.bc
        closest_pt = (eye(2) - cb * cb'/dot(cb, cb)) * triangle(:,2) + p;
    elseif edge.ca
        closest_pt = (eye(2) - ac * ac'/dot(ac, ac)) * triangle(:,3) + p;
    else % inside the triangle
        closest_pt = [0; 0];
    end 
end
