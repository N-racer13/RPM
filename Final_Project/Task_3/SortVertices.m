function A = SortVertices(A)
    %uses convhull to make sure vertices are in CCW order
    %also uses convhull so polygon is guarenteed
    order = convhull(A.');
    A = A(:,order(1:size(order)-1));
end