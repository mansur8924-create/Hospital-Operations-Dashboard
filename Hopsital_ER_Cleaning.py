"""
PROJECT: Hospital ER Data Cleaning
PURPOSE: Handling missing values and standardizing date formats for Power BI visualization.
AUTHOR: Mansur Mohammed
"""

import pandas as pd
import os

# --- STEP 1: LOAD THE DATA ---
# We use a relative path so the script works for anyone who downloads the folder.
# The file must be in the same folder as this script.
input_file = "Hospital ER_Data.csv"

try:
    df = pd.read_csv(input_file)
    print(f"Successfully loaded {input_file}")
except FileNotFoundError:
    print(f"Error: {input_file} not found in the current directory.")

# --- STEP 2: DATA CLEANING ---
# 1. Filling missing Department Referrals to avoid 'Null' errors in Power BI
df['Department Referral'] = df['Department Referral'].fillna('None')

# 2. Standardizing date formats to ensure time-intelligence functions work correctly
df['Patient Admission Date'] = pd.to_datetime(df['Patient Admission Date'], dayfirst=True)

# --- STEP 3: EXPORTING THE CLEANED DATA ---
# We save the cleaned file to the current directory for easy import into Power BI.
output_file = "Hospital_ER_Cleaned.csv"
df.to_csv(output_file, index=False)

print(f"Success! '{output_file}' has been created and is ready for dashboarding.")
