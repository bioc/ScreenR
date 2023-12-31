% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_zscore_hit.R
\name{find_zscore_hit}
\alias{find_zscore_hit}
\title{Title Find Z-score Hit}
\usage{
find_zscore_hit(table_treate_vs_control, number_barcode = 6, metric = "median")
}
\arguments{
\item{table_treate_vs_control}{table computed with the function
\code{compute_data_table}}

\item{number_barcode}{Number of barcode that as to be differentially
expressed (DE)in order to consider the gene associated
DE. Example a gene is associated
with 10 shRNA we consider a gene DE if it has at least
number_barcode = 5 shRNA DE.}

\item{metric}{A string containing the metric to use. The value allowed are
"median" or "mean".}
}
\value{
Return a tibble containing the hit for the Z-score
}
\description{
Title Find Z-score Hit
}
\examples{
object <- get0("object", envir = asNamespace("ScreenR"))
table <- compute_metrics(object,
    control = "TRT", treatment = "Time3",
    day = "Time3"
)

# For the the median
result <- find_zscore_hit(table, number_barcode = 6)
head(result)

# For the mean
result <- find_zscore_hit(table, number_barcode = 6, metric = "mean")
head(result)
}
\concept{find}
