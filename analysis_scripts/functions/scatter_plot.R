scatter_plot <- function(coded_data, x_var, y_var, color, color_manual, shape, shape_manual, loess_linetype, loess_linetype_manual, x_lab, y_lab, title, figure_path, width, height, legend_position = "bottom", facet_var = NULL, facet_ncol = NULL) {
  stopifnot(x_var %in% names(coded_data))
  stopifnot(y_var %in% names(coded_data))
  stopifnot(color %in% names(coded_data) || is.null(color))

  plot <- ggplot(coded_data, aes_string(x = x_var, y = y_var, color = color, shape = shape)) +
    geom_abline(slope = 1, intercept = 0, linetype = "11", color = "gray50", linewidth=1) +
    geom_point(size=1, alpha=0.8) +
    labs(title = title, x = x_lab, y = y_lab) +
    theme(legend.position = legend_position) +
    geom_smooth(method = "loess", se = FALSE, span = 1, linewidth=1, aes_string(linetype = loess_linetype)) +
    coord_fixed() +
    # add slight margin to axes
    scale_x_continuous(expand = expansion(mult = 0.1)) +
    scale_y_continuous(expand = expansion(mult = 0.1))

  if (!is.null(facet_var)) {
    if (is.null(facet_ncol)) {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)))
    } else {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), ncol = facet_ncol)
    }
  }

  if (!is.null(color_manual)) {
    plot <- plot + scale_color_manual(values = color_manual) 
  }
  if (!is.null(shape_manual)) {
    plot <- plot + scale_shape_manual(values = shape_manual) 
  }
  if (!is.null(loess_linetype_manual)) {
    plot <- plot + scale_linetype_manual(values = loess_linetype_manual) 
  }
  ggsave(figure_path, plot = plot, width = width, height = height, create.dir = TRUE)
}