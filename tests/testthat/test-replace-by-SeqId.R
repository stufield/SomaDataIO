# Setup -----
x  <- c("seq.4554.56", "seq.3714.49", "PlateId")
y1 <- c("Group", "3714-49", "Assay", "ABCD.4554.56")
y2 <- c("KLK4.4554.56", "foo")

# Testing -----
test_that("`replace_by_SeqId()` has expected output", {
  expect_equal(replace_by_SeqId(x, y1),
               c("ABCD.4554.56", "3714-49", "PlateId"))
  expect_equal(replace_by_SeqId(y1, x),
               c("Group", "seq.3714.49", "Assay", "seq.4554.56"))
  expect_equal(replace_by_SeqId(x, y2),
               c("KLK4.4554.56", "seq.3714.49", "PlateId"))
  expect_equal(replace_by_SeqId(y2, x),
               c("seq.4554.56", "foo"))

  # no matches
  expect_message(nomatch <- replace_by_SeqId(x, letters[1:3L]),
                 "No matches between lists")
  expect_equal(nomatch, c("seq.4554.56", "seq.3714.49", "PlateId"))

  # if x has names, keep names
  x_named <- stats::setNames(x, letters[seq_along(x)])
  expect_equal(replace_by_SeqId(x_named, y1),
               c(a = "ABCD.4554.56", b = "3714-49", c = "PlateId"))

  # works with "" and NA
  x_edges <- c(x, c("", NA))
  expect_equal(replace_by_SeqId(x_edges, y1),
               c("ABCD.4554.56", "3714-49", "PlateId", "", NA))

  # if no match, returns 'x'
  expect_message(foo <- replace_by_SeqId(x, ""), "No matches between lists")
  expect_equal(foo, x)
})

test_that("`replace_by_SeqId()` throws errors with non-character vectors", {
  expect_error(replace_by_SeqId(x, NULL),
               "`y` must be a character vector.")
  expect_error(replace_by_SeqId(x, NA),
               "`y` must be a character vector.")
  expect_error(replace_by_SeqId(x, 1:5),
               "`y` must be a character vector.")
  expect_error(replace_by_SeqId(x, as.list(letters[1:5])),
               "`y` must be a character vector.")
  expect_error(replace_by_SeqId(NULL, x),
               "`x` must be a character vector.")
})
