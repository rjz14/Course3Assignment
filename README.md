The "run_analysis.R" script works as follows:
======================================
- Before running the script, the user must set their working directory to be one level up from the "test" and "train" folders that contain the data for this assignment.
- The script loads the relevant R libraries and then reads in all of the data from the "test" and "train" folders to create a single data frame.
- The variables in the resulting data frame are then renamed to be more descriptive.  This is done in part with the help of the "features.txt" file, which is read into R.
- Only the mean and std measurements are taken from the X_train and X_test files.
- All of the above steps lead up to Step 4 of the instructions.
- Step 5 is then performed to yield a separate tidy dataset.  For each of the following nine variables, the corresponding 128 columns are collapsed into a single column by taking the average across the columns: x_total, y_total, z_total, x_body, y_body, z_body, x_gyro, y_gyro, z_gyro.
- The columns containing the original 128 data points for each variable are dropped from the resulting dataset (since the averages have been obtained), as are the variables related to std.
- Lastly, the dataset is grouped by activity and subject, and then the mean is calculated by group.
- This results in a tidy dataset of 180 rows (30 subjects x 6 activities) and 44 columns.
