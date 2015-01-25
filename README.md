---
title: "README2.MD"
author: "Chuck BOlin"
date: "Sunday, January 25, 2015"
output: html_document
---
Overview (run_analysis.R)
===

The **run_analysis.R** file must be placed in the folder that has been unzipped. This folder **must** contain the following structure.

-  Subfolder   "test"
-  Subolder  	"train"
-  File			activity_labels.txt
-  File			features.txt
-  File			features_info.txt
-  File			run_analysis.R


Script Entry Point
====

The process for loading and running the script consists of the following two lines of code.

This loads the script.
```
source("run_analysis.R");
```

This takes about 3-4 minutes and produces the a file "bigdata.csv". It could be refactored to speed it up but I ran out of time.
```
createDatasets();
```

Script Coding & Explanation
====

Refer to the source script named **run_analysis.R**.

* Step 1: 'data.table' is key to the basic R package. The code looks to see that data.table is already installed. If not it aborts the code.
* Step 2: Three variables corresponding to directories are created and loaded. They represent the current directory and the two folders containing the 'test' and 'train' data.
* Step 3: Just in case you can't read the requirements I placed code here to verify two sub-directories exist: 'train' and 'test'.
* Step 4: Seven variables are created storing the file paths to the required files inside of the 'train' and 'test folders as well as the 'activity_labels.txt' file.
* Step 5: The seven files are read and stored using 'read.table' as data frames.
* Step 6: The six 'train' and 'test' data frames are stored into data tables.
* Step 7: The six data frames are released from memory to free some resources.
* Step 8: An index numbers from 1 to the max number of rows are added to all six data tables. This will be used for merging.
* Step 9: Keys are set for each data table to ensure that merging is seamless.
* Step 10: The data tables are consolidated into two data tables using 'merge'.
* Step 11: The training and testing data is now consolidated into a big data table.
* Step 12: Feature variable names are read from "features.txt" file. Some characters are replaced such as the dash and the parentheses.
* Step 13: The feature names alone with subject and activity as assigned to the column names.
* Step 14: The very large file of 561+ columns is reduced to around 80 columns by including features with 'mean' and 'std' included in their name.
* Step 15: This is he slow part of the app that replaces the numbers 1 through 6 with descriptives name such as 'WALKING'.
* Step 16: The data table is ordered by subject and activity.
* Step 17: 'bigdata.csv' is saved and message displayed.
* Step 18: The file 'bigdata.csv' is loaded into a data frame.
* Step 19: The data frame is loaded into a data table.
* Step 20: The 'X' columns is removes. I don't like it.
* Step 21: The data table is grouped by subject and activity and ten summarized to calculate the mean of each variable.
* Step 22: The 'bigdatasummary.csv' and 'bigdatasummary.txt' files are created and a message displayed.

This scripting is completed.





  
  