function time = repair()
    lambda = 3;
    U = rand(1,3);
    times = -1 * (1/lambda) * log(U);
    time = sum(times);
end