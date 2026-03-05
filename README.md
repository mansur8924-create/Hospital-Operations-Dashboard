# Hospital-Operations-Dashboard
📌 Project Overview
This project focuses on optimizing hospital operations by analyzing patient inflow, wait times, and departmental efficiency. Using a combination of SQL for data extraction and Power BI for advanced visualization, I transformed raw healthcare records into an interactive executive dashboard. This tool allows hospital administrators to identify bottlenecks in patient care and improve resource allocation.

🛠️ Tools & Technologies
SQL: Used to query the primary healthcare database, join patient tables, and calculate key performance indicators (KPIs).

Power BI: Used to build the interactive front-end, utilizing DAX (Data Analysis Expressions) for time-based intelligence.

Data Modeling: Established relationships between Patient, Provider, and Appointment tables to ensure data integrity.

📂 Project Structure
Database Querying: SQL scripts designed to pull "Length of Stay" and "Readmission Rates."

Data Transformation: Cleaning inconsistent date formats and handling missing provider information within Power BI.

Dashboard Design: Creating a user-friendly interface with filters for Department, Date Range, and Patient Demographics.

📊 Key Insights & Features
Wait Time Analysis: Identified that the Emergency Department experienced a 20% spike in wait times on Monday mornings.

Patient Satisfaction: Correlated shorter consultation times with lower patient feedback scores.

Resource Optimization: Highlighted under-utilized operating rooms during mid-week shifts, suggesting a schedule reorganization.

🚀 How to Use
SQL Scripts: Run the .sql files provided in this repository to see how the data was aggregated.

Power BI File: Open the .pbix file to interact with the dashboard. (Note: You may need to refresh the data source links).

Documentation: Review the Hospital_Analysis_Summary.pdf for a deep dive into the business recommendations.
