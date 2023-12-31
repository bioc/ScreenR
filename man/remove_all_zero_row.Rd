% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_by.R
\name{remove_all_zero_row}
\alias{remove_all_zero_row}
\title{Remove rows that have zero count in all samples}
\usage{
remove_all_zero_row(screenR_Object)
}
\arguments{
\item{screenR_Object}{The ScreenR object obtained using the
\code{\link{create_screenr_object}}}
}
\value{
The ScreenR object with the count_table and the annotation_table
        filtered.
}
\description{
This function removes the rows that have zero count in
             all samples. It takes care of updating both count_table and
             annotation_table.
             Very_Important: It has to be performed before the
                             data normalization.
}
\examples{
object <- get0("object", envir = asNamespace("ScreenR"))
counts <- get_count_table(object)
nrow(counts)
object <- remove_all_zero_row(object)
counts <- get_count_table(object)
nrow(counts)
}
\concept{compute}
