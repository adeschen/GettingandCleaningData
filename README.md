Getting and Cleaning Data Course Project
========================================================

The purpose of this project is to collect, work with, and clean data collected from the accelerometers from the Samsung Galaxy S smartphone (public data). A tidy set containing the average of each variable related to mean or standard deviation for each activity and each subject is created.

Raw Data Set
--------------------------------------------------------

A full description of the raw data is available at the site : 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the raw data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The raw data should be downloaded and decompressed in the directory where 
the script is going to be run.

General process
--------------------------------------------------------

The "run_analysis.R" script is runned in the directory where the raw data have been
downloaded and decompressed. The script calculates the average of each variable related to mean or standard deviation for each activity and each subject. The script outputs a tidy set in a file named "tidydataset.txt".

Script description
--------------------------------------------------------

The script used to create the tidy dataset is called run_analysis.R and its present 
in this directory.

The script has to be run in the directory where the raw data has been dowloaded and decompressed.

The script is doing those steps:


### Step 1. Load files related to both the training and the test sets

* The script loads the activity_labels.txt file and the features.txt in two separated datasets. 
* The column titles "ActivityIdentifier" and "Activity" are assigned to the activity dataset.
* The column title "Feature" is assigned to the feature dataset.


### Step 2. Appropriately labels the data set with descriptive activity names

* The script formats the features names to make the names easily readable.
* Longer names are used to describe the features, as examples, "t" at the beginning of the name is replace by "Time". "std" is replace by "Standard_Deviation". All final features labels are described in the CodeBook.md file.

### Step 3. Load both the training and the test sets and create one data set

* The script first loads files related to both the training and the test datasets.  
* It loads the files subject_train.txt and subject_test.txt that contain the volunteer identifier.  
* It also loads the files y_train.txt and y_test.txt that contain the activity identifier.  
* It finally loads the files X_train.txt and X_test.txt that contain the recorded data.  
* The recorded data files don't have header. The feature dataset is used to add column names
to the recorded dataset.  
* The merging of the volunteer information, activity information and the recorded data creates
a dataset for the training data and another dataset for the test data.   
* Those two datasets arethen binded to create on dataset.  

### Step 4. Extracts only the measurements on the mean and standard deviation for each measurement

* Only the columns with "Mean" or "Standard_Deviation" in their name are kept.
* The "Activity" and "Volunteer" columns are also conserved to kept track of the subject and activity information for each observation.

### Step 4. Uses descriptive activity names to name the activities

* The activity description is added to the dataset by merging the dataset with the activity dataset loaded at step 1.
* The activity identifier column is suppress from the dataset.

### Step 6. Creates a tidy data set with the average of each variable for each activity and each subject

* The script calculates the average of each variable for each activity and each subject. The dataset 
generated is saved in a texte file named "tidydataset.txt". This text file is the final tidy set.


Tidy set
--------------------------------------------------------

See the CodeBook.md file.
