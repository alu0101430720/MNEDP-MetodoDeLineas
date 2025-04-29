% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoDeLineas/tree/main


function W=pdepe_met(x, t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Implementacion de la rutina pdepe (ver doc. de MATLAB
% https://es.mathworks.com/help/matlab/ref/pdepe.html)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W=pdepe(0,@pdefun,@icfun,@bcfun,x,t);

end
function [c,f,s] = pdefun(x,t,u,dudx)
    c = 1;
    f = dudx - 0.5*u;
    s = exp(-t)*(3*x^2 - 9*x + 8);
end

function [pl,ql,pr,qr] = bcfun(xl,ul,xr,ur,t)
    pl = ul - exp(-t);  % u(0,t) = e^(-t)
    ql = 0;
    
    pr = 0.5 * ur;
    qr = 1;
end

function u0 = icfun(x)
    u0 = -3*x^2 + 6*x + 1;
end
