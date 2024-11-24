function temperature_evolution()
    % Fonction qui calcule et affiche l'evolution naturelle de la temperature dans la piece metallique

    X = calcul_X_0(); % calcule la repartition de temperature a l'equilibre de la partie precedente
    A = calcul_A(); % calcule la matrice A dont on a besoin pour chaque iteration et ne depend que des conditions du probleme
    delta_t = 0.01;
    iterations=1000;
    expA_dt = expm(A .* delta_t); % L'elevation a l'exponentielle permet d'obtenir U(t + delta_t) en fonction de U(t)
    surf(reshape(X, 40, 15))
    view([60 37]); % Reglage de l'angle de vue
    zlim([90 310]); % Reglage de l'echelle
    pause(delta_t);
    t = 0;
    ecart_relatif_elem = 1; % Permet de rentrer la premiere fois dans la boucle
    while t<=iterations && max(ecart_relatif_elem(:)) > 0.0001
        nouv_X = expA_dt * X;
        ecart_relatif_elem = abs(nouv_X - X) ./ abs(X); % On se base sur l'ecart relatif element par element pour savoir si la solution stagne
        X = nouv_X;
        surf(reshape(X, 40, 15))
        view([60 37]);
        zlim([90 310]);
        pause(delta_t);
        disp(t)
        disp(max(ecart_relatif_elem(:)))
        t = t+1;
    end
    disp("fini")
end

function X = calcul_X_0()
    A = zeros(600, 600);
    B = zeros(600, 1);

    % Initialisation des bords (index comme dans B en concatenant les lignes)
    % Indice i pour les lignes / indice j pour les colonnes
    bords = []; % liste qui contient les indices correspondants a des cases rouges
    for j=1:40 % Premiere ligne en entier
        bords = [bords; 1*j];
    end
    for i = 2:6 % Lignes 2-6 : premiere et derniere colonne
        bords = [bords; (i-1)*40+1; (i-1)*40+40];
    end
    for i = 7:8 % Lignes 7-8 : premiere colonne et retour (colonne 27-40)
        bords = [bords; (i-1)*40+1];
        for j=27:40
            bords = [bords; (i-1)*40+j];
        end
    end
    for j=1:40 % Derniere ligne en entier
        bords = [bords; 14*40+j];
    end
    % pour ameliorer : preallouer bords (len = 132)
    
    pacman_g = []; % liste contenant les indices de la bande de gauche qui doit etre reliee a la bande de droite
    pacman_d = []; % liste contenant les indices de la bande de droite qui doit etre reliee a la bande de gauche
    for i = 9:14
        pacman_g = [pacman_g; (i-1)*40+1];
        pacman_d = [pacman_d; (i-1)*40+40];
    end
    
    % Les bandes bleues sont reliees entre elles -> plus de voisins (3 dimensions) et egalite des valeurs
    bleue_1 = [];
    bleue_2 = [];
    for i = 1:7
        bleue_1 = [bleue_1; (i-1)*40+9];
        bleue_2 = [bleue_2; (i-1)*40+32];
    end
    
    
    for i = 1:600
        A(i, i) = 1;
        % Bords rouges
        if ismember(i, bords, 'rows')
            B(i, 1) = 200;
        % Points speciaux
        elseif (i == 150 || i == 297) % Points I et J
            B(i, 1) = 300;
        elseif (i == 442) % Point K
            B(i, 1) = 100;

        % Bande pacman
        elseif ismember(i, pacman_g, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            A(i, pacman_d(pacman_g == i)) = 1; % point d'en face aka voisin de gauche apres wrapping
            A(i, i) = A(i, i) - 1;
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
        elseif ismember(i, pacman_d, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            A(i, pacman_g(pacman_d == i)) = 1; % point d'en face aka voisin de droite apres wrapping
            A(i, i) = A(i, i) - 1;
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            
            % Bande bleue
        elseif ismember(i, bleue_1, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_2(bleue_1 == i) - 1 > 0) % voisin de derriere
                A(i, bleue_2(bleue_1 == i) - 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_2(bleue_1 == i) + 1 < 600) % voisin de devant
                A(i, bleue_2(bleue_1 == i) + 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
        elseif ismember(i, bleue_2, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_1(bleue_2 == i) - 1 > 0) % voisin de derriere
                A(i, bleue_1(bleue_2 == i) - 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_1(bleue_2 == i) + 1 < 600) % voisin de devant
                A(i, bleue_1(bleue_2 == i) + 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            
            % Cas general
        else
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
        end
    end

    epsilon = 0.0001;
    X = gauss_seidel(A, B, epsilon);
    
end


function A = calcul_A()
    A = zeros(600, 600);
    
    pacman_g = []; % liste contenant les indices de la bande de gauche qui doit etre reliee a la bande de droite
    pacman_d = []; % liste contenant les indices de la bande de droite qui doit etre reliee a la bande de gauche
    for i = 9:14
        pacman_g = [pacman_g; (i-1)*40+1];
        pacman_d = [pacman_d; (i-1)*40+40];
    end
    
    % Les bandes bleues sont reliees entre elles -> plus de voisins (3 dimensions) et egalite des valeurs
    bleue_1 = [];
    bleue_2 = [];
    for i = 1:7
        bleue_1 = [bleue_1; (i-1)*40+9];
        bleue_2 = [bleue_2; (i-1)*40+32];
    end
    
    
    for i = 1:600
        % Bande pacman
        if ismember(i, pacman_g, 'rows')
            A(i, i) = 0; % On met a jour A(i,i) au fur et a mesure pour ne faire une moyenne ponderee que des voisins existants
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            A(i, pacman_d(pacman_g == i)) = 1; % point d'en face aka voisin de gauche apres wrapping
            A(i, i) = A(i, i) - 1;
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
        elseif ismember(i, pacman_d, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            A(i, pacman_g(pacman_d == i)) = 1; % point d'en face aka voisin de droite apres wrapping
            A(i, i) = A(i, i) - 1;
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            
        % Bande bleue
        elseif ismember(i, bleue_1, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_2(bleue_1 == i) - 1 > 0) % voisin de derriere
                A(i, bleue_2(bleue_1 == i) - 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_2(bleue_1 == i) + 1 < 600) % voisin de devant
                A(i, bleue_2(bleue_1 == i) + 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
        elseif ismember(i, bleue_2, 'rows')
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_1(bleue_2 == i) - 1 > 0) % voisin de derriere
                A(i, bleue_1(bleue_2 == i) - 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (bleue_1(bleue_2 == i) + 1 < 600) % voisin de devant
                A(i, bleue_1(bleue_2 == i) + 1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            
        % Cas general
        else
            A(i, i) = 0;
            if (i-40 > 0) % voisin du haut
                A(i, i-40) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i-1 > 0) % voisin de gauche
                A(i, i-1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+1 < 600) % voisin de droite
                A(i, i+1) = 1;
                A(i, i) = A(i, i) - 1;
            end
            if (i+40 < 600) % voisin du bas
                A(i, i+40) = 1;
                A(i, i) = A(i, i) - 1;
            end
        end
    end
end



function X = gauss_seidel(A, B, epsilon) % Algorithme de Gauss-Seidel vu au premier TD
    nb_iter = 0;
    n = length(A);
    if length(B) ~= n % On verifie que les operations sont valides
        disp("Les dimensions sont mauvaises")
        exit;
    end

    X = ones(n, 1);

    while ((max(abs(A * X - B)) > epsilon) && nb_iter < 100000)
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