bar_plot <- function(
  coded_data,
  grouping,
  fill,
  fill_manual,
  x_var,
  y_var,
  y_min,
  y_max,
  x_lab,
  y_lab,
  title,
  figure_path,
  width,
  height,
  legend_position = "bottom",
  facet_var = NULL,
  ncols = NULL,
  manual_ybreaks = NULL
) {
  stopifnot(x_var %in% names(coded_data))
  stopifnot(y_var %in% names(coded_data))
  stopifnot(fill %in% names(coded_data) || is.null(fill))
  stopifnot("conf" %in% names(coded_data))

  coded_data$lower <- coded_data[[y_var]] - coded_data$conf
  coded_data$upper <- coded_data[[y_var]] + coded_data$conf

  plot <- ggplot(coded_data, aes_string(x = x_var, y = y_var, fill = fill)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.25, linewidth=1) +
    labs(title = title, x = x_lab, y = y_lab) +
    theme(legend.position = legend_position) +
    coord_cartesian(ylim = c(y_min, y_max))

  if (!is.null(manual_ybreaks)) {
    plot <- plot + scale_y_continuous(breaks = manual_ybreaks)
  }

  if (!is.null(fill_manual)) {
    plot <- plot + scale_fill_manual(values = fill_manual) 
  }

  if (!is.null(facet_var)) {
    if (is.null(ncols)) {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)))
    } else {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), ncol = ncols)
    }
  }

  ggsave(figure_path, plot = plot, width = width, height = height, create.dir = TRUE)
}

bar_plot_with_pattern <- function(
  coded_data,
  grouping,
  fill,
  fill_manual,
  pattern_var,
  pattern_manual,
  x_var,
  y_var,
  y_min,
  y_max,
  x_lab,
  y_lab,
  title,
  figure_path,
  width,
  height,
  legend_position = "bottom",
  facet_var = NULL,
  ncols = NULL
) {
  stopifnot(x_var %in% names(coded_data))
  stopifnot(y_var %in% names(coded_data))
  stopifnot(fill %in% names(coded_data) || is.null(fill))
  stopifnot(pattern_var %in% names(coded_data) || is.null(pattern_var))
  stopifnot("conf" %in% names(coded_data))

  coded_data$lower <- coded_data[[y_var]] - coded_data$conf
  coded_data$upper <- coded_data[[y_var]] + coded_data$conf

  plot <- ggplot(coded_data, aes_string(x = x_var, y = y_var, fill = fill, pattern = pattern_var)) +
    geom_bar_pattern(
      stat='identity',
      position = position_dodge(width = 1),
      aes(colour = after_scale(fill)),  # border same as fill color
      pattern_fill = NA,
      pattern_colour = "white",
      pattern_density = 0.1,
      pattern_spacing = 0.04,
    ) +
    geom_errorbar(aes(ymin = lower, ymax = upper), linewidth=1, width = 0.25, position = position_dodge(width = 1)) +
    labs(title = title, x = x_lab, y = y_lab) +
    theme(legend.position = legend_position) +
    guides(
      fill = guide_legend(
        override.aes = list(pattern = "none")  # disables hatching in the fill legend
      )
    ) +
    coord_cartesian(ylim = c(y_min, y_max))

  if (!is.null(fill_manual)) {
    plot <- plot + scale_fill_manual(values = fill_manual) 
  }

  if (!is.null(pattern_manual)) {
    plot <- plot + scale_pattern_manual(values = pattern_manual) 
  }

  if (!is.null(facet_var)) {
    if (is.null(ncols)) {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)))
    } else {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), ncol = ncols)
    }
  }

  ggsave(figure_path, plot = plot, width = width, height = height, create.dir = TRUE)
}