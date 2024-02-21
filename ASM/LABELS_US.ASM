;SNES addresses			
JOYPAD1			=	$004218     ; Controller 1 address     

;Button press definitions
BUTTON_A      	= 	#$0080
BUTTON_X      	= 	#$0040
BUTTON_L      	= 	#$0020
BUTTON_R      	= 	#$0010
BUTTON_B      	= 	#$8000
BUTTON_Y      	= 	#$4000
BUTTON_SELECT 	= 	#$2000
BUTTON_START  	= 	#$1000
BUTTON_UP     	= 	#$0800
BUTTON_DOWN   	= 	#$0400
BUTTON_LEFT   	= 	#$0200
BUTTON_RIGHT  	= 	#$0100

;Labels to useful functions
LOADTILES       =   $118494
CREATUREL       =   $118561
DEATH           =   $189B45
GAME_OVER       =   $12F99A
DEATH2          =   $12F926 
LEVELDONE       =   $12F95E
CONTINUE        =   $88B939
LEVELSKIP       =   $17DAC9
LEVELSKIP2      =   $12F997
LOADLEVEL       =   $12F8DC
GAME_DONE       =   $12F917
HEALTHPICK      =   $1093C0
LIFEPICK        =   $1093A6
STARTLEVEL      =   $11B6B3
STARTL2         =   $118C0B
ETCHTEXT        =   $0BDA4E
STORYTEXT       =   $1FDE59
PAUSE1          =   $17DAB3
PAUSE2          =   $03F57E
INTROSKIP       =   $0080AB
STORYFLAG       =   $00806D
READDEBUG       =   $17E37A
TESTADR         =   $17E277

;These are blocks of memory that are unused at the end of banks, useful for storing custom data
BLOCK1		    =   $19F9F9
BLOCK2		    =   $1DFF56
BLOCK3		    =   $1EFE08
BLOCK4		    =	$3EF6E9
BLOCK5		    =	$37FDC3
BLOCK6		    =	$11FE10
BLOCK7		    =	$07F97D
BLOCK8		    =	$03F9E3
BLOCK9		    =	$02F0EA
BLOCKA		    =   $01F37D
BLOCKB		    =	$17FE7B

            ; Establish the existing RAM locations, all zero page values are likely used but currently unknown
            ; Unknown values are filled with empty spaces
            ; While some variables don't need anything beyond a half byte (such as the level index, tops at 15)
            ; It is still stored and loaded as a word (16-bit or 2-bytes) variable. 
DEBUGMODE		=	$7E0004		; Debug/cheat mode (star spin mode)
STORYMODE		=	$7E0008		; Turns story-line on or off
CONTROLS		=	$7E0009		; Controller variable (0 or 80)
STARLEVEL		=	$7E000A		; Stars collected for the current level
SCREEN_INDEX	=	$7E000E		; 0-0x14, decides whether to load Etch-n-Sketch or Game Over or Continue, etc
STARTOTAL		=	$7E0010		; Stars collected in total
CONTINUES		=	$7E0012		; Originally the variable for continues
CHECKPOINT		=	$7E0014		; Current checkpoint reached
LEVEL			=	$7E001A    	; Current level index
HEALTH			=	$7E001C     ; Woody's HP
LIVES			=	$7E001E		; Woody's lives

