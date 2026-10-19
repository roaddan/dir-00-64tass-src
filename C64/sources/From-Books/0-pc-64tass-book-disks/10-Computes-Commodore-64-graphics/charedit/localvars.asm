;-----------------------------------------------------------------------------
; Projet...: charedit
; Fichier..: localvars.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.1
; Révision.: 2026-10-16
;-----------------------------------------------------------------------------
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;-----------------------------------------------------------------------------

startaddr      .word     $d000               ; 53248
stopaddr       .word     mstopaddr           ; 55296 
bitmapaddr     .word     bitmapmem           ; $3000, 12288     
eorval         .byte     $80,$40,$20,$10,$08,$04,$02,$01
editmode       .byte     0
fkeyset        .byte     0
currentchar    .byte     0
currentkey     .byte     0
previouskey    .byte     0
bmoffset       .byte     0
mapaddr        .word     0
byteaddr       .word     0
gridaddr       .word     0 
cursln         .byte     grid_top
curscl         .byte     grid_left
pfname         .byte     vvert,27,3,18     
fname          .text     "@0:"
name           .text     "origin"
ext            .null     ".chr"
device         .byte     8
tmpbyte        .byte     $00
copykey        .byte     0  
tempbyte       .byte     0
