create_process <- function(basedir='assignment') {

  url <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  datafile <- sprintf('%s/data.zip', basedir)

  keyfiles <- list(
    features   = sprintf('%s/UCI HAR Dataset/features.txt', basedir),
    activities = sprintf('%s/UCI HAR Dataset/activity_labels.txt', basedir),
    xtrain     = sprintf('%s/UCI HAR Dataset/train/X_train.txt', basedir),
    ytrain     = sprintf('%s/UCI HAR Dataset/train/y_train.txt', basedir),
    strain     = sprintf('%s/UCI HAR Dataset/train/subject_train.txt', basedir),
    xtest      = sprintf('%s/UCI HAR Dataset/test/X_test.txt', basedir),
    ytest      = sprintf('%s/UCI HAR Dataset/test/y_test.txt', basedir),
    stest      = sprintf('%s/UCI HAR Dataset/test/subject_test.txt', basedir)
  )

  get_data <- function(...) {
  
    if (!all(file.exists(unlist(keyfiles)))) {
  
      print('Downloading data from inet')
  
      if (file.exists(basedir)) {
          unlink(basedir, recursive=T)
      }
  
      dir.create(basedir)
      download.file(url, datafile, ...)
      unzip(datafile, exdir=basedir)
    }
  
    print(sprintf('Data is ready at %s', basedir))
  }

  load_data <- function() {
  
    features <- read.table(keyfiles$features, row.names=1)
  
    x_train <- read.table(keyfiles$xtrain, row.names=NULL, col.names=features[,1])
    y_train <- read.table(keyfiles$ytrain, row.names=NULL)
    subject_train <- read.table(keyfiles$strain, row.names=NULL)
  
    x_test <- read.table(keyfiles$xtest, row.names=NULL, col.names=features[,1])
    y_test <- read.table(keyfiles$ytest, row.names=NULL)
    subject_test <- read.table(keyfiles$stest, row.names=NULL)
  
    x_train$activity <- y_train[,1]
    x_train$subject <- subject_train[,1]
  
    x_test$activity <- y_test[,1]
    x_test$subject <- subject_test[,1]
  
    rownames(x_test) <- sprintf('test-%06d', as.integer(rownames(x_test)))
    rownames(x_train) <- sprintf('train-%06d', as.integer(rownames(x_train)))
  
    rbind(x_train, x_test)
  }

  extract_mean_and_std <- function(data) {
    mean_std <- grep('(mean|std)', colnames(data))
    data[,mean_std]
  }

  name_the_activities <- function(data, basedir='assignment') {
  
    names <- read.table(
      sprintf('%s/UCI HAR Dataset/activity_labels.txt', basedir),
      row.names=1)
  
    data$activity_name <- names[data$activity,1]
    data
  }

  set_descriptive_variable_names <- function(data) {
    # nothing to do, already performed (see load_data).
    data
  }

  averages_by_activity_and_subject <- function(data) {
    aggregate(data[,1:561], by=list(activity=data$activity, subject=data$subject), mean)
  }

  full_process <- function(...) {
    get_data(...)
    X <- load_data()
    Y <- extract_mean_and_std(X)
    X <- name_the_activities(X)
    X <- set_descriptive_variable_names(X)
    Z <- averages_by_activity_and_subject(X)
    list(raw=X, tidy1=Y, tidy2=Z)
  }

  list(
    get_data = get_data,
    load_data = load_data,
    extract_mean_and_std = extract_mean_and_std,
    name_the_activities = name_the_activities,
    set_descriptive_variable_names = set_descriptive_variable_names,
    averages_by_activity_and_subject = averages_by_activity_and_subject,
    full_process = full_process
  )
}