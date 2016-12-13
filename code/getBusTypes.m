function BusTypes = getBusTypes( busSlack, busVControl )
%GETBUSTYPES Gets a string description of bus types
%
%   Given two column vectors identifying the slack bus and voltage
%   controlled buses, this function returns a cell array of short
%   string descriptions of each bus type, located at respective indices
%
%   Returned values are
%
%   SL for slack bus
%   PV for voltage controlled bus
%   PQ for load bus
    BusTypes = cell(length(busSlack),1);
    BusTypes(busSlack~=0)=cellstr('SL');
    BusTypes(busVControl~=0)=cellstr('PV');
    BusTypes((busVControl|busSlack)==0)=cellstr('PQ');
end

