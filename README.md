BIOS 611-Project
================

Project Overview
----------------

### Background

The National UFO Reporting Center (NUFORC) is a US organization which tracks and investigates UFO sightings. NUFORC maintains an online database of UFO reports, with almost 100,000 reports documented from 1949 to the present day.
A CSV and JSON file scraped from the NUFORC public database can be found at https://data.world/timothyrenner/ufo-sightings, and is also available in this repository ("source_data/nofurc_reports.csv"). Each line of data in the csv details a reported UFO citing, with fields includin greport summary, city where the sighting occurred, state of sighting, datetime of sighting, shape of the unidentified object, duration of the sighting, a link to the original report, the full text of the original report, the date the sighting was posted, and the latitude and longitude of the city where the sighting occurred.

Using This Project
-----------------
You will need to download [docker](https://docs.docker.com/get-docker/) to run this repository. 

First, fork this repo and clone to your local environment (see [here](https://docs.github.com/en/get-started/quickstart/fork-a-repo) for detailed instructions).

Next, build and run your docker environment:

        `docker build . -t project-env`
        `docker run -v $(pwd):/home/rstudio -p 8787:8787\
            -e PASSWORD=<yourpassword> -t project1-env`

Then connect to the machine on port 8787 by navigating to  http://localhost:8787/ in your browser of choice.

