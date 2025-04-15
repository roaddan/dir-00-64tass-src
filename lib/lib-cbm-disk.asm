;-------------------------------------------------------------------------------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Disk error
; Book Page.: 55
;-------------------------------------------------------------------------------
; Description : Display last disk error
;-------------------------------------------------------------------------------
diskerror      .block
               jsr  push
               lda  dsk_dev   ; Select device 8
               sta  $ba       ;
               jsr  talk      ; $ffb4 |a  , iec-cmd dev parle
               lda  #$6f
               sta  $b9       ; 
               jsr  tksa      ; $ff96 |a  , talk adresse sec.
nextchar       jsr  acptr     ; $ffa5 |a  , rx serie.
               jsr  chrout    ; $ffd2 |a  , sort un car.
               cmp  #$0d      ; Is it CR ?
               bne  nextchar  ; No, get next char
               jsr  untlk     ;$ffab      , iec-cmc stop talk
               jsr  pop
               rts
                .bend

;-------------------------------------------------------------------------------
; Display disk directory on screen.
;-------------------------------------------------------------------------------
diskdir        .block
               jsr  push
               lda  #$24      ; L012C - Filename is "$"
               sta  $fb       ; L012E - Zpage1 msb
               lda  #$fb      ; L0130 - Set current filename 
               sta  $bb       ; L0132 - Current filename msb.
               lda  #$00      ; L0134 - to Zpage 1
               sta  $bc       ; L0136 - Current filename lsb.
               lda  #$01      ; L0138 - set ...
               sta  $b7       ; L013A - ... length of current filename
               lda  dsk_dev   ; L013C - set 8 as ... 
               sta  $ba       ; L013E - ... current serial sevice.
               lda  #$60      ; L0140 - set $60 to ...
               sta  $b9       ; L0142 - ... secondary address
               jsr  sfopen    ; L0144 - $f3d5 Serial file open.
               lda  $ba       ; L0147 - Command device $ba ($08) ...%10111010
               jsr  talk      ; L0149 - $ffb4 ... to talk.
               lda  $b9       ; L014C - Command sec. device ($60) ...
               jsr  tksa      ; L014E - $ff96 ... to talk.
               lda  #$00      ; L0151 - put $00 in ...
               sta  $90       ; L0153 - ... kernal status word.
                              ; Bit 0 : Time out (Write).
                              ; Bit 1 : Time out (Read).
                              ; Bit 6 : EOI (End of Identify).
                              ; Bit 7 : Device not present.
               ldy  #$03      ; L0155 - To read 3 bytes, put $03 in
loop1          sty  $fb       ; L0157 - Zpage 1 Msb
               jsr  acptr     ; L0159 - $ffa5 Recoit un byte du port serie.
               sta  $fc       ; L015C - Store byte in zpage 1 lsb
               ldy  $90       ; L015E - Load kernal status word.
               bne  exit      ; L0160 - If any error, EXIT.
               jsr  $ffa5     ; L0162 - jsr acptr
               ldy  $90       ; L0165 - Load byte counter,
               bne  exit      ; L0167
               ldy  $fb       ; L0169
               dey            ; L016b
               bne  loop1     ; L016C - If not last, loop
               ldx  $fc       ; L016E - Load the recieved byte in X.
               jsr  b_putint  ; L0170 - $bdcd print file size    
               lda  #$20      ; L0173 - Load space character and ...
               jsr  chrout    ; L0175 - $ffd2 ... print it.
loop3          jsr  acptr     ; L0178 - $ffa5 Recoit un byte du port serie.
               ldx  $90       ; L017B - Load kernal status word.
               bne  exit      ; L017D - If any error, EXIT.
               tax            ; L017F - tfr a in x
               beq  loop2     ; L0180 - Byte is 0 loop1
               jsr  chrout    ; L0182 - $ffd2 ... print it. 
               jmp  loop3     ; L0185 - get another byte
loop2          lda  #$0d      ; L0188  - Load CR in a
               jsr  chrout    ; L018A - $ffd2 ... print it.
               ldy  #$02      ; L018D - set Y to 2
               bne  loop1     ; L018f - Loop to next dir entry.
exit           jsr  sfclose   ; L0191 - $f642 ... close file.
               jsr  pop
               rts            ; L0194
               .bend

;-------------------------------------------------------------------------------
; Display disk directory follower by disk status.
;-------------------------------------------------------------------------------
directory      .block
               jsr  diskdir
               jsr  diskerror
               rts
               .bend

;-------------------------------------------------------------------------------
; Save memory content to file.
;-------------------------------------------------------------------------------
memtofile      .block
               jsr  dsk_putmesg
               jsr  push
               lda  dsk_fnlen
               ldx  dsk_fnptr      ; load fname addr. lbyte 
               ldy  dsk_fnptr+1
               jsr  setnam         ; call setnam
               lda  dsk_lfsno
               ldx  dsk_dev        ; specified device
