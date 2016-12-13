% IEEE 5 Bus Test System
% author: Gordon Wallace
%
% Gentle Reminders of Definitions
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
% Voltage controlled bus or generator bus  or PV bus:
%   V = V @ delta
%   V fixed, delta is unkown
%   P is known and Q is variable (don�t care)
%    
% For this Test System
% 
% Bus 1 is the slack bus
% Bus 4 is a voltage controlled bus
% Bus 2,3,5 are load buses
%
% Thus 7 unknowns:
%   
%   v2, delta2
%   v3, delta3
%       delta4
%   v5, delta5
% 
% We will use Newton-Raphson to calculate the values for V and delta
% such that the specified values for the following quantities are reached:
% P2, P3, P4, P5 and Q2, Q3, Q5
%
% P1 and Q1 are excluded as they correspond to the slack bus
% Q4 is neglected because it is on the voltage controlled bus
%
% V, PGen, QGen, PDemand, QDemand are the specified initial operating 
% conditions of the 5 bus system
clear;
clc;

% define network data
BusNames = {'North'; 'Lake'; 'Main'; 'South'; 'Elm'};
BusSlack = [1; 0; 0; 0; 0];        
BusVControl = [0; 0; 0; 1; 0];
V = [1.06; 1.00; 1.00; 1.047; 1.00];
Pgen = [0.0; 0.0; 0.0; 0.45; 0.0];
Qgen = [0.0; 0.0; 0.0; 0.0; 0.0];
Pdemand = [0.0; 0.45; 0.40; 0.20; 0.60];      
Qdemand = [0.0; 0.15; 0.05; -0.20; 0.10];       
    
% MVAR Capability [Min Max] for Bus 4   
% For V = 1.047 per unit 
MVAR_MinMax = [-0.40; 0.50];

% slightly more elaborate line data is built in this funciton
[YBus Shunt] = get5BusLineData([12 23 34]);

% all the pertinent network information is in place. 
% solve the load flow problem for this network

% error tolerance for Newton-Raphson iterative solution
epsilon = 1e-8;

[V Pgen Qgen Pflow Qflow] = solveNetwork( V, YBus, Shunt, Pgen, Qgen,...
    Pdemand, Qdemand, BusSlack, BusVControl, epsilon);

displayNetwork( V, Pgen, Qgen, Pdemand, Qdemand, Pflow, Qflow,...
    BusNames, BusSlack, BusVControl, Shunt );
            
            
            
            