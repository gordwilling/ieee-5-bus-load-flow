function [nextV, deltas] = nrNBus(V, YBus, PQsched, busSlack,...
                                         busVControl, epsilon )
%NRNBUS Does one iteration of Newton-Raphson to find bus voltages

    % adjustment level per iteration
    h = epsilon/1000;

    % Identify which elements of P and Q are to be excluded because 
    % of association with either the slack or voltage controlled bus. 
    % For a slack bus, both the P and Q values are omitted. For a 
    % voltage controlled bus, only the Q value is omitted
    PQFilter = getPQFilter(busSlack, busVControl);
    
    % Row count of perturbation matrix matches that of the V matrix; 
    % Column count matches the length of the PQsched vector.
    % Note: values for slack and voltage controlled buses are still 
    % included in the PQsched vector at this point.  The Vperturbed matrix 
    % will be adjusted to exclude those corresponding quantities after it 
    % is built here
    Vperturbed = repmat(V, 1, length(PQsched));
    for k=1:length(V)
        if busVControl(k)
            % perturb the angle by h degress
            Vperturbed(k,k) = V(k)*exp(1j*h);
        elseif ~busSlack(k)
            % perturb the angle and magnitude by h 
            Vperturbed(k,k) = V(k)*exp(1j*h);
            Vperturbed(k,k+length(V)) = V(k) + h*exp(1j*angle(V(k)));
        end
    end 
    
    % remove columns corresponding to slack 
    % and voltage controlled buses
    Vperturbed(:,PQFilter)=[];

    % gets the set of PQ values
    PQunperturbed = solveP(YBus, V);
    PQunperturbed(PQFilter)=[];

    % set up the numerical Jacobian
    %
    % NOTE - About a year after writing, Andrew Ng indicates that
    % the numerical derivatives are slightly more accurate when calculated
    % as:
    %
    % f(x+h) - f(x-h)
    % ---------------
    %       2h
    %
    % (rather than using the first principles definition of the derivative
    fx = repmat(PQunperturbed, 1, length(PQunperturbed));
    fx_plus_h = zeros(size(PQunperturbed));
    for k=1:length(PQunperturbed)
        temp = solveP(YBus, Vperturbed(:,k));
        temp(PQFilter)=[];
        fx_plus_h(:,k) = temp;
    end
    J = (fx_plus_h - fx)/h;    

    % remove quantities associated with slack  and voltage controlled buses
    PQsched(PQFilter)=[];
    
    % and find the deltas
    delta_fx = PQsched - PQunperturbed;
    deltas = J \ delta_fx; 
    
    % 1. There are angle corrections in the deltas vector corresponding to 
    %    values in the Voltage (V) vector
    % 2. There are also magnitude corrections in the deltas vector 
    %    corresponding to values in the V vector
    %
    % However: the indices of values in the deltas vector are not aligned
    % with those in the voltage vector. 
    % 
    % We need to know the particular items that are missing from the deltas
    % so we can adjust the next set of voltage values. PQFilter has this
    % information. We will use PQFilter to help us add placeholders
    % (zeros) for the excluded quantities back to the deltas vector.   
    % After this operation, paddedDeltas[1:N] will contain angle deltas, 
    % with zeros in the place of excluded buses (slack or
    % V-controlled). paddedDeltas[N+1:2N] will contain magnitude deltas, 
    % with zeros in the place of excluded buses.
    paddedDeltas = double(~PQFilter);
    n = 0;
    for k=1:length(paddedDeltas)        
        if paddedDeltas(k) ~= 0
            n=n+1;
            paddedDeltas(k) = deltas(n);
        end
    end
    
    % initial values prior to perturbance
    Vangles = angle(V);
    Vmags = abs(V);
    
    % V is size n and paddedDeltas is size 2n. The first n values in
    % paddedDeltas are the angle corrections.  The next n values are
    % the magnitude corrections
    nextV = zeros(size(V));
    for k=1:length(V) 
        nextAngle = Vangles(k);
        nextMagnitude = Vmags(k);
        if busVControl(k)
            % voltage controlled bus; only the angle is adjusted
            nextAngle = nextAngle + paddedDeltas(k);
        elseif ~busSlack(k)  
            % load bus; angle and magnitude are adjusted
            nextAngle = nextAngle + paddedDeltas(k);
            nextMagnitude = nextMagnitude + paddedDeltas(length(V)+k);
        end
        nextV(k) = nextMagnitude*exp(1j*nextAngle);
    end    
end