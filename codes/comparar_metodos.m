% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoDeLineas/tree/main


function comparar_metodos(m, n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% En esta funcion se comparan los metodos implementados.
% Genera graficas conjuntas y un fichero .txt con los 
% errores en norma inf para cada t y metodo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Si no se proporcionan parámetros, usar valores por defecto
    if nargin < 2
        m = 10;
        n = 10;
    end
    
    % Crear mallas
    x = linspace(0, 1, m+1);
    t = linspace(0, 1, n+1);
    
    % Solución exacta
    u_exacta = sol_exacta(x, t);
    u_final_exacta = u_exacta(:, end);
    
    % Ejecutar metodo theta
    thetas = [0, 0.5, 1];
    W_theta = cell(length(thetas), 1);
    errores_theta = zeros(length(thetas), 1);
    errores_tiempo_theta = zeros(length(thetas), n+1);
    
    for i = 1:length(thetas)
        fprintf('Calculando solución con método theta = %g...\n', thetas(i));
        W_theta{i} = theta_metodo(thetas(i), m, n, x, t);
        errores_theta(i) = norm(u_final_exacta - W_theta{i}(:, end));
        
        % Calcular errores en cada paso de tiempo
        for j = 1:n+1
            errores_tiempo_theta(i, j) = norm(u_exacta(:, j) - W_theta{i}(:, j), inf);
        end
    end
    
    % Ejecutar metodo pdepe
    fprintf('Calculando solución con método pdepe...\n');
    W_pdepe = pdepe_met(x, t)';
    
    errores_pdepe = zeros(n+1, 1);
    for j = 1:n+1
        errores_pdepe(j) = norm(u_exacta(:, j) - W_pdepe(:, j), inf);
    end
    
    % Mostrar errores maximos por pantalla
    fprintf('\nErrores máximos:\n');
    for i = 1:length(thetas)
        fprintf('Método theta = %g: %e\n', thetas(i), max(errores_tiempo_theta(i, :)));
    end
    fprintf('Método pdepe: %e\n', max(errores_pdepe));
    
    % Gráficas
    % 1. Soluciones en t=1
    figure;
    hold on;
    plot(x, u_final_exacta, 'k-', 'LineWidth', 2, 'DisplayName', 'Exacta');
    
    linestyles = {'-', '--', ':'};
    for i = 1:length(thetas)
        plot(x, W_theta{i}(:, end), linestyles{i}, 'LineWidth', 1.5, 'DisplayName', sprintf('Theta = %g', thetas(i)));
    end
    
    plot(x, W_pdepe(:, end), '-.', 'LineWidth', 1.5, 'DisplayName', 'pdepe');
    hold off;
    
    xlabel('x');
    ylabel('u(x,1)');
    title(sprintf('Comparación de soluciones en t=1 (m=%d, n=%d)', m, n));
    legend('Location', 'best');
    grid on;
    
    % 2. Evolucion del error (max) en tiempo
    figure;
    hold on;
    for i = 1:length(thetas)
        plot(t, errores_tiempo_theta(i, :), 'LineWidth', 1.5, 'DisplayName', sprintf('Theta = %g', thetas(i)));
    end
    
    plot(t, errores_pdepe, 'LineWidth', 1.5, 'DisplayName', 'pdepe');
    hold off;
    
    xlabel('t');
    ylabel('Error (norma inf)');
    title('Evolución del error con respecto al tiempo');
    legend('Location', 'best');
    grid on;
    set(gca, 'YScale', 'log'); % Escala logaritmica
    
    % 3. Superficie 3D para cada método (comentar en caso de no desear la salida)
    metodos = [W_theta; {W_pdepe}];
    
    theta_nombres = arrayfun(@(theta) sprintf('Theta = %g', theta), thetas, 'UniformOutput', false)';
    metodos_nombres = [theta_nombres; {'pdepe'}];
    
    for i = 1:length(metodos)
        figure;
        surf(x, t, metodos{i}');
        xlabel('x');
        ylabel('t');
        zlabel('u(x,t)');
        title(['Solución con método ', metodos_nombres{i}]);
    end
   
    grid on;
    
    % Guardar datos en un archivo .txt
    txt_filename = sprintf('comparacion_metodos_m%d_n%d.txt', m, n);
    fid = fopen(txt_filename, 'w');
    
    % Alinear
    header_fmt = '%12s %12s %12s %12s %12s\n';
    data_fmt = '%.6e %.6e %.6e %.6e %.6e\n';
    
    % Escribir encabezados
    fprintf(fid, header_fmt, 't', 'Theta_0', 'Theta_0.5', 'Theta_1', 'pdepe');
    
    % Escribir datos fila por fila
    for i = 1:length(t)
        fprintf(fid, data_fmt, ...
            t(i), ...
            errores_tiempo_theta(1, i), ...
            errores_tiempo_theta(2, i), ...
            errores_tiempo_theta(3, i), ...
            errores_pdepe(i));
    end
    
    fclose(fid);
    fprintf('Resultados guardados en: %s\n', txt_filename);


end

function u = sol_exacta(x, t)
    u0_values = u0(x)';
    u = u0_values .* exp(-t);
end

function u0 = u0(x)
    u0 = -3*x.^2 + 6*x + 1;
end
