function [nb_iter, w, p_min, X] = relaxation(A, B, epsilon)
    nb_iter = 0;
    n = length(A);
    if length(B) ~= n
        disp("Les dimensions sont mauvaises")
        exit;
    end
    X = ones(n, 1);
    v = diag(A);
    D = diag(v);
    L = tril(A) - D;
    U = triu(A) - D;
    % M = D + L;
    % N = A - M;

    z = 0;
    w = 1;
    p_min = 10;
    while z<1.99
        z = z + 0.01;
        pi = inv(D + z*L) * ((1 - z) * D - z * U);
        p = max(abs(eig(pi)));
        if p < p_min
            w = z;
            p_min = p;
        end
    end

    G = X;

    while ((max(abs(A * X - B)) > epsilon) && nb_iter < 100000)
        for i = 1:n
            somme = 0;
            for j = 1:n
                if (j~=i)
                    somme = somme + (A(i, j) * G(j, 1));
                end
            end
            G(i, 1) = (B(i, 1) - somme) / A(i, i);
            X(i, 1) = (1 - w) * X(i, 1) + w * G(i, 1);
        end
        nb_iter = nb_iter + 1;
    end
    
end