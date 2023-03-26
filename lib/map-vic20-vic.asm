;---------------------------------------------------------------------
; Macro et librairies pour gérer le VIC-II
;---------------------------------------------------------------------
vic = $9000			; VicII C64 memorymap base address
vichorcnt = vic+$00	; $9000, 36864 Bit 0-6 Horizontal centering.
                    ;              Bit 7 sets Interlace scan vertical center.
vicvercnt = vic+$01	; $9001, 36865 Vertical centering.
viccolnum = vic+$02	; $9002, 36866 Bit 0-6 set # of column.
                    ;              Bit 7 part of video matrix address.
vicrownum = vic+$03	; $9003, 36867 Bit 1-6 set # of rows.
                    ;              Bit 0 sets 8x8 or 16x8 chars.
vicsrastr = vic+$04	; $9004, 36868 TV raster beam line.
viccstart = vic+$05	; $9005, 36869 Bit 0-3 start of character memory (dflt=0).
                    ;              Bit 4-7 is rest of video address (dflt=f).
                    ; Bits 3,2,1,0  CM starting address.
                    ; 0000  ROM     $8000 - 32768
                    ; 0001  ROM     $8400 - 32768
                    ; 0010  ROM     $8800 - 32768
                    ; 0011  ROM     $8c00 - 32768
                    ; 1000  RAM     $0000 - 00000
                    ; 1001  RAM      xxxx - unavailable
                    ; 1010  RAM      xxxx - unavailable
                    ; 1011  RAM      xxxx - unavailable
                    ; 1100  RAM     $1000 - 4096
                    ; 1101  RAM     $1400 - 5120
                    ; 1110  RAM     $1800 - 6144
                    ; 1111  RAM     $1c00 - 7168
vicpenhor = vic+$06	; $9006, 36870 Horizontal position of light pen.
vicpenver = vic+$07	; $9007, 36871 Vertical position of light pen
vicpadhor = vic+$08	; $9008, 36872 Digitized value of paddle X
vicpadver = vic+$09	; $9009, 36873 Digitized value of paddle Y
vicosclhz = vic+$0a	; $900a, 36874 Oscillator 1 freq. (low) (on: 128-255)
vicoscmhz = vic+$0b	; $900b, 36875 Oscillator 2 freq. (medium) (on: 128-255)
vicoschhz = vic+$0c	; $900c, 36876 Oscillator 3 freq. (high) (on: 128-255)
vicnoizhz = vic+$0d	; $900d, 36877 Noise source freq.
vicvolume = vic+$0e	; $900e, 36878 Bit 0-3 set volume of all sound.
vicscrbrd = vic+$0f	; $900f, 36879 Screen and border color register.
                    ;              Bits 4-7 select background color.
                    ;              Bits 0-2 select border color.
                    ;              Bit 3 selects inverted or normal color.
vicbordcol=vicscrbrd
vicbackcol=vicscrbrd