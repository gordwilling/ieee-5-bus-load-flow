function [YBus Shunt] = get5BusLineData( FaultLines )
% GET5BUSLINEDATA Returns Line Data for the IEEE 5 Bus Test System
%
% Line data includes:
%       YBus Matrix, including shunt capacitance
%       Shunt Matrix, standalone shunt capacitance values
%
% FaultLines is an optional row vector containing one or more lines that
% are to be assigned faults.  If a line is indicated in the FaultLines 
% parameter, its admittance and shunt capacitance will be omitted from the 
% YBus and Shunt matrices constructed by this function. Use get5BusLineList 
% to get a list of valid values that can be supplied 
%
    % As Y Bus is symmetric, Yjk = Ykj
    % only Yjk is specified here 
    y12 = 1 / (0.08 + 0.24j);
    y13 = 0;
    y14 = 1 / (0.02 + 0.06j);
    y15 = 0;
    y23 = 1 / (0.01 + 0.03j);
    y24 = 1 / (0.06 + 0.18j);
    y25 = 0;
    y34 = 1 / (0.06 + 0.18j);
    y35 = 1 / (0.08 + 0.24j);
    y45 = 1 / (0.04 + 0.12j);

    % shunt capacitance values B/2
    % also symmetrical; Shunt[jk] = Shunt[kj]
    shunt12 = 0.025j;
    shunt14 = 0.030j;
    shunt23 = 0.010j;
    shunt24 = 0.020j;
    shunt34 = 0.020j;
    shunt35 = 0.025j;
    shunt45 = 0.015j;

    % this can be done better by restructuring line and shunt
    % values into an indexable data structure beforehand, instead
    % of after the fact, as we do now
    if exist('FaultLines','var')
        for k=1:length(FaultLines)
            switch(FaultLines(k))
                case 12 
                    y12=0; 
                    shunt12=0;
                case 14
                    y14=0;
                    shunt14=0;
                case 23
                    y23=0;
                    shunt23=0;
                case 24
                    y24=0;
                    shunt24=0;
                case 34 
                    y34=0;
                    shunt34=0;
                case 35
                    y35=0;
                    shunt35=0;
                case 45
                    y45=0;
                    shunt45=0;
            end     
        end
    end

    Shunt = [      0    shunt12          0    shunt14          0
             shunt12          0    shunt23    shunt24          0
                   0    shunt23          0    shunt34    shunt35 
             shunt14    shunt24    shunt34          0    shunt45
                   0          0    shunt35    shunt45          0];

    shuntRow = sum(Shunt,2);

    % diagonal values for the y bus matrix
    y11 = y12 + y14 + shuntRow(1);
    y22 = y12 + y23 + y24 + shuntRow(2);
    y33 = y23 + y34 + y35 + shuntRow(3);
    y44 = y14 + y24 + y34 + y45 + shuntRow(4);
    y55 = y35 + y45 + shuntRow(5);

    YBus = [ y11   -y12   -y13   -y14   -y15;
            -y12    y22   -y23   -y24   -y25;
            -y13   -y23    y33   -y34   -y35;
            -y14   -y24   -y34    y44   -y45;
            -y15   -y25   -y35   -y45    y55];    
end