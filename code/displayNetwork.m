function displayNetwork( V, Pgen, Qgen, Pdemand, Qdemand, Pflow, Qflow, ...
                         BusNames, BusSlack, BusVControl, Shunt )
%DISPLAYNETWORK Displays a summary of a Network's Power Flow Statistics
%   
% Information displayed in the generated table corresponds to that
% shown in Figure 9.4 of Grainger & Stevenson, p358

BusTypes = getBusTypes(BusSlack, BusVControl);
N = length(V);

fprintf('---------------------------------------Bus Information-------------------------------------|--------------Line Flow----------------------\n');
fprintf(' Bus               Volts     Angle    |------Generation----|---------Load---------|  Bus   |--------To--------|--------Line Flow---------\n');
fprintf(' no.  Name         (p.u.)    (deg.)   |  (MW)      (MVAR)  |   (MW)      (MVAR)   |  type  |  Bus     Name    |     (MW)      (MVAR)     \n');
fprintf('-----------------------------------------------------------------------------------------------------------------------------------------\n');

% change the text color red if one of the buses is 
% 10% beyond or below the slack voltage, because that's bad
slackV = V(BusSlack~=0);

for k=1:N 
    if abs(V(k)) < 0.90*slackV || abs(V(k)) > 1.1*slackV
        % bus voltage not within 10% of slack bus; bad: make text red
        textColor=2;
    else
        % bus voltage within 10% of slack bus; okay: make text black
        textColor=1;
    end
    
    % fills in the Bus Information section, one row per bus
    fprintf(textColor,' %-5d%-7s% 11.4f% 11.4f% 11.4f% 11.4f% 11.4f% 11.4f%9s',...
        k,BusNames{k},abs(V(k)),angle(V(k))*180/pi,Pgen(k),Qgen(k),...
        Pdemand(k),Qdemand(k),BusTypes{k});
    busRows = 0;
    % fills in the Line Flow section for a bus, which may be multiple 
    % rows - one per connected line.  The lines connected to the bus are 
    % determined by examining non-zero values in row k of the Shunt 
    % capacitance matrix (the row corresponding to bus k)
    for m=1:length(Shunt(k,:))        
        if Shunt(k,m)~=0
            busRows = busRows + 1;
            if busRows > 1
                % adds padding to get the this row of Line Flow
                % data aligned with the row above
                fprintf('%88s','');
            end
            fprintf(textColor,'%7s%-7d%-8s% 11.4f% 11.4f\n','',m,BusNames{m},...
                Pflow(k,m),Qflow(k,m));
        end
    end    
end  
fprintf('-----------------------------------------------------------------------------------------------------------------------------------------\n');
fprintf('                        Area Totals% 11.4f% 11.4f% 11.4f% 11.4f\n',sum(Pgen),sum(Qgen),sum(Pdemand),sum(Qdemand));
fprintf('-----------------------------------------------------------------------------------------------------------------------------------------\n');
end

