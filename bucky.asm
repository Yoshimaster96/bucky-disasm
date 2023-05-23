;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Bucky O'Hare (U) Disassembly;
;      By Yoshimaster96      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VER_JPN = 0
VER_USA = 0	;Default

;;;;;;;;;;;;;
;INES HEADER;
;;;;;;;;;;;;;
	.incbin "header.bin"

;;;;;;;;;
;PRG ROM;
;;;;;;;;;
	.include "regs.asm"
	.include "vars.asm"

	.fillvalue $FF
	.include "prg0.asm"
	.include "prg1.asm"
	.include "prg2.asm"
	.include "prg3.asm"
	.include "prg4.asm"
	.include "prg5.asm"
	.include "prg6.asm"
	.include "prg7.asm"

;;;;;;;;;
;CHR ROM;
;;;;;;;;;
	.incbin "chr.bin"
