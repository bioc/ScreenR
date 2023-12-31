% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_robust_zscore_hit.R
\name{find_robust_zscore_hit}
\alias{find_robust_zscore_hit}
\title{Title Find robust Z-score Hit}
\usage{
find_robust_zscore_hit(table_treate_vs_control, number_barcode)
}
\arguments{
\item{table_treate_vs_control}{A table computed with the function
\code{compute_data_table}.
It contain for each barcode the associated
Gene the counts in the treated and control
and the value for the Log2FC, Zscore,
ZscoreRobust in each day.}

\item{number_barcode}{Number of barcode that as to be differentially
expressed (DE)in order to consider the gene associated
DE. Example a gene is associated
with 10 shRNA we consider a gene DE if it has at least
number_barcode = 5 shRNA DE.}
}
\value{
Return a tibble containing the hit for the robust Z-score
}
\description{
Title Find robust Z-score Hit
}
\examples{
object <- get0("object", envir = asNamespace("ScreenR"))
table <- compute_metrics(object,
    control = "TRT", treatment = "Time3",
    day = "Time3"
)
result <- find_robust_zscore_hit(table, number_barcode = 6)
head(result)
}
\concept{find}
