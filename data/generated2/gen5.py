import random

k1 = 3
k2 = (-3)
k3 = 3
c = 100

def addnoise(f0s):
	return [x + random.randint(0,3) for x in f0s]

# generate 10 +ve linear things

for i in range(100):
	a = [k1 * x + c - 50 for x in range(30)]
	a = addnoise(a)
	print " ".join([str(x) for x in a]) + " rise"


# generate 10 -ve linear things
for i in range(100):
	a = [k2 * x + c + 50 for x in range(30)]
	a = addnoise(a)
	print " ".join([str(x) for x in a]) + " fall"

# generate 10 flat
for i in range(100):
	a = [c for x in range(30)]
	a = addnoise(a)
	print " ".join([str(x) for x in a]) + " flat"

# generate quadratic
for i in range(100):
	a = [0.5 * (x-14.5)**2 + 49.875 for x in range(30)]
	a = addnoise(a)
	print " ".join([str(int(x)) for x in a]) + " quad"

# generate upside down quadratic
for i in range(100):
	a = [-1*(0.5 * (x-14.5)**2 + 49.875) for x in range(30)]
	a = addnoise(a)
	print " ".join([str(int(x)) for x in a]) + " uqua"

# generate same constant quadratic
for i in range(100):
	a = [0.5 * (x-14.5)**2 + 100 for x in range(30)]
	a = addnoise(a)
	print " ".join([str(int(x)) for x in a]) + " 100q"


# generate flatter quadratic
for i in range(100):
	a = [0.2 * (x-14.5)**2+80  for x in range(30)]
	a = addnoise(a)
	print " ".join([str(int(x)) for x in a]) + " qua2"

# generate cubic
for i in range(100):
	a = [0.05*x*(x-14.5)*(x-29)+100 for x in range(30)]
	a = addnoise(a)
	print " ".join([str(int(x)) for x in a]) + " cube"
