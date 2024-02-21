;Introskip - On power-on, the game now jumps right to the level loading screen instead of going through the main menu

            ORG     INTROSKIP   		; This skips straight to the title screen by changing the scene index
            LDA     #$0000      		; Saves a lot of time on power-on
			;STA		$00001A
			DS		$4					; Could not make it store a long even if explicitly told it to
			LDA     #$0002      		; Saves a lot of time on power-on
            
            ORG     $0080B9   			; Right after "INTROSKIP"
            JML		BLOCK2          	; Replacing a very early jump 
                        
            ORG     STORYFLAG   		; Disabling storymode from power-on, saving a lot of time when testing
            LDA     #$8000      		; Second byte for story mode (0 or 1), also controls in the first byte (80 or 0)
            STA     STORYMODE
            LDA     #$0000      		; Enable/Disable debug mode, 0100 to enable, 0000 to disable
            STA     DEBUGMODE
            			
			ORG		BLOCK2				; From power-on to level 1 briefing screen, but requires that some RAM values are set
			LDA		#$01FE
			TCS
			LDA		#$1827
			STA		$02
			LDA		#$8000
			STA		$08
			LDA		#$80E6
			STA		$16
			LDA		#$0080
			STA		$18
			LDA		#$00DF
			STA		$20
			LDA		#$0014
			STA		$22
			LDA		#$0B00
			STA		$5C
			LDA		#$D6A4
			STA		$5E
			LDA		#$00FA
			STA		$60
			LDA		#$0080
			STA		$0116
			LDA		#$0080
			STA		$011A
			LDA		#$B9B8
			STA		$0120
			LDA		#$0098
			STA		$0122
			LDA		#$0101
			STA		$01F4
			LDA		#$D6AC
			STA		$01F6
			LDA		#$1414
			STA		$01F8
			LDA		#$E8B1
			STA		$01FA
			LDA		#$83DE
			STA		$01FC
			LDA		#$0091
			STA		$01FE
			REP		#$FF
			SEP		#$03
			JML		$918413