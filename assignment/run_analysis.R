## Coursera course:  getting and cleaning data
## Assignment week 4

#function to update status messages to the console
comm <- function(...) cat("[run_analysis.R]", ..., "\n")

#function to import data files in data folder to single data frame
filetodata <- function (Folder="."){
        allfiles  <- list.files(Folder, full.names=TRUE, pattern="*.txt")
        result <- data.frame() #empty data frame
        
        for (textfile in allfiles){
                if (grepl("[Xx]_", textfile)) df3 <- read.table(textfile) #import each downloaded data file to a data frame
                if (grepl("[Yy]_", textfile)) df2 <- read.table(textfile)
                if (grepl("subject_", textfile)) df1 <- read.table(textfile) 
                }
        ## add column detailing if data comes from test dataset or training dataset
        if (grepl("test.txt$", textfile)) result <- cbind(df1,"test", df2,df3) else result <-cbind(df1,"training", df2,df3)
        }

#function to download the data from the internet and create a clean dataset
ProcessData <- function (myfolder="."){
        
        if (!file.exists(myfolder)) dir.create(myfolder)
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        FileName <- file.path(myfolder, "datasets.zip")
        comm("downloading dataset") ## downloading dataset
        download.file(fileUrl,destfile=FileName,method="auto")
        comm("unzipping dataset") ## unzipping dataset
        unzip(FileName, exdir = myfolder)
        testdata <- paste(myfolder,"/UCI HAR Dataset/test", sep="")
        trainingdata <- paste(myfolder,"/UCI HAR Dataset/train", sep="")
        rootdata <- paste(myfolder,"/UCI HAR Dataset", sep="")
        
        comm("read data from features.txt and activity.txt") ## Load activity labels + features
        activities <- read.table(paste(rootdata,"/activity_labels.txt", sep=""), col.names=c("activityid", "activity"))
        activities[,2] <- as.character(activities[,2])
        features <- read.table(paste(rootdata,"/features.txt", sep=""), col.names=c("featureid", "feature"))
        features[,2] <- as.character(features[,2])

        comm("read test data") ## read all data from the test dataset
        testdf  <- filetodata(testdata)
        colnames(testdf) <- c("subject", "dataset", "activity", features[,2])  
        
        comm("read training data") ## read all data from the training dataset
        traindf <- filetodata(trainingdata)
        colnames(traindf) <- c("subject", "dataset", "activity", features[,2])  

        comm("combine data sets")    ## combine both the test and the training data set
        cleandf <- rbind(testdf,traindf)
        
        comm("replace the activities with their description") ## replace the activities with their full description
        cleandf$activity <- activities[match(cleandf$activity, activities$activityid),2]
        
        ##drop colums without standard deviation or mean data
        dropcolumns <- grep(pattern="*.-std*.|*.-mean*.", x=features[,2], invert=TRUE)
        dropcolumns <- dropcolumns + 3  ## +3  because I added 3 columns to the cleaned data 
        cleandf <- cleandf[-dropcolumns] ## dropping columns from dataframe
        comm("clean dataset created")
        cleandf
        }

## Main program

datafolder <- "GettingAndCleaningData/assignment" #define the directory to download data to
cleandata <- ProcessData(file.path(getwd(), datafolder)) # get clean data set

#new data set based on the average of each variable for each activity and each subject.
comm("dplyr installation") 
if (!require("dplyr")) install.packages("dplyr") else comm("dplyr already installed") ## check if package installed
comm("creating second dataset")
newdata <- cleandata %>% group_by(activity, subject) %>% select(-dataset) %>% summarise_each(funs(mean))
#write clean data set to harddisk
comm("writing second dataset to hard drive")
write.table(newdata, file.path(getwd(), datafolder, 
                                 "tidydata.txt"), row.names = FALSE, quote = FALSE)
comm("complete")