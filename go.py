def openfile():
	f = open("C:/Users/m3r8/Desktop/a/elf.bin", "rb")
	return f

def decodeelf(file):
	endf = open("C:/Users/m3r8/Desktop/ch.bin", "wb")
	bytarr2 = bytearray()
	bytarr = bytearray(file.read())
	it = 1
	while it < len(bytarr):
                print it
		if it >= len(bytarr)- 1:
			endf.write(bytarr2)
			return 
		else:
			if chr(bytarr[it]) == "*":
				if bytarr[it + 1] == 0x0a:
					bytarr2.append(bytarr[it-1])
					bytarr2.append("*")
				else:
                                    for i in range((bytarr[it+1] - 28)):
						bytarr2.append(bytarr[it - 1])
				it += 3
			 elif chr(bytarr[it-1]) == "}":
                            if bytarr[it] != 0x5D:
                                it += 1
                                continue
                            else:
                                bytarr2.append(bytarr[it - 1])
                                it += 2
                                continue
			else:
				bytarr2.append(bytarr[it - 1])
				it += 1

p = openfile()
decodeelf(p)
raw_input()
		
