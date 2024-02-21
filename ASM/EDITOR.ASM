;Custom level editor ASM patch for Toy Story SNES-U by Enmet
;Very basic functionality, press SELECT while in game to cycle between the different modes
;Currently there are 3 modes: Normal (Off) - Tile edit - Creature edit
;The tile editor currently only works in the first level
;Uses a lot of labels loaded from LABELS_US.ASM

            ORG     $16A696             ; STA, NOP out this and the camera X-pos doesnt update, so that the custom cam can be hooked up
            JSL		CAM_ON_X:
            
            ORG     $16A6C4             ; STA, NOP out this and the camera Y-pos doesnt update
            JSL		CAM_ON_Y:
            
			ORG     $00809B   			; Very early from power-on, the game sets up starting life count
            LDA		#$0000				; Setting this to 0 because we're using the life count for keeping track of objects, starting at the first
            NOP                         ; SEC
            NOP                         ; SBC $000006
            NOP
            NOP
            NOP

			ORG		BLOCKB              ; EXP
			JSR		$17FDDE
			RTL
            
            ORG     READDEBUG   		; Replaces the debug code read during the main game loop
            JSL     BLOCK1      
            NOP
            NOP
            
            ORG     PAUSE1      		; Replacing the pause menu routine and moving it into our own function
            JSL     BLOCK3      		; Jumping to the sub-routine at the unused space in ROM
            NOP                 		; Need these two NOPs to get the correct offset
            NOP
            
			ORG		PAUSE2				; Pause menu for Really Inside
			JSL		BLOCK3
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			
            ORG		BLOCK3				; Custom pause routine: While in pause menu, every button now has a custom function
			LDA		#$000A
			CMPL	LEVEL
			BNE		NORMALREAD:
			PHB							; Wrong bank, so we're switching here instead of doing longs everywhere
			PHB
			PLA
			STA		CONTINUES
			LDA		#$7E7E
			PHA
			PLB
			PLB
			LDA		$00E6				; Really Inside doesn't read the controller normally, so we have to make an exception
			BRA		REALLYREAD:
NORMALREAD: LDA		JOYPAD1
REALLYREAD: BIT		BUTTON_A
            BNE		SKIPPAUSE:
			BIT		BUTTON_R			; This is the level change function from the practice rom
			BNE		INCLEVEL:			; The practice ROM was done entirely in a HEX editor so consider this a proper "port" with documentation
			BIT		BUTTON_L
			BNE		DECLEVEL:
			BIT		BUTTON_X
			BNE		RESETLVL2:			; Reset level = Kill player to trigger the level to reload
			BIT     BUTTON_A
			BNE		RESETLVL:			; Resets level from the mission brief screen (includes decompressing level data again)
			BIT		BUTTON_B
			BNE		SKIPPAUSE:			; Changing these later
			BIT		BUTTON_Y
			BNE		RESETLVL:
			BIT		BUTTON_LEFT
			BNE		CHECKBRA:			; Branch both L and R to the same checkpoint branch, to then handle the separate button checks
			BIT		BUTTON_RIGHT
			BNE		CHECKBRA:			
			BIT		BUTTON_UP
			BNE		SKIPPAUSE:
			BIT		BUTTON_DOWN
			BEQ		SKIPPAUSE:		; Unused, this line can be either commented or left to skippause
			SEP		#$30
			PLA
			PLA
			PLA
			REP		#$30
			LDA		#$0008
			STA		LEVEL
			JML		func_LoadLevel
SKIPPAUSE:  LDAL	LEVEL
			CMP		#$000A				; Checks for Really Inside so that it can do an extra store in that pause routine
			BNE		SKIPPAUSE2:
			LDAL	$0000E6
			LDA		CONTINUES
			PHA
			PLB
			PLB
			RTL
SKIPPAUSE2:	LDA 	JOYPAD1
			STA		CONTINUES
			BIT		#$000F
			RTL			
INCLEVEL:	LDA		LEVEL				; Increases the level count by one
			CMP		#$0010				; If we're on the last level, make sure to reset the count to 0 so it properly wraps back
			BNE		INCLEVEL1:
			STZ		LEVEL
			BRA		RESETLVL2:
