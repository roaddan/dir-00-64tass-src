affichemesg    .macro msgaddr
               txa
               pha
               tya
               pha
               ldx #<blankmsg
               ldy #>blankmsg
               jsr putscxy
               ldx #<\msgaddr 
               ldy #>\msgaddr
               jsr putscxy
               pla
               tay
               pla
               tax
               .endm