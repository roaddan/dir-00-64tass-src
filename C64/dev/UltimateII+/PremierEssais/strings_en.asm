headera                       ;0123456789012345678901234567890123456789
               .text          "     1541 Ultimate II+ File Manager"
               .byte     $0d  
               .text          " Cartridge snd API by Gideon Zweijtzer."
               .byte     $0d
               .text          "     API Version 1.0, 1er Feb 2013"
               .byte     $0d,0

headerb        .text          "               essai01 "
               .byte     $0d
               .text          "       (c) 2025 Daniel Lafrance"
               .byte     $0d
               .text   format("       Version: %s",Version)
               .byte     $0d,0

shortcuts      .byte     $0d
               .byte     ucurkey,ucurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey,rcurkey      
               .text          " S H O R T - C U T S "
               .byte     $0d
               .text   format(" essai01..: SYS%05d ($%04X)",main, main)
               .byte     $0d
               .text   format(" help.....: SYS%05d ($%04X)",aide, aide)
               .byte     $0d
               .text   format(" cls......: SYS%05d ($%04X)",cls, cls)
               .byte     $0d,0
aidetext       .text   format(" Execute..: SYS%05d ($%04X)",essai01, essai01)
               .byte     $0d, $0d
               .text   format("    ex.: SYS%05d",essai01)
;              .byte     $0d
;              .text   format("    for i=0to100:SYS%05d:next",essai01)
               .byte     $0d,0
line           .byte     $20,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192
               .byte     $0d,0


