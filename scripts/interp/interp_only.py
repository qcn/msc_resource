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

    return f0s



# in and outfiles
infile = sys.argv[1]
outfile = sys.argv[2]

out = open(outfile, "w")

lines = open(infile).readlines()

#write header
out.write(lines[0])

for line in lines[1:]:
    f0_values = [float(x) for x in line.split()[1:]]
    if nonzero(f0_values):
        # write back to file
        out.write(line)
    else:
        print line
        rowno = line.split()[0]
        print rowno
        out.write(rowno + " ")
        print f0_values
        # interpolate
        new_f0s = int_smooth(f0_values)
        out.write(" ".join(["{0:.2f}".format(round(x,2)) for x in new_f0s]) + "\n")

out.close()
    
