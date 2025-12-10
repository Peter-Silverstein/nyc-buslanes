data {
  int<lower=0> N;
  array[N] real<lower=0> y; // outcome: bus speed
  vector[N] z; // continuous treatment variable
  
  // factor vars
  int<lower=1> I; // num year periods
  array[N] int<lower=1,upper=I> i_index; // year index
  
  int<lower=1> J; // num month periods
  array[N] int<lower=1,upper=J> j_index; // month index
  
  int<lower=1> M; // num borough
  array[N] int<lower=1,upper=M> m_index; // borough index
  
  // hierarchical variables
  int <lower=1> R; // num route_ids
  array[N] int<lower = 1, upper=R> r_index; // route_id index
}
parameters {
  real beta0; // intercept
  vector[I] beta_i; // year-level fixed effects
  vector[J] beta_j; // month-level fixed effects
  vector[M] beta_m; // borough-level fixed effects
  vector[R] beta_r; // route-level random effects
  
  real<lower=0> sigma_r; // route-level variance
  real<lower=0> sigma; // variance
  
  real theta; // treatment effect
}
model {
  // Priors
  beta0 ~ normal(0, 5);
  beta_i ~ normal(0, 1);
  beta_j ~ normal(0, 1);
  beta_m ~ normal(0, 1);
  beta_r ~ normal(0, sigma_r);
  sigma_r ~ normal(0, 1);
  sigma ~ normal(0, 2);
  theta ~ normal(0, 1);
  
  // Linear predictor
  vector[N] mu;
  for (n in 1:N) {
    mu[n] = beta0 + beta_i[i_index[n]] + beta_j[j_index[n]] + beta_m[m_index[n]] + beta_r[r_index[n]] + theta * z[n];
  }
  
  // Likelihood
  y ~ normal(mu, sigma);
}
