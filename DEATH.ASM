            ORG     $17DAC9     ; Checks if debug code is on, if it is, pressing select+pause skips a level
            JSL     BLOCK1       ; This will replace the check for the debug code so we jump straight to address
            NOP

;            ORG     $1093CD     ; This replaces RTS with RTL, because we need to switch banks
;            RTL                 ; Only use this for HEALTHPICK
            
;            ORG     $1093B5     ; This replaces RTS with RTL, because we need to switch banks
;            RTL                 ; Only use this for LIFEPICK
        
            ORG     $189B50     ; Disables life loss, nopes lda-dec-sta
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
