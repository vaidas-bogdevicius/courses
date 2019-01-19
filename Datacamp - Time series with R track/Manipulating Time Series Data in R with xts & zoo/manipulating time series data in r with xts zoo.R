require(xts)

x <- matrix(1:4, ncol = 2, nrow = 2)
x

idx <- as.Date(c("2015-01-01", "2015-02-01"))
idx

X <- xts(x, order.by = idx)
X

## Useful functions: coredata(), index()

###############
#   Example   #
###############

# Load xts
library(xts)

# View the structure of ex_matrix
str(ex_matrix)

# Extract the 3rd observation of the 2nd column of ex_matrix
ex_matrix[3, 2]

# Extract the 3rd observation of the 2nd column of core 
core[3, 2]

###############
#   Example   #
###############

# Create the object data using 5 random numbers
data = rnorm(5)

# Create dates as a Date class object starting from 2016-01-01
dates <- seq(as.Date("2016-01-01"), length = 5, by = "days")

# Use xts() to create smith
smith <- xts(x = data, order.by = dates)

# Create bday (1899-05-08) using a POSIXct date class object
bday <- as.POSIXct("1899-05-08")

# Create hayek and add a new attribute called born
hayek <- xts(x = data, order.by = dates, born = bday)

###############
#   Example   #
###############

# Extract the core data of hayek
hayek_core = coredata(hayek)

# View the class of hayek_core
class(hayek_core)

# Extract the index of hayek
hayek_index = index(hayek)

# View the class of hayek_index
class(hayek_index)
# Example 4
a <- xts(x = 1:2, as.Date("2012-01-01") + 0:1)
a[index(a)]

###############
#   Example   #
###############

# Convert austres to an xts object called au
au <- as.xts(austres)

# Then convert your xts object (au) into a matrix am
am <- as.matrix(au)

# Inspect the head of am
head(am)

# Convert the original austres into a matrix am2
am2 <- as.matrix(austres)

# Inspect the head of am2
head(am2)

###############
#   Example   #
###############

# Create dat by reading tmp_file
dat <- read.csv(tmp_file)

# Convert dat into xts
xts(dat, order.by = as.Date(rownames(dat), "%m/%d/%Y"))

# Read tmp_file using read.zoo
dat_zoo <- read.zoo(tmp_file, index.column = 0, sep = ",", format = "%m/%d/%Y")

# Convert dat_zoo to xts
dat_xts <- as.xts(dat_zoo)

###############
#   Example   #
###############

# Convert sunspots to xts using as.xts().
sunspots_xts <- as.xts(sunspots)

# Get the temporary file name
tmp <- tempfile()

# Write the xts object using zoo to tmp 
write.zoo(sunspots_xts, sep = ",", file = tmp)

# Read the tmp file. FUN = as.yearmon converts strings such as Jan 1749 into a proper time class
sun <- read.zoo(tmp, sep = ",", FUN = as.yearmon)

# Convert sun into xts. Save this as sun_xts
sun_xts <- as.xts(sun)

###############
#   Example   #
###############

# Select all of 2016 from x
x_2016 <- x["2016"]

# Select January 1, 2016 to March 22, 2016
jan_march <- x["2016/2016-03-22"]

# Verify that jan_march contains 82 rows
82 == length(jan_march)

###############
#   Example   #
###############

# Extract all data from irreg between 8AM and 10AM
morn_2010 <- irreg["T08:00/T10:00"]

# Extract the observations in morn_2010 for January 13th, 2010
morn_2010["2010-01-13"]

###############
#   Example   #
###############

# Row selection with time objects

# Subset x using the vector dates
x[dates]

# Subset x using dates as POSIXct
x[as.POSIXct(dates)]

###############
#   Example   #
###############

# Update and replace elements
# 
# Replacing values in xts objects is just as easy as extracting them. You can use either ISO-8601 strings, date objects, logicals, or integers to locate the rows you want to replace. One reason you may want to do this would be to replace known intervals or observations with NA, say due to a malfunctioning sensor on a particular day or a set of outliers given a holiday.
# 
# For individual observations located sporadically throughout your data dates, integers or logical vectors are a great choice. For continuous blocks of time, ISO-8601 is the preferred method.
# 
# In this exercise, you'll continue using the vector dates from the previous exercise to modify your x object. Both are already loaded in your workspace

