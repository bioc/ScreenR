#' @title Plot mapped reads
#' @description This function plots the number of reads mapped for each
#'              sample. It internally call the \code{\link{count_mapped_reads}}
#'              function, to compute the number of mapped reads.
#' @param screenR_Object The ScreenR object obtained using the
#'                       \code{\link{create_screenr_object}}
#' @param palette A vector of color that as to be used to fill the barplot.
#' @param alpha A value for the opacity of the plot.
#'              Allowed values are in the range 0 to 1
#' @param legende_position Where to positioning the legend of the plot
#'                         ("none", "left", "right", "bottom", "top")
#' @importFrom magrittr %>%
#' @importFrom  ggplot2 geom_bar
#' @importFrom rlang .data
#' @return return a ggplot object
#' @export
#' @examples
#' object <- get0("object", envir = asNamespace("ScreenR"))
#'
#' plot_mapped_reads(object)
plot_mapped_reads <- function(screenR_Object, palette = NULL, alpha = 1,
    legende_position = "none") {
    table <- ScreenR::mapped_reads(screenR_Object)
    if (is.null(palette)) {
        plot <- ggplot(table, aes(
            x = .data$Sample, y = .data$Mapped,
            fill = .data$Sample
        )) +
            geom_bar(stat = "identity")
    } else {
        plot <- ggplot(table, aes(
            x = .data$Sample, y = .data$Mapped,
            fill = .data$Sample
        )) +
            geom_bar(alpha = alpha, stat = "identity") +
            scale_fill_manual(values = palette)
    }
    plot <- plot + theme(legend.position = legende_position)
    return(plot)
}
