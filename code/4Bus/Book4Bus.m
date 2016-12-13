% Book 4 Bus Test System
% author: Gordon Wallace
%
% This tests the reference system from the text book, ensuring the code 
% written for the 5-Bus problem is generally applicable and correct
%
% Gentle Reminder of Definitions
% 
% Slack bus:
%   V = 1 @ 0
%   Power (MVA) is found by power balance
%
% Load bus or PQ Bus:
%   V = V @ delta
%   Both V and delta are unknown
%   P and Q demands are known
%
% Voltage controlled bus or generator bus or PV bus:
%   V = V @ delta
%   V fixed, delta is unkown
%   P is known and Q is variable (don�t care)
%    
% For this Test System
% 
% Bus 1 is the slack bus
% Bus 4 is a voltage controlled bus
% Bus 2,3 are load buses
%
% Therefore, there are 5 unknowns:
%   
%   v2, delta2
%   v3, delta3
%       delta4
% 
% We will use Newton-Raphson to calculate the values for V and delta
% such that the specified values for the following quantities are reached:
% P2, P3, P4 and Q2, Q3
%
% P1 and Q1 are excluded as they correspond to the slack bus
% Q4 is neglected because it is on the voltage controlled bus
%
% V, SGen, and SLoad are the specified initial operating conditions
% of the 5 bus system
%
clear;
clc;

% BusNames provides labels for the tabulated solution data
% BusVControl and BusSlack are used to identify quantities
% that can be excluded from calculations. 
BusNames = {'Birch'; 'Elm'; 'Pine'; 'Maple'};
BusVControl = [0; 0; 0; 1];
BusSlack = [1; 0; 0; 0];

V = [1.00; 1.00; 1.00; 1.02];
Pgen = [0.0; 0.0; 0.0; 3.18];     
Pdemand = [0.50; 1.70; 2.00; 0.80];      
Qgen = [0.0; 0.0; 0.0; 0.0];     
Qdemand = [0.3099; 1.0535; 1.2394; 0.4958];       

[YBus Shunt] = get4BusLineData();
       
% error tolerance for Newton-Raphson iterative solution
epsilon = 1e-8;

% end configuration data            

[V Pgen Qgen Pflow Qflow] = solveNetwork( V, YBus, Shunt, Pgen, Qgen,...
    Pdemand, Qdemand, BusSlack, BusVControl, epsilon);

displayNetwork( V, Pgen, Qgen, Pdemand, Qdemand, Pflow, Qflow,...
    BusNames, BusSlack, BusVControl, Shunt );





    





 