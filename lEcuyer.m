function u = lEcuyer(z, s ,n)
%LECUYER Generates a sequence of l'Ecuyer-LSFR random numbers.
%   U = LECUYER(Z1, Z2, Z3, Z4, N) generates N random numbers 
%   using the l'Ecuyer-LSFR algorithm.
%
%   Inputs:
%       Z - A Vector of integer seeds for the LSFR.
%       S - A Vector of integers representing the taps (shift values)
%       N - The number of random numbers to generate.
%
%   Output:
%       U - A row vector of N random numbers between 0 and 1.
% The code / header have been changed to make the code more modular and
% follow best practices:
    if length(z) ~= length(s)
        error("Seeds and shifts have to be of equal length!");
    end

    L = 32;
    u = zeros(n, 1);

    % Since we need to use bitshift operations, the variables have to be converted to unsigned integers:
    z = uint32(z);
    s = uint32(s);

    % Iterate over the vector of input variables
    for c = 1:n 
        for i = 1:length(z)
            b = bitxor(bitsll(z(i), s(i)), z(i));
            b = bitsrl(b, L - s(i));
            z(i) = bitxor(bitsll(bitand(z(i), 2^L - 2^(i-1)), s(i)), b);
        end

        result = 0;
        for i = 1:length(z)
            result = bitxor(result, z(i));
        end
        u(c) = double(result) / 2^L;
    end
end