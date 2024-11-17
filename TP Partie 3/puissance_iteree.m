function [lambda, vecteur] = puissance_iteree(A, direction)
    epsilon = 0.000000001;
    % epsilon = 0.00001;
    n = length(A);
    if (direction == "ligne")
        vecteur = randi(100, 1, n);
    elseif (direction == "colonne")
        vecteur = randi(100, n, 1);
    else
        disp("la direction n'est pas valide (ligne ou colonne)")
        exit;
    end
    precedent = vecteur * 0;
    i = 0;
    while (abs(dot(vecteur / norm(vecteur), precedent)) < (1 - epsilon))
        vecteur = vecteur / norm(vecteur);
        precedent = vecteur;
        if (direction == "ligne")
            vecteur = vecteur * A;
        elseif (direction == "colonne")
            vecteur = A * vecteur;
        end
        i = i+1;
    end
    vecteur = vecteur / norm(vecteur);
    
    
    if (direction == "ligne")
        mult = vecteur * A;
    elseif (direction == "colonne")
        mult = A * vecteur;
    end
    
    % somme = 0;
    % nombre = 0;
    % for i=1:length(vecteur)
    %     if (direction == "ligne")
    %         if vecteur(1, i) ~= 0
    %             somme = somme + mult(1, i) / vecteur(1, i);
    %             nombre = nombre + 1;
    %         end 
    %     elseif (direction == "colonne")
    %         if vecteur(i, 1) ~= 0
    %             somme = somme + mult(i, 1) / vecteur(i, 1);
    %             nombre = nombre + 1;
    %         end 
    %     end
    % end

    [maximum, i] = max(abs(vecteur));

    if (direction == "ligne")
        if vecteur(1, i) ~= 0
            lambda = mult(1, i) / vecteur(1, i);
        end 
    elseif (direction == "colonne")
        if vecteur(i, 1) ~= 0
            lambda = mult(i, 1) / vecteur(i, 1);
        end 
    end
end