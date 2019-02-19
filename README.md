# Getting_Cleaning_Data_Project
Final Project for the Coursera Course "Getting and Cleaning Data"

## Background of the Data

The data collected for this project was from the UCI HAR Dataset available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
The data was downloaded via https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
This .zip file contains measurements from accelerometers and gyroscopes attached inside of smartphones attached to 30 subjects participating in a study.
The goal of this study was to classify the type of activity being performed based on the data the smartphone provides, broken down into walking, sitting,
walking up or downstairs, laying down, and standing.

## Composition of the compressed data
The '.zip' file mentioned above contains a README describing the data collection, as well as a 'features_info.txt' with more information about the features constructed from the basic measurements.
The features are labelled according to the 'features.txt' file, and 'X_test.txt' and 'X_train.txt' contain the values of each of these features.

The 'y_test.txt' and 'y_train.txt' files contain classification of each set of measurements into the 6 activity categories, and the labels for these activities are provided in 'activity_labels.txt'.

Finally, the 'subject_train.txt' and 'subject_test.txt' files contain the label of the subjects being measured for each of these sets of measurements.

## Analysis Explanation

To tidy the data, the 'run_analysis.R' file reads the X data with column labels provided via the 'features.txt' file.
The y data is then read in and re-labelled according the 'activity_labels.txt' file, and attached to the dataframe.
Finally, we attach the list of subjects to each row according to the subject files.

We select only the variables which calculate a mean or a standard deviation, and retain the activity and subject labels.

Finally, we normalize the names of these variables by removing all '.'s, replacing the 't' and 'f' at the beginning of each variable, reduce redundancy in some variables with 'bodybody', and replace 'std' with 'stddeviation' to be more clear.
We also enforce that all variable names be lower-case for uniformity.

## Creating the tidy data table

We make a tidy data table from this data by grouping the data according to subject, activity, and measurement.
For each measurement/activity/subject combination, there are around 250-300 rows of the data frame holding measurements, and we simply average each of these values.
The results are stored in 'tidy_table.txt'.

## Code Book
The code book can be found in the CodeBook.md file in this repository.
