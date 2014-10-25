import sys, os

original =  open("all.f0")

original.readline() # use up the header

print "t1 t2 t3 t4 t5 spk1 spk2 spk3 spk4 spk5 spk6 spk7 spk8 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 s24 s25 s26 s27 s28 s29 s30"

for line in original.readlines():
    s1 = s2 = s3 = s4 = s5 = s6 = s7 = s8 = 0
    t1 = t2 = t3 = t4 = t5 = 0

    data = line.split()
    speaker = data[0]
    tone = int(data[9])
    f0 = data[11:]

    f0line = " ".join(f0)

    if speaker == 'S1':
        s1 = 1
    elif speaker == 'S2':
        s2 = 1
    elif speaker == 'S3':
        s3 = 1
    elif speaker == 'S4':
        s4 = 1
    elif speaker == 'S5':
        s5 = 1
    elif speaker == 'S6':
        s6 = 1
    elif speaker == 'S7':
        s7 = 1
    else:
        s8 = 1

    if tone == 1:
        t1 = 1
    elif tone == 2:
        t2 = 1
    elif tone == 3:
        t3 = 1
    elif tone == 4:
        t4 = 1
    else:
        t5 = 1

    print "{} {} {} {} {} {} {} {} {} {} {} {} {} {}".format(t1, t2, t3, t4, t5, s1, s2, s3, s4, s5, s6, s7, s8, f0line)
