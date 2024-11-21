function time = arrival()
    lambda = 4;
    U = rand();
    time = -1 * (1/lambda) * log(U);
end