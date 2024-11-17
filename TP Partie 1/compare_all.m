function compare_all(A, B, epsilon)
    [nb1, X1] = jacobi(A, B, epsilon);
    disp('Jacobi : ');
    disp(X1);
    fprintf("Nombre d'itérations : %d\n\n", nb1)
    [nb2, X2] = gauss_seidel(A, B, epsilon);
    disp('Gauss-Seidel : ');
    disp(X2);
    fprintf("Nombre d'itérations : %d\n\n", nb2)
    [nb3, w, p_min, X3] = relaxation(A, B, epsilon);
    disp('Relaxation : ');
    disp(X3);
    fprintf("Nombre d'itérations : %d\n", nb3)
    fprintf("p(pi) : %d\n", p_min)
    fprintf("w de relaxation : %d\n\n", w)
    disp('Vraie réponse : ');
    disp(A \ B);

end