/*
================================================================================
PROJECT: Healthcare Operations & Patient Analytics (ER Admissions)
FILE: hospital_er_analysis.sql
AUTHOR: Mansur Mohammed
DATE: 2026-03-04
DESCRIPTION: 
    This script performs three critical functions:
    1. Schema Definition: Creates the core 'ER_Admissions' table.
    2. Executive KPIs: Calculates total volume, wait times, and admission rates.
    3. Operational Bottlenecks: Analyzes performance by Department, Hour, and Age.
================================================================================
*/

-- STEP 1: DATABASE & TABLE SETUP
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
    Admission_Flag VARCHAR(10), -- Using VARCHAR to match 'TRUE'/'FALSE' strings
    Satisfaction_Score FLOAT,
    Wait_Time_Min INT,
    Patients_CM INT
);

-- STEP 2: EXECUTIVE SUMMARY VIEW (The "Health Score")
-- -----------------------------------------------------------------------------
-- WHAT: Creates a virtual table for top-level hospital metrics.
-- WHY: Provides an instant 'pulse check' on hospital efficiency for leadership.
CREATE OR REPLACE VIEW v_executive_kpis AS
SELECT 
    -- WHAT: Counts every single row in our table.
    COUNT(*) AS Total_Patients,

    -- WHAT: Finds the average wait time and rounds it to 2 decimal places.
    ROUND(AVG(Wait_Time_Min), 2) AS Global_Avg_Wait_Time,

    -- WHAT: Calculates the percentage of patients who were actually admitted.
    -- WHY: Tells us if we are treating serious cases or minor ones.
    ROUND(SUM(CASE WHEN Admission_Flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Admission_Rate_Percentage
FROM ER_Admissions;

-- STEP 3: DEPARTMENTAL PERFORMANCE VIEW
-- -----------------------------------------------------------------------------
-- WHAT: Breaks down wait times and satisfaction by specific department.
-- WHY: Identifies the exact 'bottlenecks' where patients are getting stuck.
CREATE OR REPLACE VIEW v_department_performance AS
SELECT 
    Department_Referral,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(Wait_Time_Min), 1) AS Avg_Wait_Min,
    ROUND(AVG(Satisfaction_Score), 1) AS Avg_Satisfaction
FROM ER_Admissions
GROUP BY Department_Referral
ORDER BY Avg_Wait_Min DESC;

-- STEP 4: HOURLY PATIENT VOLUME VIEW
-- -----------------------------------------------------------------------------
-- WHAT: Extracts the hour from the timestamp to see arrival patterns.
-- WHY: Proves if the hospital needs more staff at specific times (e.g., 4 PM).
CREATE OR REPLACE VIEW v_hourly_volume AS
SELECT
