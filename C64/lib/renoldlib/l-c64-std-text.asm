;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;screen managing utilities
;---------------------------------------------------------------------
sd_bkcol       =    %00000000
sd_bkcol0      =    %00000000
sd_bkcol1      =    %01000000
sd_bkcol2      =    %10000000
sd_bkcol3      =    %11000000
bkcol          =    sd_bkcol
bkcol0         =    sd_bkcol0
bkcol1         =    sd_bkcol1
bkcol2         =    sd_bkcol2
bkcol3         =    sd_bkcol3
;-------------------------------------------------------------------------------
; Initialise le pointeur d'écran et efface l'écran
;-------------------------------------------------------------------------------
;scrmaninit    jmp  sd_scrmaninit ok
;curshome      jmp  sd_curshome.  ok
;incscrptr     jmp  sd_incscrptr. ok
;synccolptr    jmp  sd_synccolptr ok
;cls           jmp  sd_cls.       ok
;setinverse    jmp  sd_setinverse ok
;clrinverse    jmp  sd_clrinverse ok
;z2putch       jmp  sd_z2putch    ok               
;z2puts        jmp  sd_z2puts.    ok
;putch         jmp  sd_putch.     ok
;puts          jmp  sd_puts.      ok
;putsxy        jmp  sd_putsxy.    ok
;putscxy       jmp  sd_putscxy.   ok
;setcurcol     jmp  sd_setcurcol  ok
;setbakcols    jmp  sd_setbakcols ok
;setbkcol      jmp  sd_setbkcol.  ok
;gotoxy        jmp  sd_gotoxy.    ok
;saddscrptr    jmp  sd_saddscrptr ok
;scrptr2str    jmp  sd_scrptr2str ok
;scrptr2zp1    jmp  sd_scrptr2zp1 ok
;colptr2zp1    jmp  sd_colptr2zp1 ok
;scrptr2zp2    jmp  sd_scrptr2zp2 ok
;colptr2zp2    jmp  sd_colptr2zp2 ok
;putrahex      jmp  sd_putrahex.  ok
;putrahexxy    jmp  sd_putrahexxy ok
;putrahexcxy   jmp  sd_putrahexcxy ok
;-------------------------------------------------------------------------------
; Default vectors
;-------------------------------------------------------------------------------
scrmaninit     jmp     nowhere
curshome       jmp     nowhere
incscrptr      jmp     nowhere
synccolptr     jmp     nowhere
cls            jmp     nowhere
setinverse     jmp     nowhere
clrinverse     jmp     nowhere
z2putch        jmp     nowhere        
z2puts         jmp     nowhere              
putch          jmp     nowhere
puts           jmp     nowhere
putsxy         jmp     nowhere
putscxy        jmp     nowhere
setcurcol      jmp     nowhere
setbakcols     jmp     nowhere
setbkcol       jmp     nowhere
gotoxy         jmp     nowhere
saddscrptr     jmp     nowhere
scrptr2str     jmp     nowhere
scrptr2zp1     jmp     nowhere
colptr2zp1     jmp     nowhere
scrptr2zp2     jmp     nowhere
colptr2zp2     jmp     nowhere
putrahex       jmp     nowhere
putrahexxy     jmp     nowhere
putrahexcxy    jmp     nowhere
nowhere        rts

;-------------------------------------------------------------------------------
; Variables globales
;-------------------------------------------------------------------------------
scrptr          .word   $00
colptr          .word   $00
curcol          .byte   $00
brdcol          .byte   $0c
bakcol          .byte   $00
bakcol0         .byte   vnoir           ;$0b
bakcol1         .byte   vrouge          ;$0b
bakcol2         .byte   vvert           ;$0b
bakcol3         .byte   vbleu           ;$0b
inverse         .byte   $00
scraddr         .byte   0,0,0,0,0
coladdr         .byte   0,0,0,0,0

sd_scrptr       =    scrptr
sd_colptr       =    colptr
sd_curcol       =    curcol
sd_brdcol       =    brdcol
sd_bakcol       =    bakcol
sd_bakcol0      =    bakcol0
sd_bakcol1      =    bakcol1
sd_bakcol2      =    bakcol2
sd_bakcol3      =    bakcol3
sd_inverse      =    inverse
sd_scraddr      =    scraddr
sd_coladdr      =    coladdr
setvectors   =       sd_setvectors
;-------------------------------------------------------------------------------
; Initialise les vecteurs des fonctions de gestion d'écran
;-------------------------------------------------------------------------------
sd_setvectors   .block
               jsr  push
