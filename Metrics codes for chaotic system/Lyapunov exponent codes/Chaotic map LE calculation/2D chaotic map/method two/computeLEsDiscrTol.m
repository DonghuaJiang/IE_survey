% computeLEsDiscrTol.m – function implementing the LEs numerical 
% computation via the approximation of the singular values matrix 
% with adaptively chosen number of iterations.
function [t,LEs,svdIterations] = computeLEsDiscrTol(extMap,initPoint,nFactors,LEsTol)
    % Dimension of the map :
    dimMap = length(initPoint);
    % Dimension of the ext. map (map+var. eq .):
    dimExtMap = dimMap*(dimMap+1);
    initCond = initPoint(:);
    fundMat = zeros(dimMap,dimMap,nFactors);
    % Main loop : factorization of the fundamental matrix
    for iFactor = 1:nFactors
        extMapSolution = extMap(initCond);
        fundMat (:,:,nFactors-iFactor+1) = reshape(extMapSolution((dimMap+1):dimExtMap),dimMap,dimMap);
        initCond = extMapSolution(1:dimMap);
    end
    t = 1:1:nFactors;
    LEs = zeros(nFactors,dimMap);
    svdIterations = zeros(nFactors,1);
    for iFactor = 1:nFactors
        currFactorization = fundMat(:,:,nFactors-iFactor+1:nFactors);
        currSvdIteration = 1;
        LEsWithinTol = false;
        while ~ LEsWithinTol
            % Save current iteration number :
            svdIterations(iFactor) = currSvdIteration;
            % Calculate current LEs approximation :
            [~,R] = treppeniterationQR(currFactorization);
            for jFactor = 1:iFactor
                currFactorization(:,:,jFactor) = R(:,:,iFactor-jFactor+1)';
            end
            accumLEs = zeros(1,dimMap);
            for jFactor = 1:iFactor
                accumLEs = accumLEs+log(diag(currFactorization(:,:,jFactor))');
            end
            LEs(iFactor,:) = accumLEs/iFactor ;
            % Compare with previous approximation :
            if currSvdIteration > 1
                LEsWithinTol = all(abs(LEs(iFactor,:)-prevLEs) < LEsTol);
            end
            % Update
            currSvdIteration = currSvdIteration+1;
            prevLEs = LEs(iFactor,:);
        end
    end
end
