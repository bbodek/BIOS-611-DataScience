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

report.pdf: figures/cluster_map.png figures/state_dendogram.png figures/state_clusters.png \
	figures/top_ufo_shapes.png figures/sightings_by_time.png figures/pop_density_by_cluster.png \
	figures/word_cloud.png figures/ufo_sighting_by_population_density.png figures/plot_ufo_sighting_by_population.png \
	figures/duration_shape_boxplot.png report.tex
			pdflatex report.tex

figures/state_dendogram.png: derived_data/ufo_description_tfidf.csv scripts/utils.R scripts/hierarchical_clustering.R
			Rscript scripts/hierarchical_clustering.R
			
figures/state_clusters.png: derived_data/ufo_description_tfidf.csv scripts/utils.R scripts/hierarchical_clustering.R
			Rscript scripts/hierarchical_clustering.R

figures/top_ufo_shapes.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/top_ufo_shapes.R
			Rscript scripts/top_ufo_shapes.R
			
figures/duration_shape_boxplot.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/duration_shape_boxplot.R
			Rscript scripts/duration_shape_boxplot.R
			
figures/plot_ufo_sighting_by_population.png: derived_data/sighting_by_pop_density.csv scripts/plot_ufo_sighting_by_pop_density.R scripts/utils.R
			Rscript scripts/plot_ufo_sighting_by_pop.R

figures/ufo_sighting_by_population_density.png: derived_data/sighting_by_pop_density.csv scripts/plot_ufo_sighting_by_pop_density.R scripts/utils.R
			Rscript scripts/plot_ufo_sighting_by_pop_density.R
			
figures/word_cloud.png: derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/word_cloud.R 
			Rscript scripts.word_cloud.R
			
figures/pop_density_by_cluster.png: derived_data/clusters.csv derived_data/sighting_by_pop_density scripts/utils.R scripts/pop_density_by_cluster.R
			Rscript scripts/pop_density_by_cluster.R
			
figures/sightings_by_time.png: derived_data/sighting_by_pop_density.csv scripts/trends_by_time.R
			Rscript scripts/trends_by_time.R
			
figures/cluster_map.png: derived_data/clusters.csv scripts/cluster_map.R
			Rscript scripts/cluster_map.R
			
derived_data/nuforc_ufo_clean_data.csv: source_data/nuforc_ufo_data.csv scripts/process_ufo_dataset.R scripts/utils.R
			Rscript scripts/process_ufo_dataset.R
			
derived_data/ufo_description_tfidf.csv: derived_data/nuforc_ufo_clean_data.csv scripts/tfidf_by_state.R scripts/utils.R
			Rscript scripts/tfidf_by_state.R

derived_data/sighting_by_pop_density.csv: source_data/census_est_pop.csv derived_data/nuforc_ufo_clean_data.csv scripts/utils.R scripts/ufo_sighting_by_pop_density.R
			Rscript scripts/ufo_sighting_by_pop_density.R

derived_data/clusters.csv: derived_data/ufo_description_tfidf.csv scripts/utils.R scripts/hierarchical_clustering.R
			Rscript scripts/hierarchical_clustering.R

source_data/nuforc_ufo_data.csv: scripts/make_ufo_dataset.R scripts/utils.R
			Rscript scripts/make_ufo_dataset.R
			
			