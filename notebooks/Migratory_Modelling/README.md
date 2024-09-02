# Migratory Modeling Notebooks

* This Repository consist examples of migratory modelling notebooks to run the models in the jupiterhub environment on EcoCommon's coding cloud. 
* This example will allow users to load and play with different example workflows. Furthermore, users can add more workflows and examples which can be shared with colleagues and wider community.

---
Author details:  EcoCommons Platform   
Contact details: comms@ecocommons.org.au  
Copyright statement: This script is the product of the EcoCommons platform.   
                     Please refer to the EcoCommons website for more details:   
                     <https://www.ecocommons.org.au/>  
Date: September 2023  

---

## Getting started 

In this Notebook example we have created a lite version of our popular marine migration use case. We will calculate occurance for only yellow tail king fish with two months January and July monthly predictions. 

For simplicity, here we use a subset of the occurrence data used in the marine use case in the EcoCommons website for the [Yellowtail Kingfish](https://www.ecocommons.org.au/marine-use-case/).We focus on occurrence data from 2012 and 2013 and maintain the seasonal trend by focusing only on one month in Summer and another in Winter (January and July, respectively). 

## Overview

- Data preparation for occurances. 

You can download records directly from the Atlas of Living Australia and this includes IMOS records. 
Keep in mind with stochastic learning algorithms like Maxent, results may vary some what from run to run, even if using the same data.

Again, we recommend downloading directly from a large database each time you start a new model, but here we got some additional records from AODN which are not in the ALA data, so use the data in this folder to replicate our results. Note our ALA download includes WA near-coastal records, and does not include SA near-coastal data which were in the cleaned IMOS AODN data.

There are a few steps you need to take to download records from ALA. You need to register with ALA you can register here: https://auth.ala.org.au/userdetails/registration/createAccount.

- Data preparation for bathemetry with it's sensor locations, Bias, IMOS_array.
- Environmental variables included the marine example:
    - Chl Chlorophyll – A (chl)
    - Gridded Sea Level Anomaly (gsla)
    - Sea Surface Temperature (sst)
    - And north – south current velocity (vcur)

- Averaging the colection for the monthly (January & July)
- Modelling- extraction of monthly subsets from the environmnetal variables and running with MaxEnt

## Parent example Marine use case Summary

Discussions with the team at the Integrated Marine Observing System (IMOS) revealed a treasure trove of Marine data in the Australian Ocean Data Network (AODN) Portal that had not yet been explored using the analytical tools available at EcoCommons. Here we demonstrate how these marine data predict migration patterns of two marine species, the Yellowtail Kingfish (Seriola lalandi) and the Bull Shark (Carcharhinus leucas). The R code used to generate these results is provided and could be run on the Ecocommons’ coding cloud.

Some example graphs:-
GIF- https://www.youtube.com/watch?v=_OVo5ejg01s
GIF- https://www.youtube.com/watch?v=boALj9oLSO0

Again more information can be found on our website: https://www.ecocommons.org.au/marine-use-case/ 

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

``
cd existing_repo
git remote add origin https://gitlab.com/ecocommons-australia/ecocommons-platform/migratory-modeling-notebooks.git
git branch -M main
git push -uf origin main
``
## Support

Please contact the EcoCommons team for testing or any support with this notebook.
