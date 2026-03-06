"""
Hospital ER Data Cleaning Script

Purpose:
    Prepare and standardize ER admissions data for Power BI analysis. 
    Handles missing values and ensures dates are in the correct format.

Author: Mansur Mohammed
"""

import pandas as pd
import os

# ------------------------------
# Step 1: Define input file
# ------------------------------
input_file = "Hospital ER_Data.csv"

# Step 2: Load the raw data
try:
    df = pd.read_csv(input_file)
    print(f"✅ Successfully loaded '{input_file}'")
except FileNotFoundError:
    print(f"❌ Error: '{input_file}' not found in the current directory.")
    exit(1)  # Stop script if file is missing

# ------------------------------
# Step 3: Handle missing values
# ------------------------------
# Fill empty 'Department Referral' entries with 'None' to avoid issues in Power BI
df['Department Referral'] = df['Department Referral'].fillna('None')

# ------------------------------
# Step 4: Standardize date format
# ------------------------------
# Convert 'Patient Admission Date' to datetime for consistent time-based analysis
df['Patient Admission Date'] = pd.to_datetime(df['Patient Admission Date'], dayfirst=True)

# ------------------------------
# Step 5: Save cleaned data
# ------------------------------
output_file = "Hospital_ER_Cleaned.csv"
df.to_csv(output_file, index=False)

print(f"✅ Cleaned data saved as '{output_file}'. Ready for Power BI dashboards!")
