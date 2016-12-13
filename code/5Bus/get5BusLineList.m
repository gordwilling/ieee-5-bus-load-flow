function LineList = get5BusLineList()
%GET5BUSLINEList Returns a row vector of lines in the network
%
% Values in the returned list identify lines in the network. For example, 
% line 1-2 is represented by the value 12 in the list (stored as a double 
% for ease of use). As line 1-2 is the same as line 2-1, the value 21 is 
% not in the list; the user would use 12 instead.  Values are always 
% specified with the lower-numbered bus first (e.g. if 12 and 23 are 
% listed, 21 and 32 are not)
%
% This is an informational list, providing the user with the set of valid 
% lines that can be used to indicate a simple fault condition - that
% in which a line is removed from a network due to the activation of relays 
% on each end.  Passing a subset of these values to the get5BusLineData()
% function will inform it to construct its YBus and Shunt matrices
% accordingly
   
    LineList = [12 14 23 24 34 35 45];
end