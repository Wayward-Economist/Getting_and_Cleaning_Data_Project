######################################################################################
# Author:       Wayward-Economist
# Date:         6/21/14
# Github:       https://github.com/Wayward-Economist/Getting_and_Cleaning_Data_Project
# Description:  This script was written to satisfy the course requirements of "Getting
#               and Cleaning Data" offered through Coursera.org.
# Notes:        The github repository hosts this script, a readme file, and a codebook.
#               Please refer to the readme file for a description of the script. The 
#               order of steps deviates slightly from the assignment steps in order to
#               make the code more readable.
# Requirements: This script should be run in a directory that includes the directory
#               'UCI HAR Dataset'. If that directory is not in the working directory
#               it will be downloaded into the working directory.
######################################################################################

# Step 0: Download and unzip the UCI HAR Dataset into the working directory. 
if(! "UCI HAR Dataset" %in% list.files()){
  message("Downloading the data. Please wait!")
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
  unzip(temp)
  unlink(temp) # Make sure to clear the zip file from memory!
  rm(temp) # Remove the temp variable from the R enviroment.
}

setwd("UCI HAR Dataset") # Move into the directory with Samsung UCI HAR Data.

# Step 1a: Read the data into R. One data.frame is created for the subject ids, one for
#          the activity ids, and one for the data observations. 
# Notes:   The training data and the test data have to be read in the same order for 
#          each of the three data.frames.
subject  <- rbind (read.table("train\\subject_train.txt"),
                   read.table("test\\subject_test.txt")) 

activity <- rbind (read.table("train\\y_train.txt"),
                   read.table("test\\y_test.txt"))

data     <- rbind (read.table("train\\X_train.txt"),
                   read.table("test\\X_test.txt"))

# Step 2: Extract only the mean and standard deviation observations. The observation names
#         are read into R from the 'features' datafile. Then an index is created corresponding
#         to the columns that contain either a mean or standard devition by matching regexs.
# Notes:  There are 66 columns that include either 'mean()' or 'std()' in the column names.
#         See the readme file for a discussion of why these are the correct columns to extract.
features <- read.table("features.txt")
index    <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

# Step 1b: Combine the data into a single, tidy dataset. The three datasets all have the same
#          order, so cbind is used to attach the three datasets to each other. Only the columns
#          containing the mean and standard deviation are extracted.
tidy.set <- cbind(subject, activity, data[, index])

# Step 4: Label the variables with meaningful names. The variable names are stored in the 
#         features data.frame; the subject and activity data proceed the observations so
#         the names vector has to be created using append.
# Notes:  The column names have the form "tBodyAcc-mean()-X" this means that the columns
#         cannot reffered to using the $ operator. Instead, they are reffered to using
#         tidy.set[, "tBodyAcc-mean()-X"]. See the readme file for a discussion.
names(tidy.set) <- append(c("subject", "activity"), as.character(features[index, 2]))

# Step 3: Rename the activity factor vector with descriptive names. The activity names are
#         stored in the 'activity_labels' file. That file is read and the activities are
#         replaced with values in column 2 of the activities data.frame using the labels
#         option in the factor command.
activities <- read.table("activity_labels.txt")
tidy.set$activity <- factor(tidy.set$activity, labels = as.character(activities[, 2]))

# Step 5: Make a tidy dataset with the means of the observations broken down by subject and activity
#         and then write the data. The aggregate function does this easily with function = mean
#         and by variables = subject and activity. Then write the data with 'table.write'.
# Notes:  To test this code, use mean(tidy.data[which(tidy.data$subject == 1 & tidy.data$activity == "WALKING"), tBodyAcc-mean()-X])
#         or whichever subject, activity, and data observation is of interest.
tidy.means <- aggregate(tidy.set[, -c(1:2)], by=list(subject = tidy.set$subject, activity = tidy.set$activity), FUN=mean)
write.table(tidy.means, file = "tidy_means.txt")