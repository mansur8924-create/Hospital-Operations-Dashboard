USE Hospital_Analytics;
CREATE TABLE IF NOT EXISTS ER_Admissions (
    Patient_Id VARCHAR(50),
    Admission_Date DATETIME,
    First_Initial VARCHAR(5),
    Last_Name VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    Race VARCHAR(100),
    Department_Referral VARCHAR(100),
    Admission_Flag VARCHAR(10),
    Satisfaction_Score FLOAT,
    Wait_Time_Min INT,
    Patients_CM INT
);
SELECT * FROM ER_Admissions LIMIT 10;
SELECT 
    -- WHAT: Counts every single row in our table.
    -- WHY: To tell the hospital exactly how many patients arrived in total.
    COUNT(*) AS Total_Patients,

    -- WHAT: Finds the average of the wait time column and rounds it to 2 decimal places.
    -- WHY: This is the hospital's 'health score.' If this number is high, the hospital is 'sick' and slow.
    ROUND(AVG(Wait_Time_Min), 2) AS Global_Avg_Wait_Time,

    -- WHAT: A 'conditional sum.' It gives a '1' to people who stayed and a '0' to those who left.
    --       It then divides that sum by the total number of people and multiplies by 100.
    -- WHY: This calculates the Admission Rate. It tells us if we are treating serious cases or minor ones.
    ROUND(SUM(CASE WHEN Admission_Flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Admission_Rate_Percentage

-- WHAT: Tells the computer which 'filing cabinet' (table) to look in.
FROM ER_Admissions;

SELECT 
    -- WHAT: Selects the name of the department (like Cardiology or Orthopedics).
    Department_Referral,

    -- WHAT: Counts how many people went to that specific department.
    -- WHY: To see which part of the hospital is the busiest.
    COUNT(*) AS Patient_Count,

    -- WHAT: Calculates the average wait time just for that specific department.
    -- WHY: To identify the 'bottleneck'—the place where people are stuck waiting the longest.
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min,

    -- WHAT: Calculates the average satisfaction score, ignoring the empty (NULL) spots.
    -- WHY: To see if long wait times are making people unhappy in that specific area.
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction

-- WHAT: Tells the computer to look in our main admissions table.
FROM ER_Admissions

-- WHAT: Tells the computer to put patients into 'piles' based on their department.
-- WHY: Without this, the computer would try to average everyone together instead of department-by-department.
GROUP BY Department_Referral

-- WHAT: Sorts the list so the department with the longest wait is at the very top.
-- WHY: So the boss knows exactly which department needs help first.
ORDER BY Avg_Wait_Min DESC;

SELECT 
    -- WHAT: This 'extracts' only the hour (0 to 23) from the full date and time.
    -- WHY: We don't care if it was Monday or Tuesday; we want to see the pattern of the clock.
    HOUR(Admission_Date) AS Hour_of_Day,

    -- WHAT: Counts how many people arrived during that specific hour.
    COUNT(*) AS Patient_Volume,

    -- WHAT: Calculates how long people waited during that specific hour.
    -- WHY: Often, more people means longer waits. This proves if we need more staff at 4 PM.
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait

-- WHAT: Points the computer to our dataset.
FROM ER_Admissions

-- WHAT: Tells the computer to group everyone who arrived at 1 PM together, 2 PM together, etc.
GROUP BY Hour_of_Day

-- WHAT: Organizes the results from Midnight (0) to 11 PM (23).
-- WHY: So the chart in our dashboard looks like a smooth timeline.
ORDER BY Hour_of_Day;

SELECT 
    -- WHAT: A 'logic switch.' If the age is under 18, label them 'Minor.' If over 64, label them 'Senior.'
    -- WHY: A list of 9,000 different ages is messy. Three simple groups are easy for a boss to understand.
    CASE 
        WHEN Age < 18 THEN '0-17 (Minor)'
        WHEN Age BETWEEN 18 AND 64 THEN '18-64 (Adult)'
        ELSE '65+ (Senior)'
    END AS Age_Group,

    -- WHAT: Counts how many people fall into each age bucket.
    COUNT(*) AS Total_Patients,

    -- WHAT: Finds the average wait time for each age group.
    -- WHY: To see if we are making seniors wait longer than children, which might be a problem.
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait

-- WHAT: Points the computer to the source table.
FROM ER_Admissions

-- WHAT: Groups the data by the labels we just created (Minor, Adult, Senior).
GROUP BY Age_Group;