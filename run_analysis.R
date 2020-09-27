library(dplyr)
# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#Test data
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
#Train data
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
# read data description
variable_names <- read.table("./data/UCI HAR Dataset/features.txt")
# read required labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
# Requirement 1
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)
# Requirement 2
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]
# Requirement 3
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]
# Requirement 4
colnames(X_total) <- variable_names[selected_var[,1],2]
# Requirement 5
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
