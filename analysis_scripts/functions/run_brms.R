run_brms <- function(data, formula, file_path, iter=5000, chains=5, cores=5, seed=1234, family = brmsfamily("gaussian", link = "identity")) {  
  fit <- brm(
    formula = formula,
    data = data,
    iter = iter,
    chains = chains,
    cores = cores,
    seed = seed,
    family = family
  )

  dir_path <- dirname(file_path)
  dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
  sink_file <- file(file_path, open = "wt")
  sink(sink_file)
  sink(sink_file, type = "message")
  paste("seed:", seed)
  paste("brms version:", as.character(packageVersion("brms")))
  print(summary(fit))
  print(describe_posterior(fit))
  sink(type = "message")
  sink()
}