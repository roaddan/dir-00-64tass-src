;-------------------------------------------------------------------------------
                Version = "20230330-234225"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                
                .include    "header-c64.asm"
                .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    none
main            .block
                jsr scrmaninit
                jsr help
                jsr anykey
                jmp b_warmstart
                rts
                .bend
                 
help            .block      
                jsr cls
                #print line
                #print headera
                #print headerb
                ; #print line
                #print shortcuts
                #print line
                #print helptext
                ;#print line
                rts                                
headera                       ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d
                .text          "          ISBN 0-7156-1899-7"
                .byte   $0d,0

headerb         .text          "              copy (p64)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
                .byte   $0d
                .text          "     programmed by Daniel Lafrance."
                .byte   $0d
                .text   format("        Version: %s.",Version)
                .byte   $0d,0

shortcuts       .text          " -------- S H O R T - C U T S ---------"
                .byte   $0d
                .text   format(" run=SYS%5d, help=SYS%5d",main, help)
                .byte   $0d
                .text   format(" cls=SYS%5d",cls)
                .byte   $0d,0

line            .text          " --------------------------------------"
                .byte   $0d,0
                .bend
helptext        .text          " Copy :"
                .byte   $0d 
                .text   format("    SYS%5d,adress, no. of pages",copy)
                .byte   $0d
                .text   format("    SYS%5d,8192,16",copy)
                .byte   $0
                .text   format("    SYS%5d,12288,4",copy)
                .byte   $0d,0

*=$6000

copy            .block
                jsr b_chk4comma ; $aefd : Check for coma.
                jsr b_frmnum    ; $ad8a ; Evaluate numeric expression and/or ...
                                ;         ... check for data type mismatch
                jsr b_getadr    ; $b7f7 ; Convert Floating point number to ...
                                ;         ...an Unsighed TwoByte Integer.
                lda $14         ; Integer line number value LSB <LINNUM
                sta $fb         ; zeropage 1 low byte
                lda $15         ; Integer line number value LSB >LINNUM
                sta $fc         ; zeropage 1 high byte
                jsr b_chk4comma ; $aefd : Check for coma.
                jsr b_getacc1lsb; $b79e ; Get Acc#1 LSB in x.
                txa             ; X -> A
                cmp #17         ; Ptr to last string in temp string stack LASTPT
                bcc more        ; If less than 17 pages, do-it
                jmp b_fcerr     ; $b248 ; Print ILLEGAL QUANTITY error message.
more            sta $fd         ; zeropage 2 low byte
                lda #$00        ; set up a ...
                sta temp        ; ... counter.
                ldy #$00        ; set offset pointer
                lda #$00        ; starting at page offset 0
                sta $fe         ; zeropage 2 high byte
                lda #$d0        ; 
                sta $ff         ; Basic temp data for floating point conversion.
                lda #$00        ; prepating the cia1 register to ...
                sta cia1cra     ; $dc0e   ; 56334 cia1 control register A
                lda #51         ; ... get access to the character rom ...
                sta $01         ; ... and changing the CPU address mode.
loop            lda ($fe),y     ; transfer data from rom to ...
                sta ($fb),y     ; ... ram
                iny             ; point to the next byte
                bne loop        ; loop if page is not finish
                inc temp        ; We increment the page counter and ...
                lda temp        ; ... we compare it to see if we 
                cmp $fd         ; ... are to the last page.
                bcs fin         ; If so, we quit.
                inc $fc         ; 
                inc $ff
                jmp loop
fin             lda #55         ; We are setting the CPU to it'a normal  ... 
                sta $01         ; ... adressing mode and replacing port A ...
                lda #$01        ; of the CIA1 to it's normal operation.
                sta cia1cra     ; $dc0e   ; 56334 cia1 control register A
                rts
temp            .byte   0
                .bend
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 