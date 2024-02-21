;Level skip - While paused in-game, the next and previous level can be jumped to by pressing R or L respectively.
;Jumps directly to the loading screen of the next level. Levels can still be skipped by pressing select in the pause menu.
;The player can jump between checkpoints by pressing left or right in the pause menu. Respawning can also be done with the face buttons.
;This patch was originally written in a HEX editor as a practice ROM for speed running, so that levels can be easily reset and the player can jump between levels and checkpoints.

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