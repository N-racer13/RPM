function supportingPoint = SupportMapping(A,dir)
    %normalize direction
    dir = dir/norm(dir);
    %support point has largest projection on direction vector
    [~,idx] = max(A'*dir);
    supportingPoint = A(:,idx);
end