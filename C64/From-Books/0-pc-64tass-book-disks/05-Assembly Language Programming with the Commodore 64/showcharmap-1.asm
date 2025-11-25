;----------------------------------------------------------------------
; Fonction .: showcharmap
; Auteur ...: Daniel Lafrance
; Date .....: 2022-04-01
; Révision .: 0.0.1
; ---------------------------------------------------------------------
; Description:
; Affiche le bitmap des caracrtères choisi par un nombre hexadecimal
; entré au clavier. Le Bitmap est affiché par des 
;    '#' qui représentent des 1 
;       et des 
;    ' ' qui représentent des 0 
; dans une boite de 8x8 caractères.
; ---------------------------------------------------------------------
; Démarrage par Basic 2.0 
            *=          $801
            .word (+),  10
            .null $9e,  "2061"
            + .word     0
            .enc    "screen"    ; Chaines encodé en code écran $01="A"
            jmp     main
temp    =   $02
hours   =   $dc0b
minuts  =   $dc0a
secnds  =   $dc09
tenths  =   $dc08
cursorx     .byte   00
cursory     .byte   00
prompt      .text   "PETSCII:$"        
            .byte   0       
charmap     .byte   0,0,0,0,0,0,0,0
chars       .byte   $20,$23
x2bnlow     .byte   0 
 
main        .block
            jsr push
            lda #$00        ; Efface ... 
            sta $d020       ; ... l'écran et le pourtour 
            sta $d021       ; ... le pourtour en noir.
            lda #$01        ; Choisi le blanc pour les 
            sta 646         ; ...  prochains caractères.
            lda #%00010101  ; Choisi écran 0, Déf. car. 0101
            sta 53272       ; ... REG pointeur mémoire VicII.
            lda #147        ; Déplace le curseur à la position 0,0 ...
            jsr chrout      ; ... et efface l'écran.
            ldy #3          ; Valeur de départ, un "C" pour Commodore.
printit     jsr printymap   ; Affiche le bitmap du caractère
            lda #157        ; Recule le curseur de 2 espaces
            jsr chrout      ;  pour repositionner le curseur 
            jsr chrout      ;  d'entrée.
            jsr getbyt      ; Lecture Hexadécimal du prochain caractère
            ldy x2bnlow     ; Récupère le code binaire entré.
            cpy #$00        ; Si ce n'est pas $00 ...
            bne printit     ; ... on retourne l'afficher et on recommence.
nxtchar     jmp here        ; Une boucle qui affiche tous les caractères. 
            iny             ; ...
            jsr printymap   ; ...
            bne nxtchar     ; de "A" à $ff
here        ldy #0
            lda around+1
            pha
around      lda ctabl
            jsr chrout
            inc around+1    ; Self modified code
            iny 
            cpy #$10
            bne around
            ;jmp around
            pla
            sta around+1
            jsr pop
            rts
            .bend
            
printymap   .block
            jsr push        ; Sauvegarde tous
            lda #19         ; Place le curseur ...
            jsr chrout      ; ... à la position 0,0.
            jsr get_map     ; Récupère le bitmap du caractère.
            jsr grfchar     ; Affiche le bitmap.
            tya             ; sauvegarde le Y
            pha
            lda #<prompt    ; Affiche ...
            ldy #>prompt    ; ...
            jsr b_puts      ; ... l'invite.
            pla             ; Récupère Y ... 
            jsr prbyte      ; et l'afficha en Hexadécimal
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
grfchar     .block
            jsr push
            jsr topline
            ldy #$00
            ldx #$00
nxtline     
            lda #$5     ;
            sta 646     ; Change la couleur
            lda #167
            jsr chrout
            lda #$7
            sta 646     ; Change la couleur
            jsr grfbyte        
            lda #$5
            sta 646     ; Change la couleur
            lda #165
            jsr chrout
            lda #$1
            sta 646     ; Change la couleur
            lda #$0d        
            jsr chrout
            inx
            cpx #$08
            bne nxtline
            jsr botline
            jsr pop
            rts
            .bend
;----------------------------------------------------------------------
; Affiche la ligne du dessus du carré 
;----------------------------------------------------------------------
topline     .block
            jsr push
            lda #$5
            sta 646     ; Change la couleur
            lda #$20
            jsr chrout            
            lda #$08
            sta numcar
            lda #164
            sta car2prn
            jsr putncar
            lda #$1
            sta 646     ; Change la couleur
            lda #$0d
            jsr chrout
            jsr pop
            rts
            .bend
;----------------------------------------------------------------------
; Affiche la ligne du dessous du carré 
;----------------------------------------------------------------------
botline     .block
            jsr push
            lda #$20
            jsr chrout            
            lda #$5
            sta 646     ; Change la couleur
            lda #$08
            sta numcar
            lda #163
            sta car2prn
            jsr putncar
            lda #$1
            sta 646     ; Change la couleur
            lda #$0d
            jsr chrout
            jsr pop
            rts
            .bend

putncar     .block
            lda car2prn
            ldx numcar
nextcar     jsr chrout
            dex
            bne nextcar
            rts
            .bend
