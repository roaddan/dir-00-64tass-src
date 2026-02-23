;----------------------------------------------------------------------------
; Pointeur vers la memoire du Vic20
;----------------------------------------------------------------------------
; status    =    kiostatus ; mot d'état d'E/S du noyau
fnlen     =    curfnlen  ; longueur du nom de fichier actuel
sadd      =    sa        ; adresse secondaire actuelle
;----------------------------------------------------------------------------
;Déjà definies dans e-v20-page0.asm
;----------------------------------------------------------------------------
;fa        =    $ba       ; Numéro d'appareil actuel
;fnadr     =    $bb       ; pointeur vers le nom de fichier actuel
;ndx       =    $c6       ; Nombre de caracteres dans le tampon du clavier
keyd      =    $0277     ; Tampon clavier
bkvec     =    $0316     ; Vecteur de BRK
;----------------------------------------------------------------------------
; Points d'entrées de fonctions kernal.
; ; -> Déjà definies dans e-v20-kernal-map.asm
;----------------------------------------------------------------------------
;setmsg    =    $ff90     ; set kernel message control flag
;second    =    $ff93     ; set secondary address after listen
;tksa      =    $ff96     ; send secondary address after talk
;listen    =    $ffb1     ; command serial bus device to listen
;talk      =    $ffb4     ; command serial bus device to talk
;setlfs    =    $ffba     ; set logical file parameters
;setnam    =    $ffbd     ; set filename
;acptr     =    $ffa5     ; input byte from serial bus
;ciout     =    $ffa8     ; output byte to serial bus
;untlk     =    $ffab     ; command serial bus device to untalk
;unlsn     =    $ffae     ; command serial bus device to unlisten
;chkin     =    $ffc6     ; define input channel
;clrchn    =    $ffcc     ; restore default devices
input     =    chrin     ; input a character (official name chrin)
;chrout    =    $ffd2     ; output a character
;load      =    $ffd5     ; load from device
;save      =    $ffd8     ; save to device
;stop      =    $ffe1     ; check the stop key
;getin     =    $ffe4     ; get a character

;----------------------------------------------------------------------------
; 