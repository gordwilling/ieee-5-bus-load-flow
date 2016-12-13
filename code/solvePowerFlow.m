function [Pflow Qflow] = solvePowerFlow( V, YBus, Shunt )
%SOLVEPOWERFLOW Calculates Network Power Flow given Bus Voltages and Line Data
%
%Bus Voltages should first be obtained by performing Load Analysis on the
%network using the solveVPQ function
    N = length(V);
    LineFlow = zeros(size(YBus));
    for m=1:N
        for n=1:N
            if m~=n && YBus(m,n)~=0
                % line m and n are connected                
                LineFlow(m,n) = V(m)*conj((V(n)-V(m))*YBus(m,n)...
                                   +V(m)*Shunt(m,n));
            end
        end
    end
    
    Pflow = real(LineFlow);
    Qflow = imag(LineFlow);
end