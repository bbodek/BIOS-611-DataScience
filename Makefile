PHONY: clean
PHONY: shiny_app

clean:
			rm -f source_data/nuforc_ufo_data
			rm -f derived_data/*
			rm -f figures/*
			rm -f *.pdf
			rm -f *.out 
			rm -f *.aux
	
shiny_app: derived_data/nuforc_ufo_clean_data.csv ufo_sighting_map/app.R
			cd ufo_sighting_map && Rscript app.R ${PORT}			

report.pdf: report.tex figures/top_ufo_shapes.png figures/top_ufo_shapes.png
			pdflatex report.tex

source_data/nuforc_ufo_data.csv: scripts/make_ufo_dataset.R scripts/utils.R
			Rscript scripts/make_ufo_dataset.R
			
derived_data/nuforc_ufo_clean_data.csv: source_data/nuforc_ufo_data.csv scripts/process_ufo_dataset.R scripts/utils.R
			Rscript scripts/process_ufo_dataset.R

figures/top_ufo_shapes.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/top_ufo_shapes.R
			Rscript scripts/top_ufo_shapes.R
			
figures/duration_shape_boxplot.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/duration_shape_boxplot.R
			Rscript scripts/duration_shape_boxplot.R
			
derived_data/sighting_by_population.csv: source_data/census_est_pop.csv derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/ufo_sighting_by_pop.R
			Rscript scripts/ufo_sighting_by_pop.R
			
figures/plot_ufo_sighting_by_population.png: derived_data/sighting_by_population.csv scripts/plot_ufo_sighting_by_population.R scripts/utils.R
			Rscript scripts/plot_ufo_sighting_by_population.R
			
derived_data/sighting_by_pop_density.csv: source_data/census_est_pop.csv source_data/state_area.csv derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/ufo_sighting_by_pop_density.R
			Rscript scripts/ufo_sighting_by_pop_density.R
			
figures/ufo_sighting_by_population_density.png: derived_data/sighting_by_pop_density.csv scripts/plot_ufo_sighting_by_pop_density.R scripts/utils.R
			Rscript scripts/plot_ufo_sighting_by_pop_density.R