TILE_ROM_PTR	=	$7E0028		; Pointer for tile data read from ROM (D63D2A, or ROM 0x163D2A) (02A is the LO-byte of this adr)
LEVEL_PTR		=	$7E002C		; Pointer for tile data written to RAM, in this address, the address to tile RAM is stored (4B20-6B1F)
LEVEL_SIZE		=	$7E002E		; 0x2000 address, this is where the decompression tree is built
LEVEL_UNKNOWN	=	$7E0030		; On first pass, 0x007E (126) is loaded here (Bank?) 
TILE_LO			=	$7E0033		; Tile data after it has been read from ROM (LO-byte)
TILE_HI			=	$7E0035		; Tile data after it has been read from ROM (HI-byte)
LEVEL_UNKNOWN2	=	$7E0037		; Unknown decompression pointers
LEVEL_UNKNOWN3	=	$7E0039		;
LEVEL_UNKNOWN4	=	$7E003B		;  
LEVEL_UNKNOWN5	=	$7E003D		; 
TILE_PTR_RAM	=	$7E0043		; Pointer for tile data reading from earlier pos in RAM then writing to later pos in RAM
TILE_DATA		=	$7E0045		; Pointer for tile data written to RAM, compared to 2C this contains the actual tile value
LEVEL_UNKNOWN6	=	$7E0047		; Index offset used for 7E2000

DEBUG_L			=	$7E0004		; Debug byte split into two, low and high byte
DEBUG_H			=	$7E0005
	
TIMER_3D		=	$7E0046		; Timer for Really Inside the Claw Machine
	
CAM_X			=	$7E004A  	; Camera X-pos         
CAM_Y			=	$7E004C 	; Camera Y-pos 

DOOM_X			=	$7E00BA		; X-pos for Really Inside    
DOOM_Y			=	$7E00BE 	; Y-pos for Really Inside
DOOM_VEL		=	$7E00C1 	; Velocity for Really Inside

FRAMES			=	$7E00D0 	; Frame counter

JUMPSTATUS		= 	$7E0108		; Woody's jump status
WHIPSTATUS		=	$7E0110		; Woody's whip status

OBJ_ENABLE		=	$7E0114		; Believed trigger objects on or off (set 0 to turn off)

CTRLMASK		=	$7E0148		; Bit mask for controller inputs
CTRLMASK2		=	$7E0158     ; There are more than one bit masks

BORDER_XS		=	$7E015A		; Level Border (X-start) 
BORDER_XE		=	$7E015C		; Level Border (X-end)
BORDER_YS		=	$7E015E		; Level Border (Y-start)
BORDER_YE		=	$7E0160		; Level Border (Y-end)       

WOODY_IFRAMES	=	$7E01A2		; Woody's cooldown after getting hit (invincibility frames)

TRAIN_CHUG		=	$7E021C		; Train chug cooldown
TIMER_HELLO		=	$7E0244		; Hello timer for Really Inside the Claw Machine

PICKUP_X		=	$7E0601		; Pickup X-pos, pickups start at 0x0600, 32-bytes per pickup
PICKUP_Y		=	$7E0604		; Pickup Y-pos
PICKUP_GRAV		=	$7E060A		; Pickup gravity
PICKUP_SPR		=	$7E060E		; Pickup sprite
PICKUP_PAL		=	$7E060F		; Pickup palette

								; Creatures (NPCs), 48 bytes of attributes with a limit of 48 creatures per level
ENEMY1_X		=	$7E0A00   	; X-position of the first creature, Following values also only apply to creature 1
ENEMY1_Y		=	$7E0A02    	; Y-position of the first creature
ENEMY1_XS		=	$7E0A04    	; X-position start, creature moves gradually from X-start to X-end (look at trains)
ENEMY1_YS		=	$7E0A06   	; Y-position start
ENEMY1_RXS		=	$7E0A08   	; X-position render zone start, dictates how far the creature is rendered
ENEMY1_RYS		=	$7E0A0A   	; Y-position render zone start
ENEMY1_RXE		=	$7E0A0C  	; X-position render end
ENEMY1_RYE		=	$7E0A0E   	; Y-position render end
ENEMY1_PAL		=	$7E0A10   	; Creature color palette
ENEMY1_F		=	$7E0A12   	; Current creature animation frame
ENEMY1_FS		=	$7E0A14   	; Current creature animation speed
ENEMY1_ID		=	$7E0A16   	; Creature index
ENEMY1_XE		=	$7E0A18    	; X-position end
ENEMY1_YE		=	$7E0A1A   	; Y-position end
ENEMY1_U1		=	$7E0A1C   	; Unknown value 1
ENEMY1_U2		=	$7E0A1E   	; Unknown value 2
ENEMY1_HOX		=	$7E0A20   	; Hitbox X-offset
ENEMY1_HOY		=	$7E0A22   	; Hitbox Y-offset
ENEMY1_HSX		=	$7E0A24   	; Hitbox X-size
ENEMY1_HSY		=	$7E0A26   	; Hitbox Y-size
ENEMY1_U3		=	$7E0A28   	; Unknown value 3
ENEMY1_CD		=	$7E0A2A   	; Creature cool-down (the time it takes for it to recover from being whipped)
ENEMY1_U4		=	$7E0A2C   	; Unknown value 4
ENEMY1_U5		=	$7E0A2E   	; Unknown value 5