INCLEVEL1:	INC		LEVEL
			BRA		RESETLVL2:
DECLEVEL:	LDA		LEVEL
			BNE		DECLEVEL1:			; Branches unless it's the first level in the game
			LDA		#$0010				; If it is the first level, we want it to specifically wrap around to this value, which is the last (and not underflow)
			STA		LEVEL
			BRA		RESETLVL2:
DECLEVEL1:  DEC		LEVEL
			BRA		RESETLVL2:
RESETLVL:	BRA		CHECKKILL:
RESETLVL2:	SEP		#$30
			PLA
			PLA
			PLA
			REP		#$30
			LDA		#$0000
			LDY		#$0000
			LDX		#$0000
			JML		LEVELSKIP2
CHECKBRA:	LDX		LEVEL
			LDAL	CHECK_TBL:,x		; Load from a table containing the max amount of checkpoints for a level
			AND		#$00FF				; Table stores single bytes, but to prevent having to switch to 8-bit mode, we can clear the second byte with AND
			CMP		#$0000				; If the value from the table is 0, it means that the level doesn't have checkpoints and therefor we can skip this part
			BEQ		SKIPPAUSE:
			TAY
			LDA		JOYPAD1				; Secondary check after setting up the checkpoint value, now we read if it's forward or backwards
			BIT		BUTTON_LEFT
			BNE		DECCHECK:
			BIT		BUTTON_RIGHT
			BNE		INCCHECK:
			BRA		CHECKKILL:
INCCHECK:	CPY		CHECKPOINT
			BNE		INCCHECK2:
			STZ 	CHECKPOINT
			BRA		CHECKKILL:
INCCHECK2:  INC		CHECKPOINT
			BRA		CHECKKILL:
DECCHECK:	LDA		#$0000
			CMP		CHECKPOINT
			BNE		DECCHECK2:
			STY		CHECKPOINT
			BRA		CHECKKILL:
DECCHECK2:	DEC		CHECKPOINT
CHECKKILL:	SEP		#$30				; Set to 8-bit mode, we are going to jump away but we got here from a long subroutine
			PLA							; We need 8-bit mode so we can strip away the 3-bytes of the long address from the stack
			PLA
			PLA
			REP		#$30
			LDA		#$0000				; Probably doesn't matter but clearing registers to prevent issues after jumping 
			LDY		#$0000
			LDX		#$0000
			JML		DEATH
					; This table contains the max amount of checkpoints that each level can have, if any
CHECK_TBL:          db $00, $00, $05, $00, $00, $03, $01, $00, $00, $02, $00, $00, $02, $02, $02, $00, $00, $00
			
			
			
            ORG     BLOCK1      		; We're setting up the code at the unused location in ROM - $19F9F9
			LDA 	JOYPAD1				; Read controller
			AND		BUTTON_SELECT		; Read the select button 
			BEQ		DEBUGLOAD:			; If select has not been pressed, skip
			LDA		CONTINUES			; Compare with bit mask, bit mask gets updated at the end of the function the first time it's run
			AND		BUTTON_SELECT		; That means on the second pass, if joypad input and ctrl bit mask matches, it will branch
			BNE		DEBUGLOAD:			
			LDA		DEBUGMODE			; Read the current debug mode to know which one it should switch to next
			BNE		CMP2:				; No compare needed because if it loaded zero, it has already affected the Z-flag required for this branch
			INC		DEBUGMODE			; And because we know the value is zero here, we can just increase it by one to turn it into mode 1
			BRA		MODES:
CMP2:		CMP		#$0002				
			BNE		CMP3:				; Branches if match is not equal
			STZ		DEBUGMODE			; So far, debug mode 2 is the highest so here it needs to wrap around back to zero
			BRA		SKIPMODE:
CMP3:		LDA		#$0002				; At this point we already know that there is only one mode left so can set it to mode 2
			STA		DEBUGMODE
			BRA		MODES:
DEBUGLOAD:  LDA     DEBUGMODE   		; The different modes will be stored at the debug mode address
            BEQ     SKIPMODE:   		; If false, return
