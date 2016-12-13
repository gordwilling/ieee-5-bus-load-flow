function PQFilter = getPQFilter( busSlack, busVControl )
%GETPQFILTER Returns indices to exclude from the load flow calculation
%
%Given busSlack and busVControl column vectors of equal size N, the
%returned vector will be of length 2N.  Elements 1:N of the returned vector
%indicate real power indices that should be excluded; elements N+1:2N
%indicate reactive power indices that should be excluded
    PFilter = busSlack ~=0;
    QFilter = (busSlack + busVControl) ~= 0;
    PQFilter = [PFilter; QFilter];
end

