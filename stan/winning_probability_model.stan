data {
    int<lower = 0> max_score;
    real<lower = 0> mean_rate_of_rates;
    int<lower = 0> sample_size;
    int<lower = 0> team_count;
    array[sample_size] int<lower = 1, upper = team_count> team;
    array[sample_size] real<lower = 0> time;
    array[sample_size] int<lower = 0> score;
}
transformed data {
    real<lower = 0> rate_of_rates;

    rate_of_rates = 1 / mean_rate_of_rates;

    array[sample_size] real tbp;

    {
        array[team_count] real last_time;
        for (i in 1:team_count) {
            last_time[i] = 0;
        }

        for (i in 2:sample_size) {
            tbp[i] = time[i] - last_time[team[i]];
            last_time[team[i]] = time[i];
        }
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
    real<lower = 0, upper = 1> winning_probability;

    {
        array[team_count] int current_score;

        for (i in 1:team_count) {
            current_score[i] = 0;
        }

        for (i in 1:sample_size) {
            if (current_score[team[i]] < score[i]) {
                current_score[team[i]] = score[i];
            }
        }

        real rate_1_contribution = rate[1] / (rate[1] + rate[2]);
        real points_to_win_1 = max_score - current_score[1];
        real points_to_win_2 = max_score - current_score[2];

        // Probability of team 1 winning
        // Which is equivalent to probability of team 1 achieving 100 score first
        // Which is equivalent to P(sum(tbp from current_score[1] to 100) < sum(tbp from current_score[2] to 100))
        // Which is equivalent to P(sum(Exponential(rate[1]) from current_score[1] to 100) < sum(Exponential(rate[2]) from current_score[2] to 100))
        // Which is equivalent to P(Gamma(points_to_win_1, rate[1]) < Gamma(points_to_win_2, rate[2]))
        // Which is equivalent to P(Beta(points_to_win_1, points_to_win_2) < rate_1_contribution)
        // For last point, see htbps://math.stackexchange.com/questions/2426140/probability-of-a-gamma-r-v-greater-than-another
        winning_probability = beta_cdf(rate_1_contribution | points_to_win_1, points_to_win_2);
    }
}
