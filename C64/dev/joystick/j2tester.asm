;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: j2tester.asm
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Révision : 20250523-224956
;-------------------------------------------------------------------------------
               .enc none
               .include  "map-c64-kernal.asm"
               .include  "map-c64-vicii.asm" 
               .include  "header-c64.asm"
               .include  "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
;               jsr  initnmi        ; À utiliser avec TMPreu
;               jsr  setmyint
;               rts
               jsr  scrmaninit
ici            jmp  ici               
               jsr  js_init
               lda  #$80
               sta  curcol
               lda  #0
               sta  vicback0col
               lda  #vrouge
               sta  brdcol
               sta  vicbordcol
               jsr  cls
               lda  #$20
               ora  #%00000000
               ldy  #$04
               ldx  #$04
               jsr  memfill
               lda  #$00
               ldy  #$d8
               jsr  memfill
               jsr  sprt_init
goagain        jsr  setinverse
               #printcxy bstring1 
               #printcxy bstring2 
               #printcxy bstring3 
               #printcxy bstring4 
               jsr  clrinverse
               #printcxy js_status1 
               #printcxy js_status2 
               #printcxy js_status3 
               #printcxy js_status4 
               #printcxy js_status5 
               #printcxy js_status6 
               #locate   $00,$0f
               lda  #vjaune
               jsr  setcurcol
               ldx  #$00
               jsr  setbkcol


looper         jsr  js_scan        ; ****** Un prob avec j2scan.

INFINIE        jmp  INFINIE          ; Un branchement infinie. 
   

               jsr  js_showvals


               jsr  js_updatecurs
               jsr  sprt_move
               ldx  #$16
               ldy  #$11
               jsr  gotoxy
               lda  #3
               jsr  setcurcol
               lda  js_2fire

               beq  looper     
               lda  js_2y
               cmp  #$04
               bne  nochange
               lda  js_2x
               cmp  #$0b
               bmi  nochange
               cmp  #$1d
               bpl  nochange
               inc  sprt_ptr
               lda  sprt_ptr
               cmp  #9         
               bcc  drawsptr
               lda  #$00
drawsptr       sta  sprt_ptr
               jsr  sprt_init
nochange       jmp  looper
out            jsr  kstop
               rts
onebyte        .byte     0    
               .enc      screen
bstring1       .byte     vbleu1,bkcol1,0,0        
;                                   111111111122222222223333333333
;                         0123456789012345678901234567890123456789    
               .text     "      Visualisation du port jeu #2      "
               .byte     0
bstring2       .byte     vgris,bkcol2,0,1
               .text     " Programme assembleur pour 6510 sur C64 "
               .byte     0
bstring3       .byte     vrose,bkcol3,0,2
               .text     "     par Daniel Lafrance (2024-06) C    "
               .byte     0
bstring4       .byte     vjaune,bkcol3,11,4
               .text     " Changer pointeur "
               .byte     0
js_status1     .byte     vvert1,bkcol0,19,22
               .text     "   up <----1> haut "
               .byte     0
js_status2     .byte     vbleu1,bkcol0,19,21
               .text     " down <---2-> bas "
               .byte     0
js_status3     .byte     vrose,bkcol0,19,20
               .text     " left <--4--> gauche"
               .byte     0
js_status4     .byte     vjaune,bkcol0,19,19
               .text     "right <-8---> droite"
               .byte     0
js_status5     .byte     vblanc,bkcol0,19,18
               .text     " Fire <1----> Feu"
               .byte     0
js_status6     .byte     vcyan,bkcol0,1,23
               .text     "+-> Etat de JS2:     %---FRLDU EOR #$1F"
               .byte     0
               .bend
;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
;
*=$8000
               .include  "lib-c64-joystick-mc.asm"
               .include  "lib-c64-spriteman-mc.asm"
;               .include  "lib-c64-text-sd.asm"
               .include  "lib-c64-text-mc.asm"
*=$c800
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-c64-showregs-mc.asm"                    