function C = Minkowski(A, B)
    dim_A = size(A, 2);
    dim_B = size(B, 2);
    C = zeros(2, dim_A * dim_B);
    for i = 1:dim_A
        for j = 1:dim_B
            C(:,sub2ind([dim_A, dim_B], i, j)) = A(:,i) + B(:,j);            
        end
    end
    k = convhull(C');
    C = C(:, reshape(k, 1, []));
end