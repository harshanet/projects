#from book import Book3 as book3
import datetime
#import csv_loader_assignment as csv
#import measurement_values as measure
import pandas as pd

'''
        /*
         * Please implement the Task 1 code here, including both two sub-tasks
         */
'''


def data_statistics():
    #restaurants = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Practice 3\DataLinkage\DataLinkage_py\data\restaurant.csv")
    book1 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book1.csv")
    book2 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book2.csv")
    #book3 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book3.csv")
    book4 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book4.csv")
    book_pair = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book1and2_pair.csv")
    #restaurants = csv.csv_loader()
    #print(restaurants)
    #print('hello', restaurants)
    multiple_of_100_count = 0
    NULL_field_count = 0
    #row_book3_multiple_of_100 = book3.iloc[:,0].tolist() #building function in pandas for row finding
    #row_only = book3.iloc[:,0]
    #print(row_only)
    #col_book_3_index = book3.iloc[0, :].tolist() #building function in pandas for column finding
    #print(book3)
    #print(book3.iloc[0, :])
    #print(row_book3_multiple_of_100)
    
    #print(res_loc)
    #GOOD ATTEMPT

    # Initialise dataframe for Question 6
    book3 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book3.csv")
    # book3.iloc[:, 0] % 100 == 0 refers to the indexing of finding 
    # the number of rows that correlate with being a multiple of 100  
    question_6_df = book3[book3.iloc[:, 0] % 100 == 0] 

    # Question 6.1 & 6.2
    print('(rows, cols) by convention:', question_6_df.shape)
    print('rows = count of multiple of 100 IDs:', question_6_df.shape[0])
    print('cols = within specified rows:', question_6_df.shape[1])
    print('count of NULL fields = total number of deflects sum in the reduced dataframe:', question_6_df.isna().sum().sum())

    #Question 6.3
    total_number_deflects = question_6_df.isna().sum().sum()
    sample_size = question_6_df.shape[0]
    number_of_deflect_opportunities = question_6_df.shape[1]
    dpmo_empo_null = (total_number_deflects / (sample_size * number_of_deflect_opportunities)) * 1000000
    print('DPMO/EMPO:', dpmo_empo_null, 'deflects/errors per 1 000 000 opportunities')
    
    """
    for id in row_book3_multiple_of_100:
        if id % 100 == 0:
            #book3_filtered = row_only.query(id % 100 == 0)
            #rslt_df = book3[book3[row_only] % 100]
            multiple_of_100_count += 1
            #print(multiple_of_100_count) #37
            if id is None:
                NULL_field_count += 1
                #print(NULL_field_count) #0

    #print(rslt_df)

    
    print('cols', len(col_book_3_index)) #17
    print('rows', multiple_of_100_count) #37

    # DPMO = total number of deflects in a sample
    # /(sample size x number of defect opportunities per unit in the sample)

    sample_size = multiple_of_100_count #rows
    number_of_deflect_opportunities = len(col_book_3_index) #cols

    # total_number_deflects = 0    
    # for i in col_book_3_index:
    #     #print(i)
    #     #print(row_book3_multiple_of_100)
    #     if i == "nan":
    #         total_number_deflects += 1
    #         print('deflects', total_number_deflects)
    
    print('sample size (rows)', sample_size) #rows
    print('number of deflect opportunities (cols)', number_of_deflect_opportunities) #cols
    print('total deflect number', total_number_deflects) #null values in rows
    dpmo = (total_number_deflects / (sample_size * number_of_deflect_opportunities)) * 1000000
    print('DPU', dpmo/1000000)
    print('DPMO', dpmo, 'deflects per 1 000 000 opportunities')
    #print(book3.isna().sum().sum())
    

    

    print("mutliple of 100 count in book 3,", multiple_of_100_count)
    print("NULL field count in book3 out of multiple of 100,", NULL_field_count) 

    #print("Number of distinct values in city:", num_values) #49
    """

data_statistics()
