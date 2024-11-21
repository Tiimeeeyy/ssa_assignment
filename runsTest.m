function [reject, R] = runsTest(u, a)
%   [REJECT, R] = RUNSTEST(U, A) performs a runs test on the 
%   sequence of numbers in U to assess randomness. 
%
%   Null Hypothesis: The sequence of numbers in U is random.
%
%   Inputs:
%       U - A column vector of numbers.
%       A - The significance level (alpha) for the test.
%
%   Outputs:
%       REJECT - A boolean value indicating whether to reject the null 
%                hypothesis (true) or not (false).
%       R - The calculated runs test statistic.
    % We need this to seperate the Values
    n = length(u);
    mean_u = mean(u);
    
    % This converts the numeric sequence into runs based on the mean
    runs_sequence = u > mean_u;
    runs = 1; % Initialize run count
    
    % This loop counts the amout of runs
    for i=2:n 
        if runs_sequence(i) ~= runs_sequence(i-1)
            % Increment the number of runs if the next element (i) is
            % different than the last one (i-1)
            runs = runs+1;
        end 
    end 
    
    % Determine the amount of runs below and above the mean:
    runs_above_mean = sum(runs_sequence);
    runs_below_mean = n - runs_above_mean;
    

    num_expected_runs = (2 * runs_above_mean * runs_below_mean / n) + 1;
    Variance = (2 * runs_above_mean * runs_below_mean * (2 * runs_above_mean * runs_below_mean- n)) / (n^2 * n - 1);

    % Calculate the test statistic, which gets printed to the console:
    R = (runs - num_expected_runs) / sqrt(Variance)

    % Calculate the crtitical value z_critical, which gets printed to the
    % console
    z_critical = norminv(1 - a/2)

    % Compare the test statistic and the critical value and reject / accept
    % based on the null hypothesis mentioned in the beginning:
    reject = abs(R)> z_critical;
    
    % Print the outcome of the test:
    if reject 
        disp("Reject the null hypothesis, the sequence is not random!");
    else 
        disp("Null Hypothesis cant be rejected, the sequence is random!");
    end 
end 

