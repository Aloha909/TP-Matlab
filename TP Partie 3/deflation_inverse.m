function A = deflation_inverse(A, nombre)
    if (nargin < 2)
        nombre = length(A);
    end
    for i=1:nombre
        [lambda1, vecteur_colonne] = puissance_iteree(A, 'colonne');
        [lambda2, vecteur_ligne] = puissance_iteree(A, 'ligne');
        lambda = (lambda1 + lambda2) / 2;

        surf(reshape(vecteur_colonne, 25, 25))
        view([60 37]);
        pause(0.5);

        disp(1/lambda);

        A = A - lambda * ((vecteur_colonne * vecteur_ligne) / (vecteur_ligne * vecteur_colonne));
    end
end