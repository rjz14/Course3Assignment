#Load R libraries
library(dplyr)
library(tidyr)

#Variable initializations
set <- c("train", "test")
features <- read.table("features.txt")

#Load in test and train data
for (i in seq_along(set)) {
        
        #An identifier of the subject who carried out the experiment
        subject <- read.table(paste0("./", set[i], "/subject_", set[i], ".txt"))
        #Activity label
        activity <- read.table(paste0("./", set[i], "/y_", set[i], ".txt"))
        #Triaxial acceleration from the accelerometer (total acceleration)
        x_total <- read.table(paste0("./", set[i], "/Inertial Signals/total_acc_x_", set[i], ".txt"))
        y_total <- read.table(paste0("./", set[i], "/Inertial Signals/total_acc_y_", set[i], ".txt"))
        z_total <- read.table(paste0("./", set[i], "/Inertial Signals/total_acc_z_", set[i], ".txt"))
        #Triaxial acceleration from the accelerometer (body acceleration)
        x_body <- read.table(paste0("./", set[i], "/Inertial Signals/body_acc_x_", set[i], ".txt"))
        y_body <- read.table(paste0("./", set[i], "/Inertial Signals/body_acc_y_", set[i], ".txt"))
        z_body <- read.table(paste0("./", set[i], "/Inertial Signals/body_acc_z_", set[i], ".txt"))
        #Triaxial Angular velocity from the gyroscope
        x_gyro <- read.table(paste0("./", set[i], "/Inertial Signals/body_gyro_x_", set[i], ".txt"))
        y_gyro <- read.table(paste0("./", set[i], "/Inertial Signals/body_gyro_y_", set[i], ".txt"))
        z_gyro <- read.table(paste0("./", set[i], "/Inertial Signals/body_gyro_z_", set[i], ".txt"))
        #561-feature vector with time and frequency domain variables.
        dataVector <- read.table(paste0("./", set[i], "/X_", set[i], ".txt"))
        
        #Rename variables to be more descriptive
        names(subject) <- "subject"
        names(activity) <- "activity"
        readingLabels <- gsub("V", "Reading_", names(x_total))
        names(x_total) <- paste0(readingLabels, "__x_total")
        names(y_total) <- paste0(readingLabels, "__y_total")
        names(z_total) <- paste0(readingLabels, "__z_total")
        names(x_body) <- paste0(readingLabels, "__x_body")
        names(y_body) <- paste0(readingLabels, "__y_body")
        names(z_body) <- paste0(readingLabels, "__z_body")
        names(x_gyro) <- paste0(readingLabels, "__x_gyro")
        names(y_gyro) <- paste0(readingLabels, "__y_gyro")
        names(z_gyro) <- paste0(readingLabels, "__z_gyro")
        names(dataVector) <- features[, 2]
        
        #Select only mean and std of each measurement
        dataVector <- dataVector[grepl("mean\\(|std", names(dataVector))]
        
        #Create separate train and test datasets
        if (set[i] == "train"){
                train <- cbind.data.frame(subject, activity, x_total, y_total, z_total, x_body, y_body, z_body, x_gyro, y_gyro, z_gyro, dataVector)
        }else{
                test <- cbind.data.frame(subject, activity, x_total, y_total, z_total, x_body, y_body, z_body, x_gyro, y_gyro, z_gyro, dataVector)
        }
}

#Combine train and test datasets
combined <- rbind.data.frame(train, test)

#Replace activity names to be more descriptive
combined <- combined %>% merge(read.table("activity_labels.txt"), by.x= "activity", by.y= "V1") %>% mutate(activity = V2) %>% select(-V2)
combined <- tbl_df(combined)

#Tidy up dataset
combined2 <- combined %>%
        mutate(x_total_mean = rowSums(combined[grep("x_total", names(combined))])/128) %>%
        mutate(y_total_mean = rowSums(combined[grep("y_total", names(combined))])/128) %>%
        mutate(z_total_mean = rowSums(combined[grep("z_total", names(combined))])/128) %>%
        mutate(x_body_mean = rowSums(combined[grep("x_body", names(combined))])/128) %>%
        mutate(y_body_mean = rowSums(combined[grep("y_body", names(combined))])/128) %>%
        mutate(z_body_mean = rowSums(combined[grep("z_body", names(combined))]/128)) %>%
        mutate(x_gyro_mean = rowSums(combined[grep("x_gyro", names(combined))])/128) %>%
        mutate(y_gyro_mean = rowSums(combined[grep("y_gyro", names(combined))])/128) %>%
        mutate(z_gyro_mean = rowSums(combined[grep("z_gyro", names(combined))])/128) %>%
        select(-grep("Reading|std", names(combined))) %>%
        #Take averages of each variable across rows, by group
        group_by(activity, subject) %>%
        summarize_all(mean)



