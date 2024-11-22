% Add your code for Task 2 in this file
% Load the Data:
data_loader = load("dataIndAss2425.mat");
% Assign the loaded data from the loader to a variable:
data = data_loader.dat;
% Show the head of the table to see the different variables to determine suitable plots:
head(data)
% This shows us that the table consists of 4 columns:
% - Date: A column that contains the date of the recording 
% - Time: The timestamp of the recording
% - CO: The content of Carbon monoxide in the Air
% - C6H6: The content of Benzene in the Air
% -> These are assumptions, but the data needs to be put into context somehow
% To visualise the data, we need to split the data into "frames" for each column
date_data = data.Date;
time_data = data.Time;
CO_data = data.CO;
C6H6_data = data.C6H6;
% These following Frames become relevant in ex 2c), I just put them here because they make sense here :^)
C6H6_data_unclean = data.C6H6;
date_data_unclean = data.Date;
CO_data_unclean = data.CO;
time_data_unclean = data.Time;
% First, lets plot the amount of benzene present in the air on each day:
figure;
plot(date_data, C6H6_data);
xlabel("Date");
ylabel("Benzene Content");
title("TIme Series of Benzene content in the Air")
% From looking at this simple plot, we can see that there are several extreme outliers,
% the benzene values randomly drop below 0, however otherwise there are no other negative values
% Except for those outliers. 
figure;
boxplot(C6H6_data)
ylabel("Benzene Content in the Air")
title("Boxplot of the Benzene content in the Air")
% From the boxplot we can see that there are not only negative outliers, but also positive outliers.
% However, in the context of the data, positive outliers could STILL be relevant.
% Now we know that there are some outliers, now lets see how frequently they occur in the data:
figure;
histogram(C6H6_data)
xlabel("Benzene Concentration")
ylabel("Frequency of occurence")
title("Benzene Histogram")
% From this plot we can see that the positive outliers are more or less in line with natural data, as 
% They seem to follow a Gaussian distribution. However, we can clearly see, that there are a lot of 
% outliers which are smaller than 0, whereas there is not data in between. From this information
% We can conclude that the negative values are outliers. Other outliers are the values that lie beyond the 
% lower and upper fence. To find those values we need to calculate the interquartile range:
q_1 = prctile(C6H6_data, 25);
q_3 = prctile(C6H6_data, 75);
IQR = q_3 - q_1;
% Compute the lower quartile:
l_f = (q_1 - (1.5 * IQR));
% Compute the upper quartile: 
u_f = (q_3 + (1.5 * IQR));
C6H6_outlier_indexes = find(C6H6_data < l_f | C6H6_data > u_f);
% Then we need to remove them from the data, this is done by assigning an empty array to the datapoints which are below 0:
C6H6_data(C6H6_outlier_indexes) = [];
% Now, since we also have more data, we need to remove those indexes in the other dataframes:
date_data(C6H6_outlier_indexes) = [];
time_data(C6H6_outlier_indexes) = [];
CO_data(C6H6_outlier_indexes) = [];
% This is done to keep the data lines up and functioning "together" properly. Now lets visualize 
% And check if our cleaning was effective:
figure;
histogram(C6H6_data);
% Now we can see, it worked! The negative outliers beyond the hinges / fences are removed!.
% Now to finish this step, lets check if the lengths of all data arrays are the same:
if isequal(size(date_data), size(time_data), size(CO_data), size(C6H6_data))
    disp("Everything has the same length, it worked! Yippie :)")
else
    disp("Something went wrong while cleaning!")
end
% This works for me, so lets move on to 2b) (From thispoint on we will *ONLY* focus on the Benzene data):
% Calculate the variance and mean:
helper = 0; % Helper variables to keep track of the sum:
for i = 1:length(C6H6_data)
    helper = helper + C6H6_data(i);
end
mean = helper / length(C6H6_data);
helper2 = 0; % Helper variables to keep track of the sum:
for i = 1:length(C6H6_data)
    helper2 = helper2 + (C6H6_data(i) - mean) ^ 2;
