'''
Created on 1 May 2020

@author: shree
'''

#import src.oracle.DBconnect as db
import ed_calculation_detail as ed_calculation_detail
import csv_loader_assignment as csv
import measurement_values as measure

from restaurant import restaurant as res
import datetime
import pandas as pd


def nested_loop_by_name_jaccard():
    threshold = 0.75 #change these values with 5 options 0.75 (0-1)
    q = 3 #change these values with 5 options 3 (length of string thing)

    '''
    con=db.create_connection()
    cur=db.create_cursor(con)
    string_query = "SELECT * FROM RESTAURANT";
    cur.execute(string_query);
    restaurants=[];
    for rid ,name, address, city  in cur:
        restaurant = res()
        restaurant.set_id(rid);
        restaurant.set_name(name);
        restaurant.set_address(address);
        restaurant.set_city(city);
        restaurants.append(restaurant)
        
    cur.close();
    con.close();
    '''
    restaurants = csv.csv_loader()
    results = []
    restaurant1 = res()
    restaurant2 = res()
    id1 = 0
    id2 = 0
    name1 = None
    name2 = None
    start_time = datetime.datetime.now()
    book1 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book1.csv")
    book2 = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book2.csv")
    for i in range(0, len(book1)):
        book1 = book1[i]
        id1 = book1.get_id()
        name1 = book1.get_name()
        for j in range(i + 1, len(book2)):
            book2 = book2[j]
            id2 = book2.get_id()
            name2 = book2.get_name()
            sim = ed_calculation_detail.calc_jaccard(name1, name2, q) 
            if sim >= threshold: #standard/benchmark for similarity
                results.append(str(id1) + '_' + str(id2))

    end_time = datetime.datetime.now()
    time = end_time - start_time
    print("Total Time:", round(time.total_seconds() * 1000, 3), 'milliseconds')
    measure.load_benchmark()
    measure.calc_measure(results)
    print('results', results)

    #compared and constrast 
    #result of the compare and constrast (restaurant_pair.csv to result_list)
    # effect the threshold = 1(empty list)
    # effect the threshold = 0 (two strings that have no similaries)

    #nested for loop to compare the two lists


# End of function
print("Hello World")
nested_loop_by_name_jaccard()


#random string = 'hello'
#value (q) = 3
# hel
# ell
# llo
