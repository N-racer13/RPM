function [qNew, idx] = nearestVertex(q, G)
    d = inf;
    for i=1:size(G,2)
        currentVertex = G(:, i);
        if norm(q-currentVertex) < d
            qNew = currentVertex;
            d = norm(q-currentVertex);
            idx = i;
        end
    end
end

