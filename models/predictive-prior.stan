data {
    int<lower = 0> max_score;
    real<lower = 0> mean_rate_of_rates; // 100 kills in 15 minutes
}
generated quantities {
    real<lower = 0> rate_of_rates = 1 / mean_rate_of_rates;

    real<lower = 0> rate = exponential_rng(rate_of_rates);

    array[max_score] real<lower = 0> time_to_kills;
    for (t in 1:max_score)
        time_to_kills[t] = exponential_rng(rate);
}
