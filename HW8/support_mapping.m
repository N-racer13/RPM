function V = support_mapping(C, p)
% Find supporting direction along -p on polyhedron C
    supporting_direction = ((C - p)'*(p));
    [~, index] = min(supporting_direction);
    V = C(:,index);
end