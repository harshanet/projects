'''
Created on 1 May 2020

@author: shree
'''

#import src.oracle.DBconnect as db
import similarity as similarity
import csv_loader as csv
import measurement as measure

from restaurant import restaurant as res
import datetime


def nested_loop_by_name_jaccard():
    threshold = 0.95
    q = 3
    print('threshold', threshold)
    print('q', q)

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
    for i in range(0, len(restaurants)):
        restaurant1 = restaurants[i]
        id1 = restaurant1.get_id()
        name1 = restaurant1.get_name()
        for j in range(i + 1, len(restaurants)):
            restaurant2 = restaurants[j]
            id2 = restaurant2.get_id()
            name2 = restaurant2.get_name()
            sim = similarity.calc_jaccard(name1, name2, q) 
            if sim >= threshold: #standard/benchmark for similarity
                results.append(str(id1) + '_' + str(id2))

    end_time = datetime.datetime.now()
    time = end_time - start_time
    print("Total Time:", round(time.total_seconds() * 1000, 3), 'milliseconds')
    measure.load_benchmark()
    measure.calc_measure(results)

nested_loop_by_name_jaccard()