# Bayesian approach for addressing covariate measurement error in propensity score methods
<br>
<br>

### Elizabeth Stuart
### Kara Rudolph

Note: 

---

## Motivation

Balancing score property of propensity scores (PS) assumes that:
1. all confounders are observed and 
2. measured without error.

In reality, covariate measurement error may be the rule rather than the exception. 
E.g., 
* self-reported measures: household income, weight, age of parents.
* imperfect instruments: blood pressure, cortisol levels.
* latent constructs: depression, disability.

Researchers left with the choice: exclude mismeasured covariates from PS model or ignore the measurement error. 

Note: 

---

## Previous Research

Focus has been on classical measurement error
$W = X + U$, $E(U \vert X)=0$, with constant variance $U \vert X \sim Normal(0,\sigma^2_u)$ where:

* $X$ is the correctly measured covariate, and
* $W$ is the mismeasured version of X.

* Steiner, Cook, Shadish. 2011: Classical measurement error in covariate(s) comprimises bias-reduction potential of propensity score methods
* McCaffrey, Lockwood, Setodji. 2011: Propose IPW that corrects for classical measurement error in the covariates.
* Lockwood, McCaffrey. 2014: Argue that PS matching using covariates measured with error (only) will not work, but suggest that using the covariates measured with error in conjunction with treatment status may work in some scenearios.
* Raykov
* Millimet
* McCandless
* Gustafson


Note: 

---

## Research Gap
<br>

Non-classical measurement error. 

We consider measurement error that is differential by treatment status. 
* Systematic differential measurement error that affects the mean. 
	* Example: Adolescents in disadvantaged neighborhoods (`treatment' group) tend to overestimate their mothers' age when the adolescents were born.
* Heteroscedastic differential measurement error that affects the variance.
	* Example: Adolescents in disadvantaged neighborhoods are less accurate in knowing their mothers' age when the adolescents were born.


Note: 

---

## Goal

Approach that can flexibly handle covariate measurement error that is differential by treatment status.

* Bayesian approach
	* Most flexible approach for addressing measurement error (Carroll et al., 2006). Especially useful for measurement error model involving heteroscedasticity.
	* Propogates uncertainty.
	* More appropriate when validation data are external to the study sample instead of internal (Cole et al., 2006).
	* Maximum likelihood approach has similar advantages, but Bayesian is simpler to implement (Hossain, Gustafson, 2009).


Note: 

---

## Data Generating Mechanism
Let observed data $O=(W, Y, A, Z)$ and complete data $C=(W, Y, A, X, Z)$, where:
* $Z$ = observed, continuous covariate. $Z \sim Normal(1, 1)$
* $X$ = unobserved, continuous covariate. $X \sim Normal(1 + 0.2*Z, 1)$
* $W$ = observed, mismeasured version of $X$, $W \sim Normal(X + 2*A, 0.5(1 + A)^2)$. Note that a more general version of measurement error differential by treatment status could be written: $W \sim Normal(\gamma*f(X,A), \sigma^2*(delta*f(X,A))^2)$
* $A$ = observed, binary (0/1) variable indicating treatment. $A \sim Bernoulli(-2log(2) + log(2)*X + log(2)*Z)$
* $Y$ = observed, continuous outcome of interest. $Y \sim Normal(3*A + 2*X + 2*Z, 1)$

Note:


---

## Data Generating Mechanism

<img src="./BayesianMESummary-002.png" width="800" height="300">

Note: 

---

## Estimands and Estimators

Estimands: ATE and ATT
Why both? 
* Non-differential covariate measurement error  : unobserved confounding
* Covariate measurement error differential by Tx status : unobserved effect modification. ATE $\ne$ ATT in sample

Estimator: IPTW

* But, we do not observe $X$, so the ATE is not identifiable. It's possible that Bayesian models can be useful even under non-identifiability, but we need some assumptions.

Assumptions: 
* External validation data with $(A,X,W)$ that can inform priors related to measurement error.
* External validation data generalizes to study sample.
* $W \indep (Y, Z) \vert X, A$. Could be relaxed if $Y$ or $Z$ was observed in the validation study.
And the usual causal inference assumptions:
* No unmeasured confounders: for each $a \in \{ 0,1 \}$, we have $Y_a \indep A \vert X,Z$.
* Consistency: for each $a \in \{ 0,1 \}$, we have $Y_a =Y$ on the event $A=a$.
* Positivity: for each $a \in \{ 0,1 \}$, we have $P(A=a \vert X, Z)$ is strictly positive.


Note: 

---

## Bayesian Sensitivity Analysis for Covariate Measurement Error


* Point mass priors on coefficients in measurement error model:
[insert model]
* Strong and untestable assumption, unless internal validation data are present. 
* Assume have external knowledge to inform priors related to measurement error.
* Assume that this external knowledge generalizes to the study sample.
* Non-informative priors on coefficients in treatment, outcome, and X models
* Semi-informative priors on $\sigma_u$ and $\sigma_x$

Note: 

---

## Bayesian Sensitivity Analysis for Covariate Measurement Error

graph from 1 iteration

Note: 

---

## Bayesian Sensitivity Analysis for Covariate Measurement Error

graph from simuation (500 trials)

Note: 

---

## Results

* Differential measurement error in variance (heteroscedasticity) less important than differential measurement error in the mean (agrees with Spiegelman et al., 2011).
* Don't have to use point mass priors. Could use non-informative priors if increased the number of iterations (and therefore increase computing time).
* Model feedback not an issue. We allow the outcome model to be a function of covariates instead of just the propensity score (as in imputation).

Note:  

---

## Example Data

Association between living in a disadvantaged neighborhood and past-year drug abuse or dependence disorder.
* Important confounders: family income, race/ethnicity, urbanicity, region of the country, age of adolescent, age of mother when the adolescent was born
* National Comorbidity Survey Replication Adolescent Supplement: 
	* Nationally-representative survey of adoelscent mental health (DSM-IV diagnoses)
	* Face-to-face, computer-assisted interviews with the adolescent. 
  	* Self-administered questionnaire to parents or parent surrogate of the adolescent.
  	* Geocoded residence.	

Note: 

---

## Example Data: Measurement Error

$X$: mother-reported maternal age at birth 
$W$: adolescent-reported maternal age at birth

insert figure of observed data. 

* We use subset where both $X$ and $W$ are observed to evaluate how the method works.

Note: 

---

## Example Data: Simulated Additional Measurement Error

* Measurement error scale may be differential by neighborhood disadvantage status---greater variance in disadvantaged versus non-disadvantaged neighborhoods. 
* Highly correlated.

insert picture

Note: 

---

## Example Data: Analysis

We evaluate our Bayeian approach using:
* $W$ from the data ($\rho=0.94$)
* $W$ with simulated additional measurement error that is differential in the location parameter ($\rho=0.7$)
* $W$ with simulated additional measurement error that is differential in the scale parameter ($\rho=0.7$)
* $W$ with simulated additional measurement error that is differential in the location and scale parameters ($\rho=0.7$)


Note: 


---

## Example Data: Results

insert graph 

Note: 

---

## Conclusions


Note:


---

## Future Work

---

## Acknowledgements