SPRITE_X		=	$7E1500		; Sprite X-pos, sprites start at 0x1500
SPRITE_Y		=	$7E1501		; Sprite Y-pos
SPRITE_U		=	$7E1502		; Sprite Y-pos
SPRITE_F		=	$7E1503		; Sprite flags?

WOODY_X			=	$7E1730		; Woody's X-pos
WOODY_Y			=	$7E1734		; Woody's Y-pos

WOODY_SPR_F		=	$7E1764		; Woody's sprite flags (HI-byte: b0 = horizontal orientation, b1 = vertical, last four bits = pal) (LO-byte unknown)

WOODY_X_SPEED	=	$7E1780		; Woody's X-velocity
WOODY_Y_SPEED	=	$7E1784		; Woody's Y-velocity

								; Buzz variables in the order he appears (Ego = Buzz, Nightmare = Buzz2, Battle = Buzz3, etc..)
BUZZ2_ANIM		=	$7E2920		; Buzz's animation (Nightmare Buzz)
BUZZ2_TELE		=	$7E2922		; Buzz's teleport status (Nightmare Buzz)
BUZZ4_ANIM4		=	$7E2928		; Buzz's animation (Food and Drink)
BUZZ_X			=	$7E292A		; Buzz's X-pos (Ego Check)
BUZZ2_X			=	$7E292C		; Buzz's X-pos (Nightmare Buzz)
BUZZ_Y			=	$7E292E		; Buzz's Y-pos (Ego Check)
BUZZ4_CROUCH	=	$7E2930		; Crouch status for Food and Drink
BUZZ2_RING		=	$7E2934		; Buzz's ring sequence animation (Nightmare Buzz)
BUZZ2_SHOT_X	=	$7E2938		; Buzz's laser's X-position
BUZZ3_X			=	$7E293A		; Buzz's X-pos (Buzz Battle)
BUZZ3_X_SPEED	=	$7E2946		; Buzz's X-velocity (Buzz Battle)
CLAW_HP			=	$7E294A		; The Claw's health
BUZZ3_HP		=	$7E296E		; Buzz's health (Buzz Battle)
BUZZ2_HP		=	$7E29D2		; Buzz's health (Nightmare Buzz)

TIMER_CONTINUE	=	$7E2978		; Timer for the continue screen

TIMER_ALERT_1	=	$7E29DE		; Timer for Red Alert, stored in three different digits
TIMER_ALERT_2	=	$7E29E0
TIMER_ALERT_3	=	$7E29E2
            
RC_HEALTH		=	$7E29F3		; RC-battery bar
RC_X			=	$7E2A08		; RC X-pos
RC_Y			=	$7E2A0C		; RC Y-pos
			
TILE_GFX_PS		=	$7E2B20		; Tilemap graphics pointer start. This is where the tilemap for graphics are stored
								; SNES format (from right to left) 16-bits per character (8x8 pixels)
								; 10 bits for (A)ddress location in VRAM
								; 3 bits for (C)olor pallette, 1 bit for (P)riority, 1 each for (H)orizontal and (V)ertical rientation
								; Like this: VHPCCCAAAAAAAAAA, remember little-endian	
