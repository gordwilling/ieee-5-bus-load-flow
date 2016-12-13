function PQ = solveP( YBus, V )
% SOLVEP Calculates Power given a YBus matrix and Voltage vector
%
% Given a voltage column vector of length N, the returned column vector
% will be of length 2N, where elements 1:N contain the real powers and 
% elements N+1:2N contain the reactive powers
    I = YBus * V;
    S = V .* conj(I);
    P = real(S);
    Q = imag(S);
    PQ=[P;Q];    
end