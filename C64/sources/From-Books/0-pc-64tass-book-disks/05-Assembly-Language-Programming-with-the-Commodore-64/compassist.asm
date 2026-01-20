*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
                jmp main
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                jsr     scrmaninit
                lda     vicii+$16
                ora     #%00001000
                sta     vicii+$16
                lda     #vblanc
                sta     bascol
                lda     #$80
                sta     curcol
                lda     #vnoir
                sta     vicbackcol
                lda     #vnoir
                sta     vicbordcol
                jsr     cls
                lda     #$20
                ora     #%00000000
                ldy     #$04
                ldx     #$04
                jsr     memfill
                lda     #$00
                ldy     #$d8
                jsr     memfill
goagain         jsr     setinverse
                ldx     #<bstring1 
                ldy     #>bstring1
                jsr     putscxy
                ldy     #$00
nextcar         lda     bstring2,y
                beq     nomore
                jsr     chrout
                iny
                jmp     nextcar
nomore          jsr     gettwo
                ;jsr     display
                rts
               .enc    "screen"
bstring1       .byte   vblanc,bkcol3,0,0        
;                                 111111111122222222223333333333
;                       0123456789012345678901234567890123456789    
               .text   "---> Programme de test pour exemple <---"
               .byte   0
bstring2       .byte   19,17,05,0
               
               .bend
opa     =       $fb
opb     =       $fc
temp    =       $02 ; unused byte in page 0 

*=$c100
gettwo          jsr ioinit      ; initialise io devices
                lda #$0d        ; carriage return
                jsr chrout      ; 
                jsr rdbyte      ; get a hex number
                sta opa         ; store in opa
                lda #$11
                jsr chrout
getone          jsr rdbyte      ; get second hex number
                sta opb         ; store in opb
                jsr display
                rts
rdbyte          jsr getin       ; get a key code
                cmp #$00        ; is code 0
                beq rdbyte      ; yes, try again
                sta temp        ; store code there
                jsr chrout      ; print to screen
                lda temp        ; get code again
                jsr ashex       ; convert to hex
                asl             ; shift right order nibble
                asl
                asl
                asl
                sta temp        ; save the high nibble
wait            jsr getin       ; get second key code
                cmp #$00        ; if 0
                beq wait        ; try again
                pha             ; code to stack
                jsr chrout      ; print code
                pla             ; code from stack
                jsr ashex       ; convert to hex
                ora temp        ; combine both nibbles
                sta temp        ; store the hex number
                ldx #$06        ; insert 6 spaces
back            lda #$20        ; ascii space
                jsr chrout      ; output space
                dex
                bne back
                ldx #$08        ; bit counter
                lda temp        ; get number
                sta $97         ; store number there
br3             asl $97         ; shift into carry   
                lda #$00   
                adc #$30        ; add ascii for "0"
                jsr chrout      ; print bit value
                dex
                bne br3
                lda #$0d        ; output a
                jsr chrout      ; carriage return
                lda temp
                rts
ashex           cmp #$40        ; digit or letter
                bcs br1 
                and #$0f        ; digit, mask high nibble
                bpl br2         ; branch if not a letter
br1             sbc #$37        ; letter, substract $37
br2             rts
;*=$c16c

display         php             ; save flags on stack
                pha             ; put a on stack
                php             ; save p again
                pla             ; load p into a
                ldx #$08
                sta $fe
                pla             ; get a back from the stack
                pha             ; put it on the stack again
                sta temp
br4             lda #$20        ; ascii space
                jsr chrout
                dex
                bne br4
                ldx #$08        ; count 8 bits
br5             asl temp        ; shift bit into carry
                lda #$00        ; clear a
                adc #$30        ; add ascii for "0"
                jsr chrout      ; output it
                dex
                bne br5
                lda #$0d        ; output a 
                jsr chrout      ; carriage return
                lda #$0d        ; output a 
                jsr chrout      ; carriage return
                ldx #$08                
br6             lda #$20
                jsr chrout
                dex
                bne br6
                ldx #$08
br7             asl $fe
                lda #$00
                adc #$30
                jsr chrout
                dex
                bne br7
                lda #$0d        ; output a 
                jsr chrout      ; carriage return
                ldx #$08                
br8             lda #$20
                jsr chrout
                dex
                bne br8           
                lda #'N'
                jsr chrout
                lda #'V'
                jsr chrout
                lda #$20
                jsr chrout
                lda #'B'
                jsr chrout
                lda #'D'
                jsr chrout
                lda #'I'
                jsr chrout
                lda #'Z'
                jsr chrout
                lda #'C'
                jsr chrout
                lda #$0d
                jsr chrout
                pla
                plp
                rts
waitkey         php                
                pha
loaf            jsr getin
                beq loaf
                pla
                plp
                rts
                
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "c64_map_kernal.asm"
               .include "c64_map_vicii.asm" 
               .include "c64_map_basic2.asm"
               .include "c64_lib_pushpop.asm"
               .include "c64_lib_mem.asm"
               .include "c64_lib_hex.asm"
;               .include "c64_lib_text_sd_new.asm"
               .include "c64_lib_text_mc.asm"
               .include "c64_lib_showregs.asm"                
               ;.include "c64_lib_joystick.asm"
               ;.include "c64_lib_spriteman.asm"
               ;.include "c64_lib_tmpjb.asm"
                
