rem Character display mode : Multi-colour (MCM).
rem Character colouring method : Per-Character.

rem Colour values...

COLR_SCREEN = 8
COLR_CHAR_DEF = 11
COLR_CHAR_MC1 = 0
COLR_CHAR_MC2 = 1

rem Quantities and dimensions...

CHAR_COUNT = 256
MAP_WID = 40
MAP_HEI = 25

rem Data block sizes (in bytes)...

SZ_CHARSET_DATA        = 2048
SZ_CHARSET_ATTRIB_DATA = 256
SZ_MAP_DATA            = 1000

rem Data block addresses (dummy values)...

ADDR_CHARSET_DATA = $1000            ; block size = $0800, label = 'charset_data'.
ADDR_CHARSET_ATTRIB_DATA = $2000     ; block size = $0100, label = 'charset_attrib_data'.
ADDR_MAP_DATA = $5000                ; block size = $03e8, label = 'map_data'.

rem * INSERT EXAMPLE PROGRAM HERE! * (Or just include this file in your project).
poke $dd00,peek($dd00) & %11111100 | %00000011 : rem bank 0
poke $d016,peek($d016)|16 : rem multi color char mode
poke $d018,peek($d018) & %11110001 | %00001000 : rem $2000
poke $d020,COLR_SCREEN
poke $d021,COLR_SCREEN
poke $d022,COLR_CHAR_MC1
poke $d023,COLR_CHAR_MC2
poke $d024,COLR_CHAR_DEF


memcpy $5000,$0400,$800

for i = 0 to 999
	poke$d800+i,peek($4000+peek($0400+i)) : rem paint correct colors
next

loop:
goto loop

rem CHARSET IMAGE DATA...
rem 256 images, 8 bytes per image, total size is 2048 ($800) bytes.

origin $2000
incbin "mymap - Chars.bin"
origin $4000
incbin "mymap - CharAttribs.bin"
origin $5000
incbin "mymap - Map (40x25).bin"
