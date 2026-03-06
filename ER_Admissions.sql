/*
================================================================================
PROJECT: ER Operations & Patient Analytics
FILE: hospital_er_analysis.sql
AUTHOR: Mansur Mohammed
DATE: 2026-03-04
DESCRIPTION: 
    This script sets up ER admissions data and generates views for:
    1. Hospital-level KPIs
    2. Department performance
    3. Hourly patient volume patterns
================================================================================
*/

-- STEP 1: Database & Table Setup
-- ----------------------------------------------------------------------------- 
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
    Admission_Flag VARCHAR(10), -- 'TRUE'/'FALSE' strings
    Satisfaction_Score FLOAT,
    Wait_Time_Min INT,
    Patients_CM INT
);

-- STEP 2: Executive Summary View
-- ----------------------------------------------------------------------------- 
-- Provides high-level KPIs for leadership review
CREATE OR REPLACE VIEW v_executive_kpis AS
SELECT 
    COUNT(*) AS Total_Patients, -- Total patients in the ER
    ROUND(AVG(Wait_Time_Min), 2) AS Global_Avg_Wait_Time, -- Average wait time
    ROUND(SUM(CASE WHEN Admission_Flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Admission_Rate_Percentage -- % admitted
FROM ER_Admissions;

-- STEP 3: Department Performance
-- ----------------------------------------------------------------------------- 
-- Shows patient count, avg wait time, and satisfaction by department
CREATE OR REPLACE VIEW v_department_performance AS
SELECT 
    Department_Referral,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min,
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction
FROM ER_Admissions
GROUP BY Department_Referral
ORDER BY Avg_Wait_Min DESC;

-- STEP 4: Hourly Patient Volume
-- ----------------------------------------------------------------------------- 
-- Identifies busy hours for staffing and resource planning
CREATE OR REPLACE VIEW v_hourly_volume AS
SELECT
    EXTRACT(HOUR FROM Admission_Date) AS Admission_Hour,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min,
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction
FROM ER_Admissions
GROUP BY Admission_Hour
ORDER BY Admission_Hour;
