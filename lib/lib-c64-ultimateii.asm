;-------------------------------------------------------------------------------
; 1541 Ultimate II+ DOS Include file for constants and functions:
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants addresses.
;-------------------------------------------------------------------------------
uiictrlreg	=	$df1c
uiistatreg	=	$df1c
uiicomddta	=	$df1d
uiiidenreg	=	$df1d
uiirspdtaa	=	$df1e
uiistatdta	=	$df1e

;-------------------------------------------------------------------------------
; Status register flag and constants
;-------------------------------------------------------------------------------
;  Bit 7  ;  Bit 6  ; Bit 5 ; Bit 4 ;  Bit 3  ;   Bit 2  ;   Bit 1  ;   Bit 0  ;
;---------;---------;---------------;---------;----------;----------;-----------
; DATA_AV ; STAT_AV ;     STATE     ;  ERROR  ;  ABORT_P ; DATA_ACC ; CMD_BUSY ;
;-------------------------------------------------------------------------------
uiiidle		=	$00
uiicmdbusy	=	$01
uiidatalast	=	$02
uiidatamore	=	$03

;-------------------------------------------------------------------------------
; 1541 Ultimate II+ DOS Command structure :	$01 CMD [XX] <FILENAME> 
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; CMD list
;-------------------------------------------------------------------------------
uii_identify	=	$01	; $01 $01 -> Read Id String as "ULTIMATE-II DOS V1.0"

;-------------------------------------------------------------------------------
; File access commands.
;-------------------------------------------------------------------------------
uii_file_open	=	$02	; Open file for ...
;-------------------------------------------------------------------------------
; File access sub-command.
;-------------------------------------------------------------------------------
uii_fa_read	=	$01	; $01 $02 $01 <filename> -> ... reading.
uii_fa_write	=	$02	; $01 $02 $02 <filename> -> ... writing. 
uii_fa_new	=	$04	; $01 $02 $04 <filename> -> ... creating/writing.
uii_fa_ovwri	=	$08	; $01 $02 $08 <filename> -> ... overwriting.
uii_file_close	=	$03	; $01 $03 -> close opened file.
uii_read_data	= 	$04  ; $01 $04 [len_lo] [len_hi]
uii_writ_data	=	$05	; $01 $05 [dummy] [dummy] [data...]
uii_file_seek	=	$06	; $01 $06 [posl] [posml] [posmh] [posh].
;-------------------------------------------------------------------------------
uii_file_info 	=	$07	; $01 $07 -> returns current open file info.
uii_file_stat  = 	$08	; $01 $08 <filename> -> returns file info.
;-------------------------------------------------------------------------------
; File info/stat structure.
;-------------------------------------------------------------------------------
; dword	size -> file size.
; word	date -> last modifief date.
; word	time -> last modifief time.
; char 	extension[3]
; byte	attrib
; char filename[] 
;-------------------------------------------------------------------------------
uii_file_del	=	$09	; $01 $09 <filename> -> delete/scratch file.
uii_file_ren	=	$0a	; $01 $0a <filename> $00 <newname>
uii_file_copy	=	$0b	; $01 $0b <source> $00 <destination>

;-------------------------------------------------------------------------------
; Directory access commands.
;-------------------------------------------------------------------------------
uii_dir_change = 	$11	; $01 $11 <directory name>
uii_dir_pwd	=	$12	; $01 $12 
uii_dir_open	=	$13	; $01 $13 
uii_dir_read	=	$14  ; $01 $14
;-------------------------------------------------------------------------------
; Read dir output : attr <filename> attr <filename> ... 
; byte attribute 
; char filename []
; 
; Attribute description.
;	; Bit 7-6 ; Bit 5   ; Bit 4 ; Bit 3  ; Bit 2  ; Bit 1  ; Bit 0	 ;
; 	; Unused  ; Archive ; Dir   ; Volume ; System ; Hidden ; Readonly ; 
;-------------------------------------------------------------------------------
uii_dir_cp_ui	=	$15	; $01 $15 -> makes UI current path as API current path.
uii_dir_mkdir	=	$16	; $01 $16 <dirname> -> Create directory under current.
uii_dir_home	=	$17	; $01 $17 -> makes UI home path as API current path.