;----------------------------------------------
; scrnmaninit
;----------------------------------------------
               lda     #$4c
               sta     scrmaninit
               lda     #<sd_scrmaninit
               sta     scrmaninit+1
               lda     #>sd_scrmaninit
               sta     scrmaninit+2
;----------------------------------------------
; curshome
;----------------------------------------------
               lda     #$4c
               sta     curshome
               lda     #<sd_curshome
               sta     curshome+1
               lda     #>sd_curshome
               sta     curshome+2
;----------------------------------------------
; incscrptr
;----------------------------------------------
               lda     #$4c
               sta     incscrptr
               lda     #<sd_incscrptr
               sta     incscrptr+1
               lda     #>sd_incscrptr
               sta     incscrptr+2
;----------------------------------------------
; synccolptr
;----------------------------------------------
               lda     #$4c
               sta     synccolptr
               lda     #<sd_synccolptr
               sta     synccolptr+1
               lda     #>sd_synccolptr
               sta     synccolptr+2
;----------------------------------------------
; cls
;----------------------------------------------
               lda     #$4c
               sta     cls
               lda     #<sd_cls
               sta     cls+1
               lda     #>sd_cls
               sta     cls+2
;----------------------------------------------
; setinverse
;----------------------------------------------
               lda     #$4c
               sta     setinverse
               lda     #<sd_setinverse
               sta     setinverse+1
               lda     #>sd_setinverse
               sta     setinverse+2
;----------------------------------------------
; clrinverse
;----------------------------------------------
               lda     #$4c
               sta     clrinverse
               lda     #<sd_clrinverse
               sta     clrinverse+1
               lda     #>sd_clrinverse
               sta     clrinverse+2
;----------------------------------------------
; z2putch   
;----------------------------------------------
               lda     #$4c
               sta     z2putch
               lda     #<sd_z2putch
               sta     z2putch+1
               lda     #>sd_z2putch
               sta     z2putch+2
;----------------------------------------------
; z2puts    
;----------------------------------------------
                lda     #$4c
                sta     z2puts
                lda     #<sd_z2puts
                sta     z2puts+1
                lda     #>sd_z2puts
                sta     z2puts+2
;----------------------------------------------
; putch
;----------------------------------------------
                lda     #$4c
                sta     putch
                lda     #<sd_putch
                sta     putch+1
                lda     #>sd_putch
                sta     putch+2
;----------------------------------------------
; puts
;----------------------------------------------
                lda     #$4c
                sta     puts
                lda     #<sd_puts
                sta     puts+1
                lda     #>sd_puts
                sta     puts+2
;----------------------------------------------
; putsxy
;----------------------------------------------
                lda     #$4c
                sta     putsxy
                lda     #<sd_putsxy
                sta     putsxy+1
                lda     #>sd_putsxy
                sta     putsxy+2
;----------------------------------------------
; putscxy
;----------------------------------------------
                lda     #$4c
                sta     putscxy
                lda     #<sd_putscxy
                sta     putscxy+1
                lda     #>sd_putscxy
                sta     putscxy+2
;----------------------------------------------
; setcurcol
;----------------------------------------------
                lda     #$4c
                sta     setcurcol
                lda     #<sd_setcurcol
                sta     setcurcol+1
                lda     #>sd_setcurcol
                sta     setcurcol+2
;----------------------------------------------
; setbakcols
;----------------------------------------------
                lda     #$4c
                sta     setbakcols
                lda     #<sd_setbakcols
                sta     setbakcols+1
                lda     #>sd_setbakcols
                sta     setbakcols+2
;----------------------------------------------
; setbkcol
;----------------------------------------------
                lda     #$4c
                sta     setbkcol
                lda     #<sd_setbkcol
                sta     setbkcol+1
                lda     #>sd_setbkcol
                sta     setbkcol+2
;----------------------------------------------
; gotoxy
;----------------------------------------------
                lda     #$4c
                sta     gotoxy
                lda     #<sd_gotoxy
                sta     gotoxy+1
                lda     #>sd_gotoxy
                sta     gotoxy+2
;----------------------------------------------
; saddscrptr
;----------------------------------------------
                lda     #$4c
                sta     saddscrptr
                lda     #<sd_saddscrptr
                sta     saddscrptr+1
                lda     #>sd_saddscrptr
                sta     saddscrptr+2
