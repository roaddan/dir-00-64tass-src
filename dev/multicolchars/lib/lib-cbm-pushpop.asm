push      .block         ; stack : pcl, pch
          php            ; stack : flg, pcl, pch  
          sei
          sta  ra        ; save a
          pla            ; stack : pcl, pch
          sta  rp        ; save rp
          pla            ; stack : pch
          sta  pc        ; save pcl
          pla            ; stack : -
          sta  pc+1      ; save pch
          lda  zpage1    ; get zpage1 low byte
          pha            ; stack : zp1l
          lda  zpage1+1  ; get zpage1 High byte
          pha            ; stack : zp1h, zp1l
          lda  zpage2    ; get zpage2 low byte
          pha            ; stack : zp2l, zp1h, zp1l
          lda  zpage2+1  ; get zpage2 High byte
          pha            ; stack : zp2h, zp2l, zp1h, zp1l 
          lda  rp        ; get rp
          pha            ; stack : flg, zp2h, zp2l, zp1h, zp1l
          lda  ra        ; get a
          pha            ; stack : a, flg, zp2h, zp2l, zp1h, zp1l
          txa            ; get x
          pha            ; stack : x, a, flg, zp2h, zp2l, zp1h, zp1l
          tya            ; get y
          pha            ; stack : y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          lda  pc+1      ; get pch
          pha            ; stack : pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          lda  pc        ; get pcl
          pha            ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          lda  rp        ; get rp
          pha            ; stack : flg, pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          lda  ra        ; get a
          plp            ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          cli
          rts
rp        .byte     0
ra        .byte     0
pc        .word     0
          .bend

pull
pop       .block         ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          sei
          pla            ; get pcl stack : pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          sta  pc        ; save pcl
          pla            ; get pch stack : y, x, a, flg, zp2h, zp2l, zp1h, zp1l
          sta  pc+1      ; save pch
          pla            ; get y stack : x, a, flg, zp2h, zp2l, zp1h, zp1l
          tay            ; set y
          pla            ; get x stack : a, flg, zp2h, zp2l, zp1h, zp1l
          tax            ; set x
          pla            ; get a stack : flg, zp2h, zp2l, zp1h, zp1l
          sta  ra        ; save a
          pla            ; get flag stack : zp2h, zp2l, zp1h, zp1l
          sta  rp        ; save rp
          pla            ; stack : zp2l, zp1h, zp1l 
          sta  zpage2+1  ; get zpage1 low byte
          pla            ; stack : zp1h, zp1l
          sta  zpage2    ; get zpage2 High byte
          pla            ; stack : zp1l
          sta  zpage1+1  ; get zpage2 low byte
          pla            ; stack :
          sta  zpage1    ; get zpage1 High byte
          lda  pc+1      ; get pch
          pha            ; stack : pch
          lda  pc
          pha            ; stack : pcl, pch
          lda  rp        ; get rp
          pha            ; stack : rp, pcl, pch
          lda  ra        ; set ra        
          cli
          plp            ; stack : pcl, pch              
          rts
rp        .byte     0
ra        .byte     0
pc        .word     0
          .bend        
