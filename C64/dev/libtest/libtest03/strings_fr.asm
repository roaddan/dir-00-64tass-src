;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------                
headera                       ;0123456789012345678901234567890123456789
               .byte     b_home,b_crsr_right,b_crsr_right,b_crsr_right,b_crsr_right
               .text              " Commodore 64 test de libraries "
               .byte     $0d,0

headerb        .text          "         >>>>>[libtest03]<<<<<"
               .byte     $0d
               .text          "       (c) 2025 Daniel Lafrance"
               .byte     $0d
               .text   format("       Version: %s",Version)
               .byte     $0d,0

shortcuts      .byte     $0d
               .byte     ucurkey,ucurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey,rcurkey      
               .text          " R A C C O U R C I S "
               .byte     $0d
               .text   format(" Libtest03: SYS%05d (jsr $%04X)",main, main)
               .byte     $0d
               .text   format(" Aide.....: SYS%05d (jsr $%04X)",aide, aide)
               .byte     $0d
               .text   format(" Cls......: SYS%05d (jsr $%04X)",cls, cls)
               .byte     $0d,0
aidetext       .text   format(" Lancement: SYS%05d (jsr $%04X)",libtest03, libtest03)
               .byte     $0d, $0d
                .text   format("    ex.: SYS%05d",libtest03)
                .byte     $0d
                .text   format("    for i=0to100:SYS%05d:next",libtest03)
                .byte     $0d,0
line            .byte     $20,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192
                .byte     $0d,0

dataloc         .byte       1,0,0,0
