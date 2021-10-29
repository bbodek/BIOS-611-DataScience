BIOS 611-Project
================

Project Overview
----------------

### Background

The National UFO Reporting Center (NUFORC) is a US organization which tracks and investigates UFO sightings. NUFORC maintains an online database of UFO reports, with almost 100,000 reports documented from 1949 to the present day.
A CSV and JSON file scraped from the NUFORC public database can be found at https://data.world/timothyrenner/ufo-sightings. When running this project, the csv will automatically be downloaded as part of the data processing pipeline. Each line of data in the csv details a reported UFO citing, with fields includin greport summary, city where the sighting occurred, state of sighting, datetime of sighting, shape of the unidentified object, duration of the sighting, a link to the original report, the full text of the original report, the date the sighting was posted, and the latitude and longitude of the city where the sighting occurred.

Using This Project
-----------------
You will need to download [docker](https://docs.docker.com/get-docker/) to run this repository. 

First, fork this repo and clone to your local environment (see [here](https://docs.github.com/en/get-started/quickstart/fork-a-repo) for detailed instructions).

Next, build and run your docker environment (note that you must replace "\<yourpassword\>" with a password you would like to use):

        docker build . -t project-env
        docker run -v $(pwd):/home/rstudio -p 8787:8787 -e PASSWORD=<yourpassword> -t project-env

Then connect to the machine on port 8787 by navigating to  http://localhost:8787/ in your browser of choice.

Shiny App
---------
This project employs a Shiny app to track trends in the location and description of UFO sightings in the United States. The app contains an interactive map displaying UFO reportings in a specific year. Users can adjust the year displayed on the map to observe trends over time, and adjust the UFO shapes displayed to examine trends in UFO sigthing descriptions.

To start the R shiny app (map_ufo_sightings/app.R), first launch docker with the code below (note that if you have not already, you must first build the docker container as described in the "Suing This Project" section of this ReadMe):

	docker run -v $(pwd):/home/rstudio -e PASSWORD=<yourpassword> -p 8787:8787 -p 8788:8788 -t project-env

Then use the Rstudio terminal to launch the shiny app:

	PORT=8788 make shiny_app

Navigate to http://localhost:8788/ in your browser to display the shiny app.

Makefile
--------
The Makefile included in this repository will help build major components
 of the project. 
 
 For example, to build a figure displaying a bar chart of the top observed UFO shapes, run the following code in the terminal or Rstudio :
 	
	make figures/top_ufo_shapes.png
