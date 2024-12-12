import pandas as pd

activities_file = 'FC_ACTIVITY.csv'
activities_df = pd.read_csv(activities_file)

def enforce_trainer_limit(df, trainer_column, max_occurrences=2):
    grouped = df.groupby(trainer_column).apply(lambda x: x.head(max_occurrences))

    return grouped.reset_index(drop=True)

filtered_activities_df = enforce_trainer_limit(activities_df, 'main_trainer_id', max_occurrences=2)

filtered_activities_df.to_csv('filtered_activities.csv', index=False)

print("Filtered dataset saved to 'filtered_activities.csv'.")
