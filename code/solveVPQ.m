function [V P Q] = solveVPQ( V, YBus, PQsched,...
                             busSlack, busVControl, epsilon )
%SOLVEVPQ Determines V P and Q for each node in a network
%
%This function uses Newton-Raphson to generate a solution; If a solution
%can not be found within 10 iterations, an error is thrown. Be prepared to
%handle the error so that civilization doesn't collapse.

    %this will produce a vector of 1s, the length of which matches the 
    %number of unknowns we're solving for. How? busSlack and busVControl 
    %identify P and Q values that are excluded from the problem; the 
    %leftover values correspond to the unknowns. The vector of 1s is 
    %initially used as a starting point to enter the upcoming while loop; 
    %it later contains the corrections computed by the NewtonRaphson method
    deltas = getPQFilter(busSlack, busVControl);
    deltas = double(~deltas(deltas==0));  

    % Tracks the number of iterations; Newton-Raphson should converge
    % quickly, so throw an error if k grows beyond 10 
    k = 0;    
    while( norm( deltas ) > epsilon )
        [nextV deltas] = nrNBus( V, YBus, PQsched,...
                                 busSlack, busVControl, epsilon);
        V = nextV;
        k = k + 1;   
        if k > 10
            error('Newton-Raphson Failed to Converge within 10 Iterations');
        end
    end

    Powers = solveP(YBus, V);
    N = length(V);
    P = Powers(1:N);
    Q = Powers(N+1:2*N);
    
    %message = sprintf( 'Newton-Raphson Completed in %d Iterations.', k );
    %disp(message);
end