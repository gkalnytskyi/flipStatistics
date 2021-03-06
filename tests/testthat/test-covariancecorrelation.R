context("Covariance and Correlation Matrix")

# Tests which replicate options available in SPSS
data("pcaPhoneTestData", package = "flipExampleData")
test.data.1 <- pcaPhoneTestData$data.set # Most cases have some missing observations (named "q23 20% Missing" in SPSS file)
test.data.2 <- pcaPhoneTestData$data.set.original # Most cases do not have missing observations (named "q23" in SPSS file)
test.weight <- pcaPhoneTestData$weight
test.calibrated.weight <- pcaPhoneTestData$q.calibrated.weight

# Note that comparisons with SPSS using weighted data will differ when these functions are used in
# DisplayR because there we always supply QCalibratedWeight.


####
# Replicated options in SPSS and paste value (3,4) from the correlation/covariance matrix
####

test_that("Correlation and covariance matrices are calculated correctly",
{
    test.complete.obs <- !is.na(rowSums(test.data.2)) & test.weight > 0

    # Weighted Correlation Matrix with Pairwise
    expect_equal(weightedPartialCovarianceMatrix(test.data.1, test.weight, correlation = TRUE)[3,4], 0.151448808216322)

    # Weighted Covariance Matrix with Pairwise
    expect_equal(weightedPartialCovarianceMatrix(test.data.1, test.weight, correlation = FALSE)[3,4], 0.220870616976875)

    # Compare correlation against 'weights' package
    expect_equal(weightedPartialCovarianceMatrix(test.data.1, test.weight, correlation = TRUE),
        weights::wtd.cors(test.data.1, weight = test.weight))

    # Weighted Correlation Matrix with Complete Obs Only
    expect_equal(weightedPartialCovarianceMatrix(test.data.2[test.complete.obs, ],
        test.weight[test.complete.obs],
        correlation = TRUE)[3,4], 0.142891895221493)
    expect_equal(CovarianceAndCorrelationMatrix(test.data.2, weights = test.weight, pairwise = FALSE, use.correlation = TRUE)[3,4], 0.142891895221493)


    # Weighted Covariance Matrix with Complete Obs Only
    expect_equal(weightedPartialCovarianceMatrix(test.data.2[test.complete.obs, ],
        test.weight[test.complete.obs],
        correlation = FALSE)[3,4], 0.184031773635988)
    expect_equal(CovarianceAndCorrelationMatrix(test.data.2, weights = test.weight, pairwise = FALSE, use.correlation = FALSE)[3,4], 0.184031773635988)


    # Compare correlation against 'weights' package
    expect_equal(weightedPartialCovarianceMatrix(test.data.2[test.complete.obs, ],
        test.weight[test.complete.obs], correlation = TRUE),
        weights::wtd.cors(test.data.2[test.complete.obs, ], weight = test.weight[test.complete.obs]))

    # Un-weighted Correlation Matrix with Pairwise
    expect_equal(cor(test.data.1, use = "pairwise.complete.obs")[3,4], 0.237209928184647)

    # Unweighted Covariance Matrix with Complete Obs Only
    expect_equal(cov(test.data.2, use = "complete.obs")[3,4], 0.235279345882637)

    # Unweighted Covariance Matrix with Pairwise Obs
    expect_equal(cov(test.data.1, use = "pairwise.complete.obs")[3,4], 0.314795729067899)


})


test_that("Correlation",
{
    x <- c(NA, 1:10)
    y <- c(NA, 2, 2:10)
    w <- c(NA, rep(1, 10))
    expect_equal(Correlation(x, y, w), Correlation(x, y))
    expect_equal(cor(x, y, use = "complete.obs"), Correlation(x, y))
    w <- c(NA, 1:10)
    expect_equal(Correlation(x, y, w), 0.998631, 0.0000001)
})
