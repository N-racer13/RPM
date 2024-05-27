function C = MinkowskiDifference(A,B)
    A = -A;
    C = zeros([2,size(A,2)*size(B,2)]);
    i=1;
    for j = 1:size(A,2)
        for k = 1:size(B,2)
            C(:,i) = A(:,j) + B(:,k);
            i = i+1;
        end
    end
    order = convhull(C');
    C = C(:,order(1:size(order)-1));
end