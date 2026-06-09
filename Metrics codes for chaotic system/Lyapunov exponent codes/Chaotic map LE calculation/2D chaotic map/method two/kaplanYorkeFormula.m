% kaplanYorkeFormula.m – function implementing the local Lyapunov 
% dimension calculation via Kaplan-Yorke formula.
function LD = kaplanYorkeFormula(LEs)
    % Initialization of the local Lyupunov dimention :
    LD = 0;
    % Number of LCEs :
    nLEs = length(LEs);
    % Sorted LCEs :
    sortedLEs = sort(LEs,'descend');
    % Main loop :
    leSum = sortedLEs(1);
    if ( sortedLEs(1) > 0)
        for i = 1:nLEs-1
            if sortedLEs(i+1) ~= 0
            LD = i + leSum/abs(sortedLEs(i+1));
            leSum = leSum+sortedLEs(i+1);
                if leSum < 0
                    break;
                end
            end
        end
    end
end