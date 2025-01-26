"""
Created on 1 May 2020

@author: shree
"""
import pandas as pd

def load_benchmark():
    try:
        #with open(r'C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book1and2_pair.csv', 'r') as f:
        benchmark = pd.read_csv(r"C:\Users\Harsha\Desktop\INFS3200\Assignments\Assignment\Assignment Dataset\dataset\Book1and2_pair.csv")
            #benchmark = f.read().splitlines() #f-measure (gold standard for providing results)
        if benchmark is None:
            print("no file.")  
        return benchmark
        
    except:
        print("Error occurred. Check if file exists")


def calc_measure(results):
    benchmark = load_benchmark()
    if len(results) == 0:
        print('Precision = 0, Recall = 0, Fmeasure = 0')
        return
    count = 0
    for pair in results:
        if pair in benchmark:
            count = count + 1
    if count == 0:
        print('Precision=0, Recall=0, Fmeasure=0')
        return
    precision = count / len(results) 
    recall = count / len(benchmark)
    f_measure = 2 * precision * recall / (precision + recall)
    print("Precision=", precision, ", Recall=", recall, ", Fmeasure=", f_measure)
    return

#load_benchmark()
calc_measure(load_benchmark())