# Replace the values in x contained in the dates vector with NA
x[dates] <- NA

# Replace all values in x for dates starting June 9, 2016 with 0
x["2016-06-09/"] <- 0

# Verify that the value in x for June 11, 2016 is now indeed 0
x["2016-06-11"]

###############
#   Example   #
###############

# Find the first or last period of time
# 
# Sometimes you need to locate data by relative time. Something that is easier said than put into code. This is equivalent to requesting the head or tail of a series, but instead of using an absolute offset, you describe a relative position in time. A simple example would be something like the last 3 weeks of a series, or the first day of current month.
# 
# Without a time aware object, this gets quite complicated very quickly. Luckily, xts has the necessary prerequisites built in for you to use with very little learning required. Using the first() and last() functions it is actually quite easy!
#   
# For this exercise, you'll extract relative observations from a data set called temps, a time series of summer temperature data from Chicago, IL, USA.

# Create lastweek using the last 1 week of temps
lastweek <- last(temps, "1 week")

# Print the last 2 observations in lastweek
last(lastweek, 2)

# Extract all but the first two days of lastweek
first(lastweek, -2)

###############
#   Example   #
###############

# Combining first and last
# 
# Now that you have seen how to extract the first or last chunk of a time series using natural looking language, it is only a matter of time before you need to get a bit more complex.
# 
# In this exercise, you'll extract a very specific subset of observations by linking together multiple calls to first() and last().
# 
# # Last 3 days of first week
# last(first(Temps, '1 week'), '3 days') 
# 
# You will reconfigure the example above using the temps data from the previous exercise. The trick to using such a complex command is to work from the inside function, out.

# Extract the first three days of the second week of temps
first(last(first(temps, "2 weeks"), "1 week"), 3)

###############
#   Example   #
###############

# Matrix arithmetic - add, subtract, multiply, and divide in time!
#   
#   xts objects respect time. By design when you perform any binary operation using two xts objects, these objects are first aligned using the intersection of the indexes. This may be surprising when first encountered.
# 
# The reason for this is that you want to preserve the point-in-time aspect of your data, assuring that you don't introduce accidental look ahead (or look behind!) bias into your calculations.
# 
# What this means in practice is that you will sometimes be tasked with handling this behavior if you want to preserve the dimensions of your data.
# 
# Your options include:
# 
#     Use coredata() or as.numeric() (drop one to a matrix or vector).
#     Manually shift index values - i.e. use lag().
#     Reindex your data (before or after the calculation).
# 
# In this exercise, you'll look at the normal behavior, as well as an example using the first option. For now you will use two small objects a and b. Examine these objects in the console before you start.

# Add a and b. Notice the behavior of the dates, which ones remain?
# Add a with the numeric value of b. b will need to be converted to a numeric for this to work.

# Add a and b
a + b

# Add a with the numeric value of b
a + as.numeric(b)

###############
#   Example   #
###############

# Math with non-overlapping indexes
# 
# The previous exercise illustrated the ins and outs of doing basic math with xts objects. At this point you are aware that xts respects time and will only return the intersection of times when doing various mathematical operations.
# 
# We alluded to another way to handle this behavior in the last exercise. Namely, re-indexing your data before an operation. This makes it possible to preserve the dimensions of your data by leveraging the same mechanism that xts uses internally in its own Ops method (the code dispatched when you call + or similar).
# 
# The third way involves modifying the two series you want by assuring you have some union of dates - the dates you require in your final output. To do this you will need a few functions that won't be dealt with in depth until Chapter 3, but are very useful here.
# 
# merge(b, index(a))
# 
# Don't worry if you aren't yet familiar with merge(). This exercise may be easier if you just follow along with the instructions.



###############
#   Example   #
###############

# Math with non-overlapping indexes
# 
# The previous exercise illustrated the ins and outs of doing basic math with xts objects. At this point you are aware that xts respects time and will only return the intersection of times when doing various mathematical operations.
# 
# We alluded to another way to handle this behavior in the last exercise. Namely, re-indexing your data before an operation. This makes it possible to preserve the dimensions of your data by leveraging the same mechanism that xts uses internally in its own Ops method (the code dispatched when you call + or similar).
# 
# The third way involves modifying the two series you want by assuring you have some union of dates - the dates you require in your final output. To do this you will need a few functions that won't be dealt with in depth until Chapter 3, but are very useful here.
# 
# merge(b, index(a))
# 
# Don't worry if you aren't yet familiar with merge(). This exercise may be easier if you just follow along with the instructions.