MODES:      CMP     #$0001      		; Let's check the first bit for the first mode
			BEQ		BRANCH0:			
			CMP     #$0002      		; Let's check the first bit for the second mode, etc
			BEQ		BRANCH1:
			
SKIPMODE:   LDA     JOYPAD1    	 		; Part of the original function
			STA		CONTINUES			; Update the controller bit mask before exiting
			BIT     #$000F      		; Checks for any face button?
            RTL
			
BRANCH0:
			JSR		CHECK_R:			; If true, free-look will be enabled  
			JSR     TILEVIEW:    		
			BRA		SKIPMODE:
			
BRANCH1:	CLC							; Somehow the carry flag became an issue and resulted in an extra number. So let's clear it
			LDA 	JOYPAD1				; Read controller
			AND		BUTTON_R+BUTTON_L	; Read L+R at the same time, so that they can't be activated at the same time
			BEQ		CRECOUNT2:			; If select has not been pressed, skip
			LDA		CONTINUES			; Using the bit mask because we only want this to be activated one single time during a button press
			AND		BUTTON_R+BUTTON_L	; Check for both L+R at the same time, as before, so that they can't be pressed at the same time
			BNE		CRECOUNT2:			; If any of these have already been pressed, branch from here and continue one with the function as usual
			LDA		JOYPAD1				; If L or R have been pressed for the "first time", then continue on here and actually differentiate the buttons
			BIT		BUTTON_R			; Read shoulder R
			BEQ		DECLIVES:			; Button not held = branch
			LDX		LIVES				; Start by reading the current creature count
			INX							; Increase by one right away, instead of after
			STX		LIVES				; Store the new value
			CPX		#$0030				; If the new value became too high (overflow, there can be 48 objects, so creature ID can be 0-47)
			BNE		CRECOUNT2:			; Branches unless creature count is too high
			STZ		LIVES				; If the creature count is too high, we store 0 to effectively wrap it around back to 0
			LDA		#$0000				; And of course, load zero in A to make sure it's then also loading creature number 0
			BRA		CAMSTART:
DECLIVES:	LDA		LIVES				; Load creature count, if creature count is at 0, then zero flag will affect the branch
			BNE		DECLIVES2:			; Branches if number is larger than zero, so then we can safely subtract it
			ADC		#$0030				; Here we know that the number is zero, so we're wrapping it back to the highest creature number which is 47
			STA		LIVES				; 48 is stored but DEC will inevitably happen next
DECLIVES2:	DEC		LIVES
CRECOUNT2:	LDA		#$0000
			LDX		LIVES				; Loading the creature count once again
			BEQ		CAMSTART:			; Only branches if count is zero, and creature zero does not need an offset
CRECOUNT:	ADC		#$0030				; Counting function, for every creature, add 48 bytes (because it's 48 bytes to the next creature)
			DEX			
			BNE		CRECOUNT:			; Repeat until there are no creatures left
CAMSTART:	TAY							; Transfer the offset over to the Y-register and use it to index
			LDA 	JOYPAD1				; Read controller
			AND		BUTTON_B			; Hold B to grab a creature and be able to move it around with the d-pad 
			BEQ		FOLLOWCAM:			; If B has not been pressed, skip
			LDA 	JOYPAD1				; Read controller again
			AND		BUTTON_Y			; In addition to B, holding Y gives us a "precision mode" that can only move the creature 1 pixel once per press
			BEQ		FOLLOWCAM2:
			LDA		CONTINUES			; This means that the controller bit mask is needed to make sure that function only runs once until the player releases Y
			AND		#$0F00
			BNE		FOLLOWCAM:
FOLLOWCAM2: JSR		CHECK2_R:
FOLLOWCAM:	LDA		CAM_X				; Load current camera pos
			ADC		#$0076				; We have to compare with this offset, because we want the creature to be centered and not at left edge of camera
			CMP		ENEMY1_X,y			; Compare with the current enemy position, indexed
			BPL		ADDCAM2:			; If the value is larger, branch. Else, add numbers until it matches
			ADC		#$000C				; This offset is arbitrary, but it can't be too small or too big
			CMP		ENEMY1_X,y			; Compare to the creature now with the added offset. We didn't match earlier, but is it within this range?
			BMI		ADDCAM3:			; If we're not reaching the desired value, we're branching to add more to the camera
			LDA     ENEMY1_X,y			; Here we finally load the creature value with the intention to match it with the camera
			SBC		#$007A				; Creatures X-pos start in their middle, for the camera the same value is on the very left edge. We need this offset
			STA		CAM_X				; Then we can store that subtracted value so that the creature is centered on screen (~128 pixels, 256 is the full screen)
			BRA		YPART:				; After that's done, we can finally begin doing the same procedure on the Y-axis