;----------------------------------------------
; scrptr2str
;----------------------------------------------
                lda     #$4c
                sta     scrptr2str
                lda     #<sd_scrptr2str
                sta     scrptr2str+1
                lda     #>sd_scrptr2str
                sta     scrptr2str+2
;----------------------------------------------
; scrptr2zp1
;----------------------------------------------
                lda     #$4c
                sta     scrptr2zp1
                lda     #<sd_scrptr2zp1
                sta     scrptr2zp1+1
                lda     #>sd_scrptr2zp1
                sta     scrptr2zp1+2
;----------------------------------------------
; colptr2zp1
;----------------------------------------------
                lda     #$4c
                sta     colptr2zp1
                lda     #<sd_colptr2zp1
                sta     colptr2zp1+1
                lda     #>sd_colptr2zp1
                sta     colptr2zp1+2
;----------------------------------------------
; scrptr2zp2
;----------------------------------------------
                lda     #$4c
                sta     scrptr2zp2
                lda     #<sd_scrptr2zp2
                sta     scrptr2zp2+1
                lda     #>sd_scrptr2zp2
                sta     scrptr2zp2+2
;----------------------------------------------
; colptr2zp2
;----------------------------------------------
                lda     #$4c
                sta     colptr2zp2
                lda     #<sd_colptr2zp2
                sta     colptr2zp2+1
                lda     #>sd_colptr2zp2
                sta     colptr2zp2+2
;----------------------------------------------
; putrahex
;----------------------------------------------
                lda     #$4c
                sta     putrahex 
                lda     #<sd_putrahex 
                sta     putrahex+1
                lda     #>sd_putrahex 
                sta     putrahex+2
;----------------------------------------------
; putrahexxy
;----------------------------------------------
                lda     #$4c
                sta     putrahexxy
                lda     #<sd_putrahexxy
                sta     putrahexxy+1
                lda     #>sd_putrahexxy
                sta     putrahexxy+2
;----------------------------------------------
; putrahexcxy
;----------------------------------------------
                lda     #$4c
                sta     putrahexcxy
                lda     #<sd_putrahexcxy
                sta     putrahexcxy+1
                lda     #>sd_putrahexcxy
                sta     putrahexcxy+2
;----------------------------------------------
                jsr     pop
                rts
                .bend       
