function [YBus Shunt] = get4BusLineData()
% GET4BUSLINEDATA Returns Line Data for the 4 Bus Study System
% specified in Grainger-Stevenson Chapter 9
%
% Line data includes:
%       YBus Matrix, including shunt capacitance
%       Shunt Matrix, standalone shunt capacitance values
%       ChargingMVARS, charging MVAR due to shunt capacitance
%

    % Raw Line Data used to construct Y bus
    %
    % As Y Bus is symmetric, Yjk = Ykj, so only Yjk is
    % specified here; it is reused in place of Ykj during Y Bus
    % construction
    y12 = 1/(0.01008 + 0.0504j); 
    y13 = 1/(0.00744 + 0.0372j);
    y14 = 0;
    y23 = 0;
    y24 = 1/(0.00744 + 0.0372j); 
    y34 = 1/(0.01272 + 0.0636j); 

    % shunt capacitance values B/2
    % as with Y Bus, shunt[jk] = shunt[kj]
    shunt12 = 0.05125j;
    shunt13 = 0.03875j;
    shunt24 = 0.03875j;
    shunt34 = 0.06375j;
    
    Shunt = [      0   shunt12   shunt13         0
             shunt12         0         0   shunt24  
             shunt13         0         0   shunt34
                   0   shunt24   shunt34         0];
    
    % sum each row for inclusion in the ybus diagonals          
    shuntRowSums = sum(Shunt,2);               
   
    % diagonal values for the y bus matrix
    y11 = y12 + y13 + shuntRowSums(1);
    y22 = y12 + y24 + shuntRowSums(2);
    y33 = y13 + y34 + shuntRowSums(3);
    y44 = y24 + y34 + shuntRowSums(4);

    YBus = [ y11 -y12 -y13 -y14;
            -y12  y22 -y23 -y24;
            -y13 -y23  y33 -y34;
            -y14 -y24 -y34  y44];
end
      
     

