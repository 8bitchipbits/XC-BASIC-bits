print "{CLR}"
rem 10-bit lfsr - optimized by dz
rem seed (1 < s < 1023)
DATA co[] = 0,11,12,15,1,15,12,11
DATA ch[] = 230, 81, 90, 219, 32, 160, 102, 218, 209, 86, 214, 87, 215
n = 0
col = 0
newcol = 0
while n = 0
thiscol = newcol
for i = 0 to 12
newcol = newcol + 1
if newcol = 8 then newcol = 0
poke 53281, co[thiscol]
rem col = cast!(rnd%() * 16)
s = 1001
docycle:
a = 0
rem get 10th bit for tap
if (s & 512) = 512 then a = 1
b = 0
rem get 7th bit for tap
if (s & 64) = 64 then b = 1
rem shift and discard msb
s = (s*2) & 1023
rem shift in the lsb (set if a xor b)
if a <> b then s = s +1
rem only values < 1000 are visible
if s < 1001  then
poke s+1023,ch[i]
poke s+55295,co[newcol]
endif
rem continue until we finish the cycle
if s <> 1001 then goto docycle
next i
endwhile

