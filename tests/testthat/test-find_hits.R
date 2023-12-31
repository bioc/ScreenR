data("count_table", package = "ScreenR")
data("annotation_table", package = "ScreenR")
data <- count_table
annotaion <- annotation_table

groups <- factor(c(
    "T1/T2", "T1/T2", "Treated", "Treated", "Treated",
    "Control", "Control", "Control", "Treated", "Treated", "Treated",
    "Control", "Control", "Control"
))


palette <- c(
    "#1B9E75", "#1B9E75", "#D95F02", "#D95F02", "#D95F02",
    "#7570B3", "#7570B3", "#7570B3", "#E7298A", "#E7298A", "#E7298A",
    "#66A61E", "#66A61E", "#66A61E"
)

create_test_object <- function() {
    data <- data %>%
        dplyr::filter(Barcode != "*")

    colnames(data) <- c(
        "Barcode", "T1", "T2", "Time3_TRT_A", "Time3_TRT_B", "Time3_TRT_C",
        "Time3_A", "Time3_B", "Time3_C", "Time4_TRT_A", "Time4_TRT_B",
        "Time4_TRT_C", "Time4_A", "Time4_B", "Time4_c"
    )
    obj <- create_screenr_object(
        table = data,
        annotation = annotaion, groups = groups, replicates = c("")
    )
    obj <- normalize_data(obj)
    obj <- compute_data_table(obj)

    obj@data_table <- obj@data_table %>%
        dplyr::filter(Gene %in% paste0("Gene_", seq(1, 10)))

    obj@normalized_count_table <- obj@normalized_count_table %>%
        dplyr::filter(Barcode %in% obj@data_table$Barcode)

    obj@count_table <- obj@count_table %>%
        dplyr::filter(Barcode %in% obj@data_table$Barcode)

    obj@annotation_table <- obj@annotation_table %>%
        dplyr::filter(Barcode %in% obj@data_table$Barcode)

    return(obj)
}
test_that("find_common_hit 2", {
    hit_zscore <- data.frame(Gene = c("A", "B", "C", "D", "E"))
    hit_camera <- data.frame(Gene = c("A", "B", "C", "F", "H", "G"))
    hit_roast <- data.frame(Gene = c("A", "L", "N"))

    common_hit <-
        find_common_hit(hit_zscore, hit_camera, hit_roast, common_in = 2)
    expect_equal(common_hit, c("A", "B", "C"))
})

test_that("find_common_hit 3", {
    hit_zscore <- data.frame(Gene = c("A", "B", "C", "D", "E"))
    hit_camera <- data.frame(Gene = c("A", "B", "C", "F", "H", "G"))
    hit_roast <- data.frame(Gene = c("A", "L", "N"))

    common_hit <- find_common_hit(hit_zscore,
        hit_camera,
        hit_roast,
        common_in = 3
    )
    # expect_equal(class(find_common_hit), "character")
    expect_equal(common_hit, c("A"))
})


test_that("find_roast_hit", {
    set.seed(42)
    object <- get0("object", envir = asNamespace("ScreenR"))
    matrix_model <- model.matrix(~ slot(object, "groups"))
    colnames(matrix_model) <- c("Control", "T1_T2", "Treated")
    expect_warning(find_roast_hit(object,
        matrix_model = matrix_model,
        contrast = "Treated", nrot = 20
    ))
})
