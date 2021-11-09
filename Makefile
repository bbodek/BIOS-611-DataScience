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
			
derived_data/sighting_by_population.csv: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/ufo_sighting_by_pop.R
			Rscript scripts/ufo_sighting_by_pop.R

figures/top_ufo_shapes.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/top_ufo_shapes.R
			Rscript scripts/top_ufo_shapes.R
			
figures/duration_shape_boxplot.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/duration_shape_boxplot.R
			Rscript scripts/duration_shape_boxplot.R