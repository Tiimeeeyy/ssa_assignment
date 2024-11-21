function time = service()
    lambda = 5;
    U = rand();
    time = -1 * (1/lambda) * log(U);
end