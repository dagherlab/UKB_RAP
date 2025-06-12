library(data.table)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("Need ≥1 input file + output name")
output_name <- tail(args, 1L)
files       <- head(args, -1L)

# 1. Read + key
data_list <- lapply(files, function(f) {
  dt <- fread(f)
  if (!"eid" %in% names(dt)) {
    warning("Skipping ", f, ": no 'eid'")
    return(NULL)
  }
  setkey(dt, eid)
  dt
})
data_list <- Filter(Negate(is.null), data_list)
if (length(data_list) == 0) stop("No valid tables")

# 2. Sort by nrows
data_list <- data_list[order(sapply(data_list, nrow))]

# 3. Balanced merge
merge_tree <- function(dtl) {
  if (length(dtl) == 1L) return(dtl[[1]])
  mid <- length(dtl) %/% 2
  merge(merge_tree(dtl[1:mid]),
        merge_tree(dtl[(mid+1):length(dtl)]),
        by = "eid", all = TRUE)
}
merged_data <- merge_tree(data_list)

# 4. Write out FAST
out_csv <- paste0(output_name, ".csv")
fwrite(merged_data, out_csv)

cat("Done: ", out_csv, "\n")
