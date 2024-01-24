#' Replace Vector Entries by Matching SeqIds
#'
#' @describeIn SeqId
#'   replace entries in `x` with `y` if the `SeqIds` match. Returns a character
#'   vector identical to `x` except entries with matching `SeqIds` are
#'   replaced by entries of `y`.
#'
#' @return [replace_b_SeqId()] A character vector identical to `x` except
#'   with matching `SeqIds` replaced by entries of `y`.
#' @examples
#'
#' # replace_by_SeqId
#' v1 <- c("seq.4554.56", "seq.3714.49", "PlateId")
#' v2 <- c("Group", "3714-49", "Assay", "ABCD.4554.56")
#' v3 <- c("KLK4.4554.56", "foo")
#'
#' replace_by_SeqId(v1, v2)
#' replace_by_SeqId(v2, v1)
#' replace_by_SeqId(v1, v3)
#' replace_by_SeqId(v3, v1)
#' @export
replace_by_SeqId <- function(x, y) {
  stopifnot(
    "`x` must be a character vector." = is.character(x),
    "`y` must be a character vector." = is.character(y)
  )
  matches       <- getSeqIdMatches(x, y)
  change_idx    <- match(matches$x, x, nomatch = 0L)
  x[change_idx] <- matches$y
  x
}
