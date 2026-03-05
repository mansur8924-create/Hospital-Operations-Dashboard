import pandas as pd

# Use the full path you just copied
df = pd.read_csv(r"C:\Users\mansu\OneDrive\Desktop\Data Analyst Boot Camp\Data Analyst Projects\Hospital Dashboard(project)-SQL,Power BI\Hospital ER_Data.csv")

# Now let's do the cleaning we discussed
df['Department Referral'] = df['Department Referral'].fillna('None')
df['Patient Admission Date'] = pd.to_datetime(df['Patient Admission Date'], dayfirst=True)

# Save the cleaned file to the same folder
df.to_csv(r"C:\Users\mansu\OneDrive\Desktop\Data Analyst Boot Camp\Data Analyst Projects\Hospital Dashboard(project)-SQL,Power BI\Hospital_ER_Cleaned.csv", index=False)

print("Success! The cleaned file has been created.")