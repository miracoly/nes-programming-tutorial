;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INES Header (https://www.nesdev.org/wiki/INES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
.byte $4E,$45,$53,$1A               ; NES\n
.byte $02                           ; 2x 16KB = 32KB PRG ROM
.byte $01                           ; 1x 8KB CHR ROM
.byte %00000000                     ; Flag 6
.byte %00000000                     ; Flag 7
.byte $00                           ; PRG RAM
.byte $00                           ; NTSC TV Format
.byte $00                           ; No PRG-RAM
.byte $00,$00,$00,$00,$00           ; Unused padding
