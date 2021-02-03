context("calling resistance")

library(hivdrg)


test_that("variant files return resistance", {
  infile = system.file("testdata",  "example.vcf", package = "hivdrg")
  
  t1 = call_resistance(infile, all_mutations = FALSE)
  expect_equal(nrow(t1), 4)
})