ADDCAM3:	LDA		CAM_X 
			ADC		#$000C				; Cam value + a few pixels units at a time, if we transition too fast, the level tiles will glitch out
			STA		CAM_X
			BRA		YPART:
ADDCAM2:	LDA		CAM_X
			SBC		#$0008
			STA		CAM_X
YPART:		LDA		CAM_Y				; Most of this part is the same as the X-axis
			ADC		#$0042
			CMP		ENEMY1_Y,y
			BPL		ADDCAM4:
			ADC		#$000C			
			CMP		ENEMY1_Y,y
			BMI		ADDCAM5:
			LDA     ENEMY1_Y,y
			SBC		#$004B
			STA		CAM_Y
			BRA		YDONE:
ADDCAM5:	LDA		CAM_Y
			ADC		#$0006
			STA		CAM_Y
			BRA		YDONE:
ADDCAM4:	LDA		CAM_Y
			SBC		#$0006
			STA		CAM_Y
YDONE:		BRL 	SKIPMODE:

BRANCH2:								; Test function as of now, increase health if debug first bit is 1
			LDA		HEALTH
			SBC		#$0001
			STA		HEALTH
			BRL		SKIPMODE:
CAM_ON_X:								; This function is replaced with the regular camera X-pos update, so that we can use it on demand
			PHA							; It's important to not ruin any other function so we're pushing this on the stack
			LDA     DEBUGMODE			; Checks for debug/cheat mode	
			BNE		SKIPCAM:			; Branches to skip cam if debug mode is on, which is a number larger than 0
			PLA							; The game was already doing something with the accumulator for the camera
			ADC		$4A					; We pulled it back so we can add it back here
			STA		$4A					; This is how the camera is supposed to operate normally 
			RTL
SKIPCAM:	PLA
			RTL
			
CAM_ON_Y:	PHA							; Same as for the camera X-pos	
			LDA     DEBUGMODE
			BNE		SKIPCAM:
			PLA
			LDA		$56
			STA		$4C
			RTL
			
TILEVIEW:	LDA 	JOYPAD1				; Read controller	; ADR: 19FB38
			AND		BUTTON_A			; Hold B to grab a creature and be able to move it around with the d-pad 
			BEQ		TILEVIEW2:			; If B has not been pressed, skip
			LDA		CONTINUES			; Using the bit mask because we only want this to be activated one single time during a button press
			AND		BUTTON_A			; Check for both L+R at the same time, as before, so that they can't be pressed at the same time
			BNE		TILEVIEW3:			; If any of these have already been pressed, branch from here and continue one with the function as usual
			LDA		CAM_X
			ADC		#$00FF
			STA		CAM_X
			BRA		TILEVIEW2:
			;LDX		#$1E04
			;JSL		$1389C6
			;JSL		BLOCKB			; EXP; Jump to the game's tile draw routine
TILEVIEW3:	LDA		WOODY_X
			STA		CAM_X
TILEVIEW2:	PHX							; Tile view mode, view and edit tiles using the controller. One tile is 32x32 pixels
			PHY
			LDX		#$0000
			LDY		#$0000
			LDA		CAM_X				; We don't know the exact position of the tile that we have in front of us, so let's start by measuring
TILESUB:	CMP		#$0020				; We're comparing the camera x-pos with the tile size. Camera X-pos 0 means left edge, 33 means tile 1 from left..
			BMI		TILESUB2:			; A cam-x value of less than 32 (0-31) means that it's aligned to the left, and we can shift to y-axis
			SBC		#$0020				; So counting from cam-x, for every 32 pixels, count one tile, and branch if comparison becomes less than a tile
			INX							; This becomes the actual tile counter in the x-axis
			BRA		TILESUB:			; Keep doing until we hit the left side of the screen
