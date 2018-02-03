# Code Book of tidy_dataset.txt 
This document provides descriptions of variables in `tidy_dataset.txt`. `tidy_dataset.txt`is output of `run_analysis.R`. It shows summary of experiment "Human Activity Recognition Using Smartphones Data Set", grouped by subject and activity, after excluding various variables from raw datasets. Read `README.md` for more details about `run_analysis.R`.

`tidy_dataset.txt` contains 68 variables. Below is the desciptions of the variables:

**[1] subject**

Integer with value 1 to 30. Each value indicates identifier of the 30 volunteers participating in this experiment.

**[2] activity**

Factor with 6 levels, indicating activities performed by the volunteers:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

**[3-68]**
Numeric variables. Variables 3 to 68 are normalized values of the records, bounded within [-1,1]. Units for each variable are less known as there is lack of information from the dataset provider. The method of normalizing the values are also not known.

Variables 3-68 consist of 4 segments seperated by `-`, i.e.`domain-features-mean/std-axis`. Not every variable has segment 4. Here is some examples of the names of variable 3 to 68:
* `time-BodyAccelerometer-mean-Y`
* `frequency-BodyAccelerometer-mean-X`
* `time-BodyGyroscopeJerk-std-X`
* `time-BodyAccelerometerJerkMagnitude-std` (variable without segment 4)

**Segment 1 (domain)** has two possible values:
1. time: time domain signals
2. frequency: frequency domain signals

**Segment 2 (features)** has several combinations:
1. Body/Gravity signals
2. Accelerometer/Gyroscope, readings obtained from embedded accelerometer/gyroscope
3. Jerk (if any), signals derived from body linear acceleration and angular velocity
4. Mag (if any), indicates magnitude

**Segment 3 (mean/std)** has two possible values:
1. mean: Mean value
2. std: Standard deviation

**Segment 4 (axis)** (if any) indicates which axis is recorded. It has three possible values:
1. X
2. Y
3. Z

