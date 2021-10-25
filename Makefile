PHONY: clean
PHONY: shiny_app

clean:
			rm -r source_data/*
			rm -r derived_data/*

shiny_app: derived_data/nuforc_clean_data.csv ufo_sighting_map/app.R ufo_sighting_app/www/style.css
			Rscript app.R ${PORT}			

source_data/nuforc_ufo_data.csv: scripts/make_ufo_dataset.R scripts/utils.R
			Rscript scripts/make_ufo_dataset.R
			
derived_data/nuforc_ufo_clean_data.csv: source_data/nuforc_ufo_data.csv scripts/process_ufo_dataset.R scripts/utils.R
			Rscript scripts/process_ufo_dataset.R
