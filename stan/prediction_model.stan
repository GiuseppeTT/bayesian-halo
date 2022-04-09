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
    array[sample_size] real tbp;

    rate_of_rates = 1 / mean_rate_of_rates;

    for (i in 1:team_count) {
        last_time[i] = 0;
    }

    for (i in 2:sample_size) {
        tbp[i] = time[i] - last_time[team[i]];
        last_time[team[i]] = time[i];
    }
}
parameters {
    array[team_count] real<lower = 0> rate;
}
model {
    rate ~ exponential(rate_of_rates);

    // Does 2:sample_size make sense since there are 2 teams?
    // Shouldn't I skip for team red too?
    for (i in 2:sample_size) {
        tbp[i] ~ exponential(rate[team[i]]);
    }
}
generated quantities {
    array[team_count] real<lower = 0> predicted_time;

    {
        array[team_count] real current_time;

        for (i in 1:team_count) {
            current_time[i] = 0;
        }

        for (i in 1:sample_size) {
            if (current_time[team[i]] < time[i]) {
                current_time[team[i]] = time[i];
            }
        }

        for (i in 1:team_count) {
            predicted_time[i] = current_time[i] + exponential_rng(rate[i]);
        }
    }
}
