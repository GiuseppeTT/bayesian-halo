data {
    real<lower = 0> mean_rate_of_rates;
    int<lower = 0> sample_size;
    int<lower = 0> team_count;
    array[sample_size] int<lower = 1, upper = team_count> team;
    array[sample_size] real<lower = 0> time;
}
transformed data {
    real<lower = 0> rate_of_rates;
    array[team_count] real<lower = 0> last_time;
    array[sample_size] real ttp;

    rate_of_rates = 1 / mean_rate_of_rates;

    for (i in 1:team_count) {
        last_time[i] = 0;
    }

    for (i in 2:sample_size) {
        ttp[i] = time[i] - last_time[team[i]];
        last_time[team[i]] = time[i];
    }
}
parameters {
    array[team_count] real<lower = 0> rate;
}
model {
    rate ~ exponential(rate_of_rates);

    for (i in 2:sample_size)
        ttp[i] ~ exponential(rate[team[i]]);
}
generated quantities {
    real rate_contrast;
    array[sample_size] real predicted_ttp;
    array[team_count] real<lower = 0> predicted_last_time;
    array[sample_size] real<lower = 0> predicted_time;
    array[team_count] int<lower = 0> predicted_last_score;
    array[sample_size] int<lower = 0> predicted_score;

    rate_contrast = rate[1] - rate[2];

    // predicted_ttp[1] = NaN;
    predicted_time[1] = 0;
    predicted_score[1] = 0;

    for (i in 1:team_count) {
        predicted_last_time[i] = 0;
    }


    for (i in 1:team_count) {
        predicted_last_score[i] = 0;
    }

    for (i in 2:sample_size) {
        predicted_ttp[i] = exponential_rng(rate[team[i]]);

        predicted_time[i] = predicted_last_time[team[i]] + predicted_ttp[i];
        predicted_last_time[team[i]] = predicted_time[i];

        predicted_score[i] = predicted_last_score[team[i]] + 1;
        predicted_last_score[team[i]] = predicted_score[i];
    }
}