skip           ldy  #$00
               jsr  setlfs         ; call setlfs
               lda  dsk_data_s     ; put data start lbyte in stal
               sta  stal
               lda  dsk_data_s+1   ; put data start hbyte in stal
               sta  stal+1
               ldx  dsk_data_e     ; put data end lbyte in x
               ldy  dsk_data_e+1   ; put data end hbyte in y
               lda  #stal          ; start address located in $c1/$c2
               jsr  save           ; call save
               bcc  noerror        ; if carry set, a load error has happened
noerror        jsr  pop
               rts 
               .bend

;=============================================================================
;    mem2file_usage jsr  push
;                   lda  #<fname
;                   sta  dsk_fnptr
;                   lda  #<fname
;                   sta  dsk_fnptr+1
;                   lda  #12
;                   sta  dsk_fn_len
;                   lda  device
;                   sta  dsk_lfsno
;                   lda  #<datastart
;                   sta  dsk_data_s
;                   lda  #>datastart
;                   sta  dsk_data_s+1
;                   lda  #<dataend
;                   sta  dsk_data_e
;                   lda  #>dataend
;                   sta  dsk_data_e+1
;                   jsr  memtofile
;                   jsr  pop
;                   rts               
;=============================================================================

;-------------------------------------------------------------------------------
; Load file to memory.
;-------------------------------------------------------------------------------
filetomem      .block
               jsr push
               lda dsk_fnlen  ; Loads filename lenght.
               ldx dsk_fnptr  ; Points x and y to the filename
               ldy dsk_fnptr+1;pointer
               jsr setnam     ; call setnam
               lda dsk_lfsno  ; Loads Acc with the logical file number
               ldx dsk_dev    ; default to device 8
               ldy #$01       ; not $01 means: load to address stored in file
               jsr setlfs     ; call setlfs

               lda #$00       ; $00 means: load to memory (not verify)
               jsr load       ; call load
               bcc noerror      ; if carry set, a load error has happened
               jsr  error       
noerror        jsr pop
               rts
               .bend

;-------------------------------------------------------------------------------
; Error messages management.  *** TODO ***
;-------------------------------------------------------------------------------
error          .block
               jsr  push
               ; accumulator contains basic error code

               ; most likely errors:
               ; a = $05 (device not present)
isit05         cmp  #$05
               bne  isti04
               ldx  #<dsk_emsg05         
               ldy  #>dsk_emsg05
               jmp  printerror 
               ; a = $04 (file not found)
isit04         cmp  #$04
               bne  isti1d
               ldx  #<dsk_emsg04         
               ldy  #>dsk_emsg04
               jmp  printerror                
               ; a = $1d (load error)
isit1d         cmp  #$1d
               bne  isti00
               ldx  #<dsk_emsg1d         
               ldy  #>dsk_emsg1d
               jmp  printerror                
               ; a = $00 (break, run/stop has been pressed during loading)
isit00         cmp  #$00
               bne  noerror
               ldx  #<dsk_emsg00         
               ldy  #>dsk_emsg00
               jmp  printerror      
               ; ... error handling ...
printerror     jsr  puts
noerror        jsr  pop
               rts

error1         ldx  #<dsk_emsg1         
               ldy  #>dsk_emsg1   
               jsr  puts
               jsr  pop
               rts

error2         ldx #<dsk_emsg2         
               ldy #>dsk_emsg2   
               jsr puts
               jsr  pop    
               rts
               .bend



dsk_putmesg    .block
               jsr push
               ldx #<dsk_msg0         
               ldy #>dsk_msg0   
               jsr puts    
               lda #$20
               jsr putch
               ldx dsk_fnptr         
               ldy dsk_fnptr+1   
               jsr puts
               lda dsk_lfsno
               jsr close    
               jsr pop
               rts    
               .bend      

dsk_data_s     .word     $0000     ; Data start example addresses
dsk_data_e     .word     $2000     ; Data end 
dsk_dev        .byte     $08       ; Device number
dsk_lfsno      .byte     $00       ; Logical file number
dsk_fnptr      .word     $00       ; Pointer to filename
dsk_fnlen      .byte     0         ; Number of character in filename.
dsk_msg0       .byte     141       ; Miscilinaous file message.
               .null     "saving "
dsk_msg1       .byte     141
               .null     "succes" 
dsk_emsg1      .byte     141
               .null     "fichier non ouvert"
dsk_emsg2      .byte     17
               .null     "erreur d'ecriture"
dsk_emsg05      .byte     17
               .null     "lecteur absent"
dsk_emsg04      .byte     17
               .null     "fichier introuvable"
dsk_emsg1d     .byte     17
               .null     "erreur de chargement"
dsk_emsg00     .byte     17
               .null     "break error"

