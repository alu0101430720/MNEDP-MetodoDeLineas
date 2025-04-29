% 2025 Carlos Yanes Pérez
% Programa realizado para la asignatura de MNEDP de la ULL.

function W = theta_metodo(theta, m, n, x, t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% En esta funcion se implementamos los metodos pedidos.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tau = 1/n;

    % inicializamos la sol. numerica
    W = zeros(m+1, n+1); 
    W(:, 1) = u0(x)';
    W(1, 2:n+1) = exp(-t(2:n+1));

    % Creamos las matrices pertinentes
    [DA, Bh] = crear_matrices(m, x);
    
    if theta == 0
        % Metodo explicito
        for j=1:n
            W(2:end, j+1) = W(2:end, j) + tau*(DA*W(2:end, j) + Bh(t(j)));
        end
        
    else
        % Implementacion conjunta para los metodos implicitos
        I = speye(m);
        LHS = (I - tau * theta * DA);
        [L, U] = lu(LHS);

        for j=1:n
            RHS = (I + tau * (1-theta) * DA) *W(2:end, j) + tau * (1-theta) * Bh(t(j)) + tau * theta * Bh(t(j+1));
            W(2:end, j+1) = U \ (L \ RHS);
        end
    end
end

function [DA, Bh] = crear_matrices(m, x)

    % Creacion de las matrices de difusion, adveccion y el vector Bh
    h = 1/m;
    Dh_u = ones(m, 1); Dh_u(1) = 0;
    Dh_d = -2*ones(m, 1);
    Dh_l = ones(m, 1); Dh_l(m) = 0; Dh_l(m-1) = 2;

    Dh = (1/h^2) * spdiags([Dh_l, Dh_d, Dh_u], -1:1, m, m);

    Ah_u = ones(m, 1); Ah_u(1) = 0;
    Ah_l = -ones(m, 1); Ah_l(m-1) = 0; Ah_l(m) = 0;
    Ah_d = zeros(m, 1);

    Ah = (-1/(4*h)) * spdiags([Ah_l, Ah_d, Ah_u], -1:1, m, m);

    DA = Dh + Ah;

    Bh0 = @(T) 1/h^2 * exp(-T) + 1/(4*h) * exp(-T) + G(x(2), T);
    x_inner = x(3:end);
    Bh = @(T) [Bh0(T); G(x_inner, T)];
end

function u0 = u0(x)
    u0 = -3*x.^2 + 6*x + 1;
end

function g = G(x, t)
    g = (3*x.^2 - 9*x + 8)' * exp(-t);
end



