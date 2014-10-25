lines = open("gen5.f0").readlines()
for line in lines:
	if line.split()[-1] == "uqua":
		print " ".join([str(int(x)+200) for x in line.split()[:-1]]) + " uqua"
	else:
		print line.strip()