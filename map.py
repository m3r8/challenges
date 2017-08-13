width = 58
height = 26

maze = bytearray()
for i in range(width * height): maze.append(0)

f = open("C:/Users/m3r8/Desktop/lol.txt", "r")
buf = f.read().split("\n")
curx = 0
cury = 9
direct = -1
lasts = []
directions = [
      ( "EAST",   1,  0 ),
      ( "NORTH",  0, -1 ),
      ( "WEST",  -1,  0 ),
      ( "SOUTH",  0,  1 )
    ]
for n,l in enumerate(buf):
    print "at pos {0} from {1}".format(n, len(buf))
    if l[1] == "r":
        if l[10] == "E":
            direct = 0
        elif l[10] == "N":
            direct = 1
        elif l[10] == "W":
            direct = 2
        else:
            direct = 3
        continue
    elif l[1] == "a":
        print "pos",curx,cury
        print "make step _______________________________________________"
        curx = curx + directions[direct][1]
        cury = cury + directions[direct][2]
        lasts.append(direct)
        print "pos",curx,cury
        continue
    elif l[1] == " ":
        print "append {0} x, {1} y".format((curx+directions[direct][1]),(cury+directions[direct][2]))
        maze[(cury+directions[direct][2]) * width+curx+directions[direct][1] ]= 0x80
        continue
    elif l[1] == "t":
        print "pos",curx,cury
        print "step back--------------------------------------------------"
        s = lasts.pop()
        curx = curx - directions[s][1]
        cury = cury - directions[s][2]
        print "pos",curx,cury
    else: 
        continue

p = open("C:/Users/m3r8/Desktop/mazesolve.bin", "wb")
p.write(maze)

































raw_input()