# Instructions
# 100 XP
# 
# Using a and b from the previous exercise, get the value of a + b for each date in a. If no b is available on a given date, the answer should be a on that date.
# Now add a to b, but this time make sure all values of a are added to the last known value of b in time.

# > a
# a
# 2015-01-24 1
# 2015-01-25 1
# 2015-01-26 1
# > b
# b
# 2015-01-24 2
# > merge(b, index(a), fill = 0)
# b
# 2015-01-24 2
# 2015-01-25 0
# 2015-01-26 0
# > 
#   > # Add a to b, and fill all missing rows of b with 0
#   > a + merge(b, index(a), fill = 0)
# a
# 2015-01-24 3
# 2015-01-25 1
# 2015-01-26 1
# > 
#   > # Add a to b and fill NAs with the last observation
#   > a + merge(b, index(a), fill = na.locf)
# a
# 2015-01-24 3
# 2015-01-25 3
# 2015-01-26 3

###############
#   Example   #
###############

# Combining xts by column with merge
# 
# xts makes it easy to join data by column and row using a few different functions. All results will be correctly ordered in time, regardless of original frequencies or date class. One of the most important functions to accomplish this is merge(). It takes one or more series and joins them by column. It's also possible to combine a series with a vector of dates. This is especially useful for normalizing observations to a fixed calendar.
# 
# merge() takes three key arguments which we will emphasize here. First is the ..., which lets you pass in an arbitrary number of objects to combine. The second argument is join, which specifies how to join the series - accepting arguments such as inner or left. This is similar to a relational database join, only here, the index is what we join on. The final argument for this exercise is fill. This keyword specifies what to do with the new values in a series if there is missingness introduced as a result of the merge.
# 
# # Basic argument use
# merge(a, b, join = "right", fill = 9999)
# 
# For this exercise, you will explore some of the different join types to get a feel for using merge(). The objects a and b have been pre-loaded into your workspace.
# 
# Instructions
# 100 XP
# 
#     Merge a and b using merge() (or cbind()), with the argument join set to "inner".
#     Perform a left-join of a and b. Use merge() and set the argument join to the correct value. Fill all missing values with zero (use the fill argument).
# 
# # Perform an inner join of a and b
# merge(___, ___, join = "___")
# 
# # Perform a left-join of a and b, fill missing values with 0
# merge(___, ___, join = "___", fill = ___)

# > a
# a
# 2016-06-05 -1.2070657
# 2016-06-08  0.2774292
# 2016-06-09  1.0844412
# 2016-06-13 -2.3456977
# > b
# b
# 2016-06-05  0.4291247
# 2016-06-06  0.5060559
# 2016-06-08 -0.5747400
# 2016-06-09 -0.5466319
# > 
#   > # Perform an inner join of a and b
#   > merge(a, b, join = "inner")
# a          b
# 2016-06-05 -1.2070657  0.4291247
# 2016-06-08  0.2774292 -0.5747400
# 2016-06-09  1.0844412 -0.5466319
# > 
#   > # Perform a left-join of a and b, fill missing values with 0
#   > merge(a, b, join = "left", fill = 0)
# a          b
# 2016-06-05 -1.2070657  0.4291247
# 2016-06-08  0.2774292 -0.5747400
# 2016-06-09  1.0844412 -0.5466319
# 2016-06-13 -2.3456977  0.0000000

###############
#   Example   #
###############

