PHONY: clean

clean:
			rm -r source_data/*
	
source_data/nuforc_ufo_data.csv: make_ufo_dataset.R utils.R
			Rscript make_ufo_dataset.R