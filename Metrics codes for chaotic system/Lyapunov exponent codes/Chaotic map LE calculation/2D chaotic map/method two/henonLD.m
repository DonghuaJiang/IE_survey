% henonLD.m – script with application of the
% described numerical procedure for LEs computation to the Henon system.
function henonLD
    clc
    clear
    close all
    % Canonical parameters
    a = 1.4; b = 0.3;
    function out = J(x,a,b)
        out = [-2*x(1),b;1,0];
    end
    % Equilibrium
    S1 = 1/2*((b-1)+sqrt((b-1)^2+4*a));
    [V1,D1] = eig(J([S1,S1],a,b));
    D1 = diag(D1);
    IX1 = find(abs(D1) > 1);
    % Self - excited attractor with respect to S1
    delta = 1e-3;
    initPoint = [S1,S1]+delta*V1(:,IX1(1))'/norm(V1(:,IX1(1)));
    % Parameters for numerical procedure
    nFactors = 1000;
    LEsTol = 1e-8;
    % LEs computation
    [t,LEs,~] = computeLEsDiscrTol(@(x) henonMap(x,a,b),initPoint,nFactors,LEsTol);
    % LD computation
    LD = cellfun(@kaplanYorkeFormula,num2cell(LEs,2));
    % Plotting
    figure(1) ; hold on;
    plot(t,LEs(:,1),'Color','red');
    plot (t,LEs(:,2),'Color','blue');
    hold off; grid on; axis on;
    xlabel('t'); ylabel('LE');
    figure(2); hold on;
    plot(t,LD,'Color','green');
    hold off; grid on; axis on;
    xlabel('t'); ylabel('LD');
end