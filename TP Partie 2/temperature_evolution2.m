function temperature_evolution2()
    % Fonction qui calcule et affiche l'evolution naturelle de la temperature dans la piece metallique lors d'un chauffage par les points I, J et K

    X = zeros(600, 1); % initialise la repartition de temperature a 0 pour tout point
    A = calcul_A(); % calcule la matrice A dont on a besoin pour chaque iteration et ne depend que des conditions du probleme
    delta_t = 0.01;
    iterations=10000;
    ecart_relatif_arret = 0.001;
    expA_dt = expm(A .* delta_t); % L'elevation a l'exponentielle permet d'obtenir U(t + delta_t) en fonction de U(t)
    surf(reshape(X, 40, 15))
    view([60 37]); % Reglage de l'angle de vue
    pause(delta_t);
    t=0;
    ecart_relatif_elem = 1; % Permet de rentrer la premiere fois dans la boucle
    while t<=iterations && max(ecart_relatif_elem(:)) > ecart_relatif_arret
        nouv_X = expA_dt * X;
        nouv_X = chauffer_X(nouv_X);
        ecart_relatif_elem = abs(nouv_X - X) ./ abs(X); % On se base sur l'ecart relatif element par element pour savoir si la solution stagne
        X = nouv_X;
        surf(reshape(X, 40, 15))
        view([60 37]);
        pause(delta_t);
        disp(t)
        disp(max(ecart_relatif_elem(:)))
        t = t+1;
    end
    disp("fini")
end

function X = chauffer_X(X)
    % Met les points I, J et K a 500C
    X(150, 1) = 500;
    X(297, 1) = 500;
    X(442, 1) = 500;
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