;-------------------------------------------------------------------------------
; REU access command.
;-------------------------------------------------------------------------------
uii_reu_load	=	$21	
;     $01 $21 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 
uii_reu_save	=	$22	
;     $01 $22 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 

;-------------------------------------------------------------------------------
; Virtual disk drive command.
;-------------------------------------------------------------------------------
uii_dsk_mount	=	$23	; $01 $23 <id> <filename>
uii_dsk_umount = 	$24	; $01 $24 <id>
uii_dsk_swap 	= 	$25	; $01 $25 <id>

;-------------------------------------------------------------------------------
; RTC command
;-------------------------------------------------------------------------------
uii_time_get	=	$26	; $01 $26 [id] -> returns current RTC time/date.
;                        ; If id = 1 returns "www yyyy/mm/dd hh:mm:ss" format.
uii_time_set	=	$27	; $01 $27 <Y> <M> <D> <H> <M> <S>
;                        ; Y = current Year - 1900

uii_dos_echo	= 	$f0	; $01 $f0 




;-------------------------------------------------------------------------------
; Return Carry flag set if 1541 Ultimate II+ busy.
;-------------------------------------------------------------------------------
isuiibusy		.block
			pha	; Bit 0
			clc
			lda	uiistatreg
			and	#%00000001
			cmp	#%00000001
			bne  out
			sec
out			pla
			rts
			.bend

;-------------------------------------------------------------------------------
; Return Carry flag representing 1541 Ultimate II+ condition.
;-------------------------------------------------------------------------------
isuiidataacc	.block
			pha ; Bit 1
			clc
			lda	uiistatreg
			and	#%00000100
			cmp	#%00000100
			bne	out
			sec
out			pla
			rts
			.bend

;-------------------------------------------------------------------------------
; Return Carry flag representing 1541 Ultimate II+ abort condition.
;-------------------------------------------------------------------------------
isuiiabort	.block
			pha ; Bit 2
			clc
			lda	uiistatreg
			and	#%00000100
			cmp	#%00000100
			bne	out
			sec
out			pla
			rts
			.bend

;-------------------------------------------------------------------------------
; Return Carry flag representing 1541 Ultimate II+ error condition.
;-------------------------------------------------------------------------------
isuiierror	.block
			pha ; Bit 3
			lda	uiistatreg
			and	#%00001000
			cmp	#%00001000
			bne	out
			sec
out			pla 
			rts
			.bend
;-------------------------------------------------------------------------------
; Returns 1541 Ultimate II+ status in A:
;    0 = Idle
;	1 = Command Busy
;    2 = Data Last
;    3 = Data More
;-------------------------------------------------------------------------------
getuiistate	.block
			php	; Bita 5,4
			lda	uiistatreg
			lsr	
			lsr	
			lsr
			lsr
			and	#%00000011
			plp
			rts
			.bend
			
;-------------------------------------------------------------------------------
; Wait for 1541 Ultimate II+ to be in idle mode.
;-------------------------------------------------------------------------------
waituiiidle	.block
			php
			pha
notyet		jsr	getuiistate
			cmp  #$00
			bne	notyet
			pla
			plp
			rts
			.bend

;-------------------------------------------------------------------------------
; Wait for 1541 Ultimate II+ to be in idle mode.
;-------------------------------------------------------------------------------
isuiimoredata	.block
			php
			pha
notyet		jsr	getuiistate
			cmp  #$00
			bne	notyet
			pla
			plp
			rts
			.bend


;-------------------------------------------------------------------------------
; Wait while 1541 Ultimate II+ is busy.
;-------------------------------------------------------------------------------
waituiinotbusy	.block
			php
wait			jsr	isuiibusy
			bcs	wait
			plp
			rts
			.bend


uiigettime
