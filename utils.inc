;; Set address of PPU
.macro PPU_SET_ADDR addr
    bit PPU_STATUS
    ldx #>addr
    stx PPU_ADDR
    ldx #<addr
    stx PPU_ADDR
.endmacro

.macro PPU_SET_DATA val
    lda val
    sta PPU_DATA
.endmacro
