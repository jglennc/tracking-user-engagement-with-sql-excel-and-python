# Tracking User Engagement with SQL, Excel, and Python Project

### Case Description
Background: The project requires you to analyze whether the new additions to the platform (new courses, exams, and career tracks) have increased student engagement.

You are given the following information:

* Holder (student ID) and issuance date of certificates issued in Q2 2022
* Student ID and registration date of students registered between January 1, 2020 and June 30, 2022
* Student ID, product type, purchase date, and refund date (if applicable) of purchases made between January 1, 2020 and June 30, 2022
* Student watching (student ID), time watched, and date of courses watched in Q2 2021 and Q2 2022

Hypothesis: The first half of 2022 was expected to be profitable for the company. The reason was the hypothesized increased student engagement after the release of several new features on the company’s website at end-2021. These include enrolling in career tracks and testing your knowledge through practice, course, and career track exams. Of course, we have also expanded our course library to increase user engagement and the platform’s audience as more topics are covered. By comparing different metrics, we can measure the effectiveness of these new features and the overall engagement of our users.

### Project requirements
* Excel 2007 (or later)
* MySQL Workbench 8.0 (or later)
* Python version: Python v.3

* Python libraries:

    * pandas
    * matplotlib
    * statsmodels
    * scikit-learn
    * seaborn (optional)

### Project files
* dataset: [data_scientist_project.sql](./data_scientist_project.sql)

    ![](/images/ER_diagram.png)

## [Part 1: Data Preparation with SQL – Creating a View (click here to see SQL query)](./data-preparation-with-SQL-creating-a-view.sql)

* Calculating a Subscription’s End Date
    * plan_id = 0 (monthly plan)
    * plan_id = 1 (quarterly plan)
    * plan_id = 2 (annual plan)
    * plan_id = 3 (lifetime plan)
    * If an order was refunded—indicated by a non-NULL value in the date_refunded field—the student’s subscription terminates at the refund date.

* Creating Two ‘paid’ Columns and a MySQL View

    The view is named "purchases_info"

    ~~~
    SELECT * FROM purchases_info
    ~~~

    ![](/images/part_1_purchases_info.png)

## [Part 2: Data Preparation with SQL – Splitting Into Periods (click here to see SQL query)](./data-preparation-with-SQL-splitting-into-periods.sql)

* Calculating Total Minutes Watched in Q2 2021 and Q2 2022
* Creating a ‘paid’ Column

### Retrieved datasets:
* Students engaged in Q2 2021 who haven’t had a paid subscription in Q2 2021 (minutes_watched_2021_paid_0.csv)
* Students engaged in Q2 2022 who haven’t had a paid subscription in Q2 2022 (minutes_watched_2022_paid_0.csv)
* Students engaged in Q2 2021 who have been paid subscribers in Q2 2021 (minutes_watched_2021_paid_1.csv)
* Students engaged in Q2 2022 who have been paid subscribers in Q2 2022 (minutes_watched_2022_paid_1.csv)

dataset example (minutes_watched_2022_paid_1.csv):

![](/images/part_2_splitting_into_periods.png)

## [Part 3: Data Preparation with SQL – Certificates Issued (click here to see SQL query)](./data-preparation-with-SQL-certificates-issued.sql)

* Studying Minutes Watched and Certificates Issued

### Retrieved datasets:
* minutes_and_certificates.csv

    ![](/images/part_3_certificates_issued.png)

## [Part 4: Data Preprocessing with Python – Removing Outliers (click here to see Python notebook)](./data-preprocessing-with-python-removing-outliers.ipynb)

* Plotting the Distributions

![](/images/part_4_distributions.png)

* Removing the Outliers:

    For each of the four datasets, keep the values lower than the 99th percentile. 

![](/images/part_4_distributions_no_outliers.png)

* Save the preprocessed data as a CSV file:
    * minutes_watched_2021_paid_0_no_outliers.csv
    * minutes_watched_2022_paid_0_no_outliers.csv
    * minutes_watched_2021_paid_1_no_outliers.csv
    * minutes_watched_2022_paid_1_no_outliers.csv

## [Part 5: Data Analysis with Excel – Hypothesis Testing ](./data-analysis-with-excel-hypothesis-testing-and-correlation-coefficients.xlsx)

* Calculating Mean and Median Values

    ![](/images/part_5_mean_median.png)

* Calculating Confidence Intervals

    ![](/images/part_5_CI.png)

    ![](/images/part_5_bar_chart_free.png)

    ![](/images/part_5_bar_chart_paying.png)

    * Interpretation:
    
        For free-plan students, there’s an increase in engagement from Q2 2021 to Q2 2022, as the confidence interval for the later period (15.41 – 16.66 minutes) is slightly higher than for the earlier one (13.55 – 14.87 minutes).

        Students with paid memberships watch substantially more than those without. This is evident by comparing the confidence intervals of the two groups in Q2 2021: (13.55 – 14.87) minutes for non-subscribers and (339.60 – 380.61) minutes for subscribers.
        
        Among the paid subscribers, there’s a decrease in engagement from Q2 2021 to Q2 2022, as the confidence interval for the later period (276.54 – 307.90 minutes) is lower than for the earlier one (339.60 – 380.61 minutes).

        Please note that these are just interpretations based on the confidence intervals, and actual cause-effect relationships need further investigation. For instance, the fact that paid subscribers watch more doesn’t necessarily mean that having a paid subscription causes them to watch more. Those who watch more are more likely to get a paid subscription. Similarly, the decrease in engagement among paid subscribers from Q2 2021 to Q2 2022 could be due to various factors that need to be explored separately.

