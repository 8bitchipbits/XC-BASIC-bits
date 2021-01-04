rem ; Generated by CharPad 2.7, assemble with 64TASS or similar.


rem ; Character display mode : Multi-colour (MCM).

rem ; Character colouring method : Per-Map.


rem ; Colour values...

COLR_SCREEN = 0
COLR_CHAR_DEF = 14
COLR_CHAR_MC1 = 12
COLR_CHAR_MC2 = 9


rem ; Quantities and dimensions...

CHAR_COUNT = 130
TILE_COUNT = 83
TILE_WID = 2
TILE_HEI = 2
MAP_WID = 100
MAP_HEI = 24
MAP_WID_CHRS = 200
MAP_HEI_CHRS = 48
MAP_WID_PXLS = 1600
MAP_HEI_PXLS = 384


rem ; Data block sizes (in bytes)...

SZ_CHARSET_DATA        = 1040
SZ_CHARSET_ATTRIB_DATA = 130
SZ_TILESET_DATA        = 332
SZ_MAP_DATA            = 2400


rem ; Data block addresses (dummy values)...

ADDR_CHARSET_DATA = $2000            ; block size = $0410, label = 'charset_data'.
ADDR_CHARSET_ATTRIB_DATA = $2800     ; block size = $0082, label = 'charset_attrib_data'.
ADDR_CHARTILESET_DATA = $3000        ; block size = $014c, label = 'chartileset_data'.
ADDR_MAP_DATA = $5000                ; block size = $0960, label = 'map_data'.

TILE_DATA_LEN = TILE_WID * TILE_HEI
const debug = 0
rem * INSERT EXAMPLE PROGRAM HERE! * (Or just include this file in your project).
if debug = 0 then
	poke $DD00,peek($dd00) & %11111100 | %00000011 : rem bank 0
	poke $D016,peek($D016) | %00010000 : rem multi color char mode
	poke $D018,peek($D018) & %11110001 | %00001000 : rem $2000
	poke $D020,COLR_SCREEN
	poke $D021,COLR_SCREEN
	poke $D022,COLR_CHAR_MC1
	poke $D023,COLR_CHAR_MC2
	poke $D024,COLR_CHAR_DEF
endif
rem For tiles, map is only a reference to tile. Then tile is a reference to characters.
rem memcpy ADDR_MAP_DATA,$0400,SZ_CHARSET_DATA
tile = 0
starty = 0
startx = 10

xoffset = 0
yoffset = 0
pagex = 40
pagey = pagex * TILE_HEI
rows = 12
columns = 20
y = starty
rem find nth tile by size of tile
rem print "----"
rem first block should be 0E mapped to 1B 1C 00 00
repeat rem rows
	x = startx
	xoffset = 0
	repeat rem columns
		tile = peek(ADDR_MAP_DATA + x + (y * MAP_WID)) * TILE_DATA_LEN

		counter = 0
		offsets = xoffset + yoffset
		for h = 0 to TILE_HEI - 1
			for w = 0 to TILE_WID - 1		
				poke $0400 + offsets + w + (h * pagex) , peek!(ADDR_CHARTILESET_DATA + tile + counter)
				inc counter
			next
		next
		xoffset = xoffset + TILE_WID
		inc x
		until x >= columns + startx
		yoffset = yoffset + pagey		
	inc y
until y >= rows + starty

rem paint correct colors per char
if debug = 0 then
	i = $0400
	repeat
		poke $d400 + i, peek(ADDR_CHARSET_ATTRIB_DATA + peek(i))
		inc i
	until i = 1000 + $0400
endif
loop:
goto loop

rem CHARSET IMAGE DATA...
rem 256 images, 8 bytes per image, total size is 2048 ($800) bytes.

origin $2000
incbin "Navy Seals - L1 - Harbour - Chars.bin"
origin $2800
incbin "Navy Seals - L1 - Harbour - CharAttribs.bin"
origin $3000
incbin "Navy Seals - L1 - Harbour - Tiles.bin"
origin $5000
incbin "Navy Seals - L1 - Harbour - Map (100x24).bin"