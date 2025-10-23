;-----------------------------------------------------------------------------
; bonjour
;-----------------------------------------------------------------------------
;  ---------------> "0123456789012345678901234567890123456789
titre       .byte   $0d,$20,b_rvs_on,b_mauve
            .text   "                                      "
            .byte   b_rvs_off,$0d,$20,b_rvs_on
            .text   "   essaies de sons sur sid c64/c64c   "
            .byte   b_rvs_off,$0d,$20,b_rvs_on
            .text   " en assembleur avec 64tass sous linux "
            .byte   b_rvs_off,$0d,$20,b_rvs_on
            .text   "   par daniel lafrance octobre 2025   "
            .byte   b_rvs_off,$0d,$20,b_rvs_on
            .text   "                                      "
            .byte   b_rvs_off,$0d,b_black,$00
startcmd    .byte   $0d,b_crsr_down,b_crsr_down,b_crsr_down,b_crsr_down,b_crsr_down
            .text   '/"sidtest03"'
            .byte   b_crsr_up,b_crsr_up,$00