* Performing Hypothesis Testing

    Null hypothesis: The engagement (minutes watched) in Q2 2021 is higher than or equal to the one in Q2 2022.

    Alternative hypothesis: The engagement (minutes watched) in Q2 2021 is lower than the one in Q2 2022.

    ![](/images/part_5_hypothesis_testing.png)

    Interpretation: 
    * For free-plan students, with a t-statistic of -3.95 (less than the critical value of -1.645), we would reject the null hypothesis.

        The engagement in Q2 2021 is not significantly higher than the engagement in Q2 2022 with 5% level of significance

        Rejecting the null hypothesis does not confirm the alternative hypothesis. It suggests that the data provide enough evidence againts the null hypothesis

    * For paying students, with a t-statistic of 5.15 (greater than the critical value of 1.645), we would fail to reject the null hypothesis.

        This means there’s not enough evidence to conclude that engagement in Q2 2021 is significantly higher than the engagement in Q2 2022 with 5% level of significance

        So the data supports the null hypothesis
    
    * Conclusion:

        The correctness of these hypothesis testing are crucial for avoiding false company investestment based on these tests.

        A type I error might result in over-investment in in certain features or complacency about needing to improve features.

        A type II erorr might result in potentially missing out on recognizing successful features or identifying areas that need improvement.				

## [Part 6: Data Analysis with Excel – Correlation Coefficients](./data-analysis-with-excel-hypothesis-testing-and-correlation-coefficients.xlsx)

* Calculating Correlation Coefficients

    $correlation (certificates \space vs \space minutes) = 0.51$

    ![](/images/part_6_scatter_plotpng.png)

    The correlation between Certificates and Minutes is approaximately 0.513—a strong positive correlation. It suggests that students who watch more content tend to earn more certificates.

   

## [Part 7: Dependencies and Probabilities (click here to see Python notebook)](./dependencies-and-probabilities.ipynb)

* Assessing Event Dependencies

    Two events are said to be independent if the occurrence of one does not affect the occurrence of the other. In probability terms, this is expressed as:

    $P(A \cap B) = P(A) \times P(B)$

    $0.040 \neq 0.269$

     Interpretation:
    1. Because the independence test is not fulfilled, then watching a lecture in Q2 2021 and Q2 2022 are dependent events.
    1. This means that the occurrence of one event has some influence on the occurrence of the other
    1. Since P(A) × P(B) is larger than P(A∩B), it suggests that those who watched a lecture in Q2 2021 were less likely to watch a lecture in Q2 2022 than anticipated if the two events were independent. This is to be expected. A student who has benefitted from the program in 2021 and has completed their goal is not as likely to return in 2022 and study as much.

    Conclusion:
    From this information, we should run marketing campaigns that 'resurrect' students who've been registered on the platform for a while but have not been active in a long time.

    The reason for that is to introduce such students to the new features of the platform as well as the new content in the course library. We always aim to upload new and relevant content and believe that students finished learning on the platform can still benefit the program even after some time.

* Calculating Probabilities

    $P(A | B) = 0.072$

    where,

    Event A: student watching a video in Q2 2021.
    Event B: student watching a video in Q2 2022.

    This results confirms that students who watched a lecture in Q2 2022 were unlikely to have also watched one in the same quarter of the previous year.

## [Part 8: Data Prediction with Python](./data-prediction-with-python.ipynb)

### Creating a Linear Regression
    
* I split the data into train and tests sets with a test size of 20%.

* $R^2 = 0.305$, Conclusion: 

    The value we obtained is approximately 0.305. This suggests that about 30% of the variability in the target variable (the number of certificates issued) is explained by the input variable (the number of minutes watched). This model does not account for the other 70%.

    An R-squared value of 0.305 is not a bad result, but, as we mentioned, it implies that other factors also play a role in the number of certificates issued. Let’s list them one by one.

    - One such factor, for example, includes different courses with different lengths. Therefore, a student passing three short courses will be issued three certificates, while a student passing one long course—roughly the length of three short ones—will be given only one certificate.
    - Another factor could be that some students pass exams without watching the courses. The reason could be that they are familiar with the subject and only aim for a document proving their proficiency.

    The model, therefore, provides some insight into the relationship between these two quantities, but there’s still a large portion of the variance that remains unexplained. The number of minutes watched is reasonable to include when predicting the number of certificates issued but should not be the sole factor considered.

* Model Performance

    ![](/images/part_8_model_performance.png)

    ![](/images/part_8_model_performance_difference.png)

    ![](/images/part_8_model_performance_describe.png)

* Conclusion

    This observations displays the unexpected data in which the student has only one certificate but long watching time, some possibile explanation of this occurance:

    1. The student took a very long course, resulting in the long watching time for a single certification
    1. The student don't bother finishing the course until earning the certificate

    These couple of results will be the base for determining the needed additional input variables for improving the model
