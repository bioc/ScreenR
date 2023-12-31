% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_mds.R
\name{plot_mds}
\alias{plot_mds}
\title{Multidimensional Scaling Plot}
\usage{
plot_mds(
  screenR_Object,
  groups = NULL,
  alpha = 0.8,
  size = 2.5,
  color = "black"
)
}
\arguments{
\item{screenR_Object}{The Object of the package
\code{\link{create_screenr_object}}}

\item{groups}{The vector that has to be used to fill the plot if NULL the
function will use the default groups slot in the object passed
as input.}

\item{alpha}{The opacity of the labels.
Possible value are in a range from 0 to 1.}

\item{size}{The dimension of the labels. The default value is 2.5}

\item{color}{The color of the labels. The default value is black}
}
\value{
The MDS Plot
}
\description{
Plot samples on a two-dimensional scatterplot so that
             distances on the plot approximate the typical log2 fold
             changes between the samples.
}
\examples{
object <- get0("object", envir = asNamespace("ScreenR"))

plot_mds(object)
}
