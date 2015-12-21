#Overview

For this project, we implemented an income prediction algorithm and carried out a variable selection analysis using a regression based model on US Census data. The goal was to derive a personalized estimate for one's income.

#Structure

The core of the analysis is contained in these three files:

* database.sql
* database.R
* map.R (using shapefiles to create maps)
* analysis.R

The database.sql file creates a database schema and the tables needed. The database.R file contains the code to fill the tables in the database. The analysis.R file contains the code for preprocessing and statstical inference. The code in map.R creates US maps using shapefiles.

#Implementation

We remove the variables and observations that were not relevant for the analysis of interest and ran a variable selection approach using Gibbs Sampling. The goal was to narrow down the variables that have high predictive power and provide significant marginal contribution for income prediction.  

#Required packages

* RMySQL
* data.table
* mombf
* robustbase
