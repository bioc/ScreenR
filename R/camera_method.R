#' @title Find Camera Hit
#' @description This function implements the method by proposed by Wu and
#'              Smyth (2012).
#'              The original \code{\link[limma]{camera}} method is a gene set
#'              test, here is applied in the contest of a genetic screening
#'              and so it erforms a competitive barcode set test.
#'              The paper can be found here
#'      \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3458527/}{CAMERA}
#' @param screenR_Object The ScreenR object obtained using the
#'                       \code{\link{create_screenr_object}}
#' @param matrix_model The matrix that will be used to perform the
#'                     linear model analysis created using
#'                     \code{\link[stats]{model.matrix}}
#' @param contrast A vector or a single value indicating the index or the name
#'                 of the column the model_matrix with which perform the
#'                 analysis
#' @param thresh The threshold for the False Discovery Rate (FDR) that has to be
#'               used to select the statistically significant hits.
#' @param lfc The Log2FC threshold.
#' @param number_barcode Number of barcode that as to be differentially
#'                       expressed (DE)in order to consider the gene associated
#'                       DE. Example a gene is associated
#'                       with 10 shRNA we consider a gene DE if it has at least
#'                       number_barcode = 5 shRNA DE.
#' @param direction String containing the direction of the variation,
#'                  "Down" for the down regulation "Up" for the up regulation.
#' @importFrom edgeR estimateDisp
#' @importFrom edgeR glmFit
#' @importFrom edgeR glmLRT
#' @importFrom tibble rownames_to_column
#' @importFrom limma camera
#' @importFrom purrr map_lgl
#' @return The data frame containing the hit found using the camera method
#' @export
#' @concept find
#' @examples
#' object <- get0("object", envir = asNamespace("ScreenR"))
#'
#' matrix <- model.matrix(~ slot(object, "groups"))
#' colnames(matrix) <- c("Control", "T1/T2", "Treated")
#'
#' result <- find_camera_hit(
#'     screenR_Object = object,
#'     matrix_model = matrix, contrast = "Treated"
#' )
#' head(result)
find_camera_hit <- function(screenR_Object, matrix_model,
    contrast, number_barcode = 3, thresh = 1e-04, lfc = 1,
    direction = "Down") {
    # We have to convert the screenR obj into an edgeR obj
    DGEList <- ScreenR::create_edger_obj(screenR_Object)
    xglm <- edgeR::estimateDisp(DGEList, matrix_model)
    fit <- edgeR::glmFit(xglm, matrix_model)
    lrt <- edgeR::glmLRT(fit, coef = seq(1, length(colnames(matrix_model))))

    camera_hit <- compute_camera(
        xglm = xglm, lrt = lrt, DGEList = DGEList,
        matrix_model = matrix_model, contrast = contrast,
        number_barcode = number_barcode, thresh = thresh,
        lfc = lfc
    )
    camera_hit <- camera_hit %>%
        tibble::rownames_to_column("Gene") %>%
        dplyr::tibble() %>%
        dplyr::mutate(Direction = factor(.data$Direction)) %>%
        dplyr::filter(.data$Direction == direction)


    return(camera_hit)
}

#' @title Compute Camera
#' @description This internal function computes the actual hits using  the
#'              camera method.
#' @param xglm object created with \code{\link[edgeR]{estimateDisp}}
#' @param lrt object created with \code{\link[edgeR]{glmFit}}
#' @param DGEList edgeR object
#' @inheritDotParams find_camera_hit lfc number_barcode thresh
#'                   contrast matrix_model
#' @importFrom edgeR topTags
#' @return The list of hits found by the camera method
#' @keywords internal
compute_camera <- function(xglm, lrt, DGEList, matrix_model, contrast,
    number_barcode = 3, thresh = 1e-04, lfc = 1) {
    # Take all the Tags in descending order
    top <- edgeR::topTags(lrt, n = Inf)
    topids <- top$table[top$table$FDR < thresh & top$table$logFC <= lfc, 1]

    # Select only the first column
    genesymbols <- DGEList$genes[, 1]
    genesymbollist <- unique_gene_symbols(genesymbols, number_barcode)

    # Perform the camera test
    camera.res <- limma::camera(xglm,
        index = genesymbollist, matrix_model,
        contrast = contrast
    )
    return(camera.res)
}

#' @title Unique gene Symbols
#' @description Compute a unique gene symbol for gene
#' @param gene_symbols The gene symbols list
#' @inheritDotParams  find_camera_hit number_barcode
#' @return A list of unique gene symbols
#' @keywords internal
unique_gene_symbols <- function(gene_symbols, number_barcode = 3) {
    un_genesymbols <- unique(gene_symbols)
    un_genesymbols <- un_genesymbols[!is.na(un_genesymbols)]

    gene_symbol_list <- lapply(
        X = un_genesymbols, FUN = select_number_barcode,
        gene_symbols, number_barcode
    )
    names(gene_symbol_list) <- un_genesymbols
    # sapply(gene_symbol_list, is.null)
    gene_symbol_list[purrr::map_lgl(gene_symbol_list, is.null)] <- NULL
    return(gene_symbol_list)
}

#' @title Select  number of Barcode
#' @description Compute a unique gene symbol for gene
#' @param gene The gene name
#' @inheritDotParams unique_gene_symbols gene_symbols number_barcode
#' @return The barcode of the gene passed as input
#' @keywords internal
select_number_barcode <- function(gene, gene_symbols, number_barcode) {
    sel <- gene_symbols == gene & !is.na(gene_symbols)
    if (sum(sel) > number_barcode) {
        which(sel)
    }

    return(sel)
}