# Combining xts by row with rbind
# 
# Now that you have merged data by column, you will be happy to know it's just as easy to add new rows to your data.
# 
# xts provides its own S3 method to the base rbind() generic function. The xts rbind function is much simpler than merge(). The only argument that matters is ..., which takes an arbitrary number of objects to bind. What is different is that rbind requires a time series, since we need to have timestamps for R to know where to insert new data.
# 
# For this exercise you will update your temps data with three new observations. One will be before the series started and two will be after. Pay attention to your function call, does order matter?
# 
# In your workspace, the objects temps, temps_june30, temps_july17 and temps_july18 are already loaded.
# 
# Instructions
# 100 XP
# 
#     Bind the row from June 30th (temps_june30) to temps, and call this temps2.
#     Bind the rows from July 17th and 18th to temps2. Call this temps3.
# 
# # Row bind temps_june30 to temps, assign this to temps2
# temps2 <- rbind(temps_june30, temps)
# 
# # Row bind temps_july17 and temps_july18 to temps2, call this temps3
# temps3 <- rbind(temps_july17, temps_july18, temps2)
# 
# # Row bind temps_june30 to temps, assign this to temps2
# temps2 <- rbind(temps_june30, temps)
# temps2
# # Row bind temps_july17 and temps_july18 to temps2, call this temps3
# temps3 <- rbind(temps_july17, temps_july18, temps2)
# temps3

#################
#   Example 18  #
#################

# # Fill missing values in temps using the last observation
# temps_last <- na.locf(temps)
# 
# # Fill missing values in temps using the next observation
# temps_next <- na.locf(temps, fromLast = TRUE) 

#################
#   Example 19  #
#################

# NA interpolation using na.approx()
# 
# # Interpolate NAs using linear approximation
# na.approx(AirPass)

###############
#   Example   #
###############

# Lagging series

# # Create a leading object called lead_x
# lead_x <- lag(x, k = -1)
# 
# # Create a lagging object called lag_x
# lag_x <- lag(x, k = 1)
# 
# # Merge your three series together and assign to z
# z = merge(lead_x, x, lag_x)

###############
#   Example   #
###############

# Calculate a difference of a series using diff()

# # Calculate the first difference of AirPass and assign to diff_by_hand
# diff_by_hand <- AirPass - lag(AirPass, k = 1)
# 
# # Use merge to compare the first parts of diff_by_hand and diff(AirPass)
# merge(head(diff_by_hand), head(diff(AirPass)))
# 
# # Calculate the first order 12 month difference of AirPass
# diff(AirPass, lag = 12, differences = 1)

###############
#   Example   #
###############

# # Locate the weeks
# temps
# endpoints(temps, on = "weeks")
# 
# # Locate every two weeks
# endpoints(temps, on = "weeks", k = 2)

###############
#   Example   #
###############

# Apply a function by time period(s)
# 
# # Calculate the weekly endpoints
# ep <- endpoints(temps, on = "weeks")
# 
# # Now calculate the weekly mean and display the results
# period.apply(temps[, "Temp.Mean"], INDEX = ep, FUN = mean)

###############
#   Example   #
###############

# > temps
# Temp.Max Temp.Mean Temp.Min
# 2016-07-01       74        69       60
# 2016-07-02       78        66       56
# 2016-07-03       79        68       59
# 2016-07-04       80        76       69
# 2016-07-05       90        79       68
# 2016-07-06       89        79       70
# 2016-07-07       87        78       72
# 2016-07-08       89        80       72
# 2016-07-09       81        73       67
# 2016-07-10       83        72       64
# 2016-07-11       93        81       69
# 2016-07-12       89        82       77
# 2016-07-13       86        78       68
# 2016-07-14       89        80       68
# 2016-07-15       75        72       60
# 2016-07-16       79        69       60
# > temps_weekly <- split(temps, f = "weeks")
# > temps_weekly
# [[1]]
# Temp.Max Temp.Mean Temp.Min
# 2016-07-01       74        69       60
# 2016-07-02       78        66       56
# 2016-07-03       79        68       59
# 
# [[2]]
# Temp.Max Temp.Mean Temp.Min
# 2016-07-04       80        76       69
# 2016-07-05       90        79       68
# 2016-07-06       89        79       70
# 2016-07-07       87        78       72
# 2016-07-08       89        80       72
# 2016-07-09       81        73       67
# 2016-07-10       83        72       64
# 
# [[3]]
# Temp.Max Temp.Mean Temp.Min
# 2016-07-11       93        81       69
# 2016-07-12       89        82       77
# 2016-07-13       86        78       68
# 2016-07-14       89        80       68
# 2016-07-15       75        72       60
# 2016-07-16       79        69       60
# > # Create a list of weekly means, temps_avg, and print this list
#   > temps_avg <- lapply(X = temps_weekly, FUN = mean)
# > temps_avg
# [[1]]
# [1] 67.66667
# 
# [[2]]
# [1] 77.04762
# 
# [[3]]
# [1] 76.38889

