---
title: "Readme for the repository Getting_and_Cleaning_Data_Project"
author: "Wayward-Economist"
date: "Saturday, June 21, 2014"
output: html_document
---

=================================

### This is the course project for "Getting and Cleaning Data"

The assignment instructons are found here. The asignment requires a script 'run_analysis.R' that does the following five steps: 

1. Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

This readme file explains 'run_analysis.R' script. Some of the steps are preformed in a different order from the assignment steps.

#### Step 0

This step downloads the Samsung UCI HAR Dataset. An if statement checks to see if the directory 'UCI HAR Dataset' is in the current working directory. If the directory does not exist in the working directory then it is downloaded from the link provided by the Coursera webpage. If the data has already been downloaded, please make sure that the 'UCI HAR Dataset' directory is within the working directory. If the working directory is the 'UCI HAR Dataset' then the data will be downloaded an extra time. The last statement in this step moves into the 'UCI HAR Dataset' directory.

#### Step 1.a 

The UCI HAR Dataset includes six different files. There are three pairs of files, one pair for the subject ids called 'subject_train' and 'subject_test', one pair for the activites ids called "y_train" and "y_test", and one pair for the data called 'x_train' and 'y_train'. Each pair is read into a single data.frame using rbind(). The final data.frame has 10299 observations and the data.frame with the observations has 561 different columns. 

Before combining the data into a single data frame, the mean and standard deviation observations are extracted. If a single data.frame were created at this point then two assignment operations would be necessary, one to combine the data and a second assingment operation is necessary to create the smaller data.frame. Instead, an index extracting the mean and standard deviation variables are extracted and a single assigment operation is used. 

#### Step 2. 

The 'features_info.txt' describes the different variables in the data set. According to this file, the mean and standard deviation variables have "mean()" and "std()" in the variable names. Thus the names have the form "tBodyAcc-mean()-X" is read into a data.frame. The first column of the data.frame has an integer value.  The second column of the data.frame has the names of the variables. The second column of the 'features' data.frame is matched to a regular expression in order to select the means and standard deviations. There are 66 columns that have either 'mean()' or 'std()' in the variable name. 

Note that only the columns that contain either 'mean()' or 'std()' are extracted. According to the features_info file there are some columns of the form 'meanFreq()' which represents the "Weighted average of the frequency components to obtain a mean frequency" these columns are not extracted because the assignment instructions ask for only the mean and standard deviation observations.

#### Step 1.b

Now that an index correspnding to the mean and standard deviation columns has been created, a single data.frame with the subject IDs, the activity IDs, and the mean and standard deviation obersvations can be created using a single assigment operation. 

#### Step 4

After the single data.frame is created, it makes sense to name the variables descriptively now rather than later since the next step (creating the meaningful activity labels) will require referencing the 'activity' column. The variable names used by the authors of the 'UCI HAR Dataset' are stored in the 'features.txt' file. These variables are considered descriptive for two reasons. First, variable names of the form "tBodyAcc-mean()-X" are reasonably self-explainitory. This variable is the body acceleration around the X axis. Second, it is preferable to maintain consistent variable names accross the documentation.

This will cause some problems since the code tidy.set$tBodyAcc-mean()-X will produce an error. The characters '(', ')', and '-' are command characters. Therefore, it will be necessary to refer to these columns using the code tidy.set[, "tBodyAcc-mean()-X"]. Alternatively, gsub could be used to replace the '(', ')', and '-' characters in the variable names. 

#### Step 3

The file 'activity_labels.txt' includes textual descriptions of the activities. There are six different activities. These activities are read into a data.frame. The first column has the numerical value of the factor and the second column has the textual description of the factor. The numerical values are replaced in the data.frame uses the label arguement to the factor function.

#### Step 5 

The assigment requires that a single data.frame be produced with the mean of each variables calculated for each subject and activity. This can be done easily using the aggregate function. There are 30 subjects and 6 different activities so there are 180 different rows. Then there is one mean for each variable so there are 68 columns (two columns for the subject and activity and 66 for the data variables). 

The final step is completed by writing the final tidy.means data.frame to a text file. Note that this data file will appear within the 'UCI HAR Dataset' directory.

