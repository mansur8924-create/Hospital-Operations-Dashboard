"""
PROJECT: Hospital ER Data Cleaning
PURPOSE: Handling missing values and standardizing date formats for Power BI visualization.
AUTHOR: Mansur Mohammed
"""

import pandas as pd
import os

input_file = "Hospital ER_Data.csv"

try:
    df = pd.read_csv(input_file)
    print(f"Successfully loaded {input_file}")
except FileNotFoundError:
    print(f"Error: {input_file} not found in the current directory.")

# Filling missing Department Referrals to avoid 'Null' errors in Power BI
df['Department Referral'] = df['Department Referral'].fillna('None')

# Standardizing date formats to ensure time-intelligence functions work correctly
df['Patient Admission Date'] = pd.to_datetime(df['Patient Admission Date'], dayfirst=True)

# save the cleaned file to the current directory for easy import into Power BI.
output_file = "Hospital_ER_Cleaned.csv"
df.to_csv(output_file, index=False)

print(f"Success! '{output_file}' has been created and is ready for dashboarding.")

