%% This function is used to decompose face into triangle to help draw intersection
function obsTriangle = triangleDecomposition(Obs)

faceTriangle = {};

V = Obs{1};
F = Obs{2}; 
[~, faceCols] = size(F);

for i = 1:faceCols
    faceCurrent = F{i};
    verticesNum = size(faceCurrent, 2);
    for j = 1:verticesNum-2
        % Decompose face into several triangles(CCW)
        faceTriangle{end+1} = [faceCurrent(1), faceCurrent(1+j), faceCurrent(2+j)];
    end
end

obsTriangle = {V, faceTriangle};

end