
line_plot <- function(
  coded_data,
  grouping,
  linetype,
  linetype_manual,
  color,
  color_manual,
  x_var,
  y_var,
  y_min,
  y_max,
  x_lab,
  y_lab,
  title,
  figure_path,
  width,
  height
) {
  stopifnot(x_var %in% names(coded_data))
  stopifnot(y_var %in% names(coded_data))
  stopifnot(linetype %in% names(coded_data) || is.null(linetype))
  stopifnot(color %in% names(coded_data) || is.null(color))
  stopifnot("conf" %in% names(coded_data))

  coded_data$lower <- coded_data[[y_var]] - coded_data$conf
  coded_data$upper <- coded_data[[y_var]] + coded_data$conf

  plot <- ggplot(coded_data, aes_string(x = x_var, y = y_var, group = grouping, linetype = linetype, color = color)) +
    geom_line(linewidth=1) +
    geom_point(size=3) +
    geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.25, linewidth=1) +
    labs(title = title, x = x_lab, y = y_lab) +
    theme(legend.position = "bottom") +
    coord_cartesian(ylim = c(y_min, y_max))

  if (!is.null(linetype_manual)) {
    plot <- plot + scale_linetype_manual(values = linetype_manual) 
  }
  if (!is.null(color_manual)) {
    plot <- plot + scale_color_manual(values = color_manual) 
  }
  ggsave(figure_path, plot = plot, width = width, height = height, create.dir = TRUE)
}