TILESUB2:	LDA		CAM_Y
TILESUB6:   CMP		#$0020
			BMI		TILESUB3:
			SBC		#$0020
			INY							; Tile counter for the y-axis
			BRA		TILESUB6:
TILESUB3:	PHX							; Pushing x-tilecount
			LDA		#$7E7E				; Need to change banks so that ADC can load directly from the table in ROM
			PHA
			PLB
			PLB
			LDX		LEVEL				; Load current level so we can use it as index for the level size table
			TYA							; Add an offset to the Y-register value, but it needs to accumulator
			ADC		#$0004				; For now: Hard-coded offset so that stars are actually placed in view and not at the top edge (camera alignment)
			TAY
			LDA		#$0000
TILESUB4:	CPY		#$0000
			BEQ		TILESUB5:
			ADC		#$00FF				; Figure out the size of the level in tiles from the indexed table
			DEY
			BRA		TILESUB4:
TILESUB5:	PLX							; Pulling x-tilecount
			INX
			INX
			INX
			LDY		LEVEL_PS			; Temporarily using an arbitrary address in RAM so that we can use the accumulator to ADC
			PHY							; Push whatever was there before onto the stack so we can restore it later
			STX		LEVEL_PS			; Store the x-tilecount here so we can add it with the accumulator
			ADC		LEVEL_PS			; Finally adding the x-tile count so at this point accumulator should have the exact tile position
			PLY
			STY		LEVEL_PS			; Restore what was stored in here before
			TAY
			SEP		#$80				; We only want to draw one tile at a time so we need to enable 8-bit mode
			LDA     CONTINUES+1     	; Read the SNES controller (in 8-bit mode, we need to +1 to get the right byte)
            BIT     #$40      			; Compare with Y
            BNE     DRAWTILE2:    		; If Y is pressed, erase mode is enabled (drawing with tile number 0)
            BIT     #$80      			; Compare with B
            BEQ     SKIPDRAW:    		; If B is pressed, erase mode is enabled (drawing with tile number 0)
DRAWTILE1:	LDA		#$7D				; Load tile type
			BRA		DRAWTILE:
DRAWTILE2:	LDA		#$00	
DRAWTILE:	STA		LEVEL_PS,y			; Store inside the tile number
SKIPDRAW:	REP		#$80			
			LDA		#$0000				; As we exit, remember to switch banks
			PHA
			PLB							; We're switching banks to RAM so we need this
			PLB
			PLY
			PLX
			RTS
			
CHECK_R:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_RIGHT      	; Compare with right-arrow
            BEQ     CHECK_U:    		; Branch if pressed
            LDA     #$0005      		; Load the current X-cam value
            ADC     CAM_X       		; Add previous value + current cam position
            STA     CAM_X       		; Stores the new value back into position
CHECK_U:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_UP      		; Compare with up-arrow
            BEQ     CHECK_L:    		; Branch if pressed
            LDA     CAM_Y       		; Load the current Y-cam value
            SBC     #$0004      		; Move camera up = Subtract Y-axis
            STA     CAM_Y       		; Stores the new value back into position
CHECK_L:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_LEFT      	; Compare with left-arrow
            BEQ     CHECK_D:    		; Branch if pressed
            LDA     CAM_X
            SBC     #$0005
            STA     CAM_X
CHECK_D:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_DOWN      	; Compare with down-arrow
            BEQ     CHECK_EXIT: 		; Branch if pressed
            LDA     #$0005
            ADC     CAM_Y
            STA     CAM_Y
CHECK_EXIT:								; This is the exit for the camera move function, it always ends here
            RTS							; We called a sub-routine to get here so let's return it			
			
