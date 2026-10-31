;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier..: e-cbm-vars.asm
; Type fichier....: Variables
; Creation........: 20161130 
; Version.........: 0.1.0
; Revisions.......: 20161130 - Francisation des commentaires.
; Inspiration ....: Mapping The C64 
;                   Sheldon Leemon 
;                   ISBN: 0-87455-082-3
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; Variables utilisées dans :
; l-cbm-conv.asm 
;------------------------------------------------------------------------------
a2hexcol          .byte 0  ;
a2hexpos                   ;
a2hexpx           .byte 0  ;
a2hexpy           .byte 0  ;
a2hexpfx          .byte 0  ;
a2hexstr           .fill 4,0;
                  .byte 0  ;
;------------------------------------------------------------------------------
a2bincol          .byte 0  ;
a2binpos                   ;
a2binpx           .byte 0  ;
a2binpy           .byte 0  ;
a2binpfx          .byte 0  ;
a2binstr            .fill 8,0;
                  .byte 0  ;
;------------------------------------------------------------------------------
a2deccol          .byte 0  ;
a2decpos                   ;
a2decpx           .byte 0  ;
a2decpy           .byte 0  ;
a2decpfx          .byte 0  ;
a2decstr            .fill 5,0;
                  .byte 0  ;
;------------------------------------------------------------------------------
; Variables Utilisées dans: l-cbm-push.asm
;------------------------------------------------------------------------------
rp                .byte 0  ;
ra                .byte 0  ;
rx                .byte 0  ;
ry                .byte 0  ;
rs                .byte 0  ;
pc                .byte 0  ;
curcol            .byte 0  ;
;-------------------------------------------------------------------------------
; Variables Utilisées dans: l-cbm-mem.asm
;-------------------------------------------------------------------------------
ymult          .byte     40                
addr1          .word     $0000    
addr2          .word     $0000
bytecnt        .word     $0000       
zp1            .word     $0000
zp2            .word     $0000