library(rstan)
library(readr)

# data scraped in python with pybaseball package

df <- read_csv("C:/Users/david/Downloads/test_py.csv")

stan_data = list(N = length(df$is_hr),
                 home_run = df$is_hr,
                 exit_velocity = df$launch_speed,
                 launch_angle = df$launch_angle)

system.time({
fit <- stan(file = "fangraphs-hr-stan.stan",
            data = stan_data,
            warmup = 1000,
            iter = 2000,
            chains = 4,
            cores = 6)
})

fit
stan_hist(fit)

