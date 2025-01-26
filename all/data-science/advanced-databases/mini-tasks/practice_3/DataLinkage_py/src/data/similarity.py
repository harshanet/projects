'''
Created on 1 May 2020

@author: shree
'''


def calc_jaccard(str1, str2, q):
    str1_tokens = tokenize(str1, q)
    str2_tokens = tokenize(str2, q)
    total_tokens = str1_tokens + str2_tokens
    total_tokens = list(set(total_tokens))
    return len(str1_tokens) + len(str2_tokens) - len(total_tokens) / len(total_tokens)


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

    return 1 - (ed / max(len(str1), len(str2)))


def calc_ed(str1, str2):

    '''
         * Please implement the calculation of edit distance between two strings
         * Dynamic programming should be used
         */
    '''
    if len(str1) > len(str2):
        str1, str2 = str2, str1

    short_string_distance = range(len(str1) + 1)
    for i2, c2 in enumerate(str2): #longer string
        long_string_distance = [i2+1]
        for i1, c1 in enumerate(str1): #shorter string
            if c1 == c2:
                long_string_distance.append(short_string_distance[i1])
            else:
                long_string_distance.append(1 + min((short_string_distance[i1], short_string_distance[i1 + 1], long_string_distance[-1])))
        short_string_distance = long_string_distance
    return short_string_distance[-1]

#print('Edit Distance = ', calc_ed("University", "Unvesty"))
#print('Jaccard Coefficient = ', calc_jaccard("University", "Unvesty", 3))
#print('Similarity', calc_ed_sim("University", "Unvesty"))