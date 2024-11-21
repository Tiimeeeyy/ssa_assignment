function [avgWaitingTime, avgQueueLength] = DES()
    % Initialize arrays to store performance indicators for each iteration
    avgWaitingTime = zeros(1, 20);
    avgQueueLength = zeros(1, 20);

    % Simulate 20 times:
    for iteration = 1:20
        % The Simulation lasts until 10000 products are "produced"
        % For each simulation we need to reset the variables:
        serverStatus = 0; % 0: idle, 1: busy, 2: broken down
        clock = 0;
        numberInQueue = 0;
        timesOfArrivals = [];
        timeOfLastEvent = 0;
        numberDelayed = 0;
        totalDelay = 0;
        areaUnderQ = 0;
        areaUnderB = 0;
        nextArrival = clock + arrival();
        nextDeparture = inf;
        nextBreakdown = inf;
        nextRepair = inf;
        completedProducts = 0;
        remainingServiceTime = 0;
        while completedProducts < 10000

            % Get the nextEventTime, nextEventType based on the minimal value of the given 
            [nextEventTime, nextEventType] = min([nextArrival, nextDeparture, nextBreakdown, nextRepair]);
            clock = nextEventTime;

            areaUnderQ = areaUnderQ + numberInQueue * (clock - timeOfLastEvent);

            switch nextEventType
                case 1
                    % Here we handle the arrival:
                    interArrivalTime = arrival();
                    nextArrival = clock + interArrivalTime;
                    if serverStatus == 0
                        numberDelayed = numberDelayed + 1;
                        % Set the server to busy
                        serverStatus = 1;
                        % Since the server now has a customer, we have to serve it:
                        serviceTime = service();
                        % We add the service time to the current time:
                        nextDeparture = clock + serviceTime;
                        % Schedule first breakdown
                        breakdownTime = breakdown();
                        nextBreakdown = clock + breakdownTime;
                        
                    else 
                        numberInQueue = numberInQueue + 1;
                        timesOfArrivals(end + 1) = clock;
                    end
                case 2
                    % This case handles the Departure:
                    completedProducts = completedProducts + 1;
                    if numberInQueue > 0
                        totalDelay = totalDelay + (clock - timesOfArrivals(1));
                        timesOfArrivals(1) = [];
                        numberInQueue = numberInQueue - 1;
                        numberDelayed = numberDelayed + 1;
                        serviceTime = service();
                        nextDeparture = clock + serviceTime;

                    else 
                        % Idle the server when we dont have anything to serve
                        serverStatus = 0;
                        nextBreakdown = inf; % No breakdown while broken dowwn
                        nextDeparture = inf; % No departures are possible while broken down 
                    end
                case 3
                    % Repair:
                    serverStatus = 2;
                    remainingServiceTime = nextDeparture - clock;
                    nextDeparture = inf;
                    nextBreakdown = inf;
                    repairTime = repair();
                    nextRepair = clock + repairTime;
                case 4
                    % Server Breakdown
                    serverStatus = 1;
                    nextDeparture = clock + remainingServiceTime;
                    breakdownTime = breakdown();
                    nextBreakdown = clock + breakdownTime;

            end
            timeOfLastEvent = clock;
        end

        % Calculate and store performance indicators for this iteration
        avgWaitingTime(iteration) = totalDelay / numberDelayed;
        avgQueueLength(iteration) = areaUnderQ / clock;
    end
end