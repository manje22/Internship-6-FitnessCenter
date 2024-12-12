import pandas as pd


activity_df = pd.read_csv(r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Data_sets\Activity_data_set.csv')
helper_trainers_df = pd.read_csv(r'C:\Users\uvodi\OneDrive\Desktop\DUMP_Internship\domaciRad\SQL-6\Seed\activity_helper_trainers.csv')

merged_df = pd.merge(helper_trainers_df, activity_df[['id', 'main_trainer_id']], left_on='activity_id', right_on='id', how='left')

filtered_helper_trainers_df = merged_df[merged_df['trainer_id'] != merged_df['main_trainer_id']]

filtered_helper_trainers_df = filtered_helper_trainers_df.drop(columns=['main_trainer_id', 'id'])

filtered_helper_trainers_df.to_csv('filtered_activity_helper_trainers.csv', index=False)

print("ok")
