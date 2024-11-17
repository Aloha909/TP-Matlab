function [nb_iter, X] = gauss_seidel(A, B, epsilon)
    nb_iter = 0;
    n = length(A);
    if length(B) ~= n
        disp("Les dimensions sont mauvaises")
        exit;
    end
    X = ones(n, 1);
    % v = diag(A);
    % M = diag(v);
    % N = A - M;

    while ((max(abs(A * X - B)) > epsilon) && nb_iter < 10000)
        for i = 1:n
            somme = 0;
            for j = 1:n
                if (j~=i)
                    somme = somme + (A(i, j) * X(j, 1));
                end
            end
            X(i, 1) = (B(i, 1) - somme) / A(i, i);
        end
        nb_iter = nb_iter + 1;
    end
    
end