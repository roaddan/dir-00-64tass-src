;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: e-c64-vicii.asm
; Cernière m.à j. : 20261027-223250
; Inspiration ....: 
;--------------------------------------------------------------------------------
viciiscn    =   $0400
viciiscn0   =   $0400
viciiscn1   =   $04f0
viciiscn2   =   $05e0
viciiscn3   =   $06d0
;---------------------------------------------------------------------
; Macro et librairies pour gérer le VIC-II
;---------------------------------------------------------------------
vic = $d000       ; VicII C64 memorymap base address
vicsprt0x = vic+$00  ; $d000, 53248 Sprt 0 Position horizontale (X)                 
vicsprt0y = vic+$01  ; $d001, 53249 Sprt 0 Position verticale (Y)                
vicsprt1x = vic+$02  ; $d002, 53250 Sprt 1 Position horizontale (X)                 
vicsprt1y = vic+$03  ; $d003, 53251 Sprt 1 Position verticale (Y)                
vicsprt2x = vic+$04  ; $d004, 53252 Sprt 2 Position horizontale (X)                 
vicsprt2y = vic+$05  ; $d005, 53253 Sprt 2 Position verticale (Y)                
vicsprt3x = vic+$06  ; $d006, 53254 Sprt 3 Position horizontale (X)                 
vicsprt3y = vic+$07  ; $d007, 53255 Sprt 3 Position verticale (Y)                
vicsprt4x = vic+$08  ; $d008, 53256 Sprt 4 Position horizontale (X)                 
vicsprt4y = vic+$09  ; $d009, 53257 Sprt 4 Position verticale (Y)                
vicsprt5x = vic+$0a  ; $d00a, 53258 Sprt 5 Position horizontale (X)                 
vicsprt5y = vic+$0b  ; $d00b, 53259 Sprt 5 Position verticale (Y)                
vicsprt6x = vic+$0c  ; $d00c, 53260 Sprt 6 Position horizontale (X)                 
vicsprt6y = vic+$0d  ; $d00d, 53261 Sprt 6 Position verticale (Y)                
vicsprt7x = vic+$0e  ; $d00e, 53262 Sprt 7 Position horizontale (X)                 
vicsprt7y = vic+$0f  ; $d00f, 53263 Sprt 7 Position verticale (Y)
;---------------------------------------------------------------------
; Bit de poids fort pour les Positions horizontales des sprites                     
vicspxmsb = vic+$10  ; $D010, 53264                   
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  | sprt7 | sprt6 | sprt5 | sprt4 | sprt3 | sprt2 | sprt1 | sprt0 | 
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Fonction diverse
vicctrl0v  = vic+$11 ; $d011, 53265                      
vicmiscfnc = vicctrl0v
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  | rastr |  ext  |  bmp  | blank | 24/25 |  ver  |  ver  |  ver  | 
;  |  bit  |  col  |  mod  |  scr  | lines | scrol | scrol | scrol |
;  |   8   |  mod  |       |       |       | bit 2 | bit 1 | bit 0 |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Registre raster
vicraster = vic+$12  ; $d012, 53266       |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
; Stylet optique – Position horizontale   
viclpenhp = vic+$13  ; $d013, 53267       |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
; Stylet optique – Position verticale
viclpenvp = vic+$14  ; $d014, 53268       |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
; Activer/Désactiver le sprite (1/0)      |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprctl = vic+$15  ; $d015, 53269       |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
; Fonction diverse
vicctrl1h = vic+$16  ; $d016, 53270                      
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |       |       | reset | multi | 38/40 |  hor  |  hor  |  hor  | 
;  |   X   |   X   |allways| color | colmn | scrol | scrol | scrol |
;  |       |       |   0   |  mod. |       | bit 2 | bit 1 | bit 0 |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Étendre le sprite verticalement        |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprtexv = vic+$17 ; $d017, 53271      |s7|s6|s5|s4|s3|s2|s1|s0|   
;---------------------------------------------------------------------
; Pointeurs mémoire pour l'affichage de caractères, les bitmaps et
; l'écran.
vicmemptr  = vic+$18 ; $d018, 53272
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  txt  |  txt  |  txt  |  txt  | chars | chars | chars |       | 
;  |  scr  |  scr  |  scr  |  scr  |  def  |  def  |  def  |   X   |
;  | bit 3 | bit 2 | bit 1 | bit 0 | bit 2 | bit 1 | bit 0 |       |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Registre d'interruption                  
vicirqreg  = vic+$19 ; $d019, 53273
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  vic  |       |       |       | light | sprit | sprit | rastr | 
;  | inter |   X   |   X   |   X   |  pen  | sprit | bkgnd | count |
;  |  flg  |       |       |       | latch | coll. | coll. | maich |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Registre d'activation des interruptions                 
vicirqena  = vic+$1a ; $d01a, 53274
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  vic  |       |       |       | light | sprit | sprit | rastr | 
;  | inter |   X   |   X   |   X   |  pen  | sprit | bkgnd | count |
;  |  flg  |       |       |       | latch | coll. | coll. | maich |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
; Priorité d'arrière-plan des sprites     |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprtprio = vic+$1b   ; $d01b, 53275    |s7|s6|s5|s4|s3|s2|s1|s0|  
;---------------------------------------------------------------------
; Sélectionner le mode multicolore        |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprtmcol = vic+$1c   ; $d01c, 53276    |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
; Étendre les sprites horizontalement     |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprtexh = vic+$1d    ; $d01d, 53277    |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
; Collision entre sprites                 |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprscol = vic+$1e    ; $d01e, 53278    |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
;Collision entre sprite et arrière-plan   |b7|b6|b5|b4|b3|b2|b1|b0|
vicsprbakcol = vic+$1f ; $d01f, 53279     |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
;Border Color : $00 to $0f                |--|--|--|--|b3|b2|b1|b0|
vicbordcol = vic+$20    ; $d020, 53280    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur d’arrière-plan #0 : $00 to $0f   |--|--|--|--|b3|b2|b1|b0|
vicbackcol  = vic+$21   ; $d021, 53281    |--|--|--|--|c3|c2|c1|c0|
vicback0col = vic+$21   ; $d021, 53281    |--|--|--|--|c3|c2|c1|c0|
vicbackcol0 = vic+$21   ; $d021, 53281    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur d’arrière-plan #1 : $00 to $0f   |--|--|--|--|b3|b2|b1|b0|
vicback1col = vic+$22   ; $d022, 53282    |--|--|--|--|c3|c2|c1|c0|
vicbackcol1 = vic+$22   ; $d022, 53282    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur d’arrière-plan #2 : $00 to $0f   |--|--|--|--|b3|b2|b1|b0|
vicback2col = vic+$23   ; $d023, 53283    |--|--|--|--|c3|c2|c1|c0|
vicbackcol2 = vic+$23   ; $d023, 53283    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur d’arrière-plan #3 : $00 to $0f   |--|--|--|--|b3|b2|b1|b0|
vicback3col = vic+$24   ; $d024, 53284    |--|--|--|--|c3|c2|c1|c0|
vicbackcol3 = vic+$24   ; $d024, 53284    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Sprite multicolore #0 : $00 to $0f       |--|--|--|--|b3|b2|b1|b0|
vicsprtmcol0 = vic+$25  ; $d025, 53285    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Sprite multicolore #1 : $00 to $0f       |--|--|--|--|b3|b2|b1|b0|
vicsprtmcol1 = vic+$26  ; $d026, 53286    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #0 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt0col = vic+$27   ; $d027, 53287    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #1 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt1col = vic+$28   ; $d028, 53288    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #2 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt2col = vic+$29   ; $d029, 53289    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #3 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt3col = vic+$2a   ; $d02a, 53290    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #4 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt4col = vic+$2b   ; $d02b, 53291    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #5 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt5col = vic+$2c   ; $d02c, 53292    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #6 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt6col = vic+$2d   ; $d02d, 53293    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
;Couleur du Sprite #7 : $00 to $0f        |--|--|--|--|b3|b2|b1|b0|
vicsprt7col = vic+$2e   ; $d02e, 53294    |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------

