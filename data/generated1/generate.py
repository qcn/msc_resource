import random

print "gender voiced tone s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 s24 s25 s26 s27 s28 s29 s30"

# tone contours

# straight rise
tone0 = [   0,  3,  6,  9,  12, 15,
            18, 21, 24, 27, 30, 33,
            36, 39, 42, 45, 48, 51,
            54, 57, 60, 63, 66, 69,
            72, 75, 78, 81, 84, 87]

# flat with a bump towards the end
tone1 = [ 0,    0,    0,    0,    0,    0,
          0,    0,    0,    0,    0,    0,
          15,  30,   45,   60,   75,   90,
          80,  70,   60,   50,   40,   30,
          20,  10,    0,    0,    0,    0]

# independent variables

# downward slope: presence/absence of voicing
v_voice = [60.0, 50.0, 40.0, 30.0, 20.0, 10.0,
          0,    0,    0,    0,    0,    0,
          0,    0,    0,    0,    0,    0,
          0,    0,    0,    0,    0,    0,
          0,    0,    0,    0,    0,    0]

# gender: add a constant height
v_gender = [100, 100, 100, 100, 100, 100,
          100, 100, 100, 100, 100, 100,
          100, 100, 100, 100, 100, 100,
          100, 100, 100, 100, 100, 100,
          100, 100, 100, 100, 100, 100]

n = 100 # number of contours to generate
for i in xrange(n):
    # All we actually care about this time round are the speaker ID (male or female in this case), the tone and whether it's voiced.
    gender = random.randint(0,1)
    voiced = random.randint(0,1)
    tone = random.randint(0,1)

    randomness = [random.uniform(-3, 3) for x in xrange(30)]

    gender_contrib = [gender * c for c in v_gender]
    voice_contrib = [voiced * c for c in v_voice]
    if ( tone == 0 ):
        tone_contrib = tone0
    else:
        tone_contrib = tone1

    contour = [sum(t) for t in zip(tone_contrib, gender_contrib, voice_contrib, randomness)]

    print "{} {} {} {}".format(gender, voiced, tone, " ".join(map(str, contour)))
