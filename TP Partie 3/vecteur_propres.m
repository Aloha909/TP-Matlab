function vecteur_propres()
    A = randi(100, 5, 5);
    % A = [-27.6885 -73.6885; -72.6885 -88.6885];
    % A = [95 49; 50 34];
    disp(A)
    [V, D] = eig(A);
    disp(D);
    disp(V);
    % [lambda, vecteur] = puissance_iteree(A, 'colonne');
    % disp(lambda);
    % disp(vecteur);
    A = deflation(A);
    % disp(A)
end