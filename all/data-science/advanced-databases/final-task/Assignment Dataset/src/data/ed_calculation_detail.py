'''
Created on 1 May 2020

@author: shree
'''


def calc_jaccard(str1, str2, q):
    str1_tokens = tokenize(str1, q)
    str2_tokens = tokenize(str2, q)
    total_tokens = str1_tokens + str2_tokens
    total_tokens = list(set(total_tokens))
    return (len(str1_tokens) + len(str2_tokens) - len(total_tokens)) / len(total_tokens)


def tokenize(string, q):
    if q != 0:
        if len(string) < q:
            str_tokens = [string]
        else:
            str_tokens = [string[i:i + q] for i in range(0, len(string) - q + 1, 1)]
        return list(set(str_tokens))
    else:
        str_tokens = string.split(" ")
        return list(set(str_tokens))


def calc_ed_sim(str1, str2):
    if str1 == str2:
        return 1
    ed = calc_ed(str1, str2)
    print('Edit Distance =', ed)
    return ed
    #return 1 - (ed / max(len(str1), len(str2)))


def calc_ed(str1, str2):
    ed = 0

    '''
         * Please implement the calculation of edit distance between two strings
         * Dynamic programming should be used
         */
    '''
    if len(str1) > len(str2):
        str1, str2 = str2, str1
        #print('first str', str1)
        #print('second str', str2)
        
        #print(max((len(s1), len(s2))))

    distances = range(len(str1) + 1)
    for i2, c2 in enumerate(str2): #longer string
        longer_string_distances_ = [i2+1]
        for i1, c1 in enumerate(str1): #shorter string
            if c1 == c2:
                longer_string_distances_.append(distances[i1])
            else:
                longer_string_distances_.append(1 + min((distances[i1], distances[i1 + 1], longer_string_distances_[-1])))
        distances = longer_string_distances_
        ed = distances[-1]
    #max_string_length = max(abs(len(str1)), abs(len(str2)))
    out2 = calc_jaccard(str1, str2, 2)
    print("Jaccard Coefficient =", out2)
   
    #loop to edit distance
    #build table and fill values
    #edit distance on right bottom 
    
    # for i in str1:
    #     for j in str2:
    #         if str1[-1] == str2[-1]:
    #             ed[i][j] = ed[i-1][j-1]
    #         elif str1[-1] != str2[-1] and str1 == str1-str1[-1]:
    #             ed[i][j] = ed[i-1][j-1] + 1
    #         elif str1[-1] != str2[-1]:
    #             ed[i][j] = ed[i-1]    


    return ed

#calc_ed("Richmond Shee, Kirtikumar Deshpande and K. Gopalakrishnan", 
#        "K. Gopalakrishnan, Kirtikumar Deshpande and Richmond Shee")
print(calc_ed_sim("Richmond Shee, Kirtikumar Deshpande and K. Gopalakrishnan", "K. Gopalakrishnan, Kirtikumar Deshpande and Richmond Shee"))
#calc_ed("hello", "helloddd")
#jaccard coefficent, not sure why haha