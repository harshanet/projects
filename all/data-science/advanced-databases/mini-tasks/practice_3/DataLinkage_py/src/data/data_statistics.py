from restaurant import restaurant as res
import datetime
import csv_loader as csv
import measurement as measure
import pandas as pd

'''
        /*
         * Please implement the Task 1 code here, including both two sub-tasks
         */
'''


def data_statistics():
    restaurants = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Practice 3\DataLinkage\DataLinkage_py\data\restaurant.csv")
    new_york_count = 0
    new_york_city_count = 0
    res_loc_list = restaurants.iloc[:,3].tolist()

    #Task 1.1    
    for location in res_loc_list:
        if location == "new york":
            new_york_count += 1
        if location == "new york city":
            new_york_city_count += 1

    #Task 1.2
    res_loc_list_set = set(res_loc_list)
    res_loc_distinct_values = len(res_loc_list_set)

    #Printing Outputs
    print("new york,", new_york_count)
    print("new york city,", new_york_city_count)
    print("Number of distinct values in city:", res_loc_distinct_values)

data_statistics()
