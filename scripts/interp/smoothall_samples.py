# smooth everything

from scipy.signal import butter
from scipy.signal import filtfilt
#from scipy.signal import array
from numpy import array

import sys

def nonzero(list):
    for item in list:
        if item == 0:
            return False
    return True

def int_smooth(f0vals):
    i = 0
    f0s = []
    while (i < len(f0vals)):
        if (f0vals[i] == 0):
            st = i
            i += 1
            while ((i < len(f0vals)) and (f0vals[i] == 0)):
                i += 1
            en = i
            if (st <> 0) and (en <> len(f0vals)):
                # do interpolation
                beg = f0vals[st-1]
                end = f0vals[en]
                for m in range(st, en):
                    f0 = beg + (end-beg)/(en-st+1)*(m-st+1)
                    f0s.append(f0)
            #the 0s at the beginning and the the end
            else:
                for k in range(st, en):
                    f0s.append(f0vals[k])
        else:
            f0s.append(f0vals[i])
            i += 1

    print f0s

    #smoothing
    i = 0
    while (f0s[i] == 0):
         i += 1
    j = len(f0s) - 1
    while (f0s[j] == 0):
        j -= 1
    [b, a] = butter(3, 0.1)
    print i, j
    y = filtfilt(b, a, array(f0s[i:j+1]))

    new_f0s = []

    for k in range(0, i):
        new_f0s.append(0.0)
    for k in range(len(y)):
        new_f0s.append(y[k])
    for k in range(j+1, len(f0s)):
        new_f0s.append(0.0)
    print new_f0s
    return new_f0s



# in and outfiles
infile = sys.argv[1]
outfile = sys.argv[2]

out = open(outfile, "w")

lines = open(infile).readlines()

#write header
out.write(lines[0])

for line in lines[1:]:
    f0_values = [float(x) for x in line.split()[1:]]
    rowno = line.split()[0]
    out.write(rowno + " ")
    # interpolate
    new_f0s = int_smooth(f0_values)
    out.write(" ".join(["{0:.2f}".format(round(x,2)) for x in new_f0s]) + "\n")

out.close()
    
