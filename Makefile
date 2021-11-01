PHONY: clean
PHONY: shiny_app

clean:
			rm -f source_data/*
			rm -f derived_data/*
			rm -f figures/*
			rm -f *.pdf
	
shiny_app: derived_data/nuforc_ufo_clean_data.csv ufo_sighting_map/app.R
			cd ufo_sighting_map && Rscript app.R ${PORT}			

report.pdf:
			R -e "rmarkdown::render(\"shark_report.Rmd\", output_format=\"pdf_document\")"

source_data/nuforc_ufo_data.csv: scripts/make_ufo_dataset.R scripts/utils.R
			Rscript scripts/make_ufo_dataset.R
			
derived_data/nuforc_ufo_clean_data.csv: source_data/nuforc_ufo_data.csv scripts/process_ufo_dataset.R scripts/utils.R
			Rscript scripts/process_ufo_dataset.R

figures/top_ufo_shapes.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R 
			Rscript scripts/top_ufo_shapes.R
			
figures/duration_shape_boxplot.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R 
			Rscript scripts/duration_shape_boxplot.R