// NOTE: The semicolons (;) at the end of each line is necessary!
// This is from C++ syntax.

data {
  int <lower=0> N; // number of parameter
  int <lower=0, upper=1> home_run[N]; // 1 if home run, 0 otherwise
  vector[N] exit_velocity; // column for exit velocity
  vector[N] launch_angle; // column for launch angle
  
}

transformed data {
  // initialise scaled parameters
  vector[N] ev_std;
  vector[N] la_std;
  
  // define how parameters are scaled
  ev_std = (exit_velocity - mean(exit_velocity))/ sd(exit_velocity);
  la_std = (launch_angle - mean(launch_angle)) / sd(launch_angle);
  
}

parameters {
  real alpha; // intercept
  real beta_ev; // coefficient for exit velocity in regression
  real beta_la; // coefficient for launch angle in regression
  
}

model {
  // model equation
  home_run ~ bernoulli_logit(alpha + beta_ev*ev_std + beta_la*la_std);
  
  // priors
  alpha ~ normal(-3,5);
  beta_ev ~ normal(0,5);
  beta_la ~ normal(0,5);
  
}
