#' @title Plot Barcode Hit
#' @description This function plot the boxplot in each sample for the genes
#'              passed as input
#' @param screenR_Object The Object of the package
#' @param group_var The variable that as to be used to filter the data, for
#'                  example the different treatment
#' @param fill_var The variable used to fill the boxplot
#' @param alpha The opacity of the regression line
#' @param genes The vector of genes to use
#' @param nrow The number of rows in case multiple genes are plotted
#' @param ncol The number of columns in case multiple genes are plotted
#' @param type  The type of plot to use boxplot or violinplot
#' @concept  plot
#' @importFrom dplyr sym
#' @return A boxplot
#' @export
#' @examples
#' obj <- get0("obj", envir = asNamespace("ScreenR"))
#'
#' plot_boxplot(obj, genes = c("SEPT5", "GLS"),
#'              group_var = c("T0", "T48", "Met"), nrow = 1, ncol = 2,
#'              fill_var = "Day", type = "violinplot")

plot_boxplot <- function(screenR_Object, genes, group_var, alpha = 0.5,
    nrow = 1, ncol = 1, fill_var = "Sample", type = "boxplot") {
    data <- screenR_Object@data_table

    # Select only the hit gene
    data <- dplyr::filter(data, .data$Gene %in% genes)

    # Select only the sample of interest
    data <- dplyr::filter(data, .data$Treatment %in% group_var)

    plot <- ggplot2::ggplot(data, aes(.data$Sample, .data$Frequency,
        fill = !!sym(fill_var)))
    if (type == "boxplot") {
        plot <- plot + geom_boxplot()
    } else if (type == "violinplot") {
        plot <- plot + geom_violin()
    } else {
        stop("The only available type of plot are boxplot and violinplot")
    }

    if (length(genes) > 1) {
        plot <- plot + facet_wrap("Gene", nrow = nrow, ncol = ncol)
    }

    return(plot)
}