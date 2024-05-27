function A = StraightNeedlePolygon(tip,qI,qG)
    %tip is isosceles triangle [w,l]
    base = [0 0 tip(2); tip(1)/2 -tip(1)/2 0;1 1 1];

    A = [cos(qI(3)) -sin(qI(3)) qI(1); sin(qI(3)) cos(qI(3)) qI(2)]*base;
    A = [A, [cos(qG(3)) -sin(qG(3)) qG(1); sin(qG(3)) cos(qG(3)) qG(2)]*base];
    A = SortVertices(A);
end