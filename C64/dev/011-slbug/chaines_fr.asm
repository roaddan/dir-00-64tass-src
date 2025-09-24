headera                        ;0123456789012345678901234567890123456789
                .text          "    **** SL-BUG 64 Version 4.00 ****"
                .byte   $0d
                .text          "    *       Pour Commodore 64      *"
                .byte   $0d,0
headerb         .text          "    *  Idee Originale: S. Leblanc  *"
                .byte   $0d
                .text          "    * Version originale sur MC6809 *"
                .byte   $0d,$0
headerc         .text          "    * Port sur C64 Daniel Lafrance *"
                .byte   $0d
                .text          "    *      (c) Septembre 2025      *"
                .byte   $0d
                .text   format("    * Version: %-20s*",Version)
                .byte   $0d,0

shortcuts       .byte   $0d
                .text          "    *---- R A C C O U R C I S -----*"
                .byte   $0d
                .text   format("    * Execution.: SYS%05d ($%04X) *",slbug64,slbug64)
                .byte   $0d
                .text   format("    * Aide......: SYS%05d ($%04X) *",help,help)
                .byte   $0d
                .text   format("    * CLS.......: SYS%05d ($%04X) *",cls,cls)
                .byte   $0d,0
line            .text          "    *------------------------------*"
                .byte   $0d,0
helptext        .text   format(" Lancement de slbug64  : SYS%5d",slbug64)
                .byte   $0d
                .text   format(" ex.: SYS%5d",slbug64)
                .byte   $0d,0