car2prn     .byte   0
numcar      .byte   0
;-----------------------------------------------------------
; Ne numéro du caractère dans X
;-----------------------------------------------------------
bigcar      .block
            jsr push
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
; Pour copier le map du caractère
;-----------------------------------------------------------
carmap0     .byte  0, 0, 0, 0
carmap1     .byte  0, 0, 0, 0
carmap2     .byte  0, 0, 0, 0
carmap3     .byte  0, 0, 0, 0
;-----------------------------------------------------------
; Je travaille syr ybe représentation de 4x4 au lieu de 8x8
;-----------------------------------------------------------
ctabl       ;.byte $00, $01, $02, $03, $04, $05, $06, $07    
            .byte $60, $6c, $7b, $62, $7c, $e1, $ff, $fe 
            ;.byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
            .byte $7e, $7f, $61, $fc, $e2, $fb, $ec, $e0
;-----------------------------------------------------------
; Affiche une reprécentation graphique du caractère 
;-----------------------------------------------------------
grfbyte     .block
            jsr push
            lda #$08
            sta bitcnt
            lda charmap,x
            clc
            pha
nxtbit      pla
            rol         
            pha  
            lda #$00
            adc #$00
            tay
            lda chars,y
            jsr chrout 
            dec bitcnt
            lda bitcnt
            cmp #$00
            bne nxtbit
            pla
            jsr pop
            rts
bitcnt      .byte   8
            .bend
;-----------------------------------------------------------
; Récupère les 16 bytes représentant l'apparence du 
; caractère dont le numéro est dans X.
;-----------------------------------------------------------
get_map     .block
            jsr push
            lda 56334   ; Arrète l'horloge d'interruption
            and #254    ;  en plaçant un 0 dans le bit 0 du 
            sta 56334   ;  registre de contrôle du port A 
                        ;  du CIA #1.
            lda 1       ; On accède le ROM charmap en
            and #251    ;  la cartographie mémoire  
            sta 1       ;  du CHARGEN.
            
            jsr copymap ; On appelle notre commande de copy. 
            
            lda 1
            ora #4
            sta 1
            lda 56334
            ora #1
            sta 56334
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
; ----- # map dans Y
copymap     .block
            jsr push
            ldx #$00
            stx myword
            stx myword+1
            sty myword          ; On prend le no du caractere dans Y.
            asl myword          ; On multiplie Y par 8 sur 16 bits ...
            rol myword+1        ; ... pour trouver l'adresse du map ...
            asl myword          ; ... du caractère.
            rol myword+1
            asl myword
            rol myword+1
            lda myword
            sta $fd
            lda myword+1
            clc
            adc #$d0
            sta $fe
            ;brk
            ldy #$00
nxtbyte     lda ($fd),y ; lecture des 8 octets
            sta charmap,y    
            iny
            cpy #$8
            bne nxtbyte
            jsr pop
            rts
myword      .word   $00
            .bend
            
;-----------------------------------------------------------
tod         .block
            jsr settime
            sta tenths    
more        lda hours    
            and #$1f    
            jsr prbyte
            jsr colon
            lda minuts
            jsr prbyte
            jsr colon
            lda secnds
            jsr prbyte
            jsr colon
            lda tenths
            jsr prbyte
            ldy #$0b
loop        lda #$9d        
            jsr chrout
            dey
            bne loop
            beq more
colon       jsr push
            ;lda #$9d        
            ;jsr chrout
            lda #":"
            jsr chrout
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
settime     .block
            jsr push
            lda #$11 
            sta hours 
            lda #$59
            sta minuts
            lda #$00
            sta secnds
            sta tenths
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
hexcii      cmp #$0a
            bcc around
            adc #$06
around      adc #$30
            rts
;-----------------------------------------------------------
aschex      .block
            cmp #$40
            bcc skip
            sbc #$07
skip        sec        
            sbc #$30        
            rts
            .bend
;-----------------------------------------------------------
prbyte      .block
            jsr push
            sta temp        
            lsr        
            lsr
            lsr
            lsr
            jsr hexcii
            jsr chrout
            lda temp
            and #$0f
            jsr hexcii
            jsr chrout
            ;lda #$20
            ;jsr chrout
            lda temp
            jsr pop
            rts
            .bend
;-----------------------------------------------------------
getbyt      .block
            pha
            lda #$04
            sta 646
            lda #$00
            sta x2bnlow
            pla
            jsr getin        
            beq getbyt        
            tax
            jsr chrout
            txa
            jsr aschex
            jsr xcii2bin            
            asl
            asl
            asl
            asl
            sta temp
            asl x2bnlow
            asl x2bnlow
            asl x2bnlow
            asl x2bnlow
loaf        jsr getin
            beq loaf
            tax
            jsr chrout
            txa
            jsr aschex
            jsr xcii2bin
            ora temp
            lda #$01
            sta 646
            rts
            .bend       

mygetin     .block
            php
            jsr getin
            cmp #$00
            plp
            rts
            .bend
            
xcii2bin    .block
            jsr push
            sec
            sbc #$30
            cmp #$0a
            jmp number
            bcc number
letter      sec
            sbc #$06
number      and #$0f
            ora x2bnlow  
            sta x2bnlow
            jsr pop
            rts
            .bend
    

;----------------------------------------------------------------------
; Utilise utilise les macros suivantes:   
;----------------------------------------------------------------------
.include    "c64_map_kernal.asm"    ; inclus un instruction "jmp main".
.include    "c64_map_basic2.asm" 
;----------------------------------------------------------------------
; Utilise utilise les librairies suivantes:   
;----------------------------------------------------------------------
.include    "c64_lib_pushpop.asm"
;----------------------------------------------------------------------
;*=$c000
;-----------------------------------------------------------
