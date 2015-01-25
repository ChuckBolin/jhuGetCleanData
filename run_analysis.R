#*****************************************************************
# 
# run_analysis.R  - Written by Chuck Bolin, January 2015
# Purpose: Script created for the final course project for
# Getting and Cleaning Data, coursera.org/getdata-010
#
#*****************************************************************
# Does it all...
createDatasets<-function(...){

  # Check for the occurence of the package ("data.table")
  if("data.table" %in% rownames(installed.packages()) == FALSE){
    print("'do_it_all()' requires the 'data.table' package.");
    print("Please install 'data.table' package and then rerun this function.");
    return(NA) 
  }
  
  # Ensure DT is available
  require(data.table)
  
  # Define required directories
  currDir =getwd();
  testDir = paste(currDir,"/test",sep="");
  trainDir = paste(currDir,"/train",sep="");
  
  # Look for test and train folders as child subfolders
  if(file.exists(testDir)==FALSE | file.exists(trainDir)==FALSE){
    print("Set working directory to the UCI HAR Dataset and then rerun this function");
    return(NA);  
  }
  
  # Define filepaths for 6 source files and activity labels file
  subjectTrainFile = paste(trainDir,"/subject_train.txt",sep="");
  activityTrainFile = paste(trainDir,"/y_train.txt",sep="");
  dataTrainFile = paste(trainDir,"/X_train.txt",sep="");
  subjectTestFile = paste(testDir,"/subject_test.txt",sep="");
  activityTestFile = paste(testDir,"/y_test.txt",sep="");
  dataTestFile = paste(testDir,"/X_test.txt",sep="");
  activityLabelsFile = "activity_labels.txt";
  
  # Read 6 key source files into data.frames
  dfTrainSubject = read.table(file=subjectTrainFile, header=FALSE);
  dfTrainActivity = read.table(file=activityTrainFile, header=FALSE);
  dfTrainData = read.table(file=dataTrainFile, header=FALSE);
  dfTestSubject = read.table(file=subjectTestFile, header=FALSE);
  dfTestActivity = read.table(file=activityTestFile, header=FALSE);
  dfTestData = read.table(file=dataTestFile, header=FALSE);
  dfActivityLabels = read.table(file=activityLabelsFile, header=FALSE);
  
  # Convert 6 data.frames to data.tables
  dtTrainSubject=data.table(dfTrainSubject); 
  dtTrainActivity=data.table(dfTrainActivity); 
  dtTrainData=data.table(dfTrainData); 
  dtTestSubject=data.table(dfTestSubject); 
  dtTestActivity=data.table(dfTestActivity); 
  dtTestData=data.table(dfTestData); 
    
  # Remove 6 data.frames to free resources
  rm(dfTrainSubject);
  rm(dfTrainActivity);
  rm(dfTrainData);
  rm(dfTestSubject);
  rm(dfTestActivity);
  rm(dfTestData);
  
  # Add an index to all 6 data.tables to support merging
  index=c(1:nrow(dtTrainSubject));
  dtTrainSubject=cbind(index,dtTrainSubject);  
  dtTrainActivity=cbind(index,dtTrainActivity);
  dtTrainData=cbind(index,dtTrainData);
  
  index=c(1:nrow(dtTestSubject));
  dtTestSubject=cbind(index,dtTestSubject);  
  dtTestActivity=cbind(index,dtTestActivity);
  dtTestData=cbind(index,dtTestData);
  
  # Set the keys for all 6 data.tables
  setkey(dtTrainSubject,index);
  setkey(dtTrainActivity,index);
  setkey(dtTrainData,index);
  setkey(dtTestSubject,index);
  setkey(dtTestActivity,index);
  setkey(dtTestData,index);
  
  # Merge three data.tables into 1 data.table  for training and testing
  dtTrainConsolidated = merge(dtTrainSubject,dtTrainActivity,all=TRUE);
  dtTrainConsolidated = merge(dtTrainConsolidated,dtTrainData,all=TRUE);
  dtTestConsolidated = merge(dtTestSubject,dtTestActivity,all=TRUE);
  dtTestConsolidated = merge(dtTestConsolidated,dtTestData,all=TRUE);   
  
  # Combine the new consolidated training and testing data.tables 
  # into a single data.table  
  dtBigData=rbind(dtTrainConsolidated,dtTestConsolidated)  
  
  # Read features for 561 columns and add to header
  features=read.table("features.txt");
  features=features[,2]           #only need 2nd column
  features=gsub("-",".",features) #replace dashes with period
  features=sub("\\(","",features) #remove parentheses
  features=sub("\\)","",features)
  
  # Add meaningful header names to data.table
  #setnames(dtBigData, c("index","subject","activity",as.character(features$V2)));
  setnames(dtBigData, c("index","subject","activity",as.character(features)));
  
  # Extract indices for each column that has mean and std
  # including subject, and, activity 
  mainFeatures=grep("subject|activity|mean|std",names(dtBigData));
  
  # Build data.table that has only required headers (variables)
  dtBigData = dtBigData[,mainFeatures,with=FALSE]
 
  # Replace activity codes 1..6 with descriptive terms
  activity.name=as.character();  
  for(i in 1:nrow(dtBigData)){
    activityNumber = as.integer(dtBigData$activity[i])
    activityName = as.character(dfActivityLabels[activityNumber,2])
    dtBigData$activity[i]=activityName
  }
  
  # Order dt by subject and then activity
  dtBigData=dtBigData[with(dtBigData,order(subject, activity)),]
  
  # Save data.table to file
  write.csv(dtBigData,"bigdata.csv");  
  
  print("Consolidated file has been created: 'bigdata.csv'");  
  createSummaryDataset()
  

}

# Creates and saves summary data set
createSummaryDataset<-function(...){
  df = read.csv("bigdata.csv")
  dt = data.table(df)
  dt[,X:=NULL] # remove index 'X'
  
  bigdataSummary=dt %>% group_by(subject,activity) %>% summarise_each(funs(mean))
  write.csv(bigdataSummary,"bigdatasummary.csv",row.names=FALSE)
  write.table(bigdataSummary,"bigdatasummary.txt", row.names=FALSE, sep=" ")
  
  print("Summary file has been created: 'bigdatasummary.csv' and 'bigdatasummary.txt");  
 
}
