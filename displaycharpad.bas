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

ADDR_CHARSET_DATA = $2000            ; block size = $0800, label = 'charset_data'.
ADDR_CHARSET_ATTRIB_DATA = $2C00     ; block size = $0100, label = 'charset_attrib_data'.
ADDR_MAP_DATA = $2800                ; block size = $03e8, label = 'map_data'.

rem * INSERT EXAMPLE PROGRAM HERE! * (Or just include this file in your project).
poke $DD00,peek($dd00) & %11111100 | %00000011 : rem bank 0
poke $D016,peek($D016) | %00010000 : rem multi color char mode
poke $D018,peek($D018) & %11110001 | %00001000 : rem $2000
poke $D020,COLR_SCREEN
poke $D021,COLR_SCREEN
poke $D022,COLR_CHAR_MC1
poke $D023,COLR_CHAR_MC2
poke $D024,COLR_CHAR_DEF

memcpy ADDR_MAP_DATA,$0400,SZ_CHARSET_DATA

for i = 0 to SZ_MAP_DATA
	poke $d800 + i, peek(ADDR_CHARSET_ATTRIB_DATA + peek($0400 + i)) : rem paint correct colors
next

loop:
goto loop

rem CHARSET IMAGE DATA...
rem 256 images, 8 bytes per image, total size is 2048 ($800) bytes.

origin $2000
incbin "mymap - Chars.bin"
origin $2800
incbin "mymap - Map (40x25).bin"
origin $2C00
incbin "mymap - CharAttribs.bin"
