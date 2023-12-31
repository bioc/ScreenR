#' @title Plot the trend hit gene
#' @description This function plot the trend of a gene resulted as hit
#' @importFrom rlang .data
#' @param screenR_Object The ScreenR object obtained using the
#'                       \code{\link{create_screenr_object}}
#' @param group_var The variable that as to be used to filter the data, for
#'                  example the different treatment
#' @param alpha A value for the opacity of the plot.
#'              Allowed values are in the range 0 to 1
#' @param se A boolean to indicate where or not to plot the standard error
#' @param point_size The dimension of each dot
#' @param line_size The dimension of the line
#' @param nrow The number of rows in case multiple genes are plotted
#' @param ncol The number of columns in case multiple genes are plotted
#' @param genes The vector of genes to use
#' @param scales The scales to be used in the facette
#' @return The plot of the trend over time for a specific treatment.
#' @importFrom ggplot2 geom_smooth
#' @export
#' @examples
#' object <- get0("object", envir = asNamespace("ScreenR"))
#'
#' plot_trend(object, genes = "Gene_42", group_var = c("T1", "T2", "TRT"))
#'
#' plot_trend(object,
#'     genes = c("Gene_42", "Gene_100"),
#'     group_var = c("T1", "T2", "TRT"),
#'     nrow = 2
#' )
plot_trend <- function(screenR_Object, genes, group_var,
    alpha = 0.5, se = FALSE, point_size = 1, line_size = 1,
    nrow = 1, ncol = 1, scales = "free") {
    data <- compute_trend(screenR_Object, genes, group_var)

    plot <- ggplot2::ggplot(data, aes(.data$Sample, .data$Frequency)) +
        ggplot2::geom_point(size = point_size) +
        ggplot2::geom_smooth(aes(group = .data$Gene),
            method = "lm", formula = y ~ x, alpha = alpha,
            se = se, size = line_size
        )

    if (length(genes) > 1) {
        plot <- plot +
            ggplot2::facet_wrap("Gene",
                nrow = nrow, ncol = ncol,scales = scales)
    }

    return(plot)
}

#' @title Compute trend
#' @description This is an internal function  used to computes the trend of
#'              a gene
#' @param screenR_Object object created with \code{\link[edgeR]{estimateDisp}}
#' @param genes a list of genes
#' @param group_var the variable that as to be used as grouping variable
#' @return A table with the trend of the genes passed as input
#' @keywords internal
compute_trend <- function(screenR_Object, genes, group_var) {
    data <- screenR_Object@data_table

    # Select only the hit gene
    data <- dplyr::filter(data, .data$Gene %in% genes)

    # Select only the sample of interest
    data <- dplyr::filter(data, .data$Treatment %in% group_var)

    data <- dplyr::group_by(data, .data$Sample, .data$Gene)

    # Consider only the gene (which are the mean of the different shRNAs)
    data <- dplyr::summarise(data,
        Gene = unique(.data$Gene),
        Sample = unique(.data$Sample),
        Frequency = mean(.data$Frequency),
        .groups = "drop"
    )

    return(data)
}
