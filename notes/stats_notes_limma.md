Limma examples
==============

- Small model: lm(y ~ gType + devStage) (no interaction term) 
- Big model: lm(y ~ gType * devStage) (interaction term)
  yijk =θ+τj +βk +(τβ)jk +εijk “big”
- Use F-test (some function in limma?) to decide between tests
- In limma, the 'BH' adjustment method is a synonym for 'fdr' - these are the same thing!
- Design matrix is used to specify the _study design_, i.e. the relationship between samples and categorical variables that they belong to
- Contrast matrix is used to specify contrasts of interest

General FDR stuff
-----------------

- 'Hits' that we select will be composed of true positives and false positives (Type I errors)
- 'No hits' that we select will be composed of true negatives and false negatives (Type II errors)
- Nomenclature: *m* = number of genes, *S* = number of discoveries
- Thresholding at a particular p-value controls the **false-positive rate** (e.g., at 0.05)
- So for 2000 genes, \\(\alpha\\)=0.05, expected # of FPs = 250!
- Bonferroni correction is a _very_ conservative method of controlling FP rate
- Alternative is FDR == E(F/S) (i.e., expected proportion of false positives as a proportion of all 'hits')
- Using 'q-values' is controlling for FDR, as opposed to p-values, which is just FPs
> “The false positive rate is the rate that truly null featues are called significant. The false discovery rate is the rate that significant features are truly null.”
- q-value (feature) = expected proportion of false positives if this feature is called significant
= expected proportion of false positives among all features as or more extreme than this feature


Limma Workflow
--------------

- Make a design matrix
- (Optionally) make a contrast matrix to describe the contrasts of interest
- Use `lmFit` to fit the model
- Use `eBayes` to moderate the test statistics
- Use `decideTests` to compare between testing approaches

In our data-set:

| Genotype / BrainRegion | wt | S1P2 | S1P3 |
| ---------------------- | -- | ---- | ---- |
| neocortex              | \\[\theta\\]   |      |      |
| hippocampus            | \\[\tau_hippocampus\\]     |      |      |

topTable
--------

- **coef argument is where you specify what it is you want to test for equality with zero**