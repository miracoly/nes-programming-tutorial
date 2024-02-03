.include "const.inc"
.include "header.inc"
.include "reset.inc"
.include "utils.inc"

.segment "ZEROPAGE"
score: .res 1
frame: .res 1                              ; Number of frames
clock_60: .res 1                              ; clock in seconds

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"

reset:
    INIT_NES

    lda #0
    sta score
    sta frame
    sta clock_60

main:
    PPU_SET_ADDR $3F00
    jsr load_palette

    PPU_SET_ADDR $2000
    jsr load_background

    PPU_SET_ADDR $23C0
    jsr load_attributes

@enable_ppu_rendering:
    lda #%10010000                  ; Enable NMI & set background
    sta PPU_CTRL                    ;   to use 2. pattern table ($1000)
    lda #0
    sta PPU_SCROLL                  ; Scroll X
    sta PPU_SCROLL                  ; Scroll Y
    lda #%00011110
    sta PPU_MASK

loop_forever:
    jmp loop_forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sub-routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Load all 32 colors from ROM
.proc load_palette
    ldy #0
@loop:
    lda palette_data,Y              ; Lookup byte in ROM
    sta PPU_DATA
    iny
    cpy #32
    bne @loop                       ; jump if Y == 32?
    rts
.endproc

;; Load 255 tiles in the first nametable
.proc load_background
    ldy #0
@loop:
    lda background_data,Y
    sta PPU_DATA
    iny
    cpy #255                        ; jump if Y == $FF
    bne @loop
    rts
.endproc

;; Load 16 bytes of attributes for first nametable
.proc load_attributes
    ldy #0
@loop:
    lda attribute_data,Y
    sta PPU_DATA
    iny
    cpy #16                         ; jump if Y == $F0
    bne @loop
    rts
.endproc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nmi:
    inc frame
    ldy #60
    cpy frame
    bne @else
    inc clock_60
    ldy #0
    sty frame
@else:
    rti
irq:
    rti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colors to be loaded by PPU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
palette_data:
.byte $22,$29,$1A,$0F               ; Background
.byte $22,$36,$17,$0F
.byte $22,$30,$21,$0F
.byte $22,$27,$17,$0F

.byte $22,$16,$27,$18               ; Sprites
.byte $22,$1A,$30,$27
.byte $22,$16,$30,$27
.byte $22,$0F,$36,$17

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Background to copy into nametable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
background_data:
.byte $24,$24,$24,$24,$24,$24,$24,$24,$24,$36,$37,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
.byte $24,$24,$24,$24,$24,$24,$24,$24,$35,$25,$25,$38,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$60,$61,$62,$63,$24,$24,$24,$24
.byte $24,$36,$37,$24,$24,$24,$24,$24,$39,$3a,$3b,$3c,$24,$24,$24,$24,$53,$54,$24,$24,$24,$24,$24,$24,$64,$65,$66,$67,$24,$24,$24,$24
.byte $35,$25,$25,$38,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$55,$56,$24,$24,$24,$24,$24,$24,$68,$69,$26,$6a,$24,$24,$24,$24
.byte $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
.byte $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
.byte $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

attribute_data:
.byte %00000000, %00000000, %10101010, %00000000, %11110000, %00000000, %00000000, %00000000
.byte %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CHR-ROM data from external binary files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CHARS"
.incbin "assets/mario.chr"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Address of handlers at address $FFFA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "VECTORS"
.word nmi                           ; address of NMI handler
.word reset                         ; address of RESET handler
.word irq                           ; address of IRQ handler
