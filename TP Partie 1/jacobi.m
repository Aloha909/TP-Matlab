function [nb_iter, X] = jacobi(A, B, epsilon)
    nb_iter = 0;
    n = length(A);
    if length(B) ~= n
        disp("Les dimensions sont mauvaises")
        exit;
    end
    X0 = ones(n, 1);
    % v = diag(A);
    % M = diag(v);
    % N = A - M;

    X = X0;

    while ((max(abs(A * X - B)) > epsilon) && nb_iter < 10000)
        for i = 1:n
            somme = 0;
            for j = 1:n
                if (j~=i)
                    somme = somme + (A(i, j) * X0(j, 1));
                end
            end
            X(i, 1) = (B(i, 1) - somme) / A(i, i);
        end
        X0 = X;
        nb_iter = nb_iter + 1;
    end
    
end