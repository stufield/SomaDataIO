# Annotated Content Excel files from:
#   https://menu.somalogic.com
#   https://somalogic.com/somascan-menu/
# Run:
#   make sysdata
# Author:
#   Stu Field
# ------------------

n <- 8

v5k <- "SomaScan_V4.0_5K_Annotated_Content_20210616.xlsx" |>
  readxl::read_xlsx(skip = n) |>
  dplyr::select(SeqId,          # do not need CCCs here (covered in 7k)
                serum_5k_to_7k  = "Serum Scalar v4.0 to v4.1",
                plasma_5k_to_7k = "Plasma Scalar v4.0 to v4.1")

v7k <- "SomaScan_7K_Annotated_Content.xlsx" |>
  readxl::read_xlsx(skip = n) |>
  dplyr::select(SeqId,
                serum_7k_to_5k_ccc  = "Serum Lin's CCC v4.1 7K to v4.0 5K",
                plasma_7k_to_5k_ccc = "Plasma Lin's CCC v4.1 7K to v4.0 5K",
                serum_7k_to_5k      = "Serum Scalar v4.1 7K to v4.0 5K",
                plasma_7k_to_5k     = "Plasma Scalar v4.1 7K to v4.0 5K",
                serum_7k_to_11k     = "Serum Scalar v4.1 7K to v5.0 11K",
                plasma_7k_to_11k    = "Plasma Scalar v4.1 7K to v5.0 11K")

v11k <- "SomaScan_11K_Annotated_Content.xlsx" |>
  readxl::read_xlsx(skip = n) |>
  dplyr::select(SeqId,
                serum_11k_to_7k_ccc  = "Serum Lin's CCC v5.0 11K to v4.1 7K",
                plasma_11k_to_7k_ccc = "Plasma Lin's CCC v5.0 11K to v4.1 7K",
                serum_11k_to_5k_ccc  = "Serum Lin's CCC v5.0 11K to v4.0 5K",
                plasma_11k_to_5k_ccc = "Plasma Lin's CCC v5.0 11K to v4.0 5K",
                serum_11k_to_7k      = "Serum Scalar v5.0 11K to v4.1 7K",
                plasma_11k_to_7k     = "Plasma Scalar v5.0 11K to v4.1 7K",
                serum_11k_to_5k      = "Serum Scalar v5.0 11K to v4.0 5K",
                plasma_11k_to_5k     = "Plasma Scalar v5.0 11K to v4.0 5K")

# this is calculated by inverting
# does not currently exist in a
# customer facing file explicitly
v11k$serum_5k_to_11k  <- round(1 / v11k$serum_11k_to_5k, 3L)
v11k$plasma_5k_to_11k <- round(1 / v11k$plasma_11k_to_5k, 3L)

# start with largest and left_join
lift_master <- dplyr::left_join(v11k, v7k, by = "SeqId") |>
  dplyr::left_join(v5k, by = "SeqId")
lift_master <- dplyr::relocate(lift_master, SeqId, sort(names(lift_master)))



# ---------------------------------------------
# originally this chunk was saved as an object
# and added to the sysdata file this subsetting
# now happens on-the-fly inside SomaDataIO
# ---------------------------------------------
#lref <- list()
#lref$plasma <- dplyr::select(lift_master, SeqId,
#                             starts_with("plasma"), -ends_with("ccc"))
#names(lref$plasma) <- gsub("^plasma_", "", names(lref$plasma))
#lref$plasma[is.na(lref$plasma)] <- 1  # 1.0 scale factor

#lref$serum <- dplyr::select(lift_master, SeqId,
#                            starts_with("serum"), -ends_with("ccc"))
#names(lref$serum) <- gsub("^serum_", "", names(lref$serum))
#lref$serum[is.na(lref$serum)] <- 1  # 1.0 scale factor

save(lift_master, file = "sysdata.rda", compress = "xz")
