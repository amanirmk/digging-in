scatter_plot <- function(
  coded_data, 
  x_var, 
  y_var,
  crop_y_max,
  crop_y_min,
  crop_x_min,
  crop_x_max,
  color,
  color_manual,
  shape,
  shape_manual,
  loess_linetype,
  loess_linetype_manual,
  x_lab,
  y_lab,
  title,
  figure_path,
  width,
  height,
  legend_position = "bottom",
  facet_var = NULL,
  facet_ncol = NULL,
  scales = "fixed"
) {
  c_levels <- levels(factor(coded_data[[color]]))
  s_levels <- levels(factor(coded_data[[shape]]))
  s_levels <- rev(s_levels) # assuming ambiguity is shape, so that ambiguous is on top
  num_levels <- length(c_levels) * length(s_levels)

  density_height <- (crop_y_max - crop_y_min) / 4
  height_per_level <- density_height / num_levels

  true_y_max <- crop_y_max
  true_y_min <- crop_y_min - density_height
  true_x_min <- crop_x_min - (crop_x_max - crop_x_min) * 0.1
  true_x_max <- crop_x_max + (crop_x_max - crop_x_min) * 0.1

  if (!is.null(facet_var)) {
    facet_levels <- levels(factor(coded_data[[facet_var]]))
  } else {
    facet_levels <- c("none")
    facet_var <- "placeholder"
  }

  lev <- 0
  all_dens <- data.frame()
  for (c in c_levels) {
    for (s in s_levels) {
      for (f in facet_levels) {
        if (f != "none") {
          subset_data <- coded_data[coded_data[[color]] == c & coded_data[[shape]] == s & coded_data[[facet_var]] == f, ]
        } else {
          subset_data <- coded_data[coded_data[[color]] == c & coded_data[[shape]] == s, ]
        }
        dens <- density(subset_data[[x_var]], from = true_x_min, to = true_x_max, na.rm = TRUE)
        norm_dens <- data.frame(
          x = dens$x, 
          y = (dens$y / max(dens$y))*height_per_level*0.8 + true_y_min + (height_per_level * lev), 
          y_base = true_y_min + (height_per_level * lev)
        )
        norm_dens[[color]] <- c
        norm_dens[[shape]] <- s
        norm_dens[[facet_var]] <- f
        all_dens <- rbind(all_dens, norm_dens)
      }
      lev <- lev + 1
    }
  }

  # for each shape level, set to a pattern option
  pattern_manual <- setNames(rep(c("none", "stripe", "crosshatch", "circle", "wave"), length.out=length(s_levels)), s_levels)

  x_breaks <- scales::extended_breaks(n=3)(c(true_x_min, true_x_max))
  y_breaks <- scales::extended_breaks(n=6)(c(true_y_min, true_y_max))
  y_breaks <- y_breaks[y_breaks > crop_y_min & y_breaks < crop_y_max]

  # Background rectangle for density region
  density_bg <- data.frame(
    xmin = true_x_min,
    xmax = true_x_max,
    ymin = true_y_min,
    ymax = crop_y_min
  )

  plot <- ggplot(coded_data, aes_string(x = x_var)) +
    geom_abline(slope = 1, intercept = 0, linetype = "11", color = "gray50", linewidth = 0.5) +
    geom_point(aes_string(y = y_var, color = color, shape = shape), size = 1, alpha = 0.12) +
    geom_smooth(
      aes_string(y = y_var, color = color, linetype = loess_linetype), 
      method = "lm", 
      se = TRUE, 
      linewidth = 1, 
      alpha = 0.24
    ) +
    geom_rect(
      data = density_bg,
      aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "white",
      inherit.aes = FALSE
    ) +
    geom_ribbon_pattern(
      data = all_dens,
      aes_string(x = "x", ymin = "y_base", ymax = "y", fill = color, pattern = shape), 
      pattern_colour = "white",
      pattern_density = 0.01,
      pattern_spacing = 0.05,
      inherit.aes = FALSE
    ) +
    geom_hline(yintercept = crop_y_min, color = "lightgray", linewidth = 0.5) +
    geom_hline(yintercept = unique(all_dens$y_base), color = "gray97", linewidth = 0.5) +
    labs(title = title, x = x_lab, y = y_lab) +
    theme(
      legend.position = legend_position,
      panel.background = element_rect(fill = "white"),
      panel.grid.major = element_line(color = "gray97"),
      panel.grid.minor = element_line(color = "gray97"),
      panel.border = element_rect(color = "lightgray", fill = NA, linewidth = 0.5)
    ) +
    scale_x_continuous(breaks = x_breaks, expand = c(0, 0)) +
    scale_y_continuous(breaks = y_breaks, expand = c(0, 0)) +
    scale_color_manual(values = color_manual) +
    scale_shape_manual(values = shape_manual) +
    scale_linetype_manual(values = loess_linetype_manual) +
    scale_fill_manual(values = color_manual) +
    scale_pattern_manual(values = pattern_manual) +
    coord_fixed(ylim = c(true_y_min, true_y_max), xlim = c(true_x_min, true_x_max)) +
    guides(
      fill = "none"
    )

  if (facet_var != "placeholder") {
    if (is.null(facet_ncol)) {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), scales = scales)
    } else {
      plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), ncol = facet_ncol, scales = scales)
    }
  }

  ggsave(figure_path, plot = plot, width = width, height = height, create.dir = TRUE)
}