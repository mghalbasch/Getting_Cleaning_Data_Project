library(dplyr)
library(reshape2)

# See the README.md for information about the data being loaded in.

# First we load in the names of each of the features

filename_features <- "./UCI HAR Dataset/features.txt"
colnames <- read.table(filename_features)[,2] # Second column is colnames

# Next we get the 'X' data, for which each row is a list of
# features from a set of measurements.

filename_x_train <- "./UCI HAR Dataset/train/X_train.txt"
x_train <- read.table(filename_x_train, col.names=colnames)

filename_x_test <- "./UCI HAR Dataset/test/X_test.txt"
x_test <- read.table(filename_x_test, col.names=colnames)

# Next we will read in the 'y' data, which labels the activities.
# Activity labels are read in first.

filename_activities <- "./UCI HAR Dataset/activity_labels.txt"
labels <- read.table(filename_activities)[,2]

filename_y_train <- "./UCI HAR Dataset/train/y_train.txt"
y_train <- read.table(filename_y_train)

filename_y_test <- "./UCI HAR Dataset/test/y_test.txt"
y_test <- read.table(filename_y_test)

# Now we add the activity data to our rows of features

train_incomplete <- cbind(x_train, y_train)
test_incomplete <- cbind(x_test, y_test)

# Now we merge these together with rbind, to get one big data set.

data_incomplete <- {rbind(train_incomplete,test_incomplete) %>%
    rename(Activity_code = V1)}

# We also take in the label of which subject was measured in each row
filename_subject_train <- "./UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(filename_subject_train)

filename_subject_test <- "./UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(filename_subject_test)

# We can again bind these vectors together into one long subject list

subjects <- rbind(subject_train,subject_test)

# Now we need to bind this column to our incomplete data set

raw_df <- cbind(data_incomplete, subjects)

# Now the final variable is labelled 'V1' and the activities are still
# coded by their number, instead of the name.

activity_df <- {raw_df %>% mutate(Activity = labels[Activity_code]) %>%
    rename(Subject = V1)}

# Next we want to select only those measurements corresponding to
# a mean or a standard deviation.

# We can check whether a mean or std appears in the name of the feature
# with grep, and select only these columns.

mean_labels <- grep("*mean*", colnames)
std_labels <- grep("*std*", colnames)

activity_df %>% select(Activity, Subject, mean_labels, std_labels) ->
  activities_data

# Now we want to rename these variables to be more standard.
# See the README for more details.


names(activities_data) <- gsub("[.]","",names(activities_data))
names(activities_data) <- sub("^t","",names(activities_data))
names(activities_data) <- sub("^f","Freq",names(activities_data))
names(activities_data) <- sub("bodybody","body",names(activities_data))
names(activities_data) <- sub("std","stddeviation",names(activities_data))
names(activities_data) <- tolower(names(activities_data))

# Finally, we will create a tidy dataset that tracks each activity,
# subject, and variable, and reports the average of each variable.
# We will accomplish this by melting down our dataset with id
# variables of Activity and Subject.

tidy_data <- melt(activities_data, id.vars=c("activity","subject"))

# Now we will group by each activity, subject, and variable to create
# the table desired, summarizing each measurement with the average

tidy_data %>% group_by(subject,activity,variable) %>%
  summarise(average = mean(value)) %>% as.data.frame -> tidy_table

# Finally we read this table out to tidy_table.txt:

con <- file("./tidy_table.txt")
write.table(tidy_table,con,row.names=FALSE)
