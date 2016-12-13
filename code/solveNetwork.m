function [V, Pgen, Qgen, Pflow, Qflow ] = solveNetwork( V, YBus, Shunt,...
    Pgen, Qgen, Pdemand, Qdemand, BusSlack, BusVControl, epsilon)
%SOLVENETWORK Solves the Power Flow problem for the specified network
%

    % Scheduled Real Power Required at Bus       
    Psched = Pgen - Pdemand; 

    % Scheduled Reactive Power Required at Bus
    Qsched = Qgen - Qdemand;

    % stack P and Q values into a single vector
    PQsched = [Psched;Qsched];
    
    % determine bus voltages, real and reactive powers
    [V P Q] = solveVPQ(V, YBus, PQsched, BusSlack, BusVControl, epsilon);
    
    Pgen = P + Pdemand;
    Qgen = Q + Qdemand;
    
    % determine power flow throughout network
    [Pflow Qflow] = solvePowerFlow(V, YBus, Shunt);
end

