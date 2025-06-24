               VERSION="20230326-115700"

               .include "header-c64.asm"
               .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
               ;jsr  initnmi        ; À utiliser avec TMPreu
               ;jsr  setmyint
               ;jsr  mc_setvectors
               ;rts
               jsr  scrmaninit
               jsr  js_init
               lda  #$80
               sta  curcol
               lda  #0
               sta  bkcol
               lda  #vbleu
               sta  brdcol
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
goagain        #printcxy bstring1 
               #printcxy bstring2
               #printcxy bstring3
;               #printcxy bstring4
               #printcxy js_status1
               #printcxy js_status2
               #printcxy js_status3
               #printcxy js_status4
               #printcxy js_status5
               #printcxy js_status6
               ldx  #$00
               ldy  #$0f
               jsr  gotoxy
               lda  #vjaune
               jsr  setcurcol
               ldx  #$00
               jsr  setbkcol
looper         jsr  js_scan
               jsr  js_showvals
               jsr  js_updatecurs
               jsr  sprt_move
               ;lda  #$0
               ;sta  c64u_addr1+1
               ;lda  #$00
               ;sta  c64u_addr1
               ;ldy  #10
               ;ldx  #05
               ;jsr  c64u_xy2addr
               ;ldy  c64u_addr2
               ;ldx  c64u_addr2+1
               ;ldx  js_2pixx+1
               ;ldy  js_2pixx
               ;lda  js_2fire
               ;jsr  showregs
               pha
               lda  js_2fire
               and  #$1f
               eor  #$1f
               beq  nochange
               sta  vicbordcol
               sta  $d029
               jsr  pushreg
               lda  js_2port
               ldx  #$01
               stx  bascol
               ldx  #3
               ldy  #22
               jsr  putabinxy
               jsr  popreg
nochange       pla
;????????????????????????????????????????????
;eternel            jmp  eternel
;????????????????????????????????????????????

               ;inc  vicbordcol
               jmp  looper
               jsr  kstop
               bne  looper
               jsr  k_warmboot
out             rts
               .bend
               
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include       "strings_fr.asm"
               .include        "lib-c64-text-mc.asm"
               .include        "lib-c64-showregs-mc.asm"               
               .include        "lib-c64-joystick-mc.asm"
               .include        "lib-c64-spriteman-mc.asm"
*=$c000
               .include        "map-c64-basic2.asm"
               .include        "map-c64-kernal.asm"
               .include        "map-c64-vicii.asm"
               .include        "lib-cbm-pushpop.asm"
               .include        "lib-cbm-mem.asm"
               .include        "lib-cbm-hex.asm"
