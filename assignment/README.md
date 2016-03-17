##Getting and Cleaning Data - Assignment
**This is the assignment for the Getting and Cleaning Data Coursera course.**

The R script, run_analysis.R, does the following:


* Download the dataset to the specified folder 
* Unzip the dataset
* Import the activity, feature data, training and test data 
* Loads the activity and subject data for each dataset, and merges those columns with the dataset
* Merges the the training and the test data
* Dropping columns that are not about mean or standard deviation
* Replace the activity with a string indicating the activity
* Update the column names to their actual name
* Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
* The end result is shown in the file tidydata.txt.
