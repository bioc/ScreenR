% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_boxplot.R
\name{plot_boxplot}
\alias{plot_boxplot}
\title{Plot Barcodes Hit}
\usage{
plot_boxplot(
  screenR_Object,
  genes,
  group_var,
  alpha = 0.5,
  nrow = 1,
  ncol = 1,
  fill_var = "Sample",
  type = "boxplot",
  scales = "free"
)
}
\arguments{
\item{screenR_Object}{The ScreenR object obtained using the
\code{\link{create_screenr_object}}}

\item{genes}{The vector of genes that will be displayed}

\item{group_var}{The variable that as to be used to filter the data, for
example the different treatment}

\item{alpha}{A value for the opacity of the plot.
Allowed values are in the range 0 to 1}

\item{nrow}{The number of rows in case multiple genes are plotted}

\item{ncol}{The number of columns in case multiple genes are plotted}

\item{fill_var}{The variable used to fill the boxplot}

\item{type}{The type of plot to use "boxplot" or "violinplot"}

\item{scales}{The scales used for the facet.
Possible values can be "free", "fixed" and "free_y"}
}
\value{
A boxplot
}
\description{
This function plots a boxplot for each sample for the genes
             passed as input. It can be used to see the overall trend of a
             gene and so to visualize if the gene is up or down regulated.
}
\examples{
object <- get0("object", envir = asNamespace("ScreenR"))

plot_boxplot(object,
    genes = c("Gene_34"),
    group_var = c("T1", "T2", "TRT"), nrow = 1, ncol = 2,
    fill_var = "Day", type = "violinplot"
)

}
\concept{plot}
