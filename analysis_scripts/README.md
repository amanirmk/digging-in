## Analysis Scripts

Please use one of the available pipelines to recreate figures or statistical analyses. Note that all of the statistical results that appear in publications should already be provided in the <tt>reported_results</tt> folder for reference.

There are four types of pipelines that you can call:

### 1. Data filtering pipelines

These pipelines convert the <tt>unfiltered.csv</tt> human data files into the <tt>filtered.csv</tt> ones. Both files are already available; these pipelines are provided for clarity and do not need to be run.
```
Pipelines: filter_npz_maze, filter_npz_spr
Required cores: 1+
Example call: Rscript pipelines/filter_npz_maze.R
```

### 2. Figure pipelines

Generate all figures for a given experiment. These run very fast on a personal computer. Note that figures may not be same as those used in published materials.
```
Pipelines: npz_maze_figs, npz_spr_figs
Required cores: 1+
Example call: Rscript pipelines/npz_maze_figs.R
```

### 3. Statistics pipelines

Generate all statistical analyses for a given experiment. These are very slow and, by default, require at least 5 cores in order to run the brms models. If necessary, this can be changed by editing the default <tt>cores</tt> argument in <tt>functions/run_brms.R</tt>. We recommend using the parallel statistics pipeline and commenting out any undesired analyses.
```
Pipelines: npz_maze_stats, npz_spr_stats  
Required cores: 5+
Example call: Rscript pipelines/npz_maze_stats.R
```

### 4. Parallel statistics pipeline

Generate all statistical analyses for all experiments, using multiprocessing. By default, this runs 2 analysis scripts in parallel with 5 cores each. If running on a less powerful device, reduce the required number of cores per script by editing the default <tt>cores</tt> argument in <tt>functions/run_brms.R</tt>. If running on a more powerful device, increase the number of scripts run in parallel by editing the number of workers in <tt>pipelines/parallel_stats.R</tt>. With the current settings, this may take 9-18 hours on a personal computer.
```
Pipelines: parallel_stats  
Required cores: 10+
Example call: Rscript pipelines/parallel_stats.R
```

*Please note that the code in these pipelines is not fully polished and you may see various warnings while executing it (e.g., deprecation, NANs produced, etc). These warnings should not be cause for concern and can be ignored. If you determine that there is a meaningful result-changing mistake on our part, please let us know.*