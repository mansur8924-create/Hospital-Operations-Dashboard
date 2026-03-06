"""
Hospital ER Data Cleaning Script
Purpose: Clean and standardize ER data for Power BI analysis.
Author: Mansur Mohammed
"""

import pandas as pd
import os

# Input file
input_file = "Hospital ER_Data.csv"

# Load data
try:
    df = pd.read_csv(input_file)
    print(f"Loaded '{input_file}' successfully.")
except FileNotFoundError:
    print(f"Error: '{input_file}' not found in the current directory.")
    exit(1)  # Stop execution if file not found

# Fill missing values in 'Department Referral' column
df['Department Referral'] = df['Department Referral'].fillna('None')

# Convert admission date to standard datetime format
df['Patient Admission Date'] = pd.to_datetime(df['Patient Admission Date'], dayfirst=True)

# Save cleaned data for Power BI
output_file = "Hospital_ER_Cleaned.csv"
df.to_csv(output_file, index=False)

print(f"Cleaned data saved as '{output_file}'. Ready for Power BI dashboard.")

