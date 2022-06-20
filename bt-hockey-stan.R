library(dplyr)
library(rstan)

data = read.csv("https://raw.githubusercontent.com/gingfacekillah/Sports-Modelling-in-R/main/hockeydata.csv")
head(data)

bt.games <- data %>%
  mutate(h_mov = HG - AG, h_win = ifelse(h_mov > 0,1,0)) %>%
  select(date = Date,
         home = Home,
         away = Visitor,
         h_score = HG,
         a_score = AG,
         h_mov,
         h_win)

train <- bt.games[1:floor(.75*1271),]
test <- bt.games[(floor(.75*1271)+1):1271,]

dat = list(N = length(train$date),
           K = length(unique(train$home)),
           y = train$h_win,
           home = as.integer(as.factor(train$home)),
           away = as.integer(as.factor(train$away)),
           prior_mean = 0,
           prior_sd = 1,
           N_test = length(test$date),
           y_test = test$h_win)

mod = stan_model("bradley-terry-stan.stan")

fit = sampling(object = mod,
               data = dat)

print(fit, digits_summary = 3)

library(bayesplot)
y_rep = extract(fit)[["y_pred"]]
samp101 = sample(nrow(y_rep), length(test$date))
color_scheme_set("green")
ppc_dens_overlay(test$h_win, y_rep[samp101,])

lbls = c("HFA", sort(unique(test$away)))

draws = as.matrix(fit)[,1:32]
mcmc_intervals(draws, prob = 0.5) +
  ggplot2::scale_y_discrete(labels = lbls)


