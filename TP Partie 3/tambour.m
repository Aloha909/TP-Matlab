function tambour()
    A = zeros(625, 625);
    % B = zeros(625, 1)

    % Initialisation des fixes (index comme dans B en concatenant les lignes)
    % Indice i pour les lignes / indice j pour les colonnes
    fixes = []; % liste qui contient les indices correspondants a des points fixes
    for j=1:25 % Premiere ligne en entier
        fixes = [fixes; 1*j];
    end
    for i = 2:5 % Lignes 2-5 : premiere colonne, carre fixe et derniere colonne
        for j=1:5
            fixes = [fixes; (i-1)*25+j];
        end
        fixes = [fixes; (i-1)*25+25];
    end
    for i = 6:15 % Lignes 6-15 : premiere et derniere colonne
        fixes = [fixes; (i-1)*25+1; (i-1)*25+25];
    end
    for i = 16:20 % Lignes 16-20 : premiere colonne, carre fixe et derniere colonne
        for j=11:15
            fixes = [fixes; (i-1)*25+j];
        end
        fixes = [fixes; (i-1)*25+1; (i-1)*25+25];
    end
    for i = 21:24 % Lignes 21-24 : premiere et derniere colonne
        fixes = [fixes; (i-1)*25+1; (i-1)*25+25];
    end
    for j=1:9 % Derniere ligne (bloc de gauche)
        fixes = [fixes; 24*25+j];
    end
    fixes = [fixes; 24*25+25]; % Derniere ligne (derniere case)
    
    
    for i = 1:625
        % points fixes
        if ismember(i, fixes, 'rows')
            A(i, i) = 1;
            % B(i, 1) = 0;
        % Cas general
        else
            A(i, i) = 0;
            if (i-25 > 0) % voisin du haut
                A(i, i-25) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 625) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+25 < 625) % voisin du bas
                A(i, i+25) = 1;
                A(i, i) = A(i, i) - 1;
            end
        end
    end

    % epsilon = 0.0001;
    % X = gauss_seidel(A, B, epsilon);
    % surf(reshape(X, 40, 15))
    
    disp("plus petit");
    Z = inv(A);
    X = deflation_inverse(Z, 50);
    disp("plus grand");
    X = deflation(A, 20);

    % Valeur propre la plus proche de 0.53
    disp(lambda_c(A, 0.53));
end