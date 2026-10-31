;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: v-c64-showregs.asm
; Type fichier....: Variables et constantes. 
; Creation........: 20261031 
; Version.........: 0.1.0
; Révisions.......: 20261031-000000 Francisation des commentaires,
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; Variables pour l'affichage des registres.
;------------------------------------------------------------------------------
vrega          .byte 0
vregx          .byte 0
vregy          .byte 0
vregsp         .byte 0
vregsr         .byte 0
vregpch        .byte 0
vregpcl        .byte 0
vzp1h          .byte 0
vzp1l          .byte 0
vzp2h          .byte 0
vzp2l          .byte 0
;------------------------------------------------------------------------------
; Constantes de caractères pour l'affichage des registres.
;------------------------------------------------------------------------------
reg_titre      .byte b_jaune,18
               .text " contenu des registres "
               .byte 146, 0
ra_str         .byte b_blanc
               .text "a......: "
               .byte b_vertp, 0 
rx_str         .byte b_blanc
               .text "x......: " 
               .byte b_vertp, 0 
ry_str         .byte b_blanc
               .text "y......: " 
               .byte b_vertp, 0 
srh_str        .byte b_blanc
               .text "[nv-bdizc]" 
               .byte b_vertp, 0 
sr_str         .byte b_blanc
               .text "sr.....: " 
               .byte b_vertp, 0 
sp_str         .byte b_blanc
               .text "sp.....: " 
               .byte b_vertp, 0 
pc_str         .byte b_blanc
               .text "pc.....: " 
               .byte b_vertp, 0 
z1_str         .byte b_blanc
               .text "zpage1.: " 
               .byte b_vertp, 0 
z2_str         .byte b_blanc
               .text "zpage2.: " 
               .byte b_vertp, 0 
contstr        .byte b_rose
               .text "[c] pour continuer"
               .byte b_blanc, 0

