;-----------------------------------------------------------------------------
; Projet...: charedit
; Fichier..: localcons.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.1
; Révision.: 2026-10-16
;-----------------------------------------------------------------------------
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; Pour la gestion du VIC-II
;-----------------------------------------------------------------------------
scrnnewram     =    $0400 
charsdef       =    %00001100
bitmapmem      =    charsdef * 1024     ;Calcul position ram des caracteres.
endofaddr      =    (charsdef * 1024) + (4*$800)
mstopaddr      =    $d000+(4*$800)
bordure        =    vgris
fond           =    vnoir
;-----------------------------------------------------------------------------
; Pour le positionnement des lignes à l'écran. (drawlines)
;-----------------------------------------------------------------------------
hline1=4
hline2=6
hline3=18
vlinepos=16
vzplit=scrnnewram+(6*40)+8
;-----------------------------------------------------------------------------
; Pour le positionnement et les couleurs des menus.
;-----------------------------------------------------------------------------
fkeyleft       =    18
f1top          =    9 
mesgcol        =    vcyan
menu1col1      =    vvert1
menu1col2      =    vvert
menu2col1      =    vbleu1 ;vgris2
menu2col2      =    vbleu    
flashcol       =    vblanc    ; Quand l'option de menu est activée.
;-----------------------------------------------------------------------------
; Pour le positionnement de la grille de bitmap 
;-----------------------------------------------------------------------------
grid_top       =    9
grid_left      =    1
grid_bot       =    grid_top + 7
grid_right     =    grid_left + 7
;-----------------------------------------------------------------------------
; Pour la couleur des caractères à l'écran et de l'écran de présentation.
;-----------------------------------------------------------------------------
charcolor      =    vvert1  
charscolor     =    vbleu
whoamicol      =    vcyan




