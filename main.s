.include "const.inc"
.include "header.inc"
.include "reset.inc"
.include "utils.inc"

.segment "ZEROPAGE"
score: .res 1
frame: .res 1                              ; Number of frames
clock_60: .res 1                              ; clock in seconds
bg_ptr: .res 2

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
    jsr load_palette
    jsr load_background
    jsr load_text
    jsr load_mario
    jsr load_goomba

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
    PPU_SET_ADDR $3F00
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
    lda #<background_data
    sta bg_ptr
    lda #>background_data
    sta bg_ptr + 1

    PPU_SET_ADDR $2000
    ldx #0
    ldy #0
@loop:
    lda (bg_ptr),Y
    sta PPU_DATA
    iny
    cpy #0
    beq @increase_hi_byte
    jmp @loop
@increase_hi_byte:
    inc bg_ptr + 1
    inx
    cpx #4
    bne @loop

    rts
.endproc

.proc load_text
    PPU_SET_ADDR $25AC
    ldy #0
@loop:
    lda text_message,Y
    cmp #0
    beq @end
    cmp #32
    bne @else
@if_space:
    lda #$24
    jmp @if_end
@else:
    sec
    sbc #55
@if_end:
    sta PPU_DATA
    iny
    jmp @loop
@end:
    rts
.endproc

.proc load_mario
    ldy #0
@loop:
    lda sprite_mario,Y
    sta $0200,Y
    iny
    cpy #16
    bne @loop
    rts
.endproc

.proc load_goomba
    ldy #0
@loop:
    lda sprite_goomba,Y
    sta $02F0,Y
    iny
    cpy #16
    bne @loop
    rts
.endproc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nmi:
@update_sprites:
    lda #$02
    sta $4014
@update_frame_and_clock:
    inc frame
    ldy #60
    cpy frame
    bne @_else
    inc clock_60
    ldy #0
    sty frame
@_else:
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
.incbin "assets/background.nam"

sprite_mario:
;     Y    tile#  attr       X
.byte 16, $3A,   %00000000, 16
.byte 16, $37,   %00000000, 24
.byte 24, $4F,   %00000000, 16
.byte 24, $4F,   %01000000, 24

sprite_goomba:
;     Y    tile#  attr       X
.byte 146, $70,   %00100011, 200
.byte 146, $70,   %01100011, 208
.byte 154, $72,   %00100011, 200
.byte 154, $72,   %01100011, 208

text_message:
.byte "HELLO WORLD",$00

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