end
variance = helper2 / length(C6H6_data);
var(C6H6_data); % This is just to check if the value is the same / similar to the manual calculation
% Now lets move on to the seven number summary, since we already determined the IQR and q_1 and q_3 we can just summarize:
% 1. The Minimum:
minimum = min(C6H6_data);
% 2. The Lower fence (q_1 - (1.5 * IQR)), which we determined in ex 2a)
l_f;
% 3. The Lower hinge, or first quartile
q_1;
% 4. The median:
median_C6H6 = median(C6H6_data);
% 5. The third quartile
q_3;
% 6. Upper hinge
u_f;
% 7. Maximum 
maximum = max(C6H6_data);
% Print the results to the console:
disp("Seven Number Summary:")
disp(["Minimum: ", num2str(minimum)])
disp(["Lower Fence: ", num2str(l_f)])
disp(["1st Quartile: ", num2str(q_1)])
disp(["Median: ", num2str(median_C6H6)])
disp(["3rd Qurtile: ", num2str(q_3)])
disp(["Upper Hinge: ", num2str(u_f)])
disp(["Maximum: ", maximum])
% Now for the last step, lets evaluate the skewness using Pearsons Median Skewness:
skewness_c6h6 = 3 * ((mean - median_C6H6) / std(C6H6_data));
% From the output value we can see that we have a moderate to high positive (right) skew.
% Based on the Moderate to hight Right skew, as well as the graph we got in exercise 2a) (after cleaning), we have a few candidates:
% Exponential distribution: This seems similar, however can be rejected, since the histogram of the data suggests a "bump" in the data,
%   the exponential distribution canbe rejected 
% Log Normal Distribution: From a visual Inspection they seem EXTREMELY similar, therefore we can assume it fits the Log normal distribution
% => The Distribution fits Log Normal!
% 
% For task 2c) we first have to combine the date and time data into one column, since otherwise similar timesteps will mess up the plots:
date_data.Format = "dd.MM.uuuu HH:mm";
time_data.Format = "dd.MMM uuuu HH:mm";
datetime_data = date_data + timeofday(time_data);
date_data_unclean.Format = "dd.MMM.uuuu HH:mm";
time_data_unclean.Format = "dd.MM.uuuu HH:mm";
datetime_data_unclean = date_data_unclean + timeofday(time_data_unclean);
% To efficitiently plot the relationship, we can use a time series:
figure;
plot(datetime_data, CO_data, "DisplayName", "CO")
hold on
plot(datetime_data, C6H6_data, "DisplayName", "C6H6")
xlabel("Date and Time")
ylabel("Concentration")
title("Time series comparing cleaned benzene and monoxide data")
hold off
% Now we see that the monoxide data has the same type of outliers as the Benzene data. Now from this we can
% Infer that the data we previously thought to be outliers in the benzene data might not be outliers! 
% Now to confirm this, we need to look at the "unclean" data again, and compare it to the monoxide
% Data to confirm or reject our hypothesis:
figure;
plot(datetime_data_unclean, CO_data_unclean, "DisplayName", "CO Unclean")
hold on
plot(datetime_data_unclean, C6H6_data_unclean, "DisplayName", "C6H6 Unclean")
xlabel("Date and Time")
ylabel("Concentration")
title("Comparing uncleaned benzene and monoxide data")
% This plot gives us an idea that some extremes are similar in occurence. Now to actually confirm our
% hypothesis, we need to compare only the outliers. To get those outliers, we use a similar method as in 2a)
% Just reversed:
outlier_indeces = find(C6H6_data_unclean > l_f | C6H6_data_unclean < u_f);
c6h6_outlierData = C6H6_data_unclean;
datetime_outlierData = datetime_data_unclean;
co_outlierData = CO_data_unclean;
c6h6_outlierData(outlier_indeces);
datetime_outlierData(outlier_indeces);
co_outlierData(outlier_indeces);
% Now we removed the inliers (?) we can make a scatterplot and compare those values:
figure
figure;
plot(datetime_data_unclean, CO_data_unclean, "DisplayName", "CO Unclean")
hold on
plot(datetime_data_unclean, C6H6_data_unclean, "DisplayName", "C6H6 Unclean")
xlabel("Date and Time")
ylabel("Concentration")
scatter(datetime_outlierData, c6h6_outlierData, 50, "yo", "DisplayName", "C6H6 Outliers")
scatter(datetime_outlierData, co_outlierData, 50, "go", "DisplayName", "CO Outliers")
title("Scatter plot over time series of outlier data")
% From this graph, we can see, that outlier on the 