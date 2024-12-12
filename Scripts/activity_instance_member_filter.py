import pandas as pd

# Read the CSV files into DataFrames
file_paths = [
    r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_instance_member.csv',
    r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_instance_member (1).csv',
    r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_instance_member (2).csv',
    r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_instance_member (3).csv',
    r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_instance_member (4).csv'
]

dfs = [pd.read_csv(file) for file in file_paths]


merged_df = pd.concat(dfs, ignore_index=True)

merged_df.drop_duplicates()

merged_df.to_csv('filtered_activity_instance_member.csv', index=False)

print("Merged data saved to 'merged_output.csv'")
