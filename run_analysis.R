####################################################################
## Script creating tidy dataset with the average of each variable 
## for each activity and each subjecfrom data collected from the 
## accelerometers from the Samsung Galaxy S smartphone
####################################################################

################################################################
## IMPORTANT : Run this script in the directory where the 
##             input data are located
################################################################

#####################################################
## 1. LOAD DATA USED BY BOTH TRAIN AND TEST FILES
#####################################################

## Load the file that contains informations about the dataset activities
## The file doesn't contain a header
## Column names are assigned to facilitate futur manipulations
activityLabels<-read.table("UCI\ HAR\ Dataset//activity_labels.txt", header=F, col.names=c("ActivityIdentifier", "Activity"))

## Load the file that contains informations about the dataset features
## The file doesn't contain a header
## Column name is assigned to facilitate futur manipulations
features<-read.table("UCI\ HAR\ Dataset//features.txt", header=F, row.names=1)
names(features)<-c("Feature")

## Format feature names to make then more readable
features$Feature<-gsub("()", "", features$Feature, fixed = TRUE)
features$Feature<-gsub("^t", "Time.", features$Feature)
features$Feature<-gsub("^f", "Fast_Fourier_Transform.", features$Feature)
features$Feature<-gsub("Acc", "_Acceleration", features$Feature)
features$Feature<-gsub("Gyro", "_Gyroscope", features$Feature)
features$Feature<-gsub("Jerk", "_JerK_Signal", features$Feature)
features$Feature<-gsub("Mag", "_Magnitude", features$Feature)
features$Feature<-gsub("mean", "Mean", features$Feature)
features$Feature<-gsub("std", "Standard_Deviation", features$Feature)
features$Feature<-gsub("-", ".", features$Feature, fixed = TRUE)
head(features$Feature)

#####################################################
## 2. LOAD TRAIN AND TEST DATASETS
#####################################################

## Create dataset that is going to hold train and test data
all_data<-data.frame()

## Load both train and test data and merge data into one dataset
for (file_name in c("test", "train")){
  ## Load the file that contains the volunteer identifier
  ## The file has one volunteer identifier per line
  ## Each volunteer identifier line is associated to a line of the recorded data file
  ## Assign the name "Volunteer" to the volunteer column in the loaded dataset
  subjects_file<-paste("UCI HAR Dataset//", file_name, "//subject_", file_name, ".txt", sep="")
  subjects<-read.table(subjects_file, header=F, col.names=c("Volunteer"))
  
  ## Load the file that contains the activity identifier
  ## The file has one activity identifier per line
  ## Each activity identifier line is associated to a line of the recorded data file
  ## Assign the name "ActivityIdentifier" to the volunteer column in the loaded dataset
  training_file<-paste("UCI HAR Dataset//", file_name, "//y_", file_name, ".txt", sep="")
  training<-read.table(training_file, header=F, col.names=c("ActivityIdentifier"))
  
  ## Load the file that contains the recorded data
  ## One line inside the file is specific to 1 volunteer and 1 activity
  ## Each column of the recorded data is assigned its title from the feature dataset loaded sooner
  data_file<-paste("UCI HAR Dataset//", file_name, "//X_", file_name, ".txt", sep="")
  recorded_data<-read.table(data_file, header=F, col.names=as.array(features$Feature))
  
  ## Merge recorded data with the volunteer and the activity information
  ## Each observation in the dataset (each line) will be associated to 1 volunteer and 1 activity
  recorded_data_with_info<-cbind(subjects, training, recorded_data)
  
  ## Merge partial dataset currently processed with the main dataset
  all_data<-rbind(all_data, recorded_data_with_info)
  
  ## Remove variables to free memory
  rm(recorded_data_with_info)
  rm(recorded_data)
  rm(training)
  rm(subjects)
}


#####################################################
## 3. EXTRACT THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
#####################################################

## Only keep columns with "Mean" or "Standard_Deviation" in their name
## "Activity" and "Volunteer" columns are also conserved in the final dataset
all_data<-all_data[, grep("\\.Mean\\.|\\.Standard_Deviation\\.|Activity|Volunteer", names(all_data))]


#####################################################
## 4. USE DESCRIPTIVE ACTIVITY NAMES IN THE DATASET
#####################################################

## Add activity names in the data set by merging the main dataset with the activity dataset loaded sooner (step 1)
all_data_with_activity<-merge(activityLabels, all_data,  by="ActivityIdentifier")

## Remove activity identifier from the data set
all_data_with_activity<-all_data_with_activity[,!(names(all_data_with_activity) %in% c("ActivityIdentifier"))]


#####################################################
## 5. CREATE DATASET WITH AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
#####################################################

## Get the current number of columns in the dataset
nbr_columns<-length(names(all_data_with_activity))

## Aggregate dataset by activity and volunteer and calculate mean for each group, except fore
## the 2 first columns which are the volunteer and activity columns
aggdata<-aggregate(all_data_with_activity[,3:nbr_columns], 
                   by=list(all_data_with_activity$Volunteer, all_data_with_activity$Activity), 
                   FUN=mean, na.rm=TRUE)

## Set descriptive names to the first two columns
names(aggdata)[1:2]<-c("Subject", "Activity")

## Get the current number of columns in the dataset
nbr_columns<-length(names(aggdata))

## Add MEAN to columns names
names(aggdata)[3:nbr_columns]<-gsub("^", "AVERAGE.", names(aggdata)[3:nbr_columns])

## Save the tidy dataset in a file
write.table(aggdata, file = "tidydataset.txt", append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)

