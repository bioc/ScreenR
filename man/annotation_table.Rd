% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotation_table.R
\docType{data}
\name{annotation_table}
\alias{annotation_table}
\title{Table for the annotation of Barcode}
\format{
A data frame with 5320 rows and 2 columns obtained from a
        loss-of-function genetic screening. This table is used to
        store information about the shRNAs:
\describe{
  \item{Gene}{It Contains the gene name}
  \item{Barcode}{It contains an ID that identify each barcode
                 (it is an unique identifier for an shRNA). I
                 t can be use to merge the annotation table with t
                 he count table}

  \item{Gene_ID}{It Contains a unique Gene ID}

  \item{Sequence}{It contains the cDNA sequence of the shRNA associated to
                  the barcode}

  \item{Library}{It contains the library from which the shRNA come from.
                 In this case is a pooled from
                 \url{https://cellecta.com/}{cellecta}}
}
}
\usage{
data(annotation_table)
}
\description{
Table for the annotation of Barcode
}
\concept{data}
\keyword{datasets}