LEVEL_PS		=	$7E4B20		; Level pointer start. This is the very first byte of a standard level in the game. Can use this for indexing tiles
COLL_PS			=	$7E6B20		; Tile collision segment. Similar to previous pointers, this area contains the data for tiles, but this time it's collision.
			
TILE_VRAM_PS    =	$7F8000		; For level 1, this is where the actual bit plane data is stored     

;Function definitions
func_LoadLevel	=	$12F8DC				; From here, check what the level index is, do some stuff then jump to one of the level load functions below
func_EtchSketch	=	$0BE929				; Loads the Etch-n-Sketch mission brief gfx routine. If commented out, mission brief is black, but still works
func_loadAudio	=	$19E8C2				; Audio routine, load A as index and jump into this to load the proper music track
func_deCompress = 	$138333				; Decompression routine, used to decompress RNC data packets
func_gfxPara	=	$118BE5				; Graphics routine that sets up the parallax tiles for the level
func_gfxTiles	=	$17E432				; Graphics routine that sets up the graphics for regular tiles in the level
func_gfxFloor	=	$10F345				; Graphics routine for the parallax floor tiles
func_tileCol	=	$19B644				; Handles tile properties such as collision. If commented out, tiles are shown but insolid

;Level functions (jumps from "LoadLevel" to one of these, LoadLevel clears RAM and sets up values correctly)
lvl01_Load		=	$118413				; Load level - That Old Army Game
lvl02_Load		=	$11B792				; Load level - Red Alert!
lvl03_Load		=	$12D499				; Load level - Ego Check
lvl04_Load		=	$13F1DA				; Load level - Nightmare Buzz
lvl05_Load		=	$14C352				; Load level - A Buzz Clip
lvl06_Load		=	$138F42				; Load level - Revenge Of The Toys
lvl07_Load		=	$11C170				; Load level - Run, Rex, Run!
lvl08_Load		=	$11F681				; Load level - Buzz Battle
lvl09_Load		=	$11CA00				; Load level - Food And Drink
lvl10_Load		=	$12DC69				; Load level - Inside The Claw Machine
lvl11_Load		=	$13AC9E				; Load level - Really Inside The Claw Machine *(Special case)
lvl12_Load		=	$11EDC5				; Load level - The Claw!
lvl13_Load		=	$139988				; Load level - Sid's Workbench
lvl14_Load		=	$11E557				; Load level - Battle Of The Mutant Toys
lvl15_Load		=	$11D426				; Load level - Roller Bob
lvl16_Load		=	$19F244				; Load level - Light My Fire
lvl17_Load		=	$14D20E				; Load level - Rocket Man

;RNC packs - Most of the game data is compressed through the RNC format (starting with ASCII "RNC" string)
RNC_L01_Tiles 	=	$163D19
RNC_L02_Tiles 	=	$13390D
RNC_L03_Tiles 	=	$240000
RNC_L04_Tiles 	=	$33B433
RNC_L05_Tiles 	=	$286248
RNC_L06_Tiles 	=	$1ABB81
RNC_L07_Tiles 	=	$137B19
RNC_L08_Tiles 	=	$2025F4
RNC_L09_Tiles 	=	$138000
RNC_L10_Tiles 	=	$124902
;RNC_L11_Tiles 	=	            ;Really Inside the Claw Machine (3D level = no tiles)
;RNC_L12_Tiles 	=	            ;The Claw, I've yet to figure out how the tile map works in this level...
RNC_L13_Tiles 	=	$118000
RNC_L14_Tiles 	=	$1DF5FD
RNC_L15_Tiles 	=	$184EC0
RNC_L16_Tiles 	=	$3580E8
RNC_L17_Tiles 	=	$307431

RNC_L01_TMAP	=	$1630ED				; Tilemaps
RNC_L02_TMAP	=	$132D99	

RNC_L02_TGFX	=	$130000				; Tile graphics
