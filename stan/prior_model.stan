data {
    int<lower = 0> max_score;
    real<lower = 0> mean_rate_of_rates;
} transformed data {
   real<lower = 0> rate_of_rates;

   rate_of_rates = 1 / mean_rate_of_rates;
}
generated quantities {
    real<lower = 0> rate;
    array[max_score + 1] real tbp;
    array[max_score + 1] real<lower = 0> time;
    array[max_score + 1] int<lower = 0> score;

    rate = exponential_rng(rate_of_rates);

    // tbp[1] = NaN;
    time[1] = 0;
    score[1] = 0;

    for (t in 2:(max_score + 1)) {
        tbp[t] = exponential_rng(rate);
        time[t] = time[t - 1] + tbp[t];
        score[t] = score[t - 1] + 1;
    }
}
