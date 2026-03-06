/*
================================================================================
PROJECT: ER Operations & Patient Analytics
AUTHOR: Mansur Mohammed
DATE: 2026-03-04
FILE: hospital_er_analysis.sql
DESCRIPTION: 
    This script sets up the ER admissions database and generates key views for:
      1. High-level hospital KPIs
      2. Department performance metrics
      3. Hourly patient volume patterns for staffing insights
================================================================================
*/

-- STEP 1: Database & Table Setup
-- ----------------------------------------------------------------------------- 
USE Hospital_Analytics;

-- Table: ER_Admissions
-- Stores individual patient admission details including demographics, wait times, satisfaction, and department.
CREATE TABLE IF NOT EXISTS ER_Admissions (
    Patient_Id VARCHAR(50),
    Admission_Date DATETIME,
    First_Initial VARCHAR(5),
    Last_Name VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    Race VARCHAR(100),
    Department_Referral VARCHAR(100),
    Admission_Flag VARCHAR(10), -- 'TRUE' if admitted, 'FALSE' otherwise
    Satisfaction_Score FLOAT,   -- Patient satisfaction rating
    Wait_Time_Min INT,          -- Time spent in ER before being seen
    Patients_CM INT             -- Optional clinical measure count
);

-- STEP 2: Executive Summary View
-- ----------------------------------------------------------------------------- 
-- WHAT: High-level hospital KPIs
-- WHY: Gives leadership a quick overview of ER efficiency and patient outcomes
CREATE OR REPLACE VIEW v_executive_kpis AS
SELECT 
    COUNT(*) AS Total_Patients, -- Total patients recorded
    ROUND(AVG(Wait_Time_Min), 2) AS Global_Avg_Wait_Time, -- Average wait time across all patients
    ROUND(
        SUM(CASE WHEN Admission_Flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2
    ) AS Admission_Rate_Percentage -- % of patients admitted
FROM ER_Admissions;

-- STEP 3: Department Performance View
-- ----------------------------------------------------------------------------- 
-- WHAT: Metrics broken down by department
-- WHY: Identifies bottlenecks and areas needing staffing or process improvements
CREATE OR REPLACE VIEW v_department_performance AS
SELECT 
    Department_Referral,
    COUNT(*) AS Patient_Count,                    -- How many patients each department saw
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min, -- Average wait time per department
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction -- Average patient satisfaction
FROM ER_Admissions
GROUP BY Department_Referral
ORDER BY Avg_Wait_Min DESC; -- Departments with longest waits first

-- STEP 4: Hourly Patient Volume View
-- ----------------------------------------------------------------------------- 
-- WHAT: Counts patient arrivals by hour
-- WHY: Helps schedule staff during peak periods
CREATE OR REPLACE VIEW v_hourly_volume AS
SELECT
    EXTRACT(HOUR FROM Admission_Date) AS Admission_Hour, -- Hour of patient arrival
    COUNT(*) AS Patient_Count,                            -- Total patients per hour
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min,        -- Average wait time by hour
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction -- Satisfaction per hour
FROM ER_Admissions
GROUP BY Admission_Hour
ORDER BY Admission_Hour; -- Chronological order from midnight to 23:00