;---------------------------------------------------------------------
; Initialise le pointeur d'écran et efface l'écran
;---------------------------------------------------------------------
sd_scrmaninit   .block
                php
                pha
                lda     #%00010111
                ;         |||||||+-> Not Used 
                ;         ||||||+--\
                ;         |||||+----> Character-set addr (*2048) (*$800)
                ;         ||||+----/
                ;         |||+-----\
                ;         ||+-------\ Video RAM address (*1024) (*$400)
                ;         |+--------/ (1024, 2018, 3072, 4096, ... 
                ;         +--------/
                sta     $d018
                ;lda     $d016
                ;ora     #%00010000
                ;sta     $d016
                lda     $d011
                and     #%10111111
                pla
                plp
                .bend
;--------------------------------------------------------------------- 
;
;---------------------------------------------------------------------
sd_curshome     .block
                php
                pha
                lda     #$00
                sta     sd_scrptr
                lda     #$04
                sta     sd_scrptr+1
                jsr     sd_synccolptr
                lda     sd_bakcol0 
                sta     $d021
                lda     sd_bakcol1 
                sta     $d022
                lda     sd_bakcol2 
                sta     $d023
                lda     sd_bakcol3 
                sta     $d024
                ;jsr     sd_cls
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Incrémente le pointeur d'écran de une position
;---------------------------------------------------------------------
sd_incscrptr    .block
                php
                pha
                inc     sd_scrptr
                lda     sd_scrptr
                bne     norep
                inc     sd_scrptr+1
norep           jsr     sd_synccolptr
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Synchronise les pointeurs d'écran et de couleur.
;---------------------------------------------------------------------
sd_synccolptr   .block
                php
                pha
                lda     sd_scrptr
                sta     sd_colptr
                lda     sd_scrptr+1
                and     #%00000011
                ora     #%11011000
                sta     sd_colptr+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Efface l'écran avec la couleur voulue et place le curseur à 0,0.
;---------------------------------------------------------------------
sd_cls          .block
                jsr     push
                lda     #$00
                sta     sd_scrptr
                lda     #$04
                sta     sd_scrptr+1
                jsr     sd_synccolptr
                jsr     savezp1
                jsr     sd_scrptr2zp1
                lda     sd_brdcol
                sta     vicbordcol
                lda     sd_bakcol
                sta     vicbackcol
                lda     #$20
                ldx     #4
nextline        ldy     #0
nextcar         sta     (zpage1),y
                lda     zpage1+1
                pha
                and     #%00000011
                ora     #%11011000
                sta     zpage1+1
                lda     #0
                sta     (zpage1),y
                pla
                sta     zpage1+1
                lda     #$20
                dey
                bne     nextcar
                inc     zpage1+1
                dex
                bne     nextcar
                lda     #$00
                sta     sd_scrptr
                lda     #$04
                sta     sd_scrptr+1
                jsr     sd_synccolptr
                jsr     restzp1
                jsr     pop
                rts
                .bend
;--------------------------------------------------------------------- 
;
;---------------------------------------------------------------------
sd_setinverse   .block
                php
                pha
                lda     #%10000000
                sta     sd_inverse
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_clrinverse   .block
                php
                pha
                lda     #%00000000
                sta     sd_inverse
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Affiche une le caractères dont l'adresse est dans zp2 à la position et couleur
; du curseur virtuel.        
;---------------------------------------------------------------------        
sd_z2putch      .block
                jsr     push
                ldy     #$0
                lda     (zpage2),y
                jsr     sd_putch
                jsr     pop
                rts
                .bend
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dont l'adresse est dans zp2 à la position 
; du curseur virtuel.        
;---------------------------------------------------------------------
sd_z2puts       .block               
                jsr     push
                ldy     #$0
nextcar         lda     (zpage2),y 
                beq     endstr
                jsr     sd_z2putch
                jsr     inczp2
                jmp     nextcar
endstr          jsr     pop
                rts
                .bend
;---------------------------------------------------------------------
; Affiche le caractèere dans A à la position et la couleur de l'écran 
; virtuel.
;---------------------------------------------------------------------
sd_putch        .block
                jsr     push            ; On sauvegarde les registres
                jsr     savezp1         ; On sauve le zp1 du progamme appelant
                jsr     sd_scrptr2zp1   ; On place le pointeur d'écran sur zp1
                ldy     #0              ; On met Y à 0
                ora     sd_inverse
                sta     (zpage1),y      ; On affiche le caractèere
                ldx     sd_colptr+1     ; On place le MSB du pointeur de couleur
                stx     zpage1+1        ; dans le MSB du zp1
                lda     sd_curcol       ; on charge la couleur voulu dans
                sta     (zpage1),y      ; la ram de couleur
                jsr     sd_incscrptr    ; On incrémente le pointeur d'écran 
                jsr     restzp1         ; On récupèere le zpe du programme appelant
                jsr     pop             ; on replace tous les registres
                rts
                .bend
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères se terminant par 0 à la position 
; du curseur virtuel.        
;---------------------------------------------------------------------
sd_puts         .block
                jsr     push
                jsr     savezp2
                stx     zpage2
                sty     zpage2+1
                jsr     sd_z2puts
;                ldy  #0
;nextcar         lda  (zpage2),y
;                cmp  #0
;                beq  getout
;                jsr  sd_putch
;                jsr  inczp2
;                jmp  nextcar
getout          jsr     restzp2
                jsr     pop
                rts
                .bend
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dans la couleus C, à la position 
; X,Y qui sont les trois premier octets de ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------
sd_putsxy       .block
                jsr     push            ; On sauvegarde les registres         
                jsr     savezp2         ; et le zp2 
                stx     zpage2          ; On place l'adresse de la 
                                        ;   chaine dans le zp2
                sty     zpage2+1        ; X = MSB, Y = LSB
                ldy     #0              ; On place le compteur
                lda     (zpage2),y      ; Lecture de la position X
                tax                     ; de A à X
                jsr     inczp2       ; On déplace le pointeur
                lda     (zpage2),y      ;
                tay                     ; de A à Y
                jsr     sd_gotoxy       ; sd_gotoxy prend X = colonne, 
                                        ; y = ligne 
                jsr     inczp2
                jsr     sd_z2puts
                jsr     restzp2
                jsr     pop
                rts
                .bend    
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dans la couleus C, à la position X,Y 
; qui sont les trois premier octets de ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------
sd_putscxy      .block
                jsr     push            ; On sauvegarde les registres et le zp2         
                jsr     savezp2
                stx     zpage2          ; On place l'adresse de la chaine dans le zp2
                sty     zpage2+1        ; X = MSB, Y = LSB
                ldy     #0              ; On place le compteur
                lda     (zpage2),y      ; on charge la couleur
                jsr     sd_setcurcol    ; et on la définie
                jsr     inczp2       ; On pointe le prochain byte
                lda     (zpage2),y      ; Lecture de la position X
                and     #$c0
                sta     sd_bkcol          
                jsr     inczp2       ; On déplace le pointeur
                lda     (zpage2),y      ; Lecture de la position X
                tax                     ; de A à X
                jsr     inczp2       ; On déplace le pointeur
                lda     (zpage2),y      ;
                tay                     ; de A à Y
                jsr     sd_gotoxy       ; sd_gotoxy prend X = colonne, y = ligne 
                jsr     inczp2
                jsr     sd_z2puts
                jsr     restzp2
                jsr     pop
                rts
                .bend    
;---------------------------------------------------------------------
; Place A dans le registre de couleur du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
sd_setcurcol    .block
                php
                sta  sd_curcol
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_setbakcols   .block
                php
                pha  
                txa
                and     #$3
                tax
                pla
                pha
                sta     sd_bakcol1,x
                sta     $d021,x
                pla  
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_setbkcol     .block
                php
                pha
                and     #$c0
                sta     sd_bkcol
                lsr
                lsr
                lsr
                lsr
                lsr
                lsr
                and     #%00000011
                txa
                lda     sd_bakcol1,x
                sta     sd_bakcol
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Positionne le pointeur de position du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
sd_gotoxy       .block
                jsr     push
                jsr     sd_curshome
yagain          cpy     #0
                beq     setx
                lda     #40
                jsr     sd_saddscrptr
                dey
                jmp     yagain
setx            txa                
                jsr     sd_saddscrptr  
                jsr     sd_synccolptr 
                jsr     pop
                rts
                .bend
;---------------------------------------------------------------------
; Déplace le pointeur du caractèere virtuel de A position. 
;---------------------------------------------------------------------
sd_saddscrptr   .block
                php
                pha
                clc
                adc     sd_scrptr
                sta     sd_scrptr
                bcc     norep
                inc     sd_scrptr+1
norep           pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2str   .block
;--on sauvegarde tout-------------------
                jsr     push
;--chaine du msb de l'ecran-------------
                lda     sd_scrptr+1
                pha
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr
                pla
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr+1
;--chaine du msb de la couleur----------
                lda     sd_scrptr+1
                pha
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr
                pla
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr+1
;--chaine du lsb de l'ecran et couleur--
                lda     sd_scrptr
                pha
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr+2
                sta     sd_coladdr+2
                pla
                jsr     lsra4bits
                jsr     nibtohex
                sta     sd_scraddr+3
                sta     sd_coladdr+3
;--on recupere tout---------------------
                jsr     pop
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2zp1   .block
                php
                pha
                lda     sd_scrptr
                sta     zpage1
                lda     sd_scrptr+1
                sta     zpage1+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_colptr2zp1   .block
                php
                pha
                lda     sd_colptr
                sta     zpage1
                lda     sd_colptr+1
                sta     zpage1+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2zp2   .block
                php
                pha
                lda     sd_scrptr
                sta     zpage2
                lda     sd_scrptr+1
                sta     zpage2+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_colptr2zp2   .block
                php
                pha
                lda     sd_colptr
                sta     zpage2
                lda     sd_colptr+1
                sta     zpage2+1
                pla
                plp
                rts
                .bend
;-------------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne l'adresse de la
; chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position du curseur.
;-------------------------------------------------------------------------------
sd_putrahex     .block
                php
                pha
                jsr     atohex
                ldx     #<a2hexcol
                ldy     #>a2hexcol
                jsr     sd_puts
                pla
                plp
                rts
                .bend
;-------------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne l'adresse de la
; chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent être modifiées avant l'appel.
;-------------------------------------------------------------------------------
sd_putrahexxy   .block
                php
                pha
                jsr     atohex
                lda     #<a2hexpos
                ldy     #>a2hexpos
                jsr     sd_putsxy
                pla
                plp
                rts
                .bend
;-------------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne l'adresse de la 
; chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy) et dans
;          la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent être modifiées avant 
;          l'appel.
;-------------------------------------------------------------------------------
sd_putrahexcxy  .block
                php
                pla
                jsr     atohex
                lda     #<a2hexpos
                ldy     #>a2hexpos
                jsr     sd_putscxy
                pla
                plp
                rts
                .bend