###############
#   Example   #
###############

# # Use the proper combination of split, lapply and rbind
# temps_1 <- do.call(rbind, lapply(split(temps, "weeks"), function(w) last(w, n = "1 day")))
# 
# # Create last_day_of_weeks using endpoints()
# last_day_of_weeks <- endpoints(temps, on = "weeks")
# 
# # Subset temps using last_day_of_weeks 
# temps_2 <- temps[last_day_of_weeks]


###############
#   Example   #
###############

# # Convert usd_eur to weekly and assign to usd_eur_weekly
# usd_eur_weekly <- to.period(usd_eur, period = "weeks")
# 
# # Convert usd_eur to monthly and assign to usd_eur_monthly
# usd_eur_monthly <- to.period(usd_eur, period = "months")
# 
# # Convert usd_eur to yearly univariate and assign to usd_eur_yearly
# usd_eur_yearly <- to.period(usd_eur, period = "years", OHLC = FALSE)

###############
#   Example   #
###############

# # Convert eq_mkt to quarterly OHLC
# mkt_quarterly <- to.period(eq_mkt, period = "quarters")
# mkt_quarterly
# # Convert eq_mkt to quarterly using shortcut function
# mkt_quarterly2 <- to.quarterly(eq_mkt, name = "edhec_equity", indexAt = "firstof")
# mkt_quarterly2

###############
#   Example   #
###############

# # Split edhec into years
# edhec_years <- split(edhec , f = "years")
# edhec_years
# # Use lapply to calculate the cumsum for each year in edhec_years
# edhec_ytd <- lapply(edhec_years, FUN = cumsum)
# edhec_ytd
# # Use do.call to rbind the results
# edhec_xts <- do.call(rbind, edhec_ytd)
# edhec_xts

###############
#   Example   #
###############

# # Use rollapply to calculate the rolling 3 period sd of eq_mkt
# eq_sd <- rollapply(eq_mkt, width = 3, FUN = sd)


###############
#   Example   #
###############

# # View the first three indexes of temps
# index(temps)[1:3]
# 
# # Get the index class of temps
# indexClass(temps)
# 
# # Get the timezone of temps
# indexTZ(temps)
# 
# # Change the format of the time display
# indexFormat(temps) <- "%b-%d-%Y"
# 
# # View the new format
# head(temps)

###############
#   Example   #
###############

# # Construct times_xts with tzone set to America/Chicago
# times
# times_xts <- xts(1:10, order.by = times, tzone = "America/Chicago")
# times_xts
# # Change the time zone of times_xts to Asia/Hong_Kong
# tzone(times_xts) <- "Asia/Hong_Kong"
# times_xts
# # Extract the current time zone of times_xts
# indexTZ(times_xts)

###############
#   Example   #
###############

# # Calculate the periodicity of temps
# periodicity(temps)
# 
# # Calculate the periodicity of edhec
# periodicity(edhec)
# 
# # Convert edhec to yearly
# edhec_yearly <- to.yearly(edhec)
# 
# # Calculate the periodicity of edhec_yearly
# periodicity(edhec_yearly)

###############
#   Example   #
###############

# # Count the months
# nmonths(edhec)
# 
# # Count the quarters
# nquarters(edhec)
# 
# # Count the years
# nyears(edhec)

###############
#   Example   #
###############

# # Explore underlying units of temps in two commands: .index() and .indexwday()
# .index(temps)
# .indexwday(temps)
# 
# 
# # Create an index of weekend days using which()
# index <- which(.indexwday(temps) == 0 | .indexwday(temps) == 6)
# 
# # Select the index
# temps[index]

###############
#   Example   #
###############

# # Make z have unique timestamps
# z_unique <- make.index.unique(z, eps = 1e-4)
# 
# # Remove duplicate times in z
# z_dup <- make.index.unique(z, drop = TRUE)
# 
# # Round observations in z to the next hour
# z_round <- align.time(z, n = 3600)