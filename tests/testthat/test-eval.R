test_that("jl eval int64", {
  expect_equal(jlvalue_capture_display(jl(`2 * 2`)), "4\n")
})

test_that("jl eval string", {
  expect_equal(jlvalue_capture_display(jl(`"2 * 2"`)), '"2 * 2"\n')
})

test_that("jl eval symbol", {
  expect_equal(jlvalue_capture_display(jlsymbol("toto")), ":toto\n")
})
