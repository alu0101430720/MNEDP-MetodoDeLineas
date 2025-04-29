% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoDeLineas/tree/main


function main(m, n)
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta es la funcion principal de la implementacion
% del Metodo de Lineas para el problema planteado.
% Dependiendo de la seleccion se mostraran unas graficas
% u otras. Para los casos 1. y 2. tendremos las aproximaciones
% y los errores, ademas de un file con los errores max.
% En la opcion 3. se hace una llamada a la funcion
% comparar_metodos(), revise el archivo .m correspondiente
% para mas informacion.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Valores por defecto
if nargin < 2
        m = 10;
        n = 10;
end
% Mallados
 x = linspace(0, 1, m+1);
 t = linspace(0, 1, n+1);

 disp('1. Theta métodos.')
 disp('2. Integrar con pdepe.')
 disp('3. Comparar todos.')
 opc = input('Elija una opción: ');

 % Solucion exacta
 u_exacta=sol_exacta(x, t);

 % Solucion exacta en t=1
 u=u_exacta(:, end);
 
 if opc == 1
     theta = input('Theta (0, 1, 1/2): ');

     % Obtener aproximacion
     W=theta_metodo(theta, m, n, x, t);
     w_t1=W(:, end);

     % Graficar
     figure;
     xlabel('x'), ylabel('u(x,1)')
     title(sprintf('Solución exacta vs numérica en t=1 (m=%d, n=%d, theta=%f)', m, n, theta))
     hold on
     plot(x, u, 'DisplayName', 'Sol. exacta', 'LineWidth', 1.5)
     plot(x, w_t1, 'DisplayName', 'Sol. numérica', 'LineWidth', 1.5)
     legend('Location', 'best');
     hold off
     
     % Crear nombre de archivo con los parametros
     filename = sprintf('resultados_theta_%g_m%d_n%d.txt', theta, m, n);
     errores_fun(t, u_exacta, W, n, filename);
 
 elseif opc == 2
     % Llamada a pdepe
     W = pdepe_met(x, t);
     w_t1 = W(end, :)';

     % Graficar solucion
     figure;
     surf(x,t,W)
     xlabel('x'), ylabel('t'), zlabel('u(x,t)')
     title('Solución numérica de la EDP')
     
     % Extraer y graficar la solucion en t = 1
     figure;
     surf(x,t,u_exacta')
     xlabel('x'), ylabel('t'), zlabel('u(x,t)')
     title('Solución exacta de la EDP')
     figure;
     hold on;
     plot(x, w_t1, 'LineWidth', 1.5, 'DisplayName', 'Sol. numérica')
     plot(x, u, 'LineWidth', 1.5, 'DisplayName', 'Sol. exacta')
     hold off;
     xlabel('x')
     ylabel('u(x,1)')
     title('Solución en t = 1')
     legend('Location', 'best');
     grid on
     W=W';
     
     % Guardar en un fichero .txt
     filename = sprintf('resultados_pdepe_m%d_n%d.txt', m, n);
     errores_fun(t, u_exacta, W, n, filename);
 else
     comparar_metodos(m, n)
 end
end

function u = sol_exacta(x, t)
 u0_values = u0(x)';
 u = u0_values .* exp(-t);
end

function u0 = u0(x)
 u0 = -3*x.^2 + 6*x + 1;
end

function errores_fun(t, u_exacta, W, n, filename)
     errores_t = NaN(n+1, 1);
     for i=1:n+1
         errores_t(i) = norm(u_exacta(:, i) - W(:, i), inf);
     end
     
     max_error = max(errores_t);
     fprintf('Error máximo: %e\n', max_error);
     
     figure;
     plot(t, errores_t)
     xlabel('t'), ylabel('Error')
     title('Evolución del error con respecto al tiempo')
     set(gca, 'YScale', 'log'); % Escala logarítmica para ver diferencias mejor

     % Guardar como .txt
     fileID = fopen(filename, 'w');
     fprintf(fileID, 'Tiempo\tError\n');
     for i = 1:length(t)
         fprintf(fileID, '%.6f\t%e\n', t(i), errores_t(i));
     end
     fclose(fileID);
     disp(['Errores guardados en formato TXT: ', filename]);
end
