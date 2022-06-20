
data {
  int <lower = 0> N; // number of matches
  int <lower = 0> K; // number of teams
  int <lower = 0, upper = 1> y[N]; // winner 1 if team 1 win, 0 ow 
  int <lower = 1, upper = K> home[N]; // list of home teams
  int <lower = 1, upper = K> away[N]; // list of away teams

  // set priors for team ratings
  real prior_mean; 
  real <lower = 0> prior_sd;
  
  // test data
  
  int <lower = 0> N_test;
  int <lower = 0, upper = 1> y_test[N_test]; // winner 1 if team 1 win, 0 ow 
  
}

parameters {
  real hfa;
  vector[K] alpha;

}

model {
  alpha ~ normal(prior_mean, prior_sd);
  hfa ~ normal(0,1);
  
  y ~ bernoulli_logit(alpha[home] - alpha[away] + hfa);
  
}

generated quantities{
  
  vector[N_test] y_pred;
  
  for (i in 1:N_test){
    y_pred[i] = bernoulli_rng(inv_logit(alpha[home[i]] - alpha[away[i]] + hfa));
  }
  
}