CHECK2_R:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_RIGHT      	; Compare with right-arrow
            BEQ     CHECK2_U:    		; Branch if pressed
			BIT     BUTTON_LEFT      	; Compare with right-arrow
			BNE		CHECK2_U:
            LDA     ENEMY1_XE,y       	; Add previous value + current cam position
			INC	
            STA     ENEMY1_XE,y       	; Stores the new value back into position
            LDA     ENEMY1_X,y       	; Add previous value + current cam position
			INC
            STA     ENEMY1_X,y       	; Stores the new value back into position
            LDA     ENEMY1_XS,y       	; Add previous value + current cam position
			INC
            STA     ENEMY1_XS,y       	; Stores the new value back into position
            LDA     ENEMY1_RXS,y       	; Add previous value + current cam position
			INC
            STA     ENEMY1_RXS,y       	; Stores the new value back into position
            LDA     ENEMY1_RXE,y       	; Add previous value + current cam position
			INC
            STA     ENEMY1_RXE,y       	; Stores the new value back into position
CHECK2_U:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_UP      		; Compare with up-arrow
            BEQ     CHECK2_L:    		; Branch if pressed
			BIT     BUTTON_DOWN      	; Compare with right-arrow
			BNE		CHECK2_L:
			LDA     ENEMY1_YS,y       	; Load the current Y-cam value
			DEC
            STA     ENEMY1_YS,y       	; Stores the new value back into position
            LDA     ENEMY1_Y,y       	; Load the current Y-cam value
			DEC
            STA     ENEMY1_Y,y       	; Stores the new value back into position
			LDA     ENEMY1_YE,y       	; Load the current Y-cam value
			DEC
            STA     ENEMY1_YE,y       	; Stores the new value back into position
			LDA     ENEMY1_RYS,y       	; Load the current Y-cam value
			DEC
            STA     ENEMY1_RYS,y       	; Stores the new value back into position
			LDA     ENEMY1_RYE,y       	; Load the current Y-cam value
			DEC
            STA     ENEMY1_RYE,y       	; Stores the new value back into position
CHECK2_L:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_LEFT      	; Compare with left-arrow
            BEQ     CHECK2_D:    		; Branch if pressed
			BIT     BUTTON_RIGHT      	; Compare with right-arrow
			BNE		CHECK2_D:
			LDA     ENEMY1_XS,y
			DEC
            STA     ENEMY1_XS,y
            LDA     ENEMY1_X,y
			DEC
            STA     ENEMY1_X,y
			LDA     ENEMY1_XE,y
			DEC
            STA     ENEMY1_XE,y
			LDA     ENEMY1_RXS,y
			DEC
            STA     ENEMY1_RXS,y
			LDA     ENEMY1_RXE,y
			DEC
            STA     ENEMY1_RXE,y
CHECK2_D:
            LDA     JOYPAD1     		; Read the SNES controller
            BIT     BUTTON_DOWN      	; Compare with down-arrow
            BEQ     CHECK2_EXIT: 		; Branch if pressed
			BIT     BUTTON_UP      		; Compare with right-arrow
			BNE		CHECK2_EXIT:
            LDA     ENEMY1_YS,y
			INC
            STA     ENEMY1_YS,y
            LDA     ENEMY1_Y,y
			INC
            STA     ENEMY1_Y,y
            LDA     ENEMY1_YE,y
			INC
            STA     ENEMY1_YE,y
            LDA     ENEMY1_RYS,y
			INC
            STA     ENEMY1_RYS,y
            LDA     ENEMY1_RYE,y
			INC
            STA     ENEMY1_RYE,y
CHECK2_EXIT:							; This is the exit for the camera move function, it always ends here
            RTS							; We called a sub-routine to get here so let's return it

;These tables defines the size of each level, this is required for the tile editor to figure out which tile to edit
;LEVEL_SIZE_X:		    db $0100, $0100, $0200, $0020, $0040, $0100, $0400, $0020, $0200, $0020, $0000, $0040, $0200, $0100, $0400, $0020, $0200

;Split into high and low byte
;LEVEL_SIZE_X_L:		db $00, $00, $00, $20, $40, $00, $00, $20, $00, $20, $00, $40, $00, $00, $00, $20, $00
;LEVEL_SIZE_X_H:		db $01, $01, $02, $00, $00, $01, $04, $00, $02, $00, $00, $00, $02, $01, $04, $00, $02
;LEVEL_SIZE_Y:		    db $0020, $0020, $0010, $0100, $0080, $0020, $0008, $0100, $0010, $0100, $0000, $0080, $0010, $0020, $0008, $0100, $0010
