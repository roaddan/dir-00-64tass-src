;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------                
headera                       ;0123456789012345678901234567890123456789
               .text          "     Commodore 64 test de librarie "
               .byte     $0d,0

headerb        .text          "               libtest01 "
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
               .text   format(" libtest01: SYS%05d ($%04X)",main, main)
               .byte     $0d
               .text   format(" aide.....: SYS%05d ($%04X)",aide, aide)
               .byte     $0d
               .text   format(" cls......: SYS%05d ($%04X)",cls, cls)
               .byte     $0d,0
aidetext       .text   format(" Lancement: SYS%05d ($%04X)",libtest01, libtest01)
               .byte     $0d, $0d
                .text   format("    ex.: SYS%05d",libtest01)
                .byte     $0d
                .text   format("    for i=0to100:SYS%05d:next",libtest01)
                .byte     $0d,0
line            .byte     $20,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192,192
                .byte     192,192,192,192,192,192,192,192,192
                .byte     $0d,0

dataloc         .byte       1,0,0,0
