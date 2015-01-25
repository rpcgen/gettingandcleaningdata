---
title  : "Getting and cleanind data (Project)"
author : "Juan Fernandez Martin"
date   : "Friday, January 23, 2015"
output : html_document
---

INSTRUCTIONS
------------

```
source('run_analysis.R')
myprocess <- create_process()
result <- myprocess$full_process()
```

The result is a list with three elements:
* The raw dataset (raw)
* The data set with averages and standard deviations (tidy1)
* The data set with the averages by subject and activity (tidy2).

Some problems related to the file transfer may be solved by passing the
parameter method='curl' to the full_process function.

```
source('run_analysis.R')
myprocess <- create_process('base')
result <- myprocess$full_process(method='curl')
```

INTERNALS
---------

create_process(basedir='assignement')

Create an object with the following functions:

* get_data: check data is ready for the process in the basedir. If necessary it
  will download the data and install the environment in the basedir.
* load_data: load and merge the data into one big data set. It fulfills the
  requirements 1 and 4 (raw data set).
* extract_mean_and_std: extract variables related to mean and standard deviation
  from the given data set. It fulfills the requirement 2 (tidy1 data set).
* name_the_activities: add an extra row to the dataset with the activity name.
  It fulfills the requirement 3 (raw data set).
* set_descriptive_variable_names: set proper names to the data set columns. This
  is actually done on load_data.
* averages_by_activity_and_subject: calculate a new data set with the mean of
  each measurement by subject and activity (tidy2 data set). It fulfills the
  requirement 4.
* full_process: call the functions listed before to build up a result list with
  the three described data sets (raw, tidy1, tidy2). It is just a convenience
  function.