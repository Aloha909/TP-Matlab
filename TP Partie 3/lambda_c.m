function lambda = lambda_c(A, c)
    % Valeur propre la plus proche de c
    disp("lambda_c");
    Zc = inv(A - c*eye(625));
    [lambda_z, vecteur] = puissance_iteree(Zc, "colonne");
    lambda_1 = c + (1 / lambda_z);
    Zc = inv(A + c*eye(625));
    [lambda_z, vecteur] = puissance_iteree(Zc, "colonne");
    lambda_2 = - c + (1 / lambda_z);

    if (abs(abs(lambda_1) - abs(c)) < abs(abs(lambda_2) - abs(c)))
        lambda = lambda_1;
    else
        lambda = lambda_2;
    end
end