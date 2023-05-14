	.base $8000
	.org $8000
;BANK NUMBER
	.db $38

;;;;;;;;;;;;;;;;
;NAMETABLE DATA;
;;;;;;;;;;;;;;;;
Nametable00Data:
	.dw $2000
	.db $78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00
	.db $40,$00
	.db $7F
	.dw $2400
	.db $78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00,$78,$00
	.db $40,$00
	.db $FF
Nametable02Data:
	.dw $2000
	.db $7E,$00,$0D,$00,$8B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$44,$35
	.db $14,$00,$8D,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$40,$41,$76
	.db $13,$00,$82,$42,$43,$39,$00,$96,$81,$82,$82,$83,$84,$86,$87,$88
	.db $89,$8A,$8B,$8C,$8D,$8E,$8F,$AE,$AF,$85,$93,$82,$82,$47,$0A,$00
	.db $81,$90,$03,$91,$8E,$92,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E
	.db $67,$68,$94,$03,$91,$81,$46,$0B,$00,$94,$A0,$A1,$A1,$A2,$A4,$A5
	.db $A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD,$69,$00,$A3,$A1,$A1,$45,$0D,$00
	.db $92,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE
	.db $BF,$6D,$6E,$0E,$00,$92,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9
	.db $CA,$CB,$CC,$CD,$CE,$CF,$6F,$72,$0E,$00,$92,$D0,$D1,$D2,$D3,$D4
	.db $D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,$6B,$6C,$0E,$00,$95
	.db $E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF
	.db $9F,$F0,$00,$74,$75,$0C,$00,$90,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8
	.db $F9,$FA,$FB,$FC,$FD,$FE,$FF,$73,$4F,$00,$8C,$27,$00,$07,$01,$0D
	.db $05,$00,$13,$14,$01,$12,$14,$36,$00,$8B,$10,$01,$13,$13,$00,$17
	.db $0F,$12,$04,$00,$00,$05,$2D,$4C,$00,$96,$32,$00,$1C,$24,$24,$1D
	.db $00,$0B,$0F,$0E,$01,$0D,$09,$00,$03,$0F,$39,$2E,$0C,$14,$04,$39
	.db $2B,$00,$94,$0C,$09,$03,$05,$0E,$13,$05,$04,$00,$02,$19,$00,$0E
	.db $09,$0E,$14,$05,$0E,$04,$0F,$21,$00,$70,$00,$85,$0A,$0A,$0A,$00
	.db $00,$0E,$55,$82,$15,$05,$20,$00
	.db $FF
Nametable04Data:
	.dw $2000
	.db $17,$00,$81,$BA,$06,$00,$8A,$BB,$00,$00,$BF,$B9,$BC,$B7,$BF,$00
	.db $BF,$07,$00,$81,$BA,$11,$00,$83,$B9,$BA,$BF,$0A,$00,$81,$BF,$05
	.db $00,$81,$B6,$0B,$00,$83,$BD,$BB,$B7,$18,$00,$83,$BB,$00,$B6,$05
	.db $00,$81,$BF,$04,$00,$94,$A0,$A2,$A4,$A6,$A8,$AA,$AC,$00,$A4,$AC
	.db $AE,$AC,$B0,$A6,$B2,$B4,$00,$00,$BB,$B6,$04,$00,$81,$BA,$07,$00
	.db $90,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$00,$A5,$AD,$AF,$AD,$B1,$A7,$B3
	.db $B5,$03,$00,$83,$BB,$00,$B7,$04,$00,$81,$BF,$17,$00,$84,$BD,$00
	.db $00,$BB,$15,$00,$8E,$BB,$00,$00,$B7,$00,$B7,$B9,$BC,$B7,$00,$BE
	.db $00,$00,$BF,$03,$00,$81,$BF,$04,$00,$84,$82,$83,$84,$85,$03,$00
	.db $8C,$BF,$00,$98,$99,$00,$BB,$00,$B6,$B8,$B7,$B9,$B8,$08,$00,$89
	.db $95,$96,$97,$00,$00,$86,$87,$88,$89,$04,$00,$8A,$BE,$9C,$9D,$9E
	.db $00,$BF,$BC,$B9,$00,$B7,$03,$00,$81,$BE,$03,$00,$8B,$BF,$BB,$00
	.db $9C,$9D,$9E,$00,$8A,$8B,$8C,$8D,$08,$00,$82,$B6,$B9,$03,$00,$84
	.db $BB,$00,$00,$BB,$05,$00,$81,$BF,$05,$00,$83,$8E,$8F,$90,$03,$00
	.db $8A,$BF,$BB,$B8,$00,$B8,$00,$00,$B6,$00,$B8,$04,$00,$81,$BB,$04
	.db $00,$81,$BF,$0C,$00,$87,$B7,$B9,$00,$B9,$00,$00,$BB,$04,$00,$81
	.db $B8,$03,$00,$81,$BB,$03,$00,$81,$BE,$0B,$00,$81,$BC,$08,$00,$81
	.db $BF,$05,$00,$81,$BF,$04,$00,$86,$BE,$BE,$B6,$BF,$00,$BF,$05,$00
	.db $81,$B7,$05,$00,$85,$01,$02,$03,$04,$05,$0C,$00,$88,$BB,$00,$C0
	.db $C1,$C2,$C3,$C4,$C5,$04,$00,$8C,$BF,$00,$06,$07,$08,$09,$0A,$0B
	.db $0C,$0D,$00,$BF,$07,$00,$8A,$BF,$00,$C6,$C7,$C8,$C9,$CA,$CB,$CC
	.db $BE,$04,$00,$8A,$0E,$17,$17,$0F,$10,$11,$12,$13,$14,$15,$03,$00
	.db $8F,$BE,$00,$00,$BB,$00,$BE,$BF,$CE,$CF,$D0,$D1,$D2,$D3,$D4,$D5
	.db $03,$00,$8C,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$6D,$1F,$20,$04
	.db $00,$9C,$BA,$00,$00,$BE,$00,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$00
	.db $00,$21,$22,$23,$24,$25,$26,$27,$28,$29,$42,$2A,$2B,$2C,$07,$00
	.db $89,$BF,$00,$DE,$DF,$E0,$E1,$E2,$E3,$E4,$03,$00,$8D,$2D,$17,$2E
	.db $2F,$30,$31,$32,$33,$34,$35,$36,$37,$38,$0A,$00,$85,$E6,$E7,$E8
	.db $E9,$EA,$04,$00,$8F,$39,$17,$3A,$3B,$3C,$3D,$3E,$3F,$40,$41,$42
	.db $43,$4F,$00,$BB,$05,$00,$89,$9A,$9B,$00,$EC,$ED,$EE,$EF,$F0,$BE
	.db $03,$00,$8D,$44,$17,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	.db $07,$00,$89,$9C,$9D,$9E,$00,$00,$BB,$BF,$BF,$BE,$03,$00,$8D,$50
	.db $17,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$05,$00,$81,$BF
	.db $05,$00,$84,$BF,$00,$BE,$B6,$04,$00,$8D,$5C,$5D,$5E,$5F,$60,$61
	.db $62,$63,$64,$65,$6D,$66,$67,$06,$00,$81,$B6,$05,$00,$8E,$BE,$BE
	.db $BF,$91,$92,$93,$94,$00,$68,$69,$6A,$6B,$6C,$64,$03,$6D,$82,$6E
	.db $6F,$06,$00,$83,$B9,$B8,$B7,$05,$00,$81,$BF,$03,$00,$8D,$9C,$9D
	.db $9E,$00,$70,$71,$72,$73,$74,$75,$76,$6E,$77,$06,$00,$85,$BB,$BB
	.db $00,$00,$BA,$09,$00,$81,$BF,$03,$00,$87,$78,$79,$7A,$7B,$7C,$7D
	.db $7E,$08,$00,$81,$B9,$11,$00,$83,$7F,$80,$81,$4A,$00,$8A,$C0,$00
	.db $00,$C0,$00,$30,$00,$0C,$C0,$00,$04,$0A,$96,$CC,$00,$00,$00,$00
	.db $00,$0A,$C2,$CF,$00,$CC,$F0,$F0,$00,$5F,$50,$5C,$1C,$30,$FF,$FF
	.db $73,$03,$55,$85,$1D,$FF,$FF,$FF,$44,$03,$55,$88,$00,$3C,$30,$07
	.db $C5,$45,$55,$15,$09,$00
	.db $FF
Nametable06Data:
	.dw $2000
	.db $64,$00,$40,$00,$98,$32,$1C,$24,$24,$1D,$00,$03,$0F,$0E,$14,$09
	.db $0E,$15,$09,$14,$19,$00,$07,$12,$01,$10,$08,$09,$03,$27,$00,$9A
	.db $01,$13,$13,$0F,$03,$09,$01,$14,$05,$13,$2E,$09,$0E,$03,$39,$0C
	.db $09,$03,$05,$0E,$13,$05,$04,$00,$02,$19,$2C,$00,$8E,$01,$02,$12
	.db $01,$0D,$13,$30,$07,$05,$0E,$14,$09,$0C,$05,$30,$00,$92,$05,$0E
	.db $14,$05,$12,$14,$01,$09,$0E,$0D,$05,$0E,$14,$2E,$09,$0E,$03,$39
	.db $30,$00,$8F,$01,$0E,$04,$00,$08,$01,$13,$02,$12,$0F,$2E,$09,$0E
	.db $03,$39,$2F,$00,$94,$01,$0C,$0C,$00,$12,$09,$07,$08,$14,$13,$00
	.db $12,$05,$13,$05,$12,$16,$05,$04,$39,$6A,$00,$96,$14,$09,$14,$0C
	.db $05,$00,$0D,$15,$13,$09,$03,$00,$06,$12,$0F,$0D,$00,$2B,$13,$17
	.db $0D,$2C,$29,$00,$99,$17,$12,$09,$14,$14,$05,$0E,$00,$02,$19,$00
	.db $04,$0F,$15,$07,$00,$0B,$01,$14,$13,$01,$12,$0F,$13,$39,$26,$00
	.db $9A,$32,$1C,$24,$24,$1D,$00,$13,$14,$01,$12,$00,$17,$09,$0C,$04
	.db $00,$0D,$15,$13,$09,$03,$2E,$09,$0E,$03,$39,$26,$00,$9A,$78,$02
	.db $0D,$09,$79,$00,$01,$0C,$0C,$00,$12,$09,$07,$08,$14,$13,$00,$12
	.db $05,$13,$05,$12,$16,$05,$04,$39,$64,$00,$5F,$00
	.db $FF
Nametable0AData:
	.dw $2000
	.db $7E,$00,$0A,$00,$10,$01,$10,$00,$81,$01,$0E,$00,$81,$01,$10,$00
	.db $81,$01,$0E,$00,$81,$01,$10,$00,$81,$01,$0E,$00,$81,$01,$10,$00
	.db $81,$01,$0E,$00,$81,$01,$10,$00,$81,$01,$0E,$00,$81,$01,$10,$00
	.db $81,$01,$0E,$00,$81,$01,$10,$00,$81,$01,$0E,$00,$81,$01,$10,$00
	.db $81,$01,$0E,$00,$81,$01,$10,$00,$81,$01,$0E,$00,$81,$01,$10,$00
	.db $81,$01,$0E,$00,$81,$01,$10,$00,$10,$01,$7E,$00,$7E,$00,$7E,$00
	.db $58,$00,$81,$3F,$03,$0F,$04,$00,$81,$33,$07,$00,$84,$33,$C0,$C0
	.db $30,$03,$00,$07,$50,$81,$00,$06,$55,$82,$03,$00,$06,$05,$09,$00
	.db $FF
Nametable0CData:
	.dw $2088
	.db $81,$B0,$0E,$B1,$81,$B2,$10,$00,$81,$B6,$0E,$00,$81,$B7,$10,$00
	.db $81,$B6,$0E,$00,$81,$B7,$10,$00,$81,$B6,$03,$00,$86,$B8,$B9,$BA
	.db $BB,$00,$BC,$05,$00,$81,$B7,$10,$00,$81,$B6,$05,$00,$85,$BD,$BE
	.db $BF,$C0,$C1,$04,$00,$81,$B7,$10,$00,$81,$B6,$05,$00,$85,$C2,$C3
	.db $C4,$C5,$C6,$04,$00,$81,$B7,$10,$00,$81,$B6,$05,$00,$86,$C7,$C8
	.db $C9,$CA,$CB,$CC,$03,$00,$81,$B7,$10,$00,$81,$B6,$05,$00,$8A,$CD
	.db $CE,$CF,$D0,$D1,$D2,$D3,$00,$00,$B7,$10,$00,$81,$B6,$05,$00,$85
	.db $D4,$D5,$D6,$D7,$D8,$04,$00,$81,$B7,$10,$00,$81,$B6,$03,$00,$87
	.db $D9,$DA,$DB,$DC,$DD,$DE,$DF,$04,$00,$81,$B7,$10,$00,$81,$B6,$0E
	.db $00,$81,$B7,$10,$00,$81,$B3,$0E,$B4,$81,$B5,$7F,$CB,$23,$82,$50
	.db $10,$06,$00,$82,$55,$15,$06,$00,$82,$05,$05
	.db $FF
Nametable0EData:
	.dw $20AC
	.db $81,$2B,$10,$00,$81,$2A,$0D,$00,$84,$29,$00,$00,$2A,$04,$00,$81
	.db $29,$05,$00,$81,$2B,$03,$00,$81,$2A,$11,$00,$81,$2B,$22,$00,$81
	.db $2A,$07,$00,$81,$2B,$13,$00,$81,$29,$07,$00,$81,$2A,$06,$00,$81
	.db $29,$1C,$00,$81,$29,$16,$00,$81,$2B,$0D,$00,$81,$2A,$09,$00,$83
	.db $2B,$00,$29,$08,$00,$84,$29,$00,$00,$29,$03,$00,$81,$2A,$12,$00
	.db $81,$2A,$03,$00,$81,$29,$07,$00,$81,$2A,$2F,$00,$81,$2A,$0A,$00
	.db $81,$2A,$08,$00,$81,$2A,$7F,$C8,$23,$82,$AA,$AA,$06,$AA,$82,$AA
	.db $AA,$06,$AA,$82,$FF,$FF,$26,$FF
	.db $FF
Nametable10Data:
	.dw $20A5
	.db $81,$B0,$08,$B1,$84,$B2,$00,$00,$B0,$08,$B1,$81,$B2,$0A,$00,$82
	.db $B6,$F2,$03,$00,$8C,$F2,$EC,$00,$00,$B7,$00,$00,$B6,$F8,$F8,$F3
	.db $F4,$04,$F8,$81,$B7,$0A,$00,$91,$B6,$00,$00,$F2,$00,$00,$ED,$00
	.db $F1,$B7,$00,$00,$B6,$F9,$F9,$F5,$F6,$04,$F9,$81,$B7,$0A,$00,$8D
	.db $B6,$00,$00,$F2,$F1,$00,$EE,$EF,$F0,$B7,$00,$00,$B6,$05,$FA,$84
	.db $F7,$FA,$FA,$B7,$0A,$00,$8D,$B6,$E0,$E1,$E2,$E3,$E0,$E1,$E2,$E3
	.db $B7,$00,$00,$B6,$08,$FB,$81,$B7,$0A,$00,$96,$B6,$E4,$E5,$E4,$E5
	.db $E4,$E5,$E4,$E5,$B7,$00,$00,$B6,$01,$02,$03,$04,$01,$02,$03,$04
	.db $B7,$0A,$00,$96,$B6,$E6,$E7,$E6,$E7,$E6,$E7,$E6,$E7,$B7,$00,$00
	.db $B6,$05,$06,$07,$08,$05,$06,$07,$08,$B7,$0A,$00,$8D,$B6,$E8,$E9
	.db $E8,$E9,$E8,$E9,$E8,$E9,$B7,$00,$00,$B6,$08,$FD,$81,$B7,$0A,$00
	.db $81,$B6,$08,$EA,$84,$B7,$00,$00,$B6,$08,$FE,$81,$B7,$0A,$00,$81
	.db $B3,$08,$B4,$84,$B5,$00,$00,$B3,$08,$B4,$81,$B5,$7F,$CC,$23,$93
	.db $80,$A0,$20,$00,$00,$40,$50,$10,$C8,$FA,$32,$00,$00,$04,$05,$01
	.db $0C,$0F,$03
	.db $FF
Nametable12Data:
	.dw $20A5
	.db $81,$B0,$08,$B1,$84,$B2,$00,$00,$B0,$08,$B1,$81,$B2,$0A,$00,$81
	.db $B6,$08,$1F,$8D,$B7,$00,$00,$B6,$09,$00,$00,$0A,$00,$09,$00,$00
	.db $B7,$0A,$00,$81,$B6,$03,$1F,$82,$1E,$22,$03,$1F,$8D,$B7,$00,$00
	.db $B6,$00,$0B,$0C,$0D,$09,$00,$00,$09,$B7,$0A,$00,$81,$B6,$03,$1F
	.db $92,$20,$21,$1F,$1F,$28,$B7,$00,$00,$B6,$09,$0E,$0F,$10,$09,$00
	.db $12,$13,$B7,$0A,$00,$81,$B6,$06,$1F,$8F,$28,$28,$B7,$00,$00,$B6
	.db $12,$13,$11,$12,$13,$00,$14,$11,$B7,$0A,$00,$96,$B6,$1F,$23,$24
	.db $25,$1F,$1F,$28,$28,$B7,$00,$00,$B6,$14,$12,$13,$15,$16,$16,$17
	.db $00,$B7,$0A,$00,$82,$B6,$26,$04,$27,$03,$28,$8D,$B7,$00,$00,$B6
	.db $18,$18,$00,$18,$00,$00,$18,$00,$B7,$0A,$00,$96,$B6,$29,$2A,$29
	.db $2A,$29,$2A,$29,$2A,$B7,$00,$00,$B6,$19,$1A,$1B,$19,$1A,$1B,$19
	.db $1A,$B7,$0A,$00,$96,$B6,$2B,$2B,$2C,$2D,$2B,$2C,$2D,$2B,$B7,$00
	.db $00,$B6,$1C,$1D,$1C,$1D,$1C,$1D,$1C,$1D,$B7,$0A,$00,$81,$B3,$08
	.db $B4,$84,$B5,$00,$00,$B3,$08,$B4,$81,$B5,$7F,$CC,$23,$82,$80,$20
	.db $06,$00,$83,$44,$55,$11,$05,$00,$83,$0C,$0F,$03
	.db $FF
Nametable14Data:
	.dw $208B
	.db $81,$B0,$08,$B1,$81,$B2,$16,$00,$8A,$B6,$00,$00,$2E,$2F,$30,$31
	.db $00,$00,$B7,$16,$00,$8A,$B6,$00,$32,$33,$34,$35,$36,$00,$00,$B7
	.db $16,$00,$8A,$B6,$37,$38,$39,$3A,$3B,$3C,$3D,$00,$B7,$16,$00,$81
	.db $B6,$03,$00,$86,$3E,$3F,$40,$41,$00,$B7,$16,$00,$8A,$B6,$42,$43
	.db $44,$45,$46,$00,$47,$48,$B7,$16,$00,$8A,$B6,$49,$4A,$4B,$4C,$4D
	.db $4E,$4F,$50,$B7,$16,$00,$8A,$B6,$51,$52,$53,$54,$55,$56,$57,$58
	.db $B7,$16,$00,$8A,$B6,$59,$5A,$5B,$60,$61,$62,$63,$64,$B7,$16,$00
	.db $8A,$B6,$65,$66,$67,$68,$69,$6A,$6B,$6C,$B7,$16,$00,$81,$B3,$08
	.db $B4,$81,$B5,$7F,$CB,$23,$82,$A8,$22,$06,$00,$82,$55,$55,$06,$00
	.db $82,$05,$05
	.db $FF
Nametable16Data:
	.dw $20A8
	.db $81,$B0,$0E,$B1,$81,$B2,$10,$00,$81,$B6,$0E,$00,$81,$B7,$10,$00
	.db $81,$B6,$03,$00,$88,$81,$82,$83,$84,$85,$86,$00,$F2,$03,$00,$81
	.db $B7,$10,$00,$8A,$B6,$00,$00,$87,$88,$89,$8A,$8B,$8C,$8D,$04,$00
	.db $82,$09,$B7,$10,$00,$8A,$B6,$00,$00,$8E,$00,$8F,$90,$00,$91,$92
	.db $05,$00,$81,$B7,$10,$00,$81,$B6,$04,$00,$81,$93,$07,$00,$83,$09
	.db $F2,$B7,$10,$00,$81,$B6,$04,$00,$86,$94,$95,$96,$97,$98,$99,$04
	.db $00,$81,$B7,$10,$00,$81,$B6,$04,$00,$8B,$9A,$9B,$9C,$9D,$9E,$9F
	.db $00,$F2,$00,$00,$B7,$10,$00,$81,$B6,$03,$FC,$88,$00,$A1,$A2,$A3
	.db $A4,$A5,$A6,$00,$03,$FC,$81,$B7,$10,$00,$81,$B6,$03,$FC,$8C,$A7
	.db $A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,$FC,$FC,$B7,$10,$00,$81,$B3,$0E
	.db $B4,$81,$B5,$7F,$CA,$23,$83,$40,$50,$10,$05,$00,$83,$44,$55,$51
	.db $06,$00,$82,$A5,$A5
	.db $FF
Nametable18Data:
	.dw $2043
	.db $81,$B0,$05,$B1,$83,$B2,$00,$B0,$05,$B1,$81,$B2,$11,$00,$8F,$B6
	.db $00,$5A,$5B,$5C,$00,$B7,$00,$B6,$00,$2C,$2D,$2E,$2F,$B7,$11,$00
	.db $8F,$B6,$5E,$5F,$60,$61,$62,$B7,$00,$B6,$30,$31,$32,$33,$34,$B7
	.db $11,$00,$8F,$B6,$63,$64,$65,$66,$67,$B7,$00,$B6,$35,$36,$37,$38
	.db $39,$B7,$11,$00,$8F,$B6,$68,$69,$6A,$6B,$6C,$B7,$00,$B6,$3A,$3B
	.db $3C,$3D,$3E,$B7,$04,$00,$81,$B0,$05,$B1,$81,$B2,$06,$00,$8F,$B6
	.db $00,$6D,$6E,$6F,$70,$B7,$00,$B6,$3F,$40,$41,$42,$43,$B7,$04,$00
	.db $87,$B6,$13,$14,$15,$16,$17,$B7,$06,$00,$81,$B3,$05,$B4,$83,$B5
	.db $00,$B3,$05,$B4,$81,$B5,$04,$00,$87,$B6,$18,$19,$1A,$1B,$1C,$B7
	.db $19,$00,$87,$B6,$1D,$1E,$1F,$20,$21,$B7,$06,$00,$81,$B0,$05,$B1
	.db $83,$B2,$00,$B0,$05,$B1,$81,$B2,$04,$00,$87,$B6,$22,$23,$24,$25
	.db $26,$B7,$06,$00,$8B,$B6,$00,$44,$45,$46,$00,$B7,$00,$B6,$01,$02
	.db $03,$00,$81,$B7,$04,$00,$87,$B6,$27,$28,$29,$2A,$2B,$B7,$06,$00
	.db $8F,$B6,$48,$49,$4A,$4B,$4C,$B7,$00,$B6,$03,$04,$05,$06,$00,$B7
	.db $04,$00,$81,$B3,$05,$B4,$81,$B5,$06,$00,$8F,$B6,$4D,$4E,$4F,$00
	.db $50,$B7,$00,$B6,$00,$07,$08,$09,$0A,$B7,$11,$00,$8F,$B6,$51,$52
	.db $53,$54,$55,$B7,$00,$B6,$00,$0B,$0C,$0D,$0E,$B7,$11,$00,$8F,$B6
	.db $00,$56,$57,$58,$59,$B7,$00,$B6,$00,$0F,$10,$11,$12,$B7,$11,$00
	.db $81,$B3,$05,$B4,$83,$B5,$00,$B3,$05,$B4,$81,$B5,$7F,$C0,$23,$83
	.db $80,$A0,$20,$05,$00,$90,$88,$AA,$22,$00,$00,$C0,$F0,$30,$08,$0A
	.db $42,$50,$10,$CC,$FF,$33,$02,$00,$86,$44,$55,$11,$0C,$0F,$03,$02
	.db $00,$83,$04,$05,$01
	.db $FF
Nametable1AData:
	.dw $20C6
	.db $81,$B0,$05,$B1,$81,$B2,$06,$00,$81,$B0,$05,$B1,$81,$B2,$0C,$00
	.db $87,$B6,$00,$2C,$2D,$2E,$2F,$B7,$06,$00,$87,$B6,$13,$14,$15,$16
	.db $17,$B7,$0C,$00,$87,$B6,$30,$31,$32,$33,$34,$B7,$06,$00,$87,$B6
	.db $18,$19,$1A,$1B,$1C,$B7,$0C,$00,$87,$B6,$35,$36,$37,$38,$39,$B7
	.db $06,$00,$87,$B6,$1D,$1E,$1F,$20,$21,$B7,$0C,$00,$87,$B6,$3A,$3B
	.db $3C,$3D,$3E,$B7,$06,$00,$87,$B6,$22,$23,$24,$25,$26,$B7,$0C,$00
	.db $87,$B6,$3F,$40,$41,$42,$43,$B7,$06,$00,$87,$B6,$27,$28,$29,$2A
	.db $2B,$B7,$0C,$00,$81,$B3,$05,$B4,$81,$B5,$06,$00,$81,$B3,$05,$B4
	.db $81,$B5,$7F,$CC,$23,$83,$C0,$F0,$30,$05,$00,$83,$CC,$FF,$33,$05
	.db $00,$83,$0C,$0F,$03
	.db $FF
Nametable1CData:
	.dw $20C6
	.db $81,$B0,$05,$B1,$81,$B2,$06,$00,$81,$B0,$05,$B1,$81,$B2,$0C,$00
	.db $87,$B6,$00,$44,$45,$46,$47,$B7,$06,$00,$87,$B6,$13,$14,$15,$16
	.db $17,$B7,$0C,$00,$87,$B6,$48,$49,$4A,$4B,$4C,$B7,$06,$00,$87,$B6
	.db $18,$19,$1A,$1B,$1C,$B7,$0C,$00,$87,$B6,$4D,$4E,$4F,$00,$50,$B7
	.db $06,$00,$87,$B6,$1D,$1E,$1F,$20,$21,$B7,$0C,$00,$87,$B6,$51,$52
	.db $53,$54,$55,$B7,$06,$00,$87,$B6,$22,$23,$24,$25,$26,$B7,$0C,$00
	.db $87,$B6,$00,$56,$57,$58,$59,$B7,$06,$00,$87,$B6,$27,$28,$29,$2A
	.db $2B,$B7,$0C,$00,$81,$B3,$05,$B4,$81,$B5,$06,$00,$81,$B3,$05,$B4
	.db $81,$B5,$7F,$CC,$23,$83,$C0,$F0,$30,$05,$00,$83,$CC,$FF,$33,$05
	.db $00,$83,$0C,$0F,$03
	.db $FF
Nametable1EData:
	.dw $20C6
	.db $81,$B0,$05,$B1,$81,$B2,$06,$00,$81,$B0,$05,$B1,$81,$B2,$0C,$00
	.db $83,$B6,$01,$02,$03,$00,$81,$B7,$06,$00,$87,$B6,$13,$14,$15,$16
	.db $17,$B7,$0C,$00,$87,$B6,$03,$04,$05,$06,$00,$B7,$06,$00,$87,$B6
	.db $18,$19,$1A,$1B,$1C,$B7,$0C,$00,$87,$B6,$00,$07,$08,$09,$0A,$B7
	.db $06,$00,$87,$B6,$1D,$1E,$1F,$20,$21,$B7,$0C,$00,$87,$B6,$00,$0B
	.db $0C,$0D,$0E,$B7,$06,$00,$87,$B6,$22,$23,$24,$25,$26,$B7,$0C,$00
	.db $87,$B6,$00,$0F,$10,$11,$12,$B7,$06,$00,$87,$B6,$27,$28,$29,$2A
	.db $2B,$B7,$0C,$00,$81,$B3,$05,$B4,$81,$B5,$06,$00,$81,$B3,$05,$B4
	.db $81,$B5,$7F,$C9,$23,$96,$40,$50,$10,$C0,$F0,$30,$00,$00,$44,$55
	.db $11,$CC,$FF,$33,$00,$00,$04,$05,$01,$0C,$0F,$03
	.db $FF
Nametable20Data:
	.dw $20C6
	.db $81,$B0,$05,$B1,$81,$B2,$06,$00,$81,$B0,$05,$B1,$81,$B2,$0C,$00
	.db $87,$B6,$00,$5A,$5B,$5C,$5D,$B7,$06,$00,$87,$B6,$13,$14,$15,$16
	.db $17,$B7,$0C,$00,$87,$B6,$5E,$5F,$60,$61,$62,$B7,$06,$00,$87,$B6
	.db $18,$19,$1A,$1B,$1C,$B7,$0C,$00,$87,$B6,$63,$64,$65,$66,$67,$B7
	.db $06,$00,$87,$B6,$1D,$1E,$1F,$20,$21,$B7,$0C,$00,$87,$B6,$68,$69
	.db $6A,$6B,$6C,$B7,$06,$00,$87,$B6,$22,$23,$24,$25,$26,$B7,$0C,$00
	.db $87,$B6,$00,$6D,$6E,$6F,$00,$B7,$06,$00,$87,$B6,$27,$28,$29,$2A
	.db $2B,$B7,$0C,$00,$81,$B3,$05,$B4,$81,$B5,$06,$00,$81,$B3,$05,$B4
	.db $81,$B5,$7F,$C9,$23,$96,$80,$A0,$20,$C0,$F0,$30,$00,$00,$88,$AA
	.db $22,$CC,$FF,$33,$00,$00,$08,$0A,$02,$0C,$0F,$03
	.db $FF
Nametable22Data:
	.dw $20CE
	.db $8B,$01,$02,$03,$04,$05,$00,$4A,$49,$4A,$49,$49,$0E,$00,$81,$4A
	.db $03,$49,$89,$4A,$06,$07,$08,$09,$09,$0A,$0B,$0C,$17,$00,$82,$0D
	.db $0E,$03,$0F,$85,$10,$0F,$10,$11,$12,$16,$00,$8A,$13,$14,$15,$16
	.db $17,$18,$00,$18,$09,$19,$15,$00,$8D,$1A,$1B,$14,$97,$00,$97,$1C
	.db $0F,$0F,$10,$1D,$1E,$1F,$13,$00,$8D,$20,$09,$14,$97,$00,$97,$00
	.db $21,$22,$18,$09,$23,$24,$13,$00,$8D,$25,$09,$14,$97,$00,$15,$16
	.db $26,$27,$28,$29,$2A,$2B,$13,$00,$84,$2C,$2D,$14,$97,$04,$00,$84
	.db $2E,$18,$09,$30,$15,$00,$84,$31,$14,$97,$32,$04,$0F,$86,$34,$35
	.db $49,$49,$4A,$49,$0F,$00,$86,$49,$4A,$49,$36,$37,$38,$04,$39,$83
	.db $3A,$3B,$3C,$17,$00,$88,$3D,$3E,$3F,$09,$09,$40,$41,$42,$1A,$00
	.db $85,$44,$45,$46,$47,$48,$7F,$C9,$23,$81,$40,$04,$50,$81,$10,$03
	.db $00,$84,$44,$55,$55,$51,$04,$00,$81,$54,$03,$55,$81,$10,$04,$00
	.db $82,$05,$05
	.db $FF
Nametable24Data:
	.dw $262A
	.db $86,$4F,$50,$51,$52,$53,$54,$19,$00,$88,$55,$56,$57,$58,$59,$5A
	.db $5B,$60,$18,$00,$84,$61,$62,$62,$63,$03,$64,$81,$65,$18,$00,$88
	.db $66,$67,$68,$69,$6A,$6B,$6C,$6D,$17,$00,$8A,$6E,$6F,$70,$71,$72
	.db $73,$74,$64,$64,$75,$16,$00,$8A,$76,$77,$78,$79,$7A,$7B,$7C,$7D
	.db $7E,$7F,$16,$00,$8A,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CE,$CF,$D0,$16
	.db $00,$8A,$D1,$D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$19,$00,$84,$DB
	.db $E0,$E1,$E2,$7E,$00,$1D,$00,$83,$50,$50,$10,$15,$00,$83,$55,$55
	.db $10,$05,$00,$83,$A5,$A5,$21,$05,$00,$83,$0A,$0A,$02
	.db $FF
Nametable08Data:
	.dw $2087
	.db $81,$30,$10,$31,$81,$32,$0E,$00,$81,$36,$10,$00,$81,$37,$0E,$00
	.db $81,$36,$0C,$00,$85,$99,$9E,$9F,$A0,$37,$0E,$00,$81,$36,$04,$00
	.db $84,$A1,$A2,$A3,$A4,$04,$00,$85,$A5,$A6,$A7,$A8,$37,$0E,$00,$81
	.db $36,$04,$00,$8D,$A9,$AA,$AB,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4
	.db $37,$0E,$00,$81,$36,$04,$00,$8D,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC
	.db $BD,$BE,$BF,$C0,$37,$0E,$00,$92,$36,$C1,$C2,$C3,$C4,$C5,$C6,$C7
	.db $C8,$C9,$CA,$CB,$9A,$9B,$9C,$9D,$D0,$37,$0E,$00,$92,$36,$00,$D1
	.db $D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$CC,$CD,$CE,$CF,$37,$0E
	.db $00,$92,$36,$00,$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB
	.db $EC,$ED,$EE,$37,$0E,$00,$92,$36,$00,$F0,$F1,$F2,$F3,$F4,$F5,$F6
	.db $F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$37,$0E,$00,$81,$33,$10,$34,$81
	.db $35,$7F,$CD,$23,$81,$A0,$04,$00,$84,$50,$00,$FF,$5A,$04,$00,$84
	.db $05,$00,$05,$05
	.db $FF

;;;;;;;;;;;;;;;;;;;;
;COPY PROTECT CHECK;
;;;;;;;;;;;;;;;;;;;;
CopyProtectCheck:
	;Clear hard mode flag
	lda #$00
	sta HardModeFlag
	rts

;;;;;;;;;;;;;;;;;;;;;
;IRQ BUFFER SET DATA;
;;;;;;;;;;;;;;;;;;;;;
IRQBufferSetPointerTable:
	.dw IRQBufferSet00Data	;$00  Normal gameplay
	.dw IRQBufferSet02Data	;$02  Level 1 ships
	.dw IRQBufferSet04Data	;$04  Level 1 boss
	.dw IRQBufferSet06Data	;$06  Level 2/4 vertical scrolling area
	.dw IRQBufferSet08Data	;$08  Level 2 volcano
	.dw IRQBufferSet0AData	;$0A  Level 2 big rolling ball area
	.dw IRQBufferSet0CData	;$0C \Level 2 boss
	.dw IRQBufferSet0EData	;$0E /
	.dw IRQBufferSet10Data	;$10  Level 3 water
	.dw IRQBufferSet12Data	;$12  Level 3 iceberg
	.dw IRQBufferSet14Data	;$14  Level 3 horizontal ice cave areas
	.dw IRQBufferSet16Data  ;$16  Level 3 boss
	.dw IRQBufferSet18Data	;$18  Level 4 boss
	.dw IRQBufferSet1AData  ;$1A  Level 4 start area
	.dw IRQBufferSet1CData  ;$1C  Level 4 ships (area 2)
	.dw IRQBufferSet1EData	;$1E  Level 4 ships (area 3)
	.dw IRQBufferSet20Data	;$20  Level 5 elevators
	.dw IRQBufferSet22Data	;$22  Dialog
	.dw IRQBufferSet24Data	;$24  Title screen
	.dw IRQBufferSet26Data	;$26 \Level 6 boss
	.dw IRQBufferSet28Data	;$28 |
	.dw IRQBufferSet2AData	;$2A /
	.dw IRQBufferSet2CData	;$2C  Blueprint
	.dw IRQBufferSet2EData	;$2E  Level 8 miniboss ship
	.dw IRQBufferSet30Data	;$30  Level 8 miniboss snake
	.dw IRQBufferSet32Data	;$32  Level 8 boss

IRQBufferSet00Data:
	.db $01
	.db $BE,$00,$C0,$20	;level
IRQBufferSet02Data:
	.db $06
	.db $47,$00,$C0,$20	;level
	.db $15,$00,$78,$20	;mountains
	.db $20,$00,$60,$24	;bottom ships
	.db $20,$00,$40,$20	;top ships
	.db $1E,$00,$20,$20	;stars
	.db $01,$80,$00,$24
IRQBufferSet04Data:
	.db $03
	.db $17,$00,$C0,$20	;ground
	.db $A5,$00,$A8,$24	;background and large stone
	.db $01,$00,$00,$24
IRQBufferSet06Data:
	.db $05
	.db $01,$00,$C0,$20	;5th row of platforms
	.db $2F,$00,$C0,$24	;4th row of platforms
	.db $30,$00,$90,$24	;3rd row of platforms
	.db $30,$00,$60,$24	;2nd row of platforms
	.db $30,$00,$30,$24	;1st row of platforms
IRQBufferSet08Data:
	.db $04
	.db $3F,$00,$C0,$20	;ground
	.db $37,$00,$80,$20	;bottom clouds and volcano
	.db $0F,$00,$48,$20	;top clouds
	.db $37,$00,$38,$20	;sky gradient
IRQBufferSet0AData:
	.db $03
	.db $2F,$00,$C0,$20	;ground
	.db $4F,$00,$90,$24	;big rolling ball
	.db $3F,$00,$40,$24	;ceiling
IRQBufferSet0CData:
	.db $04
	.db $2F,$00,$C0,$20	;ground
	.db $5F,$00,$90,$24	;rolling ball
	.db $10,$00,$30,$24	;background top
	.db $1E,$00,$00,$24	;background top
IRQBufferSet0EData:
	.db $04
	.db $2F,$00,$C0,$20	;ground
	.db $27,$00,$90,$24	;rolling ball bottom half
	.db $01,$FF,$68,$24	;rolling ball opening
	.db $65,$FF,$00,$24	;rolling ball top half
IRQBufferSet10Data:
	.db $03
	.db $1F,$00,$C0,$20
	.db $07,$00,$A0,$20	;underwater
	.db $97,$00,$C0,$24	;water surface
IRQBufferSet12Data:
	.db $07
	.db $1E,$00,$C0,$20	;underwater
	.db $05,$F8,$A0,$24	;water surface
	.db $37,$00,$98,$20	;iceberg
	.db $1F,$F8,$60,$24	;bottom clouds
	.db $1F,$00,$40,$20	;top clouds and ship
	.db $1D,$00,$20,$20	;planets
	.db $01,$00,$00,$20
IRQBufferSet14Data:
	.db $02
	.db $06,$00,$C0,$20	;water
	.db $B6,$00,$B8,$20	;level
IRQBufferSet16Data:
	.db $03
	.db $0D,$00,$C0,$20	;ground
	.db $02,$00,$B0,$20	;water
	.db $AE,$00,$08,$20	;background
IRQBufferSet18Data:
	.db $03
	.db $3F,$00,$C0,$20	;ground
	.db $57,$00,$80,$24	;tank
	.db $26,$80,$28,$24	;ceiling
IRQBufferSet1AData:
	.db $04
	.db $4F,$00,$C0,$20	;level
	.db $1F,$00,$70,$20	;mountains
	.db $4D,$00,$50,$20	;stars and planets
	.db $01,$00,$00,$20
IRQBufferSet1CData:
	.db $04
	.db $5C,$00,$C0,$20	;level
	.db $2F,$00,$60,$20	;bottom ships
	.db $2F,$00,$30,$20	;top ships
	.db $01,$00,$00,$20
IRQBufferSet1EData:
	.db $05
	.db $2B,$00,$C0,$20	;5th row of ships
	.db $2F,$00,$90,$20	;4th row of ships
	.db $2F,$00,$60,$20	;3rd row of ships
	.db $2F,$00,$30,$20	;2nd row of ships
	.db $01,$00,$00,$20	;1st row of ships
IRQBufferSet20Data:
	.db $02
	.db $1F,$00,$C0,$20	;elevator platform
	.db $9E,$00,$A0,$20	;background
IRQBufferSet22Data:
	.db $01
	.db $87,$00,$88,$20	;Scene area
IRQBufferSet2CData:
	.db $01
	.db $97,$00,$98,$20	;Scene area
IRQBufferSet24Data:
	.db $01
	.db $87,$00,$88,$20	;Title graphic area
IRQBufferSet26Data:
	.db $03
	.db $1D,$00,$C0,$20	;ground
	.db $9F,$00,$C0,$24	;background
	.db $01,$00,$00,$20	;mecha suit
IRQBufferSet28Data:
	.db $03
	.db $1D,$00,$C0,$20	;ground
	.db $01,$00,$C0,$24	;background
	.db $9F,$00,$00,$20	;mecha suit
IRQBufferSet2AData:
	.db $04
	.db $1D,$00,$C0,$20	;ground
	.db $01,$00,$C0,$24	;background
	.db $07,$00,$00,$20	;mecha suit feet
	.db $97,$00,$B8,$24	;mecha suit
IRQBufferSet2EData:
	.db $06
	.db $16,$00,$C0,$20	;ground
	.db $01,$00,$A8,$24	;background bottom
	.db $06,$00,$C0,$24	;mini-boss ship
	.db $4E,$99,$00,$24	;mini-boss ship mask
	.db $4D,$00,$C0,$24	;background top
	.db $01,$00,$C0,$24
IRQBufferSet30Data:
	.db $05
	.db $06,$00,$C0,$20
	.db $37,$00,$B8,$24	;mini-boss snake bottom
	.db $3F,$00,$80,$24	;background
	.db $27,$00,$40,$24	;mini-boss snake top
	.db $17,$00,$18,$24	;ceiling
IRQBufferSet32Data:
	.db $03
	.db $1E,$00,$C0,$20	;ground
	.db $7F,$00,$A0,$24	;background lava
	.db $1F,$FF,$20,$24	;ceiling

;;;;;;;;;;;;;;;;;;;
;CHR BANK SET DATA;
;;;;;;;;;;;;;;;;;;;
CHRBankSetPointerTable:
	.dw CHRBankSet00Data	;$00  Title screen
	.dw CHRBankSet02Data	;$02  Level 1 area 0/1
	.dw CHRBankSet04Data	;$04  Level 1 area 2
	.dw CHRBankSet06Data	;$06  Level 1 area 4
	.dw CHRBankSet08Data	;$08  Level 2 area 0/1/2
	.dw CHRBankSet0AData	;$0A  Level 2 area 3/4/5
	.dw CHRBankSet0CData	;$0C  Level 1 area 5
	.dw CHRBankSet0EData	;$0E  Level 1 area 3
	.dw CHRBankSet10Data	;$10  Level 1 area 6/7
	.dw CHRBankSet12Data	;$12  Level 3 area 0/4
	.dw CHRBankSet14Data	;$14  Level 3 area 6/7/8
	.dw CHRBankSet16Data	;$16  Level 3 area 9
	.dw CHRBankSet18Data	;$18  Level 2 area 8
	.dw CHRBankSet1AData	;$1A  Level 4 area 0/1/2/3/4
	.dw CHRBankSet1CData	;$1C  Level 4 area 5
	.dw CHRBankSet1EData	;$1E  Level 4 area 6
	.dw CHRBankSet20Data	;$20  Level 3 area 5
	.dw CHRBankSet22Data	;$22  Level 3 area 1/2/3
	.dw CHRBankSet24Data	;$24  Level 4 area 7
	.dw CHRBankSet26Data	;$26  Stage select
	.dw CHRBankSet28Data    ;$28  UNUSED
	.dw CHRBankSet2AData	;$2A  Level 5 area 0/1/2/3/6/7
	.dw CHRBankSet2CData	;$2C  Level 5 area 9/A/B/C
	.dw CHRBankSet2EData	;$2E  Level 6 area 1/2/3/4
	.dw CHRBankSet30Data	;$30  Level 6 area 5/6/7/8
	.dw CHRBankSet32Data	;$32  Level 7 area 7/8/9/A
	.dw CHRBankSet34Data	;$34  Hero ship/toad ship chase
	.dw CHRBankSet36Data	;$36  Level 5 area D
	.dw CHRBankSet38Data	;$38  Level 5 area E
	.dw CHRBankSet3AData	;$3A  Level 5 area F
	.dw CHRBankSet3CData	;$3C  Intro part 5/6
	.dw CHRBankSet3EData	;$3E  Ready/Game over
	.dw CHRBankSet40Data	;$40  Level 5 area 4/5/8
	.dw CHRBankSet42Data	;$42  Intro part 3
	.dw CHRBankSet44Data	;$42  Intro part 4
	.dw CHRBankSet46Data	;$46  Level 8 area 0/1/2/3/5
	.dw CHRBankSet48Data	;$48  Level 6 area 9
	.dw CHRBankSet4AData	;$4A  Dialog
	.dw CHRBankSet4CData	;$4C  Blueprint
	.dw CHRBankSet4EData	;$4E  Level 7 area 4
	.dw CHRBankSet50Data	;$50  Level 7 area 0/1/2/3
	.dw CHRBankSet52Data	;$52  Level 7 area B/C/D
	.dw CHRBankSet54Data	;$54  Level 7 area 5
	.dw CHRBankSet56Data	;$56  Level 7 area 6
	.dw CHRBankSet58Data	;$58  Toad ship distant
	.dw CHRBankSet5AData	;$5A  THE END screen
	.dw CHRBankSet5CData	;$5C  Level 7 area E
	.dw CHRBankSet5EData	;$5E  Level 8 area 6
	.dw CHRBankSet60Data	;$60  Level 6 area 0
	.dw CHRBankSet62Data	;$62  Level 8 area 4

CHRBankSet00Data:
	.db $3E,$36,$55,$0A
CHRBankSet02Data:
	.db $00,$02,$59,$5A
CHRBankSet04Data:
	.db $7C,$04,$5A,$5B
CHRBankSet06Data:
	.db $7C,$0C,$59,$60
CHRBankSet08Data:
	.db $18,$06,$5E,$5F
CHRBankSet0AData:
	.db $10,$06,$5E,$5F
CHRBankSet0CData:
	.db $7C,$1C,$5C,$5D
CHRBankSet0EData:
	.db $7C,$04,$5A,$5D
CHRBankSet10Data:
	.db $26,$00,$5E,$5F
CHRBankSet12Data:
	.db $48,$0E,$60,$61
CHRBankSet14Data:
	.db $12,$0E,$60,$61
CHRBankSet16Data:
	.db $12,$06,$62,$61
CHRBankSet18Data:
	.db $26,$00,$5D,$5F
CHRBankSet1AData:
	.db $0C,$16,$63,$66
CHRBankSet1CData:
	.db $1A,$1C,$63,$66
CHRBankSet1EData:
	.db $24,$16,$63,$66
CHRBankSet20Data:
	.db $1C,$0E,$60,$61
CHRBankSet22Data:
	.db $48,$0E,$65,$61
CHRBankSet24Data:
	.db $1A,$06,$67,$60
CHRBankSet26Data:
	.db $40,$42,$65,$5A
CHRBankSet28Data:
	.db $0A,$46,$0A,$67
CHRBankSet2AData:
	.db $14,$48,$68,$64
CHRBankSet2CData:
	.db $14,$1E,$63,$64
CHRBankSet2EData:
	.db $28,$2A,$69,$6A
CHRBankSet30Data:
	.db $28,$48,$69,$6B
CHRBankSet32Data:
	.db $20,$22,$59,$6B
CHRBankSet34Data:
	.db $3E,$46,$57,$6F
CHRBankSet36Data:
	.db $14,$48,$52,$64
CHRBankSet38Data:
	.db $14,$48,$53,$64
CHRBankSet3AData:
	.db $14,$48,$51,$64
CHRBankSet3CData:
	.db $3C,$46,$57,$6F
CHRBankSet3EData:
	.db $0A,$44,$0A,$0B
CHRBankSet40Data:
	.db $14,$00,$68,$64
CHRBankSet42Data:
	.db $3C,$46,$51,$51
CHRBankSet44Data:
	.db $3C,$46,$52,$52
CHRBankSet46Data:
	.db $30,$32,$77,$70
CHRBankSet48Data:
	.db $24,$26,$67,$6A
CHRBankSet4AData:
	.db $44,$46,$6A,$63
CHRBankSet4CData:
	.db $38,$3A,$55,$55
CHRBankSet4EData:
	.db $2C,$2E,$71,$73
CHRBankSet50Data:
	.db $02,$2E,$6B,$5F
CHRBankSet52Data:
	.db $4C,$2E,$65,$75
CHRBankSet54Data:
	.db $2C,$2E,$6C,$73
CHRBankSet56Data:
	.db $48,$2E,$6C,$73
CHRBankSet58Data:
	.db $38,$3E,$6D,$70
CHRBankSet5AData:
	.db $46,$3A,$66,$67
CHRBankSet5CData:
	.db $78,$7A,$73,$76
CHRBankSet5EData:
	.db $30,$04,$77,$64
CHRBankSet60Data:
	.db $28,$2A,$72,$73
CHRBankSet62Data:
	.db $30,$32,$77,$76

;ENEMY INITIAL STATE DATA
EnemyInitialAnimation:
	.db $00,$E5,$E7,$00,$10,$0A,$0A,$0A,$00,$A8,$76,$78,$B8,$74,$BA,$20
	.db $AE,$B0,$B2,$B6,$C9,$82,$88,$86,$E0,$A8,$A8,$84,$80,$E2,$A6,$90
	.db $92,$7C,$D2,$A8,$7E,$0A,$D2,$0A,$CE,$F2,$F6,$A8,$A8,$A8,$C2,$E0
	.db $D8,$D4,$D8,$A8,$A8,$A8,$3D,$0D,$0F,$FE,$33,$01,$35,$41,$15,$1B
	.db $A8,$A8,$07,$0A,$A8,$4F,$57,$43,$6F,$73,$75,$4D,$A8,$A8,$7B,$24
	.db $24,$51,$45,$A8,$24,$A8,$A8,$16,$04,$06,$02,$8B,$9B,$5A,$A8,$A8
	.db $A8,$56,$62,$64,$A8,$97,$85,$8F,$98,$93,$9F,$45,$A8,$B4,$A7,$A8
	.db $A8,$BD,$24,$E1,$BB,$BB,$A8,$A8,$24,$A8,$0C,$0E,$A8,$AC,$96,$FF
	.db $E3,$36,$8B,$3C,$22,$12,$A8
EnemyInitialHP:
	.db $FF,$07,$07,$FF,$00,$01,$FF,$02,$FF,$01,$01,$04,$04,$01,$FF,$20
	.db $FF,$FF,$FF,$FF,$FF,$FF,$28,$FF,$FF,$FF,$FF,$FF,$01,$FF,$FF,$FF
	.db $FF,$01,$FF,$FF,$FF,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$01,$FF
	.db $FF,$18,$FF,$FF,$FF,$01,$01,$0C,$0C,$FF,$FF,$FF,$FF,$FF,$A0,$FF
	.db $FF,$FF,$FF,$08,$01,$02,$FF,$02,$04,$FF,$FF,$FF,$FF,$FF,$0C,$FF
	.db $FF,$0C,$01,$01,$FF,$FF,$FF,$FF,$70,$70,$70,$FF,$FF,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$40,$01,$01,$01,$60,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$FF,$FF,$02,$02,$80,$18,$FF,$80,$FF,$10,$FF,$04,$01,$11
	.db $06,$40,$80,$01,$05,$10,$FF

;;;;;;;;;;;;;;;;;
;VRAM STRIP DATA;
;;;;;;;;;;;;;;;;;
VRAMStrip00PointerTable:
	.dw VRAMStrip00Data	;$00  "GAME START" text
	.dw PaletteStrip01Data	;$01  Title screen palette
	.dw VRAMStrip02Data	;$02  HUD tilemap
	.dw PaletteStrip03Data	;$03  Blank
	.dw PaletteStrip04Data	;$04  Level 2 area 0 palette
	.dw PaletteStrip05Data	;$05  Level 2 area 1/2 palette
	.dw PaletteStrip06Data	;$06  Level 2 area 3 palette
	.dw PaletteStrip07Data	;$07  Level 1 area 4 palette
	.dw VRAMStrip08Data	;$08  "GAME START" text clear
	.dw VRAMStrip09Data	;$09  "SOUND CHECK" text (UNUSED)
	.dw PaletteStrip0AData	;$0A  Level 1 area 1 palette
	.dw VRAMStrip0BData	;$0B  Level 1 (GREEN planet)
	.dw VRAMStrip0CData	;$0C  Level 2 (RED planet)
	.dw VRAMStrip0DData	;$0D  Level 3 (BLUE planet)
	.dw VRAMStrip0EData	;$0E  Level 4 (YELLOW planet)
	.dw VRAMStrip0FData	;$0F  Level 5 (CEll)
	.dw VRAMStrip10Data	;$10  Level 6 (SALVAGE chute)
	.dw VRAMStrip11Data	;$11  Level 7 (CENTER of MAGMA tanker)
	.dw VRAMStrip12Data	;$12  Level 8 (ESCApe!)
	.dw PaletteStrip13Data	;$13  Ready/Game over palette
	.dw PaletteStrip14Data	;$14  Level 1 area 0 palette
	.dw VRAMStrip15Data	;$15  "CONTINUE" "END" text
	.dw PaletteStrip16Data	;$16  Level 1 area 5 palette
	.dw PaletteStrip17Data	;$17  Level 1 area 2 palette
	.dw PaletteStrip18Data	;$18  Level 1 area 3 palette
	.dw PaletteStrip19Data	;$19  Level 2 area 6/7 palette
	.dw PaletteStrip1AData	;$1A  Level 2 area 8 palette
	.dw PaletteStrip1BData	;$1B  Level 3 area 0/6/7/8 palette
	.dw VRAMStrip1CData	;$1C  Level 3 water
	.dw PaletteStrip1DData	;$1D  Level 4 area 0/1 palette
	.dw PaletteStrip1EData	;$1E  Level 4 area 2 palette
	.dw PaletteStrip1FData	;$1F  Level 4 area 3/4 palette
	.dw PaletteStrip20Data	;$20  Level 4 area 5 palette
	.dw PaletteStrip21Data	;$21  Level 4 area 7 palette
	.dw PaletteStrip22Data	;$22  Level 3 area 4/5 palette
	.dw PaletteStrip23Data	;$23  Level 3 area 1/2/3 palette
	.dw PaletteStrip24Data	;$24  Level 3 area 9 palette
	.dw PaletteStrip25Data	;$25  Stage select palette
	.dw PaletteStrip26Data	;$26  Level 2 area 4/5 palette
	.dw PaletteStrip27Data	;$27  Level 4 area 6 palette
	.dw VRAMStrip28Data	;$28  "  STAGE " text
	.dw PaletteStrip29Data	;$29  Level 5 area 0/1/2/3/6/7 palette
	.dw PaletteStrip2AData	;$2A  Level 5 area 9/A/B/C palette
	.dw PaletteStrip2BData	;$2B  Level 6 area 0 palette
	.dw PaletteStrip2CData	;$2C  Level 6 area 1 palette
	.dw PaletteStrip2DData	;$2D  Level 6 area 2/3/4 palette
	.dw PaletteStrip2EData	;$2E  Level 6 area 5/6/7 palette
	.dw PaletteStrip2FData	;$2F  Level 6 area 8 palette
	.dw PaletteStrip30Data	;$30  Level 7 area 0/1/2/3 palette
	.dw PaletteStrip31Data	;$31  Level 7 area 4/5/6 palette
	.dw PaletteStrip32Data	;$32  Level 7 area 7/8/9/A palette
	.dw PaletteStrip33Data	;$33  UNUSED
	.dw VRAMStrip34Data	;$34 \Level 5 elevator
	.dw VRAMStrip35Data	;$35 /
	.dw PaletteStrip36Data	;$36  Level 5 area D palette
	.dw PaletteStrip37Data	;$37  Level 5 area E palette
	.dw PaletteStrip38Data	;$38  Level 5 area F palette
	.dw PaletteStrip39Data	;$39  Level 5 hypno flash palette
	.dw PaletteStrip3AData	;$3A  Hero ship/Intro toad ship chase palette
	.dw PaletteStrip3BData	;$3B  Intro part 3 palette
	.dw PaletteStrip3CData	;$3C  Intro part 4 palette
	.dw PaletteStrip3DData	;$3D  Intro part 5 palette
	.dw PaletteStrip3EData	;$3E  Intro part 6 palette
	.dw PaletteStrip3FData	;$3F  Level 5 area 4/5/8 palette
	.dw PaletteStrip40Data	;$40  Level 8 area 0/1/2/3 palette
	.dw PaletteStrip41Data	;$41  Level 8 area 0/1/2/3 flashing palette
	.dw PaletteStrip42Data	;$42  UNUSED
	.dw PaletteStrip43Data	;$43  Level 6 area 9 palette
	.dw PaletteStrip44Data	;$44 \Level 5 big elevator palette
	.dw PaletteStrip45Data	;$45 /
	.dw VRAMStrip46Data	;$46 \Title screen cursor
	.dw VRAMStrip47Data	;$47 /
	.dw PaletteStrip48Data	;$48  Dialog palette
	.dw PaletteStrip49Data	;$49  Blueprint palette
	.dw PaletteStrip4AData	;$4A \Level 7 flashing palette
	.dw PaletteStrip4BData	;$4B |
	.dw PaletteStrip4CData	;$4C /
	.dw PaletteStrip4DData	;$4D  Level 7 area B/C/D palette
	.dw PaletteStrip4EData	;$4E  Toad ship distant palette
	.dw PaletteStrip4FData	;$4F  "THE END" palette
	.dw PaletteStrip50Data	;$50  Level 8 area 0/1/2/3 flashing palette
	.dw VRAMStrip51Data	;$51  Level 7 boss clear
	.dw PaletteStrip52Data	;$52  Level 8 area 4/5 palette
	.dw PaletteStrip53Data	;$53  Level 8 area 4/5 flashing palette
	.dw PaletteStrip54Data	;$54  Level 8 miniboss ship defeated palette
	.dw PaletteStrip55Data	;$55  Level 8 area 0/1/2/3 flashing palette
	.dw PaletteStrip56Data	;$56  Level 8 area 6 palette
	.dw PaletteStrip57Data	;$57  Level 8 boss flashing palette
	.dw PaletteStrip58Data	;$58  Level 7 area E palette
	.dw PaletteStrip59Data	;$59 \Level 7 boss flashing palette
	.dw PaletteStrip5AData	;$5A |
	.dw PaletteStrip5BData	;$5B /
	.dw PaletteStrip5CData	;$5C  Captured toad ship chase palette
	.dw PaletteStrip5DData	;$5D  Level 7 boss defeated palette
	.dw VRAMStrip5EData	;$5E \Credits text (     "STAFF-CREW"                        )
	.dw VRAMStrip5FData	;$5F |             ("PROGRAM AND DIRECTOR"     "M.MAEGAWA"   )
	.dw VRAMStrip60Data	;$60 |             (     "PROGRAMMER"           "H.AWAI"     )
	.dw VRAMStrip61Data	;$61 |             (                          "K.SHINDOH"    )
	.dw VRAMStrip62Data	;$62 |             (                           "M.TAIRA"     )
	.dw VRAMStrip63Data	;$63 |             (                          "T.FURUKAWA"   )
	.dw VRAMStrip64Data	;$64 |             (  "SOUND DESIGNER"       "T.SUMIYAMA"    )
	.dw VRAMStrip65Data	;$65 |             (                         "N.NAKAZATO"    )
	.dw VRAMStrip66Data	;$66 |             (                         "H.SUGANAMI"    )
	.dw VRAMStrip67Data	;$67 |             (                           "A.FUJIO"     )
	.dw VRAMStrip68Data	;$68 |             (                          "K.KIMURA"     )
	.dw VRAMStrip69Data	;$69 |             (                          "Y.YAMADA"     )
	.dw VRAMStrip6AData	;$6A |             (                          "M.OOSANI"     )
	.dw VRAMStrip6BData	;$6B |             (                         "K.SHIMOIDE"    )
	.dw VRAMStrip6CData	;$6C |             (     "THANK YOU"       "FOR YOUR PLAYING")
	.dw VRAMStrip6DData	;$6D |             (    "PRESENTED BY"          "KONAMI"     )
	.dw VRAMStrip6EData	;$6E |             (  "GRAPHIC DESIGNER"                     )
	.dw VRAMStrip6FData	;$6F /             (  "SPECIAL THANKS"                       )
	.dw VRAMStrip70Data	;$70  "THE END" text
	.dw VRAMStrip71Data	;$71  "STAGE SELECT" text

;VRAM STRIPS
VRAMStrip00Data:
	.dw $2249
	.db $07,$01,$0D,$05,$00,$13,$14,$01,$12,$14
	.db $FF
VRAMStrip08Data:
	.dw $2249
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $FF
VRAMStrip28Data:
	.dw $22A9
	.db $00,$00,$13,$14,$01,$07,$05,$00
	.db $FF
VRAMStrip46Data:
	.dw $2247
	.db $5D
	.db $FE
	.dw $2287
	.db $00
	.db $FF
VRAMStrip47Data:
	.dw $2247
	.db $00
	.db $FE
	.dw $2287
	.db $5D
	.db $FF
VRAMStrip02Data:
	.dw $2322
	.db $1C,$10,$00,$1B,$1B,$1B,$1B,$1B,$1B,$00,$0C,$09,$06,$05,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$00,$00,$00,$00,$00,$00
	.db $08,$09,$00,$1B,$1B,$20,$1B,$1B,$1B,$00,$10,$0F,$17,$05,$12
	.db $FF
VRAMStrip09Data:
	.dw $22E9
	.db $13,$0F,$15,$0E,$04,$00,$03,$08,$05,$03,$0B,$00,$00
	.db $FF
;Unreferenced VRAM strip data???
	.dw $21EA
	.db $13,$14,$01,$12,$14,$00,$04,$05,$0D,$0F
	.db $FF
VRAMStrip0BData:
	.dw $21A9
	.db $07,$12,$05,$05,$0E
	.db $FF
VRAMStrip0CData:
	.dw $21AA
	.db $12,$05,$04
	.db $FF
VRAMStrip0DData:
	.dw $21A9
	.db $02,$0C,$15,$05
	.db $FF
VRAMStrip0EData:
	.dw $21A9
	.db $19,$05,$0C,$0C,$0F,$17
	.db $FF
VRAMStrip0FData:
	.dw $21AD
	.db $03,$05
	.db $FF
VRAMStrip10Data:
	.dw $21A8
	.db $13,$01,$0C,$16,$01,$07,$05
	.db $FF
VRAMStrip11Data:
	.dw $21A4
	.db $03,$05,$0E,$14,$05,$12,$00,$00,$00,$00,$0D,$01,$07,$0D,$01
	.db $FF
VRAMStrip12Data:
	.dw $21AC
	.db $05,$13,$03,$01
	.db $FF
VRAMStrip15Data:
	.dw $220A
	.db $03,$0F,$0E,$14,$09,$0E,$15,$05
	.db $FE
	.dw $224A
	.db $05,$0E,$04
	.db $FF
VRAMStrip71Data:
	.dw $228A
	.db $13,$14,$01,$07,$05,$00,$13,$05,$0C,$05,$03,$14
	.db $FF
VRAMStrip1CData:
	.dw $2300
	.db $F9
	.db $FE
	.dw $2700
	.db $F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA
	.db $F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA,$F9,$FA
	.db $FF
VRAMStrip34Data:
	.dw $23E8
	.db $AA,$5A,$5A,$5A,$5A,$5A,$5A,$AA
	.db $FE
	.dw $2280
	.db $75,$76,$00,$52,$53,$54,$54,$54,$54,$54,$54,$54,$54,$54,$54,$54
	.db $54,$54,$54,$54,$54,$54,$54,$54,$54,$54,$54,$55,$56,$00,$75,$76
	.db $75,$76,$E7,$E8,$E9,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
	.db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EB,$EC,$ED,$75,$76
	.db $FF
VRAMStrip35Data:
	.dw $22C0
	.db $75,$76,$E5,$E6,$E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4
	.db $E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4,$E3,$E4,$E5,$E6,$75,$76
	.db $75,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$75,$76
	.db $FF
VRAMStrip51Data:
	.dw $2538
	.db $00,$00,$00,$00
	.db $FE
	.dw $2557
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $FE
	.dw $2577
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $FE
	.dw $2597
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $FE
	.dw $25B7
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $FE
	.dw $25D8
	.db $00,$00,$00,$00
	.db $FF

;PALETTE STRIPS
PaletteStrip01Data:
	.db $27,$16,$20,$27,$14,$03,$27,$16,$10,$0F,$0F,$0F
	.db $0F,$0F,$0F,$0F,$0F,$0F,$27,$27,$27,$0F,$0F,$0F
PaletteStrip13Data:
	.db $3A,$3A,$3A,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	.db $35,$35,$35,$3A,$3A,$3A
PaletteStrip03Data:
	.db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	.db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
PaletteStrip25Data:
	.db $18,$28,$39,$17,$27,$37,$17,$27,$37,$02,$21,$3C
	.db $0F,$23,$33,$15,$26,$36,$1A,$29,$26,$10,$29,$20
PaletteStrip3AData:
	.db $13,$2C,$20,$16,$06,$27,$19,$29,$20,$00,$10,$20
	.db $03,$20,$10,$13,$20,$21,$27,$2C,$17,$09,$20,$29
PaletteStrip3BData:
	.db $12,$21,$20,$19,$17,$29,$27,$14,$01,$27,$16,$03
	.db $02,$15,$27,$02,$20,$10,$08,$37,$15,$08,$27,$15
PaletteStrip3CData:
	.db $12,$21,$20,$00,$10,$29,$29,$17,$19,$27,$13,$20
	.db $01,$20,$21,$0F,$20,$15,$08,$27,$36,$08,$20,$16
PaletteStrip3DData:
	.db $11,$21,$20,$09,$29,$19,$13,$27,$20,$13,$27,$20
	.db $13,$27,$11,$2C,$20,$11,$0F,$0F,$0F,$0F,$0F,$0F
PaletteStrip3EData:
	.db $12,$21,$20,$09,$29,$19,$16,$27,$20,$0F,$0F,$0F
	.db $12,$27,$16,$24,$20,$21,$09,$19,$29,$09,$19,$29
PaletteStrip48Data:
	.db $11,$21,$20,$16,$26,$27,$07,$36,$17,$09,$19,$29
	.db $25,$15,$2A,$25,$20,$21,$37,$20,$0F,$17,$37,$27
PaletteStrip49Data:
	.db $01,$21,$20,$15,$11,$1B,$01,$21,$20,$15,$11,$1B
	.db $0F,$24,$38,$15,$26,$36,$1A,$29,$26,$10,$29,$20
PaletteStrip4EData:
	.db $01,$11,$20,$19,$29,$26,$00,$10,$10,$15,$25,$26
	.db $03,$20,$10,$0F,$37,$27,$03,$20,$10,$16,$21,$14
PaletteStrip5CData:
	.db $13,$2C,$20,$16,$06,$27,$19,$29,$20,$00,$10,$20
	.db $16,$21,$14,$13,$20,$21,$27,$2C,$17,$00,$10,$20
PaletteStrip4FData:
	.db $01,$21,$20,$15,$26,$27,$08,$36,$17,$09,$19,$29
	.db $25,$15,$2A,$25,$20,$21,$37,$20,$0F,$17,$37,$27
PaletteStrip14Data:
	.db $13,$21,$20,$13,$29,$19,$13,$17,$27,$16,$00,$10
	.db $09,$20,$29,$07,$27,$16
PaletteStrip0AData:
	.db $13,$22,$20,$13,$29,$19,$13,$17,$27,$19,$17,$27
	.db $09,$20,$29,$07,$37,$26
PaletteStrip07Data:
	.db $11,$2C,$20,$19,$39,$29,$27,$17,$29,$29,$00,$10
	.db $09,$20,$29,$07,$27,$16
PaletteStrip16Data:
	.db $11,$2C,$20,$19,$39,$29,$27,$17,$29,$29,$00,$10
	.db $02,$29,$23,$02,$37,$27
PaletteStrip17Data:
	.db $01,$21,$20,$39,$19,$0A,$27,$17,$09,$0F,$0F,$0F
	.db $0F,$39,$19,$17,$29,$27
PaletteStrip18Data:
	.db $01,$13,$22,$39,$29,$19,$27,$17,$19,$0F,$0F,$0F
	.db $09,$20,$29,$06,$26,$36
PaletteStrip04Data:
	.db $16,$27,$20,$27,$0C,$17,$00,$07,$32,$05,$03,$0C
	.db $09,$20,$29,$06,$27,$16
PaletteStrip05Data:
	.db $16,$27,$20,$0B,$1A,$2A,$00,$07,$32,$06,$16,$27
	.db $09,$20,$29,$06,$27,$16
PaletteStrip06Data:
	.db $16,$27,$20,$0B,$0A,$1A,$17,$12,$10,$06,$16,$27
	.db $09,$20,$29,$06,$27,$16
PaletteStrip19Data:
	.db $00,$07,$32,$0B,$1A,$2A,$08,$07,$17,$0B,$09,$19
	.db $09,$20,$29,$06,$27,$16
PaletteStrip1AData:
	.db $00,$07,$32,$0B,$1A,$2A,$08,$07,$27,$0B,$09,$19
	.db $09,$20,$29,$27,$17,$08
PaletteStrip26Data:
	.db $16,$27,$20,$0B,$1A,$2A,$00,$07,$32,$06,$16,$27
	.db $09,$20,$29,$0F,$21,$11
PaletteStrip1BData:
	.db $12,$21,$20,$02,$13,$23,$00,$10,$20,$3B,$29,$17
	.db $09,$20,$29,$12,$20,$21
PaletteStrip22Data:
	.db $12,$21,$20,$02,$13,$23,$20,$21,$29,$16,$21,$29
	.db $09,$20,$29,$01,$27,$15
PaletteStrip23Data:
	.db $12,$21,$20,$02,$13,$23,$20,$21,$29,$16,$21,$29
	.db $0F,$20,$11,$12,$20,$21
PaletteStrip24Data:
	.db $11,$21,$20,$13,$23,$20,$09,$39,$19,$07,$15,$27
	.db $03,$37,$23,$03,$21,$15
PaletteStrip1DData:
	.db $03,$27,$37,$00,$08,$10,$01,$1C,$20,$17,$16,$26
	.db $09,$20,$29,$0B,$00,$20
PaletteStrip1EData:
	.db $03,$27,$37,$08,$39,$29,$27,$06,$29,$29,$00,$10
	.db $09,$20,$29,$0B,$00,$20
PaletteStrip1FData:
	.db $03,$27,$37,$08,$39,$29,$27,$06,$29,$29,$00,$10
	.db $02,$32,$12,$0B,$00,$10
PaletteStrip20Data:
	.db $00,$10,$20,$03,$11,$3C,$27,$17,$29,$17,$16,$26
	.db $09,$20,$29,$06,$17,$36
PaletteStrip21Data:
	.db $15,$27,$20,$18,$29,$38,$27,$28,$17,$13,$00,$10
	.db $15,$27,$20,$01,$21,$31
PaletteStrip27Data:
	.db $00,$10,$20,$00,$02,$10,$1A,$2B,$23,$16,$10,$36
	.db $09,$20,$29,$07,$37,$27
PaletteStrip29Data:
	.db $03,$1B,$32,$00,$10,$17,$15,$19,$29,$0C,$16,$27
	.db $09,$20,$29,$0F,$10,$00
PaletteStrip2AData:
	.db $03,$1B,$32,$00,$29,$27,$00,$10,$17,$17,$26,$20
	.db $09,$20,$29,$06,$17,$36
PaletteStrip44Data:
	.db $03,$1B,$32,$00,$29,$27,$00,$10,$17,$17,$26,$25
	.db $09,$20,$29,$06,$17,$36
PaletteStrip45Data:
	.db $03,$1B,$32,$00,$29,$27,$00,$10,$17,$17,$26,$2A
	.db $09,$20,$29,$06,$17,$36
PaletteStrip33Data:
	.db $03,$1B,$32,$00,$29,$27,$00,$10,$17,$26,$27,$03
	.db $09,$20,$29,$02,$27,$15
PaletteStrip36Data:
	.db $03,$1B,$32,$00,$10,$17,$15,$19,$29,$11,$21,$20
	.db $01,$20,$21,$0F,$20,$15
PaletteStrip37Data:
	.db $03,$1B,$32,$00,$10,$17,$15,$19,$29,$27,$36,$20
	.db $08,$27,$36,$08,$20,$16
PaletteStrip38Data:
	.db $03,$1B,$32,$00,$10,$17,$15,$19,$29,$16,$27,$20
	.db $08,$37,$15,$08,$27,$15
PaletteStrip39Data:
	.db $03,$1B,$32,$00,$10,$17,$15,$19,$29,$0C,$16,$27
	.db $09,$20,$29,$02,$27,$21
PaletteStrip3FData:
	.db $07,$16,$36,$00,$10,$17,$0B,$01,$08,$0C,$16,$27
	.db $09,$20,$29,$06,$20,$24
PaletteStrip2BData:
	.db $1C,$2C,$20,$0B,$2B,$15,$0A,$2A,$27,$16,$26,$36
	.db $02,$20,$22,$09,$20,$29
PaletteStrip2CData:
	.db $1C,$2C,$20,$0B,$2B,$15,$0B,$37,$27,$0B,$37,$27
	.db $0B,$3B,$2B,$0F,$20,$20
PaletteStrip2DData:
	.db $02,$2C,$20,$0B,$2B,$15,$03,$23,$33,$0F,$16,$26
	.db $0B,$3B,$2B,$04,$24,$27
PaletteStrip2EData:
	.db $00,$10,$20,$0B,$2B,$15,$0A,$2A,$27,$0B,$11,$21
	.db $27,$13,$15,$0F,$0F,$0F
PaletteStrip2FData:
	.db $07,$17,$27,$0B,$2B,$15,$0A,$2A,$27,$06,$16,$26
	.db $00,$10,$2B,$04,$24,$15
PaletteStrip42Data:
	.db $1C,$2C,$20,$0B,$2B,$15,$0A,$2A,$27,$16,$26,$36
	.db $0B,$3B,$2B,$0F,$0F,$0F
PaletteStrip43Data:
	.db $26,$10,$20,$00,$10,$20,$01,$13,$20,$07,$27,$37
	.db $09,$20,$29,$01,$13,$20
PaletteStrip30Data:
	.db $07,$00,$10,$27,$00,$10,$04,$0C,$02,$04,$0C,$02
	.db $09,$20,$29,$07,$10,$00
PaletteStrip31Data:
	.db $07,$00,$10,$37,$00,$10,$17,$37,$27,$03,$2B,$3A
	.db $0A,$3A,$2A,$29,$20,$14
PaletteStrip4AData:
	.db $07,$00,$10,$27,$00,$10,$17,$37,$27,$03,$2B,$3A
	.db $0A,$3A,$2A,$29,$20,$14
PaletteStrip4BData:
	.db $07,$00,$10,$17,$00,$10,$17,$37,$27,$03,$2B,$3A
	.db $0A,$3A,$2A,$29,$20,$14
PaletteStrip4CData:
	.db $07,$00,$10,$0F,$00,$10,$17,$37,$27,$03,$2B,$3A
	.db $0A,$3A,$2A,$29,$20,$14
PaletteStrip32Data:
	.db $00,$10,$20,$2B,$1A,$39,$07,$00,$10,$0F,$0F,$0F
	.db $0C,$20,$2C,$07,$20,$27
PaletteStrip4DData:
	.db $03,$13,$20,$1C,$00,$10,$07,$17,$27,$07,$17,$27
	.db $0F,$33,$12,$07,$20,$27
PaletteStrip5DData:
	.db $17,$00,$37,$16,$26,$36,$07,$16,$36,$0C,$27,$35
	.db $09,$20,$29,$04,$20,$24
PaletteStrip58Data:
	.db $00,$10,$20,$19,$29,$39,$07,$16,$36,$0C,$27,$35
	.db $09,$20,$29,$04,$20,$24
PaletteStrip59Data:
	.db $00,$10,$20,$19,$29,$39,$07,$16,$36,$0C,$27,$25
	.db $09,$20,$29,$04,$20,$24
PaletteStrip5AData:
	.db $00,$10,$20,$19,$29,$39,$07,$16,$36,$0C,$27,$15
	.db $09,$20,$29,$04,$20,$24
PaletteStrip5BData:
	.db $00,$10,$20,$19,$29,$39,$07,$16,$36,$0C,$27,$0F
	.db $09,$20,$29,$04,$20,$24
PaletteStrip40Data:
	.db $08,$10,$20,$03,$03,$27,$09,$19,$29,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip41Data:
	.db $08,$10,$20,$01,$38,$27,$09,$19,$29,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip50Data:
	.db $08,$10,$20,$0B,$0B,$27,$09,$19,$29,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip55Data:
	.db $08,$10,$20,$09,$38,$27,$09,$19,$29,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip52Data:
	.db $08,$10,$20,$21,$31,$20,$09,$19,$0F,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip53Data:
	.db $08,$10,$20,$01,$11,$21,$09,$19,$0F,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip54Data:
	.db $08,$10,$20,$21,$31,$20,$09,$19,$15,$05,$17,$26
	.db $09,$20,$29,$02,$20,$22
PaletteStrip57Data:
	.db $08,$10,$20,$15,$27,$20,$01,$2B,$06,$07,$17,$27
	.db $09,$20,$29,$02,$20,$22
PaletteStrip56Data:
	.db $08,$10,$20,$15,$27,$37,$21,$2B,$26,$07,$17,$27
	.db $09,$20,$29,$02,$20,$22

;PLAYER PALETTE DATA
PlayerPaletteData:
	.db $0F,$08,$20,$29,$0F,$08,$27,$15	;Bucky normal palette
	.db $0F,$01,$20,$21,$0F,$0F,$20,$15	;Jenny normal palette
	.db $0F,$08,$37,$15,$0F,$08,$27,$15	;Dead-Eye normal palette
	.db $0F,$01,$15,$27,$0F,$01,$20,$10	;Blinky normal palette
	.db $0F,$08,$27,$36,$0F,$08,$20,$16	;Willy normal palette
	.db $0F,$20,$08,$29,$0F,$27,$08,$15	;Bucky flashing palette
	.db $0F,$01,$21,$20,$0F,$0F,$20,$20	;Jenny flashing palette
	.db $0F,$37,$08,$15,$0F,$08,$15,$27	;Dead-Eye flashing palette
	.db $0F,$01,$27,$15,$0F,$01,$10,$20	;Blinky flashing palette
	.db $0F,$08,$36,$27,$0F,$08,$16,$20	;Willy flashing palette

;VRAM STRIPS
VRAMStrip5EData:
	.dw $272B
	.db $13,$14,$01,$06,$06,$2D,$03,$12,$05,$17
	.db $FF
VRAMStrip5FData:
	.dw $2726
	.db $10,$12,$0F,$07,$12,$01,$0D,$00,$01,$0E,$04,$00,$04,$09,$12,$05
	.db $03,$14,$05,$04
	.db $FE
	.dw $274C
	.db $0D,$39,$0D,$01,$05,$07,$01,$17,$01
	.db $FF
VRAMStrip60Data:
	.dw $272B
	.db $10,$12,$0F,$07,$12,$01,$0D,$0D,$05,$12
	.db $FE
	.dw $274D
	.db $08,$39,$01,$17,$01,$09
	.db $FF
VRAMStrip61Data:
	.dw $274B
	.db $0B,$39,$13,$08,$09,$0E,$04,$0F,$08
	.db $FF
VRAMStrip62Data:
	.dw $274C
	.db $0D,$39,$14,$01,$09,$12,$01
	.db $FF
VRAMStrip63Data:
	.dw $274B
	.db $14,$39,$06,$15,$12,$15,$0B,$01,$17,$01
	.db $FF
VRAMStrip64Data:
	.dw $2728
	.db $13,$0F,$15,$0E,$04,$00,$04,$05,$13,$09,$07,$0E,$05,$12
	.db $FE
	.dw $274A
	.db $14,$39,$13,$15,$0D,$09,$19,$01,$0D,$01
	.db $FF
VRAMStrip65Data:
	.dw $274A
	.db $0E,$39,$0E,$01,$0B,$01,$1A,$01,$14,$0F
	.db $FF
VRAMStrip66Data:
	.dw $274A
	.db $08,$39,$13,$15,$07,$01,$0E,$01,$0D,$09
	.db $FF
VRAMStrip67Data:
	.dw $274C
	.db $01,$39,$06,$15,$0A,$09,$0F
	.db $FF
VRAMStrip68Data:
	.dw $274B
	.db $0B,$39,$0B,$09,$0D,$15,$12,$01
	.db $FF
VRAMStrip69Data:
	.dw $274B
	.db $19,$39,$19,$01,$0D,$01,$04,$01
	.db $FF
VRAMStrip6AData:
	.dw $274B
	.db $0D,$39,$0F,$0F,$14,$01,$0E,$09
	.db $FF
VRAMStrip6BData:
	.dw $274A
	.db $0B,$39,$13,$08,$09,$0D,$0F,$09,$04,$05
	.db $FF
VRAMStrip6CData:
	.dw $272B
	.db $14,$08,$01,$0E,$0B,$00,$19,$0F,$15
	.db $FE
	.dw $2748
	.db $06,$0F,$12,$00,$19,$0F,$15,$12,$00,$10,$0C,$01,$19,$09,$0E,$07
	.db $FF
VRAMStrip6DData:
	.dw $272A
	.db $10,$12,$05,$13,$05,$0E,$14,$05,$04,$00,$02,$19
	.db $FE
	.dw $274D
	.db $0B,$0F,$0E,$01,$0D,$09
	.db $FF
VRAMStrip6EData:
	.dw $2728
	.db $07,$12,$01,$10,$08,$09,$03,$00,$04,$05,$13,$09,$07,$0E,$05,$12
	.db $FF
VRAMStrip6FData:
	.dw $2728
	.db $13,$10,$05,$03,$09,$01,$0C,$00,$14,$08,$01,$0E,$0B,$13
	.db $FF
VRAMStrip70Data:
	.dw $222C
	.db $81,$83,$85,$00,$85,$87,$89
	.db $FE
	.dw $224C
	.db $82,$84,$86,$00,$86,$88,$8A
	.db $FE
	.dw $23E3
	.db $55,$55
	.db $FF

VRAMStrip80PointerTable:
	.dw VRAMStrip80Data	;$80 \BG fire arch
	.dw VRAMStrip81Data	;$81 |
	.dw VRAMStrip82Data	;$82 |
	.dw VRAMStrip83Data	;$83 |
	.dw VRAMStrip84Data	;$84 |
	.dw VRAMStrip85Data	;$85 |
	.dw VRAMStrip86Data	;$86 |
	.dw VRAMStrip87Data	;$87 |
	.dw VRAMStrip88Data	;$88 |
	.dw VRAMStrip89Data	;$89 |
	.dw VRAMStrip8AData	;$8A |
	.dw VRAMStrip8BData	;$8B |
	.dw VRAMStrip8CData	;$8C |
	.dw VRAMStrip8DData	;$8D |
	.dw VRAMStrip8EData	;$8E |
	.dw VRAMStrip8FData	;$8F |
	.dw VRAMStrip90Data	;$90 |
	.dw VRAMStrip91Data	;$91 |
	.dw VRAMStrip92Data	;$92 |
	.dw VRAMStrip93Data	;$93 |
	.dw VRAMStrip94Data	;$94 |
	.dw VRAMStrip95Data	;$95 /
	.dw ClearStrip96Data	;$96  Clear $2700-$273F
	.dw ClearStrip97Data	;$97  Clear $2740-$277F
	.dw VRAMStrip98Data	;$98  Hypno Jenny rescued
	.dw VRAMStrip99Data	;$99  Hypno Willy rescued
	.dw VRAMStrip9AData	;$9A  Hypno Dead-Eye rescued
	.dw VRAMStrip80Data	;$9B  UNUSED
	.dw VRAMStrip9CData	;$9C \Level 6 boss ground
	.dw VRAMStrip9DData	;$9D /
	.dw ClearStrip9EData	;$9E  Clear $2780-$27BF
	.dw ClearStrip9FData	;$9F  Clear $27F0-$27FF

;VRAM STRIPS
VRAMStrip80Data:
	.dw $2248
	.db $7D,$7E,$7F
	.db $FE
	.dw $2267
	.db $77,$7B,$75,$7C
	.db $FE
	.dw $2284
	.db $00,$73,$77,$7A,$71,$75,$7F,$00
	.db $FE
	.dw $22A4
	.db $00,$77,$7A,$71,$7B,$78,$79,$00
	.db $FE
	.dw $22C4
	.db $73,$74,$71,$71,$7B,$75,$76,$D0
	.db $FE
	.dw $22E4
	.db $DC,$72,$72,$72,$71,$72,$DE,$DC
	.db $FF
VRAMStrip81Data:
	.dw $21E9
	.db $7D,$7E,$70
	.db $FE
	.dw $2207
	.db $73,$77,$7B,$75,$7C
	.db $FE
	.dw $2226
	.db $73,$77,$7A,$71,$75,$7F
	.db $FE
	.dw $2245
	.db $73,$77,$6D,$71,$75,$6F,$7F
	.db $FE
	.dw $2265
	.db $77,$6D,$71,$71,$75,$79,$00
	.db $FE
	.dw $2284
	.db $73,$74,$71
	.db $FE
	.dw $22A4
	.db $77,$60
	.db $FE
	.dw $22C4
	.db $77,$7B
	.db $FF
VRAMStrip82Data:
	.dw $21A9
	.db $73,$69,$69,$6A,$6B,$6C
	.db $FE
	.dw $21C8
	.db $73,$77,$6D,$7B,$67,$68
	.db $FE
	.dw $21E8
	.db $77,$6D,$71,$75,$6F,$6C
	.db $FE
	.dw $2206
	.db $73,$77
	.db $FE
	.dw $2226
	.db $77,$74
	.db $FE
	.dw $2246
	.db $74,$7A
	.db $FE
	.dw $2267
	.db $71
	.db $FF
VRAMStrip83Data:
	.dw $2208
	.db $6D,$71,$75,$6F
	.db $FE
	.dw $2228
	.db $7B,$65,$6E,$7F
	.db $FE
	.dw $2248
	.db $71,$75,$79,$00
	.db $FE
	.dw $2268
	.db $72,$75,$7C
	.db $FF
VRAMStrip84Data:
	.dw $218B
	.db $73,$63,$63,$6A,$6B,$6C
	.db $FE
	.dw $21A9
	.db $73,$69,$6D,$6D,$6D,$67,$68
	.db $FE
	.dw $21C8
	.db $73,$77,$6D,$7B,$71,$75,$68
	.db $FE
	.dw $21E8
	.db $77,$6D,$71,$75,$6F,$62
	.db $FF
VRAMStrip85Data:
	.dw $216D
	.db $73,$63,$63,$56,$56,$5A,$57
	.db $FE
	.dw $218C
	.db $5E,$6D,$6D,$5F,$7B,$61,$17,$7F
	.db $FE
	.dw $21AC
	.db $71,$71,$71,$71,$67,$68
	.db $FE
	.dw $21CD
	.db $5C,$61,$62
	.db $FE
	.dw $21EC
	.db $5B,$70
	.db $FF
VRAMStrip86Data:
	.dw $2190
	.db $5F,$53,$53,$55,$36
	.db $FE
	.dw $21B0
	.db $72,$52,$72,$53,$53,$36
	.db $FE
	.dw $21D0
	.db $62,$50,$3F,$52,$52,$53,$2C
	.db $FE
	.dw $21F2
	.db $4F,$51,$37,$52,$53,$2F
	.db $FE
	.dw $2214
	.db $51,$37,$2D,$3E
	.db $FE
	.dw $2213
	.db $3C
	.db $FE
	.dw $2235
	.db $3C,$40,$40
	.db $FF
VRAMStrip87Data:
	.dw $21A9
	.db $00
	.db $FE
	.dw $21C8
	.db $00,$73
	.db $FE
	.dw $21E8
	.db $73,$5E
	.db $FE
	.dw $2206
	.db $0,$73,$6D,$71,$75,$6F,$7F
	.db $FE
	.dw $2226
	.db $73,$77
	.db $FE
	.dw $2266
	.db $6D
	.db $FF
VRAMStrip88Data:
	.dw $2208
	.db $69,$71,$75,$7F
	.db $FE
	.dw $2228
	.db $71,$75,$79,$00
	.db $FE
	.dw $2248
	.db $71,$75,$6C
	.db $FE
	.dw $2268
	.db $71,$4E,$00
	.db $FE
	.dw $2214
	.db $39,$37,$52,$29
	.db $FE
	.dw $2234
	.db $3C,$39,$37,$3D,$3E
	.db $FE
	.dw $2255
	.db $3C,$39,$3F,$66
	.db $FE
	.dw $2276
	.db $41,$40,$40
	.db $FF
VRAMStrip89Data:
	.dw $2216
	.db $52,$71,$2C
	.db $FE
	.dw $2236
	.db $52,$52,$2D,$2E
	.db $FE
	.dw $2256
	.db $37,$52,$3D,$2E
	.db $FE
	.dw $2276
	.db $30,$37,$3D,$4D
	.db $FE
	.dw $2296
	.db $31,$30,$52,$33
	.db $FE
	.dw $22B7
	.db $3A,$37,$4E
	.db $FE
	.dw $22D7
	.db $3A,$37,$35,$2D,$2C
	.db $FE
	.dw $22F7
	.db $35,$52,$52,$52,$27
	.db $FF
VRAMStrip8AData:
	.dw $2208
	.db $7E,$75,$4A,$00,$00
	.db $FE
	.dw $2228
	.db $7B,$75,$00,$00
	.db $FE
	.dw $2248
	.db $71,$79,$00
	.db $FE
	.dw $2268
	.db $71,$76
	.db $FE
	.dw $2288
	.db $71,$4E,$00
	.db $FE
	.dw $22A8
	.db $7B,$4E,$00
	.db $FE
	.dw $22C8
	.db $7B,$75,$76,$D0
	.db $FE
	.dw $22E8
	.db $7B,$72,$7B,$DC
	.db $FF
VRAMStrip8BData:
	.dw $21E8
	.db $00,$4B
	.db $FE
	.dw $2207
	.db $00,$00,$49
	.db $FE
	.dw $2226
	.db $00,$00,$00,$48
	.db $FE
	.dw $2245
	.db $00,$00,$00,$7E,$47
	.db $FE
	.dw $2265
	.db $00,$00,$77,$7B,$4D
	.db $FE
	.dw $2284
	.db $00,$73,$77,$7A
	.db $FE
	.dw $22A4
	.db $00,$77,$7A,$71
	.db $FE
	.dw $22C4
	.db $73,$74,$71,$71
	.db $FE
	.dw $22E4
	.db $DC,$72,$72,$72
	.db $FF
VRAMStrip8CData:
	.dw $218A
	.db $00,$73
	.db $FE
	.dw $21AA
	.db $4C,$6D
	.db $FE
	.dw $21C9
	.db $00,$54,$7B
	.db $FE
	.dw $21E9
	.db $4B,$71,$5B
	.db $FE
	.dw $2214
	.db $37,$37,$52,$32
	.db $FE
	.dw $2234
	.db $4F,$37,$52,$71
	.db $FE
	.dw $2255
	.db $39,$37,$52
	.db $FE
	.dw $2275
	.db $2B,$37,$52
	.db $FF
VRAMStrip8DData:
	.dw $2294
	.db $00,$2B,$37,$52,$37,$52,$2A,$00
	.db $FE
	.dw $22B4
	.db $00,$2B,$37,$52,$35,$37,$2D,$2E
	.db $FE
	.dw $22D4
	.db $D0,$3A,$52,$37,$71,$35,$2D,$D1
	.db $FE
	.dw $22F4
	.db $DC,$DC,$71,$35,$52,$52,$52,$DD
	.db $FF
VRAMStrip8EData:
	.dw $21CA
	.db $4B,$7B,$71,$61
	.db $FE
	.dw $21E9
	.db $00,$49,$4A,$7F
	.db $FE
	.dw $2209
	.db $00,$00
	.db $FE
	.dw $2229
	.db $00
	.db $FE
	.dw $2218
	.db $2C
	.db $FE
	.dw $2238
	.db $2D,$2E
	.db $FE
	.dw $2258
	.db $52,$2D,$2E
	.db $FE
	.dw $2278
	.db $52,$2D,$2C
	.db $FF
VRAMStrip8FData:
	.dw $216C
	.db $00,$00,$5A,$45
	.db $FE
	.dw $218A
	.db $00,$00,$00,$45,$46,$6D
	.db $FE
	.dw $21AA
	.db $00,$00,$00,$44,$44,$51
	.db $FE
	.dw $21CA
	.db $00,$00,$00,$00,$00,$00
	.db $FE
	.dw $21EA
	.db $00,$00,$00,$00
	.db $FF
VRAMStrip90Data:
	.dw $216E
	.db $00,$00,$00,$00,$00,$00
	.db $FE
	.dw $218D
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $FE
	.dw $21AD
	.db $00,$00,$00,$00,$00,$00,$23,$24,$00
	.db $FE
	.dw $21D0
	.db $00,$00,$00,$25,$26,$27,$2E
	.db $FE
	.dw $21F0
	.db $00,$00,00,$2B,$52,$52,$27,$4D
	.db $FF
VRAMStrip91Data:
	.dw $2209
	.db $00
	.db $FE
	.dw $2229
	.db $00
	.db $FE
	.dw $2248
	.db $00,$00
	.db $FE
	.dw $2267
	.db $00,$00,$00
	.db $FE
	.dw $2285
	.db $00,$00,$00,$7E,$47
	.db $FE
	.dw $22A5
	.db $00,$00,$77,$7B,$4D
	.db $FE
	.dw $22C4
	.db $D0,$D1,$77,$7A,$71,$4E,$D0,$D1
	.db $FE
	.dw $22E4
	.db $DC,$DD,$7A,$71,$7B,$78,$DC,$DD
	.db $FF
VRAMStrip92Data:
	.dw $2194
	.db $00
	.db $FE
	.dw $21B3
	.db $00,$00
	.db $FE
	.dw $21D3
	.db $00,$00,$00,$00
	.db $FE
	.dw $21F3
	.db $00,$00,$00,$00,$00
	.db $FE
	.dw $2213
	.db $00,$00,$23,$24,$00,$00
	.db $FE
	.dw $2234
	.db $00,$25,$26,$27,$2E,$00
	.db $FE
	.dw $2255
	.db $2B,$52,$52,$27,$2E,$00
	.db $FE
	.dw $2275
	.db $28,$37,$52,$52,$2D,$2E
	.db $FF
VRAMStrip93Data:
	.dw $2288
	.db $00,$00
	.db $FE
	.dw $22A7
	.db $00,$00,$00
	.db $FE
	.dw $22C4
	.db $D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB
	.db $FE
	.dw $22E4
	.db $E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7
	.db $FF
VRAMStrip94Data:
	.dw $2215
	.db $00,$00
	.db $FE
	.dw $2235
	.db $00,$00,$00,$00
	.db $FE
	.dw $2255
	.db $00,$00,$00,$00,$00
	.db $FE
	.dw $2275
	.db $00,$00,$00,$00,$00,$00
	.db $FE
	.dw $2295
	.db $00,$00,$00,$00,$00,$00
	.db $FE
	.dw $22B5
	.db $00,$00,$23,$24,$00,$00,$00
	.db $FE
	.dw $22D4
	.db $D8,$D9,$DA,$25,$26,$27,$2E,$DB
	.db $FE
	.dw $22F4
	.db $E4,$E5,$E6,$DC,$52,$52,$E6,$E7
	.db $FF
VRAMStrip95Data:
	.dw $22B7
	.db $00,$00
	.db $FE
	.dw $22D4
	.db $D8,$D9,$DA,$DB,$D4,$D5,$D6,$D7
	.db $FE
	.dw $22F4
	.db $E4,$E5,$E6,$E7,$E0,$E1,$E2,$E3
	.db $FF

;CLEAR STRIPS
ClearStrip96Data:
	.db $00,$00,$40
ClearStrip97Data:
	.db $40,$00,$40
ClearStrip9EData:
	.db $80,$00,$40
ClearStrip9FData:
	.db $F0,$00,$10

;VRAM STRIPS
VRAMStrip98Data:
	.dw $2720
	.db $00,$00,$B5,$B6,$B7,$00,$09,$2F,$16,$05,$00,$0C,$0F,$13,$14,$00
	.db $0D,$19,$13,$05,$0C,$06,$00,$09,$0E,$00,$01,$00,$00,$00,$00,$00
	.db $00,$00,$B8,$B9,$BA,$00,$08,$19,$10,$0E,$0F,$14,$09,$03,$00,$02
	.db $05,$01,$0D,$39
	.db $FE
	.dw $2762
	.db $BB,$BC,$BD
	.db $FE
	.dw $27F0
	.db $CC,$33
	.db $FF
VRAMStrip99Data:
	.dw $2720
	.db $00,$00,$BE,$BF,$C0,$00,$14,$08,$01,$0E,$0B,$00,$19,$0F,$15,$25
	.db $00,$04,$05,$01,$04,$2D,$05,$19,$05,$00,$0D,$01,$19,$00,$00,$00
	.db $00,$00,$C1,$C2,$C3,$00,$02,$05,$00,$03,$01,$15,$07,$08,$14,$00
	.db $01,$14,$00,$14,$08,$05,$00,$14,$0F,$10,$39
	.db $FE
	.dw $2762
	.db $C4,$C5,$C6
	.db $FE
	.dw $27F0
	.db $CC,$33
	.db $FF
VRAMStrip9AData:
	.dw $2720
	.db $00,$00,$AC,$AD,$AE,$00,$17,$08,$05,$17,$25,$00,$05,$16,$05,$12
	.db $19,$02,$0F,$04,$19,$00,$09,$13,$00,$01,$0C,$0C,$00,$00,$00,$00
	.db $00,$00,$AF,$B0,$B1,$00,$12,$09,$07,$08,$14,$25,$25
	.db $FE
	.dw $2762
	.db $B2,$B3,$B4
	.db $FE
	.dw $27F0
	.db $CC,$33
	.db $FF
VRAMStrip9CData:
	.dw $27F0
	.db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	.db $FE
	.dw $2700
	.db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	.db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	.db $47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48
	.db $47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48,$47,$48
	.db $FF
VRAMStrip9DData:
	.dw $2740
	.db $49,$4A,$49,$4A,$49,$4A,$4D,$4E,$49,$4A,$49,$4A,$49,$4A,$4D,$4E
	.db $49,$4A,$49,$4A,$49,$4A,$49,$4A,$49,$4A,$4D,$4E,$49,$4A,$4D,$4E
	.db $4B,$4C,$4B,$4C,$4B,$4C,$4F,$50,$4B,$4C,$4B,$4C,$4B,$4C,$4F,$50
	.db $4B,$4C,$4B,$4C,$4B,$4C,$4B,$4C,$4B,$4C,$4F,$50,$4B,$4C,$4B,$4C
	.db $FF

;;;;;;;;;;;;
;ENEMY DATA;
;;;;;;;;;;;;
LevelEnemyDataPointerTable:
	.dw Level1EnemyDataPointerTable
	.dw Level2EnemyDataPointerTable
	.dw Level3EnemyDataPointerTable
	.dw Level4EnemyDataPointerTable
	.dw Level5EnemyDataPointerTable
	.dw Level6EnemyDataPointerTable
	.dw Level7EnemyDataPointerTable
	.dw Level8EnemyDataPointerTable

;LEVEL 1 ENEMY DATA
Level1EnemyDataPointerTable:
	;Area 0
	.dw Level1Screen00EnemyData
	.dw Level1Screen01EnemyData
	.dw Level1Screen02EnemyData
	.dw Level1Screen03EnemyData
	.dw Level1Screen04EnemyData
	.dw Level1Screen05EnemyData
	.dw Level1Screen06EnemyData
	.dw Level1Screen07EnemyData
	.dw Level1Screen08EnemyData
	;Area 1
	.dw Level1Screen09EnemyData
	.dw Level1Screen0AEnemyData
	.dw Level1Screen0BEnemyData
	.dw Level1Screen0CEnemyData
	.dw Level1Screen0DEnemyData
	.dw Level1Screen0EEnemyData
	.dw Level1Screen0FEnemyData
	;Area 2
	.dw Level1Screen10EnemyData
	.dw Level1Screen11EnemyData
	.dw Level1Screen12EnemyData
	.dw Level1Screen13EnemyData
	.dw Level1Screen14EnemyData
	.dw Level1Screen15EnemyData
	.dw Level1Screen16EnemyData
	.dw Level1Screen17EnemyData
	.dw Level1Screen18EnemyData
	.dw Level1Screen19EnemyData
	.dw Level1Screen1AEnemyData
	.dw Level1Screen1BEnemyData
	.dw Level1Screen1CEnemyData
	;Area 3
	.dw Level1Screen1DEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen22EnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen27EnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen2CEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen31EnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen36EnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1EEnemyData
	.dw Level1Screen1DEnemyData
	
	.dw Level1Screen3CEnemyData
	.dw Level1Screen3CEnemyData
	;Area 4
	.dw Level1Screen3CEnemyData
	.dw Level1Screen3FEnemyData
	.dw Level1Screen3FEnemyData
	.dw Level1Screen3FEnemyData
	.dw Level1Screen3FEnemyData
	.dw Level1Screen43EnemyData
	
	.dw Level1Screen43EnemyData
	.dw Level1Screen45EnemyData
	.dw Level1Screen45EnemyData
	;Area 5
	.dw Level1Screen45EnemyData

Level1Screen01EnemyData:
	.db $40,$01,$8B,ENEMY_TROOPER
Level1Screen00EnemyData:
	.db $00
Level1Screen02EnemyData:
	.db $10,$04,$1D,ENEMY_1UP
	.db $20,$02,$8B,ENEMY_TROOPER
	.db $00
Level1Screen03EnemyData:
	.db $10,$03,$8B,ENEMY_TROOPER
	.db $C0,$01,$8B,ENEMY_TROOPER
	.db $F0,$15,$1C,ENEMY_BONUSCOIN
	.db $F0,$96,$4F,ENEMY_BG8WAYSHOOTER
	.db $00
Level1Screen04EnemyData:
	.db $10,$16,$4F,ENEMY_BG8WAYSHOOTER
	.db $30,$96,$4F,ENEMY_BG8WAYSHOOTER
	.db $40,$02,$A3,ENEMY_TROOPER
	.db $D0,$A7,$AF,ENEMY_BG8WAYSHOOTER
	.db $F0,$27,$AF,ENEMY_BG8WAYSHOOTER
	.db $00
Level1Screen05EnemyData:
	.db $10,$A7,$AF,ENEMY_BG8WAYSHOOTER
	.db $A0,$03,$83,ENEMY_TROOPER
	.db $90,$B4,$AF,ENEMY_BG8WAYSHOOTER
	.db $B0,$34,$AF,ENEMY_BG8WAYSHOOTER
	.db $D0,$B4,$AF,ENEMY_BG8WAYSHOOTER
	.db $00
Level1Screen06EnemyData:
	.db $40,$01,$A3,ENEMY_TROOPER
	.db $C0,$02,$83,ENEMY_TROOPER
	.db $90,$C5,$4F,ENEMY_BG8WAYSHOOTER
	.db $B0,$45,$4F,ENEMY_BG8WAYSHOOTER
	.db $D0,$C5,$4F,ENEMY_BG8WAYSHOOTER
	.db $C0,$26,$80,ENEMY_BONUSCOIN
	.db $B0,$D7,$AF,ENEMY_BG8WAYSHOOTER
	.db $D0,$57,$AF,ENEMY_BG8WAYSHOOTER
	.db $F0,$D7,$AF,ENEMY_BG8WAYSHOOTER
	.db $00
Level1Screen07EnemyData:
	.db $10,$E4,$AF,ENEMY_BG8WAYSHOOTER
	.db $30,$64,$AF,ENEMY_BG8WAYSHOOTER
	.db $50,$E4,$AF,ENEMY_BG8WAYSHOOTER
	.db $A0,$31,$1C,ENEMY_LIFEUP
	.db $00
Level1Screen08EnemyData:
	.db $80,$02,$5B,ENEMY_TROOPER
	.db $E0,$03,$83,ENEMY_TROOPER
	.db $00
Level1Screen09EnemyData:
	.db $5D,$01,$30,ENEMY_TROOPER
	.db $28,$03,$68,ENEMY_CATERPILLAR
	.db $00
Level1Screen0AEnemyData:
	.db $10,$02,$D0,ENEMY_SPIDER
	.db $68,$01,$68,ENEMY_CATERPILLAR
	.db $D8,$04,$A6,ENEMY_CATERPILLAR
	.db $00
Level1Screen0BEnemyData:
	.db $20,$03,$54,ENEMY_BEEHIVE
	.db $5D,$02,$30,ENEMY_TROOPER
	.db $68,$01,$68,ENEMY_CATERPILLAR
	.db $D8,$04,$A6,ENEMY_CATERPILLAR
	.db $00
Level1Screen0CEnemyData:
	.db $28,$03,$54,ENEMY_BEEHIVE
	.db $C0,$01,$30,ENEMY_SPIDER
	.db $00
Level1Screen0DEnemyData:
	.db $38,$04,$54,ENEMY_BEEHIVE
	.db $7D,$03,$80,ENEMY_TROOPER
	.db $D0,$02,$D0,ENEMY_SPIDER
	.db $00
Level1Screen0EEnemyData:
	.db $3D,$01,$20,ENEMY_TROOPER
	.db $9D,$04,$B0,ENEMY_TROOPER
	.db $00
Level1Screen0FEnemyData:
	.db $04,$03,$54,ENEMY_BEEHIVE
	.db $08,$02,$30,ENEMY_SPIDER
	.db $93,$01,$D0,ENEMY_TROOPER
	.db $00
Level1Screen10EnemyData:
	.db $A0,$05,$9D,ENEMY_TROOPER2
	.db $00
Level1Screen11EnemyData:
	.db $30,$03,$73,ENEMY_FALLINGTREEPLATR
	.db $78,$01,$90,ENEMY_FALLINGTREEPLATL
	.db $B8,$22,$B0,ENEMY_FLOATINGLOGPLAT
	.db $00
Level1Screen12EnemyData:
	.db $40,$27,$B8,ENEMY_FISH
	.db $B0,$25,$B8,ENEMY_FISH
	.db $B8,$41,$98,ENEMY_POWERUP
	.db $00
Level1Screen13EnemyData:
	.db $7C,$04,$80,ENEMY_BALANCEVINEPLAT
	.db $7C,$08,$20,ENEMY_BALANCEVINEMASK
	.db $9C,$06,$70,ENEMY_BALANCEVINEPLAT
	.db $9C,$09,$20,ENEMY_BALANCEVINEMASK
	.db $00
Level1Screen14EnemyData:
	.db $20,$01,$40,ENEMY_SWINGINGVINE
	.db $20,$02,$84,ENEMY_SWINGINGVINEPLAT
	.db $80,$03,$40,ENEMY_SWINGINGVINE
	.db $80,$04,$84,ENEMY_SWINGINGVINEPLAT
	.db $00
Level1Screen15EnemyData:
	.db $1C,$05,$80,ENEMY_BALANCEVINEPLAT
	.db $1C,$08,$20,ENEMY_BALANCEVINEMASK
	.db $3C,$07,$70,ENEMY_BALANCEVINEPLAT
	.db $3C,$09,$20,ENEMY_BALANCEVINEMASK
	.db $3C,$56,$98,ENEMY_1UP
	.db $C0,$01,$40,ENEMY_SWINGINGVINE
	.db $C0,$02,$84,ENEMY_SWINGINGVINEPLAT
	.db $00
Level1Screen16EnemyData:
	.db $20,$03,$40,ENEMY_SWINGINGVINE
	.db $20,$04,$84,ENEMY_SWINGINGVINEPLAT
	.db $00
Level1Screen17EnemyData:
	.db $08,$66,$98,ENEMY_1UP
	.db $5C,$57,$B0,ENEMY_FLOATINGLOGPLAT
	.db $00
Level1Screen18EnemyData:
	.db $2B,$02,$30,ENEMY_FLOATINGLOGDUMMY
	.db $2C,$06,$30,ENEMY_FLOATINGLOGPLAT
	.db $6C,$03,$70,ENEMY_FLTLOGSPAWNER
	.db $E0,$01,$B8,ENEMY_FISH
	.db $00
Level1Screen19EnemyData:
	.db $20,$12,$78,ENEMY_FISH
	.db $A0,$15,$30,ENEMY_FLTLOGSPAWNER
	.db $F0,$71,$58,ENEMY_BONUSCOIN
	.db $00
Level1Screen1AEnemyData:
	.db $40,$12,$B8,ENEMY_FISH
	.db $98,$07,$90,ENEMY_FALLINGTREEPLATL
	.db $D0,$03,$73,ENEMY_FALLINGTREEPLATR
	.db $00
Level1Screen1BEnemyData:
	.db $50,$84,$98,ENEMY_1UP
	.db $70,$05,$B8,ENEMY_FISH
	.db $00
Level1Screen1CEnemyData:
	.db $30,$03,$3D,ENEMY_TROOPER2
	.db $70,$57,$B0,ENEMY_FLOATINGLOGPLAT
	.db $00
Level1Screen1DEnemyData:
	.db $40,$01,$80,ENEMY_ROCKSMSPAWNER
Level1Screen1EEnemyData:
	.db $60,$02,$F0,ENEMY_SIDEFLOWER
	.db $D0,$03,$10,ENEMY_SIDEFLOWER
	.db $00
Level1Screen22EnemyData:
	.db $80,$94,$A8,ENEMY_1UP
	.db $00
Level1Screen27EnemyData:
	.db $80,$A5,$30,ENEMY_LIFEUP
	.db $00
Level1Screen2CEnemyData:
	.db $80,$B4,$80,ENEMY_BONUSCOIN
	.db $00
Level1Screen31EnemyData:
	.db $80,$C5,$58,ENEMY_LIFEUP
	.db $00
Level1Screen36EnemyData:
	.db $80,$D4,$D0,ENEMY_BONUSCOIN
	.db $00
Level1Screen3CEnemyData:
	.db $80,$17,$20,ENEMY_ROCKSMSPAWNER
	.db $A5,$31,$3C,ENEMY_SHIPFIN
	.db $E5,$22,$1B,ENEMY_SHIPFIN
	.db $00
Level1Screen3FEnemyData:
	.db $00
Level1Screen43EnemyData:
	.db $20,$E5,$30,ENEMY_POWERUP
	.db $60,$F6,$80,ENEMY_LIFEUP
	.db $00
Level1Screen45EnemyData:
	.db $CA,$11,$8F,ENEMY_LEVEL1BOSS
	.db $00

;LEVEL 2 ENEMY DATA
Level2EnemyDataPointerTable:
	;Area 0
	.dw Level2Screen00EnemyData
	.dw Level2Screen01EnemyData
	.dw Level2Screen02EnemyData
	.dw Level2Screen03EnemyData
	.dw Level2Screen04EnemyData
	.dw Level2Screen05EnemyData
	.dw Level2Screen06EnemyData
	.dw Level2Screen07EnemyData
	
	.dw Level2Screen00EnemyData
	;Area 1
	.dw Level2Screen09EnemyData
	.dw Level2Screen0AEnemyData
	.dw Level2Screen0BEnemyData
	.dw Level2Screen0CEnemyData
	.dw Level2Screen0DEnemyData
	.dw Level2Screen0EEnemyData
	.dw Level2Screen0FEnemyData
	.dw Level2Screen10EnemyData
	;Area 2
	.dw Level2Screen11EnemyData
	.dw Level2Screen12EnemyData
	.dw Level2Screen13EnemyData
	.dw Level2Screen14EnemyData
	.dw Level2Screen15EnemyData
	.dw Level2Screen16EnemyData
	.dw Level2Screen17EnemyData
	.dw Level2Screen18EnemyData
	;Area 3
	.dw Level2Screen19EnemyData
	.dw Level2Screen1AEnemyData
	.dw Level2Screen1BEnemyData
	.dw Level2Screen1CEnemyData
	.dw Level2Screen1DEnemyData
	.dw Level2Screen1EEnemyData
	.dw Level2Screen1FEnemyData
	
	.dw Level2Screen20EnemyData
	;Area 4
	.dw Level2Screen20EnemyData
	.dw Level2Screen22EnemyData
	;Area 5
	.dw Level2Screen23EnemyData
	.dw Level2Screen24EnemyData
	.dw Level2Screen25EnemyData
	.dw Level2Screen25EnemyData
	.dw Level2Screen27EnemyData
	;Area 6
	.dw Level2Screen28EnemyData
	.dw Level2Screen29EnemyData
	.dw Level2Screen2AEnemyData
	.dw Level2Screen2BEnemyData
	.dw Level2Screen2CEnemyData
	
	.dw Level2Screen2DEnemyData
	.dw Level2Screen2DEnemyData
	.dw Level2Screen03EnemyData
	;Area 7
	.dw Level2Screen30EnemyData
	.dw Level2Screen31EnemyData
	.dw Level2Screen32EnemyData
	.dw Level2Screen33EnemyData
	.dw Level2Screen34EnemyData
	.dw Level2Screen34EnemyData
	.dw Level2Screen36EnemyData
	.dw Level2Screen37EnemyData
	.dw Level2Screen38EnemyData
	.dw Level2Screen39EnemyData
	
	.dw Level2Screen03EnemyData
	.dw Level2Screen03EnemyData
	.dw Level2Screen3CEnemyData
	;Area 8
	.dw Level2Screen3DEnemyData
	
	.dw Level2Screen3CEnemyData

Level2Screen00EnemyData:
	.db $F0,$01,$9C,ENEMY_LAVABUBBLESPLASH
	.db $F0,$02,$9C,ENEMY_LAVABUBBLE
	.db $00
Level2Screen07EnemyData:
	.db $E0,$02,$8D,ENEMY_TROOPER
Level2Screen01EnemyData:
	.db $50,$03,$9C,ENEMY_LAVABUBBLESPLASH
	.db $50,$04,$9C,ENEMY_LAVABUBBLE
	.db $B0,$05,$9C,ENEMY_LAVABUBBLESPLASH
	.db $B0,$06,$9C,ENEMY_LAVABUBBLE
	.db $00
Level2Screen02EnemyData:
	.db $10,$01,$8D,ENEMY_TROOPER
	.db $70,$02,$95,ENEMY_TROOPER
	.db $80,$03,$44,ENEMY_VOLCANO
	.db $00
Level2Screen03EnemyData:
	.db $00
Level2Screen04EnemyData:
	.db $01,$04,$44,ENEMY_VOLCANO
	.db $00
Level2Screen05EnemyData:
	.db $80,$03,$44,ENEMY_VOLCANO
	.db $F0,$05,$AC,ENEMY_LAVABUBBLESPLASH
	.db $F0,$06,$AC,ENEMY_LAVABUBBLE
Level2Screen09EnemyData:
	.db $B0,$01,$AC,ENEMY_LAVABUBBLESPLASH
	.db $B0,$02,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen06EnemyData:
	.db $C0,$07,$95,ENEMY_TROOPER
	.db $00
Level2Screen0AEnemyData:
	.db $70,$03,$04,ENEMY_BOULDERPUSH
	.db $00
Level2Screen0BEnemyData:
	.db $30,$05,$A0,ENEMY_POWERUP
	.db $B0,$06,$35,ENEMY_TROOPER2
	.db $00
Level2Screen0CEnemyData:
	.db $70,$01,$84,ENEMY_BOULDERPUSH
	.db $90,$02,$34,ENEMY_BOULDERPUSH
	.db $00
Level2Screen0DEnemyData:
	.db $58,$03,$74,ENEMY_BOULDERPUSH
	.db $90,$04,$34,ENEMY_BOULDERPUSH
	.db $00
Level2Screen0EEnemyData:
	.db $20,$01,$54,ENEMY_BOULDERPUSH
	.db $A0,$07,$15,ENEMY_TROOPER2
	.db $E0,$02,$74,ENEMY_BOULDERPUSH
	.db $00
Level2Screen0FEnemyData:
	.db $50,$05,$35,ENEMY_TROOPER2
	.db $D0,$16,$20,ENEMY_1UP
	.db $00
Level2Screen10EnemyData:
	.db $08,$03,$84,ENEMY_BOULDERPUSH
	.db $88,$27,$96,ENEMY_BONUSCOIN
	.db $00
Level2Screen11EnemyData:
	.db $DC,$01,$FC,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen12EnemyData:
	.db $DC,$12,$0C,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen13EnemyData:
	.db $1C,$23,$FC,ENEMY_BGFIRESNAKE
	.db $9C,$34,$0C,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen14EnemyData:
	.db $10,$45,$90,ENEMY_BONUSCOIN
	.db $1C,$46,$0C,ENEMY_BGFIRESNAKE
	.db $9C,$57,$FC,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen15EnemyData:
	.db $3C,$61,$0C,ENEMY_BGFIRESNAKE
	.db $9C,$72,$FC,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen16EnemyData:
	.db $7C,$83,$FC,ENEMY_BGFIRESNAKE
	.db $8C,$94,$0C,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen17EnemyData:
	.db $2C,$A5,$FC,ENEMY_BGFIRESNAKE
	.db $5C,$B6,$0C,ENEMY_BGFIRESNAKE
	.db $00
Level2Screen18EnemyData:
	.db $7C,$C7,$0C,ENEMY_BGFIRESNAKE
	.db $90,$31,$48,ENEMY_1UP
	.db $00
Level2Screen19EnemyData:
	.db $B0,$04,$B0,ENEMY_LAVABUBBLESPLASH
	.db $B0,$05,$AC,ENEMY_LAVABUBBLE
	.db $D0,$56,$70,ENEMY_POWERUP
	.db $00
Level2Screen1AEnemyData:
	.db $80,$01,$B0,ENEMY_BGFIREARCH
	.db $00
Level2Screen1BEnemyData:
	.db $20,$03,$B0,ENEMY_LAVABUBBLESPLASH
	.db $20,$04,$AC,ENEMY_LAVABUBBLE
	.db $30,$02,$65,ENEMY_TROOPER
	.db $90,$05,$B0,ENEMY_LAVABUBBLESPLASH
	.db $90,$06,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen1CEnemyData:
	.db $30,$02,$65,ENEMY_TROOPER
	.db $80,$01,$B0,ENEMY_BGFIREARCH
	.db $F0,$05,$B0,ENEMY_LAVABUBBLESPLASH
	.db $F0,$06,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen1DEnemyData:
	.db $90,$03,$B0,ENEMY_LAVABUBBLESPLASH
	.db $90,$04,$AC,ENEMY_LAVABUBBLE
	.db $F0,$05,$B0,ENEMY_LAVABUBBLESPLASH
	.db $F0,$06,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen1EEnemyData:
	.db $80,$01,$B0,ENEMY_BGFIREARCH
	.db $80,$02,$85,ENEMY_TROOPER
	.db $F0,$03,$B0,ENEMY_LAVABUBBLESPLASH
	.db $F0,$04,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen1FEnemyData:
	.db $68,$05,$B0,ENEMY_LAVABUBBLESPLASH
	.db $68,$06,$AC,ENEMY_LAVABUBBLE
	.db $88,$01,$B0,ENEMY_LAVABUBBLESPLASH
	.db $88,$02,$AC,ENEMY_LAVABUBBLE
	.db $00
Level2Screen20EnemyData:
	.db $C0,$01,$35,ENEMY_TROOPERROLLING
	.db $00
Level2Screen22EnemyData:
	.db $10,$02,$95,ENEMY_TROOPERROLLING
	.db $60,$03,$65,ENEMY_TROOPER2
	.db $E8,$05,$90,ENEMY_FLASHINGARROW
	.db $00
Level2Screen23EnemyData:
	.db $30,$02,$E8,ENEMY_FLASHINGARROW
	.db $35,$06,$08,ENEMY_TROOPERROLLING
	.db $95,$04,$08,ENEMY_TROOPERROLLING
	.db $60,$0C,$F0,ENEMY_BLUESIDESPIKES
	.db $74,$0B,$10,ENEMY_BLUESIDESPIKES
	.db $A4,$0A,$F0,ENEMY_BLUESIDESPIKES
	.db $00
Level2Screen24EnemyData:
	.db $2C,$61,$38,ENEMY_LIFEUP
Level2Screen25EnemyData:
	.db $95,$04,$08,ENEMY_TROOPERROLLING
Level2Screen27EnemyData:
	.db $A4,$0A,$F0,ENEMY_BLUESIDESPIKES
	.db $35,$06,$F8,ENEMY_TROOPERROLLING
	.db $14,$09,$10,ENEMY_BLUESIDESPIKES
	.db $44,$0C,$F0,ENEMY_BLUESIDESPIKES
	.db $74,$0B,$10,ENEMY_BLUESIDESPIKES
	.db $00
Level2Screen28EnemyData:
	.db $B0,$01,$AC,ENEMY_BOULDERROLL
	.db $00
Level2Screen29EnemyData:
	.db $40,$02,$9C,ENEMY_BOULDERROLL
	.db $D0,$03,$08,ENEMY_BOULDERROLLSPAWN
	.db $00
Level2Screen2AEnemyData:
	.db $40,$04,$34,ENEMY_BOULDERROLL
	.db $B0,$95,$30,ENEMY_1UP
	.db $00
Level2Screen2BEnemyData:
	.db $30,$01,$96,ENEMY_TROOPERTRENCH
	.db $50,$72,$30,ENEMY_BONUSCOIN
	.db $90,$03,$96,ENEMY_TROOPERTRENCH
	.db $D0,$04,$96,ENEMY_TROOPERTRENCH
	.db $00
Level2Screen2CEnemyData:
	.db $20,$05,$08,ENEMY_BOULDERROLLSPAWN
	.db $50,$81,$14,ENEMY_1UP
	.db $90,$02,$36,ENEMY_TROOPER2
Level2Screen2DEnemyData:
	.db $00
Level2Screen30EnemyData:
	.db $10,$17,$8C,ENEMY_BOULDERROLL
	.db $C8,$06,$D0,ENEMY_GREENBALLDOT
	.db $C8,$18,$D0,ENEMY_GREENBALLDOT
	.db $C8,$29,$D0,ENEMY_GREENBALLDOT
	.db $C8,$3A,$D0,ENEMY_GREENBALLDOT
	.db $C8,$4B,$D0,ENEMY_GREENBALLDOT
	.db $00
Level2Screen31EnemyData:
	.db $30,$A3,$20,ENEMY_POWERUP
	.db $00
Level2Screen32EnemyData:
	.db $00
;Unreferenced enemy data???
	.db $00
Level2Screen33EnemyData:
	.db $10,$04,$08,ENEMY_BOULDERROLLSPAWN
Level2Screen34EnemyData:
	.db $00
Level2Screen36EnemyData:
	.db $30,$B5,$70,ENEMY_POWERUP
	.db $00
Level2Screen37EnemyData:
	.db $30,$C3,$20,ENEMY_LIFEUP
	.db $00
Level2Screen38EnemyData:
	.db $40,$D4,$28,ENEMY_1UP
	.db $90,$E5,$28,ENEMY_POWERUP
	.db $00
Level2Screen39EnemyData:
	.db $A0,$F5,$20,ENEMY_BONUSCOIN
	.db $00
Level2Screen3CEnemyData:
	.db $00
Level2Screen3DEnemyData:
	.db $C1,$01,$61,ENEMY_LEVEL2BOSS
	.db $C8,$02,$D0,ENEMY_GREENBALLDOT
	.db $C8,$13,$D0,ENEMY_GREENBALLDOT
	.db $C8,$24,$D0,ENEMY_GREENBALLDOT
	.db $C8,$38,$D0,ENEMY_GREENBALLDOT
	.db $C8,$49,$D0,ENEMY_GREENBALLDOT
	.db $00

;LEVEL 3 ENEMY DATA
Level3EnemyDataPointerTable:
	.dw Level3Screen00EnemyData
	;Area 0
	.dw Level3Screen00EnemyData
	.dw Level3Screen02EnemyData
	.dw Level3Screen02EnemyData
	.dw Level3Screen04EnemyData
	.dw Level3Screen05EnemyData
	.dw Level3Screen06EnemyData
	
	.dw Level3Screen07EnemyData
	;Area 1
	.dw Level3Screen08EnemyData
	.dw Level3Screen09EnemyData
	;Area 2
	.dw Level3Screen0AEnemyData
	.dw Level3Screen0BEnemyData
	;Area 3
	.dw Level3Screen0CEnemyData
	.dw Level3Screen0DEnemyData
	;Area 4
	.dw Level3Screen0EEnemyData
	.dw Level3Screen0FEnemyData
	.dw Level3Screen10EnemyData
	.dw Level3Screen11EnemyData
	.dw Level3Screen12EnemyData
	
	.dw Level3Screen13EnemyData
	;Area 5
	.dw Level3Screen14EnemyData
	.dw Level3Screen15EnemyData
	;Area 6
	.dw Level3Screen16EnemyData
	.dw Level3Screen17EnemyData
	.dw Level3Screen18EnemyData
	.dw Level3Screen19EnemyData
	.dw Level3Screen1AEnemyData
	
	.dw Level3Screen1BEnemyData
	;Area 7
	.dw Level3Screen1CEnemyData
	.dw Level3Screen1DEnemyData
	;Area 8
	.dw Level3Screen1EEnemyData
	.dw Level3Screen1FEnemyData
	.dw Level3Screen20EnemyData
	
	.dw Level3Screen21EnemyData
	.dw Level3Screen22EnemyData
	;Area 9
	.dw Level3Screen23EnemyData
	.dw Level3Screen22EnemyData

Level3Screen00EnemyData:
	.db $01,$07,$A8,ENEMY_ICEWATERDECOR
	.db $01,$18,$B0,ENEMY_ICEWATERDECOR
	.db $01,$29,$B8,ENEMY_ICEWATERDECOR
	.db $C8,$31,$77,ENEMY_FROZENINICE
Level3Screen02EnemyData:
	.db $00
Level3Screen04EnemyData:
	.db $08,$12,$87,ENEMY_FROZENINICE
	.db $00
Level3Screen05EnemyData:
	.db $18,$A3,$57,ENEMY_FROZENINICE
	.db $28,$24,$57,ENEMY_FROZENINICE
	.db $E8,$A5,$37,ENEMY_FROZENINICE
	.db $00
Level3Screen06EnemyData:
	.db $28,$06,$87,ENEMY_FROZENINICE
	.db $68,$41,$27,ENEMY_FROZENINICE
	.db $B8,$A2,$57,ENEMY_FROZENINICE
Level3Screen07EnemyData:
	.db $00
Level3Screen08EnemyData:
	.db $80,$0C,$A0,ENEMY_SPRITEMASK
	.db $01,$08,$B4,ENEMY_ICEWATERDECOR
	.db $01,$29,$BC,ENEMY_ICEWATERDECOR
	.db $70,$02,$C0,ENEMY_BGSNAKE
	.db $00
Level3Screen09EnemyData:
	.db $30,$13,$C0,ENEMY_BGSNAKE
	.db $50,$24,$00,ENEMY_BGSNAKE
	.db $88,$91,$27,ENEMY_FROZENINICE
	.db $00
Level3Screen0AEnemyData:
	.db $80,$0C,$A0,ENEMY_SPRITEMASK
	.db $01,$08,$B4,ENEMY_ICEWATERDECOR
	.db $01,$29,$BC,ENEMY_ICEWATERDECOR
	.db $70,$A1,$50,ENEMY_POWERUP
	.db $70,$32,$C0,ENEMY_BGSNAKE
	.db $00
Level3Screen0BEnemyData:
	.db $30,$13,$C0,ENEMY_BGSNAKE
	.db $90,$44,$00,ENEMY_BGSNAKE
	.db $00
Level3Screen0CEnemyData:
	.db $80,$0C,$A0,ENEMY_SPRITEMASK
	.db $01,$08,$B4,ENEMY_ICEWATERDECOR
	.db $01,$29,$BC,ENEMY_ICEWATERDECOR
	.db $10,$51,$00,ENEMY_BGSNAKE
	.db $70,$02,$C0,ENEMY_BGSNAKE
	.db $00
Level3Screen0DEnemyData:
	.db $30,$63,$C0,ENEMY_BGSNAKE
	.db $00
Level3Screen0EEnemyData:
	.db $01,$07,$A8,ENEMY_ICEWATERDECOR
	.db $01,$18,$B0,ENEMY_ICEWATERDECOR
	.db $01,$29,$B8,ENEMY_ICEWATERDECOR
	.db $30,$01,$08,ENEMY_TROOPERJETPACK
	.db $80,$02,$83,ENEMY_TROOPERMELTINGICE
	.db $B0,$03,$83,ENEMY_RESETMELTABLEICE
	.db $C0,$04,$10,ENEMY_TROOPERJETPACK
	.db $00
Level3Screen0FEnemyData:
	.db $10,$05,$80,ENEMY_TROOPERJETPACK
	.db $70,$01,$30,ENEMY_TROOPERJETPACK
	.db $90,$B6,$70,ENEMY_1UP
	.db $E0,$12,$83,ENEMY_TROOPERMELTINGICE
	.db $00
Level3Screen10EnemyData:
	.db $10,$13,$83,ENEMY_RESETMELTABLEICE
	.db $60,$24,$83,ENEMY_TROOPERMELTINGICE
	.db $90,$25,$83,ENEMY_RESETMELTABLEICE
	.db $F0,$01,$40,ENEMY_TROOPERJETPACK
	.db $00
Level3Screen11EnemyData:
	.db $40,$32,$83,ENEMY_TROOPERMELTINGICE
	.db $70,$33,$83,ENEMY_RESETMELTABLEICE
	.db $80,$04,$40,ENEMY_TROOPERJETPACK
	.db $D0,$05,$60,ENEMY_TROOPERJETPACK
	.db $00
Level3Screen12EnemyData:
	.db $80,$01,$40,ENEMY_TROOPERJETPACK
	.db $90,$02,$80,ENEMY_TROOPERJETPACK
	.db $A0,$03,$60,ENEMY_TROOPERJETPACK
	.db $00
Level3Screen14EnemyData:
	.db $01,$07,$A8,ENEMY_ICEWATERDECOR
	.db $01,$18,$B0,ENEMY_ICEWATERDECOR
	.db $01,$29,$B8,ENEMY_ICEWATERDECOR
	.db $80,$21,$80,ENEMY_BGICEBERGCONVPLAT
	.db $80,$03,$BC,ENEMY_TROOPERJETPACK
	.db $E0,$04,$20,ENEMY_TROOPERJETPACK
	.db $D0,$C5,$60,ENEMY_LIFEUP
Level3Screen13EnemyData:
	.db $00
Level3Screen15EnemyData:
	.db $00
Level3Screen16EnemyData:
	.db $14,$01,$50,ENEMY_TROOPERICEBLOCK
	.db $14,$02,$B0,ENEMY_TROOPERICESPIKE
	.db $54,$03,$A8,ENEMY_TROOPERICEBLOCK
	.db $B0,$D4,$C0,ENEMY_LIFEUP
	.db $B4,$05,$48,ENEMY_TROOPERICEBLOCK
	.db $00
Level3Screen17EnemyData:
	.db $14,$06,$5C,ENEMY_TROOPERICESPIKE
	.db $14,$07,$D8,ENEMY_TROOPERICEBLOCK
	.db $54,$01,$5C,ENEMY_TROOPERICEBLOCK
	.db $74,$E2,$DE,ENEMY_POWERUP
	.db $B0,$03,$B4,ENEMY_TROOPERICEBLOCK
	.db $00
Level3Screen18EnemyData:
	.db $14,$04,$E4,ENEMY_TROOPERICESPIKE
	.db $14,$05,$04,ENEMY_ROLLINGSPIKE
	.db $54,$06,$04,ENEMY_ROLLINGSPIKE
	.db $94,$07,$04,ENEMY_ROLLINGSPIKE
	.db $00
Level3Screen19EnemyData:
	.db $14,$05,$04,ENEMY_ROLLINGSPIKE
	.db $54,$06,$FC,ENEMY_ROLLINGSPIKE
	.db $00
Level3Screen1AEnemyData:
	.db $34,$03,$6C,ENEMY_TROOPERICEBLOCK
	.db $34,$04,$D8,ENEMY_TROOPERICEBLOCK
	.db $94,$01,$04,ENEMY_ROLLINGSPIKE
	.db $94,$02,$FC,ENEMY_ROLLINGSPIKE
	.db $00
Level3Screen1CEnemyData:
	.db $80,$01,$84,ENEMY_L2BSEYESBGGRPIPE
	.db $E0,$02,$5E,ENEMY_L2BSEYESBGGRPIPE
	.db $60,$03,$80,ENEMY_L2BSEYESBGGRPIPE
	.db $C0,$04,$62,ENEMY_L2BSEYESBGGRPIPE
	.db $00
Level3Screen1DEnemyData:
	.db $28,$85,$27,ENEMY_FROZENINICE
Level3Screen1BEnemyData:
	.db $00
Level3Screen1EEnemyData:
	.db $54,$01,$2C,ENEMY_ICICLE
	.db $74,$12,$2C,ENEMY_ICICLE
	.db $94,$13,$2C,ENEMY_ICICLE
	.db $94,$14,$93,ENEMY_TROOPERICICLE
	.db $B8,$58,$97,ENEMY_FROZENINICE
	.db $00
Level3Screen1FEnemyData:
	.db $08,$A9,$77,ENEMY_FROZENINICE
	.db $B4,$01,$2C,ENEMY_ICICLE
	.db $D4,$02,$2C,ENEMY_ICICLE
	.db $F4,$03,$2C,ENEMY_ICICLE
	.db $F4,$14,$93,ENEMY_TROOPERICICLE
	.db $00
Level3Screen20EnemyData:
	.db $68,$A5,$77,ENEMY_FROZENINICE
	.db $78,$A6,$77,ENEMY_FROZENINICE
	.db $88,$67,$47,ENEMY_FROZENINICE
	.db $C8,$78,$47,ENEMY_FROZENINICE
	.db $D8,$A9,$77,ENEMY_FROZENINICE
Level3Screen21EnemyData:
	.db $00
Level3Screen23EnemyData:
	.db $E8,$01,$E0,ENEMY_LEVEL3BOSS
Level3Screen22EnemyData:
	.db $00

;LEVEL 4 ENEMY DATA
Level4EnemyDataPointerTable:
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	;Area 0
	.dw Level4Screen02EnemyData
	.dw Level4Screen03EnemyData
	.dw Level4Screen04EnemyData
	.dw Level4Screen05EnemyData
	.dw Level4Screen04EnemyData
	.dw Level4Screen03EnemyData
	.dw Level4Screen04EnemyData
	
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	;Area 1
	.dw Level4Screen0BEnemyData
	.dw Level4Screen0CEnemyData
	.dw Level4Screen0DEnemyData
	.dw Level4Screen0EEnemyData
	.dw Level4Screen0FEnemyData
	.dw Level4Screen10EnemyData
	.dw Level4Screen11EnemyData
	
	.dw Level4Screen00EnemyData
	;Area 2
	.dw Level4Screen13EnemyData
	.dw Level4Screen14EnemyData
	.dw Level4Screen15EnemyData
	.dw Level4Screen16EnemyData
	.dw Level4Screen15EnemyData
	
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	;Area 3
	.dw Level4Screen1AEnemyData
	.dw Level4Screen1AEnemyData
	.dw Level4Screen1CEnemyData
	
	.dw Level4Screen00EnemyData
	;Area 4
	.dw Level4Screen1EEnemyData
	.dw Level4Screen1EEnemyData
	.dw Level4Screen1EEnemyData
	.dw Level4Screen1EEnemyData
	.dw Level4Screen22EnemyData
	;Area 5
	.dw Level4Screen23EnemyData
	.dw Level4Screen24EnemyData
	.dw Level4Screen25EnemyData
	.dw Level4Screen26EnemyData
	.dw Level4Screen27EnemyData
	.dw Level4Screen25EnemyData
	.dw Level4Screen29EnemyData
	.dw Level4Screen2AEnemyData
	
	.dw Level4Screen23EnemyData
	.dw Level4Screen23EnemyData
	;Area 6
	.dw Level4Screen2DEnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen2FEnemyData
	.dw Level4Screen30EnemyData
	.dw Level4Screen31EnemyData
	.dw Level4Screen32EnemyData
	.dw Level4Screen33EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen39EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen3FEnemyData
	.dw Level4Screen40EnemyData
	.dw Level4Screen41EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen44EnemyData
	.dw Level4Screen45EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen47EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen47EnemyData
	.dw Level4Screen4CEnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen47EnemyData
	.dw Level4Screen4FEnemyData
	.dw Level4Screen50EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen5DEnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen47EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen49EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen47EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen00EnemyData
	.dw Level4Screen67EnemyData
	
	.dw Level4Screen00EnemyData
	;Area 7
	.dw Level4Screen69EnemyData
	.dw Level4Screen00EnemyData

Level4Screen05EnemyData:
	.db $80,$0C,$18,ENEMY_1UP
Level4Screen03EnemyData:
	.db $30,$07,$A0,ENEMY_CRATERSNAKE
	.db $00
Level4Screen02EnemyData:
	.db $80,$1C,$28,ENEMY_LIFEUP
Level4Screen04EnemyData:
	.db $90,$07,$A0,ENEMY_CRATERSNAKE
	.db $00
Level4Screen0BEnemyData:
	.db $80,$24,$14,ENEMY_POWERUP
	.db $F0,$03,$91,ENEMY_CRATERGUN
	.db $00
Level4Screen0CEnemyData:
	.db $20,$07,$7B,ENEMY_TROOPER2
	.db $70,$32,$30,ENEMY_LIFEUP
	.db $90,$D1,$10,ENEMY_BG3WAYSHOOTER
	.db $B0,$51,$10,ENEMY_BG3WAYSHOOTER
	.db $D0,$D1,$10,ENEMY_BG3WAYSHOOTER
	.db $D8,$06,$56,ENEMY_TROOPER2
	.db $F0,$C4,$10,ENEMY_BG3WAYSHOOTER
	.db $00
Level4Screen0DEnemyData:
	.db $10,$44,$10,ENEMY_BG3WAYSHOOTER
	.db $30,$C4,$10,ENEMY_BG3WAYSHOOTER
	.db $50,$B3,$30,ENEMY_BG3WAYSHOOTER
	.db $70,$33,$30,ENEMY_BG3WAYSHOOTER
	.db $90,$B3,$30,ENEMY_BG3WAYSHOOTER
	.db $C0,$42,$14,ENEMY_1UP
	.db $00
Level4Screen0EEnemyData:
	.db $10,$05,$50,ENEMY_TROOPERJETPACK
	.db $80,$07,$30,ENEMY_DIVEBOMBER
	.db $A0,$06,$7B,ENEMY_TROOPER2
	.db $F0,$05,$56,ENEMY_TROOPER2
	.db $00
Level4Screen0FEnemyData:
	.db $70,$A1,$30,ENEMY_BG3WAYSHOOTER
	.db $90,$21,$30,ENEMY_BG3WAYSHOOTER
	.db $B0,$A1,$30,ENEMY_BG3WAYSHOOTER
	.db $E0,$54,$24,ENEMY_BONUSCOIN
	.db $00
Level4Screen10EnemyData:
	.db $08,$97,$30,ENEMY_DIVEBOMBER
	.db $10,$93,$10,ENEMY_BG3WAYSHOOTER
	.db $30,$13,$10,ENEMY_BG3WAYSHOOTER
	.db $50,$93,$10,ENEMY_BG3WAYSHOOTER
	.db $58,$06,$36,ENEMY_TROOPER2
	.db $B0,$82,$30,ENEMY_BG3WAYSHOOTER
	.db $D0,$02,$30,ENEMY_BG3WAYSHOOTER
	.db $F0,$82,$30,ENEMY_BG3WAYSHOOTER
	.db $00
Level4Screen11EnemyData:
	.db $10,$05,$30,ENEMY_TROOPERJETPACK
	.db $90,$01,$91,ENEMY_CRATERGUN
	.db $00
Level4Screen16EnemyData:
	.db $C0,$67,$18,ENEMY_BONUSCOIN
Level4Screen14EnemyData:
	.db $10,$06,$30,ENEMY_TROOPERJETPACK
	.db $70,$03,$94,ENEMY_CRATERGUN
	.db $90,$04,$30,ENEMY_DIVEBOMBER
	.db $00
Level4Screen13EnemyData:
	.db $C0,$77,$18,ENEMY_LIFEUP
Level4Screen15EnemyData:
	.db $10,$02,$90,ENEMY_TROOPERJETPACK
	.db $70,$01,$94,ENEMY_CRATERGUN
	.db $00
Level4Screen1CEnemyData:
	.db $20,$81,$50,ENEMY_1UP
	.db $C0,$98,$20,ENEMY_POWERUP
Level4Screen1AEnemyData:
	.db $70,$72,$30,ENEMY_ASTEROID
	.db $D0,$23,$48,ENEMY_ASTEROID
	.db $40,$64,$60,ENEMY_ASTEROID
	.db $10,$75,$90,ENEMY_ASTEROID
	.db $10,$36,$A8,ENEMY_ASTEROID
	.db $A0,$67,$C0,ENEMY_ASTEROID
	.db $00
Level4Screen1EEnemyData:
	.db $0C,$41,$20,ENEMY_ASTEROID
	.db $3C,$02,$80,ENEMY_ASTEROID
	.db $6C,$53,$50,ENEMY_ASTEROID
	.db $9C,$14,$B0,ENEMY_ASTEROID
	.db $CC,$45,$E0,ENEMY_ASTEROID
Level4Screen22EnemyData:
	.db $00
Level4Screen24EnemyData:
	.db $40,$C5,$40,ENEMY_POWERUP
Level4Screen26EnemyData:
	.db $80,$07,$90,ENEMY_TROOPERJETPACK
Level4Screen23EnemyData:
	.db $00
Level4Screen25EnemyData:
	.db $80,$06,$30,ENEMY_TROOPERJETPACK
	.db $00
Level4Screen27EnemyData:
	.db $E0,$A5,$60,ENEMY_1UP
	.db $00
Level4Screen29EnemyData:
	.db $C0,$B5,$20,ENEMY_LIFEUP
	.db $00
Level4Screen2AEnemyData:
	.db $C0,$01,$60,ENEMY_ASTEROIDPLAT
	.db $40,$12,$20,ENEMY_ASTEROIDPLAT
	.db $40,$23,$E0,ENEMY_ASTEROIDPLAT
	.db $C0,$34,$A0,ENEMY_ASTEROIDPLAT
	.db $00
Level4Screen2DEnemyData:
	.db $42,$D4,$48,ENEMY_1UP
	.db $90,$E3,$48,ENEMY_POWERUP
	.db $C0,$F2,$48,ENEMY_LIFEUP
	.db $00
Level4Screen2FEnemyData:
	.db $80,$F1,$77,ENEMY_MINECART
	.db $00
Level4Screen30EnemyData:
	.db $80,$E5,$97,ENEMY_MINECART
	.db $00
Level4Screen31EnemyData:
	.db $80,$D4,$77,ENEMY_MINECART
	.db $00
Level4Screen32EnemyData:
	.db $80,$C3,$97,ENEMY_MINECART
	.db $00
Level4Screen33EnemyData:
	.db $80,$B2,$77,ENEMY_MINECART
	.db $00
Level4Screen39EnemyData:
	.db $80,$A1,$97,ENEMY_MINECART
	.db $00
Level4Screen3FEnemyData:
	.db $80,$95,$77,ENEMY_MINECART
	.db $00
Level4Screen40EnemyData:
	.db $80,$73,$57,ENEMY_MINECART
	.db $00
Level4Screen41EnemyData:
	.db $80,$84,$37,ENEMY_MINECART
	.db $00
Level4Screen44EnemyData:
	.db $80,$62,$97,ENEMY_MINECART
	.db $00
Level4Screen45EnemyData:
	.db $80,$41,$57,ENEMY_MINECART
	.db $00
Level4Screen4CEnemyData:
	.db $80,$55,$37,ENEMY_MINECART
	.db $00
Level4Screen4FEnemyData:
	.db $80,$34,$97,ENEMY_MINECART
	.db $00
Level4Screen50EnemyData:
	.db $80,$12,$57,ENEMY_MINECART
	.db $00
Level4Screen5DEnemyData:
	.db $80,$23,$37,ENEMY_MINECART
	.db $00
Level4Screen67EnemyData:
	.db $80,$01,$57,ENEMY_MINECART
Level4Screen00EnemyData:
	.db $00
Level4Screen47EnemyData:
	.db $80,$07,$10,ENEMY_TROOPERJETPACK
	.db $00
Level4Screen49EnemyData:
	.db $80,$07,$B0,ENEMY_TROOPERJETPACK
	.db $00
Level4Screen69EnemyData:
	.db $D4,$0C,$4E,ENEMY_LEVEL4BOSSP2
	.db $B8,$03,$36,ENEMY_LEVEL4BOSSP1
	.db $B8,$14,$66,ENEMY_LEVEL4BOSSP1
	.db $C7,$2B,$3D,ENEMY_LEVEL4BOSSP1
	.db $00

;LEVEL 5 ENEMY DATA
Level5EnemyDataPointerTable:
	;Area 0
	;Area 1
	.dw Level5Screen00EnemyData
	.dw Level5Screen01EnemyData
	.dw Level5Screen02EnemyData
	.dw Level5Screen03EnemyData
	.dw Level5Screen04EnemyData
	;Area 2
	;Area 3
	.dw Level5Screen05EnemyData
	.dw Level5Screen06EnemyData
	.dw Level5Screen07EnemyData
	.dw Level5Screen08EnemyData
	.dw Level5Screen09EnemyData
	;Area 4
	;Area 5
	.dw Level5Screen0AEnemyData
	.dw Level5Screen0BEnemyData
	.dw Level5Screen0CEnemyData
	.dw Level5Screen0DEnemyData
	.dw Level5Screen0EEnemyData
	;Area 6
	;Area 7
	.dw Level5Screen0FEnemyData
	.dw Level5Screen10EnemyData
	.dw Level5Screen11EnemyData
	.dw Level5Screen12EnemyData
	.dw Level5Screen13EnemyData
	;Area 8
	.dw Level5Screen14EnemyData
	.dw Level5Screen15EnemyData
	.dw Level5Screen16EnemyData
	.dw Level5Screen17EnemyData
	.dw Level5Screen18EnemyData
	;Area A
	.dw Level5Screen19EnemyData
	.dw Level5Screen19EnemyData
	;Area 9
	.dw Level5Screen19EnemyData
	.dw Level5Screen19EnemyData
	;Area C
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen1DEnemyData
	.dw Level5Screen24EnemyData
	.dw Level5Screen25EnemyData
	.dw Level5Screen26EnemyData
	.dw Level5Screen27EnemyData
	.dw Level5Screen28EnemyData
	.dw Level5Screen29EnemyData
	.dw Level5Screen2AEnemyData
	.dw Level5Screen2BEnemyData
	;Area D
	.dw Level5Screen2CEnemyData
	.dw Level5Screen2CEnemyData
	;Area E
	.dw Level5Screen2EEnemyData
	.dw Level5Screen2EEnemyData
	;Area F
	.dw Level5Screen30EnemyData
	.dw Level5Screen30EnemyData
	;Area B
	.dw Level5Screen19EnemyData
	.dw Level5Screen19EnemyData

Level5Screen00EnemyData:
	.db $48,$1A,$B0,ENEMY_BEHBGAREABGGLPIPE
	.db $A0,$71,$30,ENEMY_SPIKEBUG
	.db $70,$3B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $E8,$12,$28,ENEMY_FROZENINICE
	.db $00
Level5Screen01EnemyData:
	.db $10,$1C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $41,$04,$53,ENEMY_CAGEDPIG
	.db $48,$2A,$B0,ENEMY_BEHBGAREABGGLPIPE
	.db $70,$0B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $80,$05,$95,ENEMY_TROOPER2
	.db $C7,$06,$67,ENEMY_BGFAKEBLOCK
	.db $D7,$07,$67,ENEMY_BGFAKEBLOCK
	.db $00
Level5Screen02EnemyData:
	.db $10,$2C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $20,$08,$35,ENEMY_TROOPER2
	.db $40,$11,$A2,ENEMY_CONVEYOR
	.db $50,$82,$50,ENEMY_BG3WAYSHOOTER
	.db $70,$02,$50,ENEMY_BG3WAYSHOOTER
	.db $90,$82,$50,ENEMY_BG3WAYSHOOTER
	.db $80,$08,$25,ENEMY_TROOPER2
	.db $A0,$13,$A2,ENEMY_CONVEYOR
	.db $E0,$14,$A2,ENEMY_CONVEYOR
	.db $B0,$95,$50,ENEMY_BG3WAYSHOOTER
	.db $D0,$15,$50,ENEMY_BG3WAYSHOOTER
	.db $F0,$95,$50,ENEMY_BG3WAYSHOOTER
	.db $00
Level5Screen03EnemyData:
	.db $60,$16,$42,ENEMY_CONVEYOR
	.db $70,$A7,$70,ENEMY_BG3WAYSHOOTER
	.db $90,$27,$70,ENEMY_BG3WAYSHOOTER
	.db $B0,$A7,$70,ENEMY_BG3WAYSHOOTER
	.db $A0,$01,$42,ENEMY_CONVEYOR
	.db $E0,$02,$42,ENEMY_CONVEYOR
	.db $E0,$03,$A2,ENEMY_CONVEYOR
	.db $00
Level5Screen04EnemyData:
	.db $50,$B4,$30,ENEMY_BG3WAYSHOOTER
	.db $70,$34,$30,ENEMY_BG3WAYSHOOTER
	.db $90,$B4,$30,ENEMY_BG3WAYSHOOTER
	.db $C0,$15,$62,ENEMY_CONVEYOR
	.db $C0,$16,$A2,ENEMY_CONVEYOR
	.db $D0,$F7,$50,ENEMY_LIFEUP
	.db $D0,$E1,$90,ENEMY_POWERUP
	.db $00
Level5Screen05EnemyData:
	.db $70,$3B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $A0,$78,$30,ENEMY_SPIKEBUG
	.db $87,$13,$67,ENEMY_BGFAKEBLOCK
	.db $97,$14,$67,ENEMY_BGFAKEBLOCK
	.db $C8,$25,$88,ENEMY_FROZENINICE
	.db $E8,$06,$90,ENEMY_CEILINGLASER
	.db $00
Level5Screen06EnemyData:
	.db $10,$1C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $41,$07,$53,ENEMY_CAGEDPIG
	.db $48,$11,$90,ENEMY_CEILINGLASER
	.db $70,$0B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $A8,$02,$90,ENEMY_CEILINGLASER
	.db $00
Level5Screen07EnemyData:
	.db $10,$2C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $40,$05,$A2,ENEMY_CONVEYOR
	.db $10,$C6,$50,ENEMY_BG3WAYSHOOTER
	.db $30,$46,$50,ENEMY_BG3WAYSHOOTER
	.db $50,$C6,$50,ENEMY_BG3WAYSHOOTER
	.db $70,$D7,$50,ENEMY_BG3WAYSHOOTER
	.db $90,$57,$50,ENEMY_BG3WAYSHOOTER
	.db $B0,$D7,$50,ENEMY_BG3WAYSHOOTER
	.db $A0,$11,$A2,ENEMY_CONVEYOR
	.db $00
Level5Screen08EnemyData:
	.db $20,$13,$A2,ENEMY_CONVEYOR
	.db $28,$04,$90,ENEMY_CEILINGLASER
	.db $60,$15,$A2,ENEMY_CONVEYOR
	.db $68,$1B,$90,ENEMY_CEILINGLASER
	.db $A0,$06,$A2,ENEMY_CONVEYOR
	.db $A8,$0C,$90,ENEMY_CEILINGLASER
	.db $C8,$07,$28,ENEMY_FROZENINICE
	.db $00
Level5Screen09EnemyData:
	.db $80,$38,$60,ENEMY_YOKUBLOCKSPAWN
	.db $88,$DB,$18,ENEMY_BONUSCOIN
	.db $00
Level5Screen0AEnemyData:
	.db $10,$3B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $70,$1C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $00
Level5Screen0BEnemyData:
	.db $10,$0B,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $70,$2C,$20,ENEMY_BEHBGAREABGGLPIPE
	.db $27,$26,$57,ENEMY_BGFAKEBLOCK
	.db $37,$27,$57,ENEMY_BGFAKEBLOCK
	.db $E8,$01,$A8,ENEMY_ARROWYOKUBLOCK
	.db $E8,$32,$48,ENEMY_ARROWYOKUBLOCK
	.db $E8,$C8,$28,ENEMY_1UP
	.db $00
Level5Screen0CEnemyData:
	.db $18,$03,$38,ENEMY_ARROWYOKUBLOCK
	.db $48,$54,$98,ENEMY_ARROWYOKUBLOCK
	.db $98,$36,$38,ENEMY_ARROWYOKUBLOCK
	.db $B8,$75,$68,ENEMY_ARROWYOKUBLOCK
	.db $E8,$BA,$28,ENEMY_BONUSCOIN
	.db $00
Level5Screen0DEnemyData:
	.db $80,$08,$60,ENEMY_YOKUBLOCKSPAWN
	.db $98,$07,$98,ENEMY_ARROWYOKUBLOCK
	.db $D8,$36,$38,ENEMY_ARROWYOKUBLOCK
	.db $00
Level5Screen0EEnemyData:
	.db $30,$A9,$A0,ENEMY_1UP
	.db $70,$5A,$70,ENEMY_POWERUP
	.db $00
Level5Screen0FEnemyData:
	.db $28,$01,$50,ENEMY_CEILINGLASER
	.db $40,$02,$62,ENEMY_CONVEYOR
	.db $A8,$18,$50,ENEMY_CEILINGLASER
	.db $E0,$13,$62,ENEMY_CONVEYOR
	.db $E8,$64,$88,ENEMY_FROZENINICE
	.db $E8,$09,$50,ENEMY_CEILINGLASER
	.db $00
Level5Screen10EnemyData:
	.db $20,$15,$62,ENEMY_CONVEYOR
	.db $48,$16,$50,ENEMY_CEILINGLASER
	.db $60,$07,$62,ENEMY_CONVEYOR
	.db $A0,$01,$62,ENEMY_CONVEYOR
	.db $90,$E2,$30,ENEMY_BG3WAYSHOOTER
	.db $B0,$62,$30,ENEMY_BG3WAYSHOOTER
	.db $D0,$E2,$30,ENEMY_BG3WAYSHOOTER
	.db $00
Level5Screen11EnemyData:
	.db $10,$0C,$A5,ENEMY_TROOPER2
	.db $30,$33,$90,ENEMY_1UP
	.db $00
Level5Screen12EnemyData:
	.db $40,$11,$82,ENEMY_CONVEYOR
	.db $50,$F2,$50,ENEMY_BG3WAYSHOOTER
	.db $70,$72,$50,ENEMY_BG3WAYSHOOTER
	.db $90,$F2,$50,ENEMY_BG3WAYSHOOTER
	.db $A0,$13,$82,ENEMY_CONVEYOR
	.db $E7,$34,$47,ENEMY_BGFAKEBLOCK
	.db $F7,$35,$47,ENEMY_BGFAKEBLOCK
	.db $00
Level5Screen13EnemyData:
	.db $48,$06,$90,ENEMY_CEILINGLASER
	.db $88,$17,$90,ENEMY_CEILINGLASER
	.db $C8,$01,$90,ENEMY_CEILINGLASER
	.db $00
Level5Screen14EnemyData:
	.db $00
Level5Screen15EnemyData:
	.db $48,$17,$88,ENEMY_ARROWYOKUBLOCK
	.db $A8,$06,$48,ENEMY_ARROWYOKUBLOCK
	.db $C0,$28,$60,ENEMY_YOKUBLOCKSPAWN
	.db $00
Level5Screen16EnemyData:
	.db $18,$49,$28,ENEMY_POWERUP
	.db $A8,$17,$88,ENEMY_ARROWYOKUBLOCK
	.db $F7,$26,$A8,ENEMY_ARROWYOKUBLOCK
	.db $00
Level5Screen17EnemyData:
	.db $48,$51,$78,ENEMY_ARROWYOKUBLOCK
	.db $68,$55,$A8,ENEMY_ARROWYOKUBLOCK
	.db $C8,$17,$98,ENEMY_ARROWYOKUBLOCK
	.db $00
Level5Screen18EnemyData:
	.db $08,$16,$78,ENEMY_ARROWYOKUBLOCK
	.db $08,$99,$18,ENEMY_LIFEUP
	.db $40,$18,$60,ENEMY_YOKUBLOCKSPAWN
	.db $98,$05,$A8,ENEMY_ARROWYOKUBLOCK
	.db $D8,$7A,$88,ENEMY_POWERUP
	.db $00
Level5Screen1DEnemyData:
	.db $28,$09,$40,ENEMY_TROOPERJETPACK
	.db $88,$08,$C0,ENEMY_TROOPERJETPACK
	.db $00
Level5Screen24EnemyData:
	.db $08,$07,$80,ENEMY_TROOPERJETPACK
	.db $A8,$06,$B8,ENEMY_ASTEROIDFALL
	.db $B8,$05,$68,ENEMY_ASTEROIDFALL
	.db $D8,$34,$10,ENEMY_BGAPPEARINGSPIKES
	.db $00
Level5Screen25EnemyData:
	.db $08,$03,$80,ENEMY_TROOPERJETPACK
	.db $18,$02,$D8,ENEMY_ASTEROIDFALL
	.db $38,$41,$10,ENEMY_BGAPPEARINGSPIKES
	.db $48,$09,$28,ENEMY_ASTEROIDFALL
	.db $58,$18,$10,ENEMY_BGAPPEARINGSPIKES
	.db $78,$07,$C8,ENEMY_ASTEROIDFALL
	.db $98,$26,$10,ENEMY_BGAPPEARINGSPIKES
	.db $B8,$65,$10,ENEMY_BGAPPEARINGSPIKES
	.db $D8,$04,$48,ENEMY_ASTEROIDFALL
	.db $00
Level5Screen26EnemyData:
	.db $08,$03,$D8,ENEMY_ASTEROIDFALL
	.db $28,$02,$28,ENEMY_ASTEROIDFALL
	.db $38,$41,$10,ENEMY_BGAPPEARINGSPIKES
	.db $48,$09,$A8,ENEMY_ASTEROIDFALL
	.db $58,$18,$10,ENEMY_BGAPPEARINGSPIKES
	.db $D8,$37,$10,ENEMY_BGAPPEARINGSPIKES
	.db $00
Level5Screen27EnemyData:
	.db $38,$46,$10,ENEMY_BGAPPEARINGSPIKES
	.db $58,$15,$10,ENEMY_BGAPPEARINGSPIKES
	.db $98,$24,$10,ENEMY_BGAPPEARINGSPIKES
	.db $B8,$63,$10,ENEMY_BGAPPEARINGSPIKES
	.db $D8,$32,$10,ENEMY_BGAPPEARINGSPIKES
	.db $00
Level5Screen28EnemyData:
	.db $38,$41,$10,ENEMY_BGAPPEARINGSPIKES
	.db $58,$19,$10,ENEMY_BGAPPEARINGSPIKES
	.db $88,$08,$58,ENEMY_ASTEROIDFALL
	.db $A8,$07,$48,ENEMY_ASTEROIDFALL
	.db $C8,$06,$88,ENEMY_ASTEROIDFALL
	.db $E8,$05,$28,ENEMY_ASTEROIDFALL
	.db $00
Level5Screen29EnemyData:
	.db $08,$04,$A8,ENEMY_ASTEROIDFALL
	.db $28,$03,$38,ENEMY_ASTEROIDFALL
	.db $48,$02,$D8,ENEMY_ASTEROIDFALL
	.db $68,$01,$88,ENEMY_ASTEROIDFALL
	.db $88,$09,$98,ENEMY_ASTEROIDFALL
	.db $A8,$08,$68,ENEMY_ASTEROIDFALL
	.db $C8,$07,$B8,ENEMY_ASTEROIDFALL
	.db $E8,$06,$D8,ENEMY_ASTEROIDFALL
	.db $00
Level5Screen2AEnemyData:
	.db $08,$05,$58,ENEMY_ASTEROIDFALL
	.db $28,$04,$48,ENEMY_ASTEROIDFALL
	.db $48,$03,$D8,ENEMY_ASTEROIDFALL
	.db $68,$02,$88,ENEMY_ASTEROIDFALL
	.db $88,$01,$28,ENEMY_ASTEROIDFALL
	.db $00
Level5Screen2BEnemyData:
	.db $38,$89,$48,ENEMY_LIFEUP
	.db $00
Level5Screen2CEnemyData:
	.db $3C,$01,$A3,ENEMY_HYPNOJENNY
Level5Screen19EnemyData:
	.db $00
Level5Screen2EEnemyData:
	.db $D8,$01,$A3,ENEMY_HYPNOWILLY
	.db $00
Level5Screen30EnemyData:
	.db $D8,$01,$A3,ENEMY_HYPNODEADEYE
	.db $00

;LEVEL 6 ENEMY DATA
Level6EnemyDataPointerTable:
	;Area 0
	.dw Level6Screen00EnemyData
	.dw Level6Screen01EnemyData
	.dw Level6Screen02EnemyData
	.dw Level6Screen03EnemyData
	;Area 1
	.dw Level6Screen04EnemyData
	.dw Level6Screen05EnemyData
	.dw Level6Screen06EnemyData
	.dw Level6Screen07EnemyData
	.dw Level6Screen08EnemyData
	.dw Level6Screen09EnemyData
	;Area 2
	.dw Level6Screen0AEnemyData
	.dw Level6Screen0BEnemyData
	.dw Level6Screen0CEnemyData
	.dw Level6Screen0DEnemyData
	.dw Level6Screen0EEnemyData
	.dw Level6Screen0EEnemyData
	.dw Level6Screen10EnemyData
	;Area 3
	.dw Level6Screen11EnemyData
	.dw Level6Screen12EnemyData
	.dw Level6Screen13EnemyData
	.dw Level6Screen14EnemyData
	.dw Level6Screen15EnemyData
	
	.dw Level6Screen16EnemyData
	;Area 4
	.dw Level6Screen16EnemyData
	.dw Level6Screen18EnemyData
	.dw Level6Screen19EnemyData
	.dw Level6Screen1AEnemyData
	
	.dw Level6Screen1BEnemyData
	;Area 5
	.dw Level6Screen1BEnemyData
	.dw Level6Screen1DEnemyData
	
	.dw Level6Screen1DEnemyData
	.dw Level6Screen1BEnemyData
	;Area 6
	.dw Level6Screen1BEnemyData
	.dw Level6Screen1DEnemyData
	
	.dw Level6Screen1DEnemyData
	.dw Level6Screen1BEnemyData
	;Area 7
	.dw Level6Screen1BEnemyData
	.dw Level6Screen1DEnemyData
	
	.dw Level6Screen1DEnemyData
	;Area 8
	.dw Level6Screen27EnemyData
	.dw Level6Screen28EnemyData
	.dw Level6Screen29EnemyData
	.dw Level6Screen2AEnemyData
	.dw Level6Screen2BEnemyData
	
	.dw Level6Screen2CEnemyData
	;Area 9
	.dw Level6Screen2DEnemyData
	
	.dw Level6Screen2CEnemyData

Level6Screen00EnemyData:
	.db $C0,$01,$8C,ENEMY_MECHAFROG
	.db $00
Level6Screen01EnemyData:
	.db $B0,$0C,$60,ENEMY_POWERUP
Level6Screen02EnemyData:
	.db $00
Level6Screen03EnemyData:
	.db $20,$01,$8C,ENEMY_MECHAFROG
	.db $90,$1C,$70,ENEMY_POWERUP
	.db $00
Level6Screen04EnemyData:
	.db $50,$2C,$D0,ENEMY_LIFEUP
	.db $60,$07,$C0,ENEMY_TROOPERJETPACK
	.db $00
Level6Screen05EnemyData:
	.db $35,$05,$40,ENEMY_TROOPER2
	.db $D0,$07,$F0,ENEMY_TROOPERJETPACK
	.db $95,$06,$B0,ENEMY_TROOPER2
	.db $98,$3C,$50,ENEMY_POWERUP
	.db $00
Level6Screen06EnemyData:
	.db $50,$11,$5C,ENEMY_BGCHUTECRUSHER
	.db $50,$92,$A4,ENEMY_BGCHUTECRUSHER
	.db $70,$4C,$30,ENEMY_BONUSCOIN
	.db $90,$23,$5C,ENEMY_BGCHUTECRUSHER
	.db $90,$A4,$A4,ENEMY_BGCHUTECRUSHER
	.db $00
Level6Screen07EnemyData:
	.db $10,$45,$5C,ENEMY_BGCHUTECRUSHER
	.db $10,$C6,$A4,ENEMY_BGCHUTECRUSHER
	.db $30,$5B,$30,ENEMY_1UP
	.db $50,$51,$5C,ENEMY_BGCHUTECRUSHER
	.db $50,$D2,$A4,ENEMY_BGCHUTECRUSHER
	.db $70,$6C,$B0,ENEMY_LIFEUP
	.db $90,$23,$5C,ENEMY_BGCHUTECRUSHER
	.db $90,$A4,$A4,ENEMY_BGCHUTECRUSHER
	.db $00
Level6Screen08EnemyData:
	.db $10,$05,$5C,ENEMY_BGCHUTECRUSHER
	.db $10,$86,$A4,ENEMY_BGCHUTECRUSHER
	.db $10,$7A,$90,ENEMY_POWERUP
	.db $50,$11,$5C,ENEMY_BGCHUTECRUSHER
	.db $50,$92,$A4,ENEMY_BGCHUTECRUSHER
	.db $90,$23,$5C,ENEMY_BGCHUTECRUSHER
	.db $90,$A4,$A4,ENEMY_BGCHUTECRUSHER
	.db $00
Level6Screen09EnemyData:
	.db $10,$45,$5C,ENEMY_BGCHUTECRUSHER
	.db $10,$C6,$A4,ENEMY_BGCHUTECRUSHER
	.db $00
Level6Screen0BEnemyData:
	.db $2E,$21,$7C,ENEMY_BEETLEINWALL
	.db $4F,$62,$26,ENEMY_BEETLEINWALL
	.db $78,$89,$30,ENEMY_1UP
	.db $AE,$33,$9C,ENEMY_BEETLEINWALL
	.db $CF,$74,$46,ENEMY_BEETLEINWALL
	.db $00
Level6Screen0CEnemyData:
	.db $2E,$05,$7C,ENEMY_BEETLEINWALL
	.db $4F,$46,$26,ENEMY_BEETLEINWALL
Level6Screen0AEnemyData:
	.db $AE,$17,$9C,ENEMY_BEETLEINWALL
	.db $CF,$58,$46,ENEMY_BEETLEINWALL
	.db $00
Level6Screen0DEnemyData:
	.db $50,$0C,$75,ENEMY_TROOPER
	.db $00
Level6Screen0EEnemyData:
	.db $10,$21,$00,ENEMY_BEETLEUPDOWN
	.db $30,$32,$50,ENEMY_BEETLEUPDOWN
	.db $48,$03,$20,ENEMY_BEETLEUPDOWN
	.db $58,$14,$90,ENEMY_BEETLEUPDOWN
	.db $68,$05,$70,ENEMY_BEETLEUPDOWN
	.db $78,$16,$30,ENEMY_BEETLEUPDOWN
	.db $88,$27,$60,ENEMY_BEETLEUPDOWN
	.db $98,$38,$A0,ENEMY_BEETLEUPDOWN
	.db $A8,$09,$10,ENEMY_BEETLEUPDOWN
	.db $B8,$1A,$80,ENEMY_BEETLEUPDOWN
	.db $D0,$2B,$40,ENEMY_BEETLEUPDOWN
	.db $F0,$3C,$B0,ENEMY_BEETLEUPDOWN
	.db $00
Level6Screen10EnemyData:
	.db $F0,$01,$75,ENEMY_TROOPER2
	.db $00
Level6Screen11EnemyData:
	.db $90,$01,$44,ENEMY_CEILINGSLUG
	.db $B0,$02,$44,ENEMY_CEILINGSLUG
	.db $00
Level6Screen12EnemyData:
	.db $14,$9C,$2A,ENEMY_LIFEUP
	.db $28,$03,$34,ENEMY_CEILINGSLUG
	.db $50,$04,$24,ENEMY_CEILINGSLUG
	.db $90,$05,$44,ENEMY_CEILINGSLUG
	.db $D0,$06,$64,ENEMY_CEILINGSLUG
	.db $F0,$07,$95,ENEMY_TROOPER2
	.db $00
Level6Screen13EnemyData:
	.db $10,$01,$44,ENEMY_CEILINGSLUG
	.db $50,$02,$44,ENEMY_CEILINGSLUG
	.db $90,$03,$64,ENEMY_CEILINGSLUG
	.db $90,$AC,$18,ENEMY_1UP
	.db $B0,$04,$64,ENEMY_CEILINGSLUG
	.db $D0,$BB,$28,ENEMY_POWERUP
	.db $F0,$05,$15,ENEMY_TROOPER2
	.db $00
Level6Screen14EnemyData:
	.db $10,$06,$64,ENEMY_CEILINGSLUG
	.db $50,$07,$64,ENEMY_CEILINGSLUG
	.db $60,$01,$95,ENEMY_TROOPER2
	.db $D0,$02,$84,ENEMY_CEILINGSLUG
	.db $00
Level6Screen15EnemyData:
	.db $50,$03,$44,ENEMY_CEILINGSLUG
	.db $90,$04,$64,ENEMY_CEILINGSLUG
	.db $E0,$06,$95,ENEMY_TROOPER2
	.db $00
Level6Screen18EnemyData:
	.db $10,$C4,$38,ENEMY_POWERUP
	.db $00
Level6Screen19EnemyData:
	.db $10,$D5,$58,ENEMY_1UP
	.db $A0,$01,$75,ENEMY_TROOPER2
	.db $D0,$02,$95,ENEMY_TROOPER2
	.db $00
Level6Screen1AEnemyData:
	.db $B0,$03,$55,ENEMY_TROOPER2
Level6Screen16EnemyData:
	.db $00
Level6Screen1BEnemyData:
	.db $6A,$01,$30,ENEMY_DARKROOM
	.db $22,$12,$70,ENEMY_DARKROOM
	.db $9A,$23,$B0,ENEMY_DARKROOM
Level6Screen1DEnemyData:
	.db $00
Level6Screen27EnemyData:
	.db $04,$1C,$B0,ENEMY_SPRITEMASK
	.db $80,$01,$9E,ENEMY_LAVAPLAT
	.db $D0,$EB,$18,ENEMY_1UP
	.db $F0,$12,$9E,ENEMY_LAVAPLAT
	.db $00
Level6Screen28EnemyData:
	.db $10,$05,$86,ENEMY_LAVAWORM
	.db $D0,$06,$86,ENEMY_LAVAWORM
	.db $00
Level6Screen29EnemyData:
	.db $30,$07,$86,ENEMY_LAVAWORM
	.db $90,$05,$86,ENEMY_LAVAWORM
	.db $00
Level6Screen2AEnemyData:
	.db $50,$06,$86,ENEMY_LAVAWORM
	.db $F0,$07,$86,ENEMY_LAVAWORM
	.db $00
Level6Screen2BEnemyData:
	.db $90,$FB,$18,ENEMY_LIFEUP
	.db $00
Level6Screen2DEnemyData:
	.db $80,$01,$CA,ENEMY_LEVEL6BOSS
Level6Screen2CEnemyData:
	.db $00

;LEVEL 7 ENEMY DATA
Level7EnemyDataPointerTable:
	.dw Level7Screen00EnemyData
	;Area 7
	.dw Level7Screen01EnemyData
	.dw Level7Screen00EnemyData
	.dw Level7Screen00EnemyData
	.dw Level7Screen00EnemyData
	.dw Level7Screen00EnemyData
	.dw Level7Screen00EnemyData
	;Area 4
	.dw Level7Screen07EnemyData
	.dw Level7Screen08EnemyData
	.dw Level7Screen09EnemyData
	.dw Level7Screen0AEnemyData
	.dw Level7Screen0BEnemyData
	.dw Level7Screen0CEnemyData
	.dw Level7Screen0DEnemyData
	.dw Level7Screen0EEnemyData
	.dw Level7Screen0FEnemyData
	.dw Level7Screen10EnemyData
	;Area 5
	.dw Level7Screen11EnemyData
	.dw Level7Screen12EnemyData
	.dw Level7Screen13EnemyData
	.dw Level7Screen14EnemyData
	.dw Level7Screen15EnemyData
	
	.dw Level7Screen16EnemyData
	.dw Level7Screen16EnemyData
	;Area 0
	.dw Level7Screen18EnemyData
	.dw Level7Screen16EnemyData
	;Area 1
	.dw Level7Screen1AEnemyData
	.dw Level7Screen1BEnemyData
	;Area 2
	.dw Level7Screen1CEnemyData
	.dw Level7Screen1DEnemyData
	;Area 3
	.dw Level7Screen1EEnemyData
	.dw Level7Screen1FEnemyData
	;Area 6
	.dw Level7Screen20EnemyData
	.dw Level7Screen21EnemyData
	.dw Level7Screen22EnemyData
	.dw Level7Screen23EnemyData
	.dw Level7Screen24EnemyData
	.dw Level7Screen25EnemyData
	.dw Level7Screen26EnemyData
	
	.dw Level7Screen27EnemyData
	.dw Level7Screen27EnemyData
	;Area 8
	.dw Level7Screen29EnemyData
	.dw Level7Screen27EnemyData
	.dw Level7Screen27EnemyData
	.dw Level7Screen27EnemyData
	
	.dw Level7Screen27EnemyData
	.dw Level7Screen27EnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	;Area 9
	.dw Level7Screen31EnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	;Area A
	.dw Level7Screen39EnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	
	.dw Level7Screen2FEnemyData
	.dw Level7Screen2FEnemyData
	.dw Level7Screen3FEnemyData
	;Area B
	.dw Level7Screen40EnemyData
	.dw Level7Screen41EnemyData
	;Area C
	.dw Level7Screen42EnemyData
	.dw Level7Screen43EnemyData
	;Area D
	.dw Level7Screen44EnemyData
	.dw Level7Screen45EnemyData
	
	.dw Level7Screen46EnemyData
	;Area E
	.dw Level7Screen47EnemyData
	
	.dw Level7Screen46EnemyData

Level7Screen18EnemyData:
	.db $44,$01,$11,ENEMY_TANKERSIDESPIKES
	.db $A4,$02,$30,ENEMY_TANKERSIDESPIKES
	.db $24,$03,$50,ENEMY_TANKERSIDESPIKES
	.db $84,$04,$70,ENEMY_TANKERSIDESPIKES
	.db $EF,$05,$90,ENEMY_TANKERSIDESPIKES
	.db $C4,$06,$B0,ENEMY_TANKERSIDESPIKES
	.db $50,$07,$50,ENEMY_POWERUP
Level7Screen16EnemyData:
	.db $00
Level7Screen1AEnemyData:
	.db $64,$11,$11,ENEMY_TANKERSIDESPIKES
	.db $EF,$12,$30,ENEMY_TANKERSIDESPIKES
	.db $84,$13,$50,ENEMY_TANKERSIDESPIKES
	.db $64,$14,$70,ENEMY_TANKERSIDESPIKES
	.db $EF,$15,$90,ENEMY_TANKERSIDESPIKES
	.db $84,$16,$B0,ENEMY_TANKERSIDESPIKES
	.db $50,$17,$30,ENEMY_POWERUP
Level7Screen1BEnemyData:
	.db $00
Level7Screen1CEnemyData:
	.db $84,$21,$11,ENEMY_TANKERSIDESPIKES
	.db $24,$22,$30,ENEMY_TANKERSIDESPIKES
	.db $24,$23,$50,ENEMY_TANKERSIDESPIKES
	.db $44,$24,$70,ENEMY_TANKERSIDESPIKES
	.db $24,$25,$90,ENEMY_TANKERSIDESPIKES
	.db $A4,$26,$B0,ENEMY_TANKERSIDESPIKES
	.db $38,$27,$50,ENEMY_POWERUP
Level7Screen1DEnemyData:
	.db $00
Level7Screen1EEnemyData:
	.db $44,$31,$11,ENEMY_TANKERSIDESPIKES
	.db $A4,$32,$30,ENEMY_TANKERSIDESPIKES
	.db $24,$33,$50,ENEMY_TANKERSIDESPIKES
	.db $44,$34,$70,ENEMY_TANKERSIDESPIKES
	.db $EF,$35,$90,ENEMY_TANKERSIDESPIKES
	.db $C4,$36,$B0,ENEMY_TANKERSIDESPIKES
	.db $38,$37,$50,ENEMY_POWERUP
Level7Screen1FEnemyData:
	.db $00
Level7Screen07EnemyData:
	.db $30,$08,$50,ENEMY_BACKGROUNDMONITOR
	.db $50,$11,$60,ENEMY_LIGHTNING
	.db $B0,$0B,$30,ENEMY_TROOPERJETPACK
	.db $00
Level7Screen08EnemyData:
	.db $30,$02,$60,ENEMY_LIGHTNING
	.db $70,$1A,$30,ENEMY_BACKGROUNDMONITOR
	.db $70,$0C,$53,ENEMY_TROOPER
	.db $90,$13,$60,ENEMY_LIGHTNING
	.db $D0,$04,$60,ENEMY_GRAVITYAREA
	.db $00
Level7Screen09EnemyData:
	.db $30,$08,$50,ENEMY_BACKGROUNDMONITOR
	.db $A0,$0B,$30,ENEMY_TROOPERJETPACK
	.db $F0,$0C,$73,ENEMY_TROOPER
	.db $00
Level7Screen0AEnemyData:
	.db $10,$07,$60,ENEMY_GRAVITYAREA
	.db $50,$08,$60,ENEMY_LIGHTNING
	.db $90,$19,$60,ENEMY_LIGHTNING
	.db $D0,$01,$60,ENEMY_GRAVITYAREA
	.db $E0,$43,$40,ENEMY_BONUSCOIN
	.db $F0,$02,$60,ENEMY_GRAVITYAREA
	.db $00
Level7Screen0BEnemyData:
	.db $10,$24,$60,ENEMY_GRAVITYAREA
	.db $30,$05,$60,ENEMY_GRAVITYAREA
	.db $50,$06,$60,ENEMY_GRAVITYAREA
	.db $70,$07,$60,ENEMY_GRAVITYAREA
	.db $90,$08,$30,ENEMY_BACKGROUNDMONITOR
	.db $D0,$1A,$70,ENEMY_LIGHTNING
	.db $F0,$01,$60,ENEMY_GRAVITYAREA
	.db $00
Level7Screen0CEnemyData:
	.db $10,$02,$60,ENEMY_GRAVITYAREA
	.db $30,$23,$60,ENEMY_GRAVITYAREA
	.db $50,$04,$60,ENEMY_GRAVITYAREA
	.db $50,$55,$38,ENEMY_LIFEUP
	.db $70,$26,$60,ENEMY_GRAVITYAREA
	.db $90,$07,$60,ENEMY_GRAVITYAREA
	.db $00
Level7Screen0DEnemyData:
	.db $10,$0B,$75,ENEMY_TROOPER
	.db $30,$1A,$50,ENEMY_BACKGROUNDMONITOR
	.db $50,$08,$60,ENEMY_LIGHTNING
	.db $70,$19,$60,ENEMY_LIGHTNING
	.db $B0,$01,$60,ENEMY_GRAVITYAREA
	.db $00
Level7Screen0EEnemyData:
	.db $30,$08,$70,ENEMY_BACKGROUNDMONITOR
	.db $90,$12,$60,ENEMY_LIGHTNING
	.db $C0,$03,$60,ENEMY_LIGHTNING
	.db $F0,$14,$60,ENEMY_LIGHTNING
	.db $00
Level7Screen0FEnemyData:
	.db $50,$08,$30,ENEMY_BACKGROUNDMONITOR
	.db $D0,$15,$70,ENEMY_LIGHTNING
	.db $F0,$0B,$65,ENEMY_TROOPER
	.db $00
Level7Screen10EnemyData:
	.db $01,$06,$70,ENEMY_LIGHTNING
	.db $30,$17,$70,ENEMY_LIGHTNING
	.db $40,$0C,$15,ENEMY_TROOPER
	.db $90,$01,$70,ENEMY_LIGHTNING
	.db $B0,$1A,$70,ENEMY_BACKGROUNDMONITOR
	.db $D0,$62,$50,ENEMY_LIFEUP
	.db $00
Level7Screen11EnemyData:
	.db $90,$7A,$B0,ENEMY_LIFEUP
	.db $F0,$82,$20,ENEMY_BGGLASSROBOT
	.db $00
Level7Screen12EnemyData:
	.db $10,$02,$20,ENEMY_BGGLASSROBOT
	.db $30,$82,$20,ENEMY_BGGLASSROBOT
	.db $B0,$93,$60,ENEMY_BGGLASSROBOT
	.db $D0,$13,$60,ENEMY_BGGLASSROBOT
	.db $F0,$93,$60,ENEMY_BGGLASSROBOT
	.db $F0,$8A,$20,ENEMY_BONUSCOIN
	.db $00
Level7Screen13EnemyData:
	.db $70,$A4,$60,ENEMY_BGGLASSROBOT
	.db $90,$24,$60,ENEMY_BGGLASSROBOT
	.db $B0,$A4,$60,ENEMY_BGGLASSROBOT
	.db $D0,$E5,$40,ENEMY_BGGLASSROBOT
	.db $F0,$65,$40,ENEMY_BGGLASSROBOT
	.db $00
Level7Screen14EnemyData:
	.db $10,$E5,$40,ENEMY_BGGLASSROBOT
	.db $10,$B1,$40,ENEMY_BGGLASSROBOT
	.db $30,$31,$40,ENEMY_BGGLASSROBOT
	.db $50,$B1,$40,ENEMY_BGGLASSROBOT
	.db $B0,$C2,$20,ENEMY_BGGLASSROBOT
	.db $D0,$42,$20,ENEMY_BGGLASSROBOT
	.db $F0,$C2,$20,ENEMY_BGGLASSROBOT
	.db $00
Level7Screen15EnemyData:
	.db $30,$9A,$B0,ENEMY_1UP
	.db $50,$D3,$40,ENEMY_BGGLASSROBOT
	.db $70,$53,$40,ENEMY_BGGLASSROBOT
	.db $90,$D3,$40,ENEMY_BGGLASSROBOT
	.db $00
Level7Screen20EnemyData:
	.db $40,$15,$62,ENEMY_CONVEYOR
	.db $70,$AC,$90,ENEMY_POWERUP
	.db $A8,$08,$66,ENEMY_BGICEBERGCONVPLAT
	.db $00
Level7Screen21EnemyData:
	.db $01,$16,$62,ENEMY_CONVEYOR
	.db $40,$07,$42,ENEMY_CONVEYOR
	.db $88,$09,$86,ENEMY_BGICEBERGCONVPLAT
	.db $C8,$08,$86,ENEMY_BGICEBERGCONVPLAT
	.db $F0,$BC,$30,ENEMY_BONUSCOIN
	.db $00
Level7Screen22EnemyData:
	.db $A0,$15,$62,ENEMY_CONVEYOR
	.db $A0,$36,$A2,ENEMY_CONVEYOR
	.db $E0,$34,$22,ENEMY_CONVEYOR
	.db $00
Level7Screen23EnemyData:
	.db $08,$08,$86,ENEMY_BGICEBERGCONVPLAT
	.db $20,$CC,$A0,ENEMY_POWERUP
	.db $60,$17,$A2,ENEMY_CONVEYOR
	.db $00
Level7Screen24EnemyData:
	.db $08,$08,$86,ENEMY_BGICEBERGCONVPLAT
	.db $48,$09,$66,ENEMY_BGICEBERGCONVPLAT
	.db $A0,$16,$62,ENEMY_CONVEYOR
	.db $00
Level7Screen25EnemyData:
	.db $01,$17,$A2,ENEMY_CONVEYOR
	.db $20,$DC,$20,ENEMY_1UP
	.db $58,$18,$66,ENEMY_BGICEBERGCONVPLAT
	.db $A8,$09,$66,ENEMY_BGICEBERGCONVPLAT
	.db $00
Level7Screen26EnemyData:
	.db $01,$35,$A2,ENEMY_CONVEYOR
	.db $C8,$08,$86,ENEMY_BGICEBERGCONVPLAT
	.db $00
Level7Screen39EnemyData:
	.db $90,$05,$48,ENEMY_ROTROOMSHOOTER
Level7Screen01EnemyData:
	.db $98,$11,$63,ENEMY_TROOPER2
	.db $40,$12,$73,ENEMY_TROOPER2
	.db $78,$03,$A8,ENEMY_ROTROOMARROW
	.db $90,$04,$10,ENEMY_ROTROOMARROW
Level7Screen00EnemyData:
	.db $00
Level7Screen29EnemyData:
	.db $80,$11,$53,ENEMY_TROOPER2
	.db $40,$12,$73,ENEMY_TROOPER2
	.db $78,$03,$A8,ENEMY_ROTROOMARROW
	.db $90,$04,$10,ENEMY_ROTROOMARROW
	.db $90,$05,$30,ENEMY_ROTROOMSHOOTER
Level7Screen27EnemyData:
	.db $00
Level7Screen31EnemyData:
	.db $98,$11,$35,ENEMY_TROOPER2
	.db $78,$12,$95,ENEMY_TROOPER2
	.db $78,$03,$A8,ENEMY_ROTROOMARROW
	.db $90,$04,$10,ENEMY_ROTROOMARROW
	.db $C7,$05,$70,ENEMY_ROTROOMSHOOTER
Level7Screen2FEnemyData:
	.db $00
Level7Screen40EnemyData:
	.db $04,$0C,$D0,ENEMY_SPRITEMASK
	.db $70,$01,$C0,ENEMY_BGSNAKE
	.db $00
Level7Screen41EnemyData:
	.db $08,$03,$00,ENEMY_CROCODILESPAWNER
	.db $30,$12,$C0,ENEMY_BGSNAKE
	.db $C1,$04,$00,ENEMY_CROCODILESPAWNER
Level7Screen3FEnemyData:
	.db $00
Level7Screen42EnemyData:
	.db $04,$0C,$D0,ENEMY_SPRITEMASK
	.db $70,$01,$C0,ENEMY_BGSNAKE
	.db $00
Level7Screen43EnemyData:
	.db $08,$04,$00,ENEMY_CROCODILESPAWNER
	.db $30,$62,$C0,ENEMY_BGSNAKE
	.db $00
Level7Screen44EnemyData:
	.db $04,$0C,$D0,ENEMY_SPRITEMASK
	.db $70,$31,$C0,ENEMY_BGSNAKE
	.db $00
Level7Screen45EnemyData:
	.db $10,$03,$00,ENEMY_CROCODILESPAWNER
	.db $30,$12,$C0,ENEMY_BGSNAKE
	.db $D0,$EB,$50,ENEMY_LIFEUP
	.db $00
Level7Screen47EnemyData:
	.db $AC,$01,$60,ENEMY_LEVEL7BOSSBACK
	.db $40,$02,$66,ENEMY_LEVEL7BOSSTOP
	.db $98,$03,$30,ENEMY_LEVEL7BOSSFRONTP1
	.db $98,$04,$90,ENEMY_LEVEL7BOSSFRONTP1
	.db $A8,$05,$2F,ENEMY_LEVEL7BOSSFRONTP2
	.db $A8,$06,$8F,ENEMY_LEVEL7BOSSFRONTP2
	.db $78,$09,$08,ENEMY_TROOPJPSPAWNER
	.db $78,$0A,$B8,ENEMY_TROOPJPSPAWNER
Level7Screen46EnemyData:
	.db $00

;LEVEL 8 ENEMY DATA
Level8EnemyDataPointerTable:
	;Area 0
	.dw Level8Screen00EnemyData
	.dw Level8Screen01EnemyData
	;Area 1
	.dw Level8Screen02EnemyData
	.dw Level8Screen03EnemyData
	.dw Level8Screen04EnemyData
	.dw Level8Screen05EnemyData
	.dw Level8Screen06EnemyData
	.dw Level8Screen07EnemyData
	.dw Level8Screen08EnemyData
	.dw Level8Screen03EnemyData
	.dw Level8Screen0AEnemyData
	.dw Level8Screen0BEnemyData
	.dw Level8Screen0CEnemyData
	.dw Level8Screen0DEnemyData
	.dw Level8Screen0EEnemyData
	.dw Level8Screen0BEnemyData
	.dw Level8Screen10EnemyData
	.dw Level8Screen08EnemyData
	.dw Level8Screen12EnemyData
	.dw Level8Screen13EnemyData
	.dw Level8Screen14EnemyData
	.dw Level8Screen15EnemyData
	.dw Level8Screen16EnemyData
	.dw Level8Screen17EnemyData
	.dw Level8Screen18EnemyData
	.dw Level8Screen19EnemyData
	;Area 2
	.dw Level8Screen1AEnemyData
	.dw Level8Screen1AEnemyData
	.dw Level8Screen1CEnemyData
	.dw Level8Screen1DEnemyData
	.dw Level8Screen1EEnemyData
	.dw Level8Screen1FEnemyData
	.dw Level8Screen1CEnemyData
	.dw Level8Screen1AEnemyData
	.dw Level8Screen1EEnemyData
	.dw Level8Screen1FEnemyData
	.dw Level8Screen1CEnemyData
	;Area 3
	.dw Level8Screen25EnemyData
	.dw Level8Screen25EnemyData
	.dw Level8Screen27EnemyData
	.dw Level8Screen28EnemyData
	.dw Level8Screen29EnemyData
	.dw Level8Screen2AEnemyData
	.dw Level8Screen2BEnemyData
	.dw Level8Screen2CEnemyData
	.dw Level8Screen2DEnemyData
	.dw Level8Screen2EEnemyData
	.dw Level8Screen2FEnemyData
	.dw Level8Screen30EnemyData
	.dw Level8Screen30EnemyData
	.dw Level8Screen32EnemyData
	.dw Level8Screen33EnemyData
	.dw Level8Screen34EnemyData
	;Area 4
	.dw Level8Screen25EnemyData
	.dw Level8Screen36EnemyData
	.dw Level8Screen37EnemyData
	.dw Level8Screen38EnemyData
	.dw Level8Screen36EnemyData
	.dw Level8Screen36EnemyData
	.dw Level8Screen36EnemyData
	.dw Level8Screen3CEnemyData
	.dw Level8Screen3DEnemyData
	.dw Level8Screen3EEnemyData
	.dw Level8Screen36EnemyData
	;Area 5
	.dw Level8Screen40EnemyData
	.dw Level8Screen41EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen40EnemyData
	.dw Level8Screen4AEnemyData
	.dw Level8Screen4BEnemyData
	.dw Level8Screen4CEnemyData
	.dw Level8Screen40EnemyData
	;Area 6
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4FEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData
	.dw Level8Screen4EEnemyData

Level8Screen00EnemyData:
	.db $30,$1A,$B0,ENEMY_BEHBGAREABGGLPIPE
	.db $00
Level8Screen01EnemyData:
	.db $30,$2A,$B0,ENEMY_BEHBGAREABGGLPIPE
	.db $30,$01,$78,ENEMY_ESCAPEPOD
	.db $00
Level8Screen02EnemyData:
	.db $00
Level8Screen03EnemyData:
	.db $30,$09,$20,ENEMY_ESCAPEFLAME
	.db $70,$01,$A1,ENEMY_TROOPERESCAPING
	.db $B0,$02,$A1,ENEMY_TROOPERESCAPING
	.db $F0,$0A,$20,ENEMY_ESCAPEFLAME
Level8Screen04EnemyData:
	.db $00
Level8Screen05EnemyData:
	.db $10,$03,$A1,ENEMY_TROOPERESCAPING
	.db $50,$1B,$B0,ENEMY_ESCAPEFLAME
	.db $90,$09,$20,ENEMY_ESCAPEFLAME
	.db $D0,$1A,$B0,ENEMY_ESCAPEFLAME
	.db $00
Level8Screen06EnemyData:
	.db $30,$01,$A1,ENEMY_TROOPERESCAPING
	.db $90,$02,$A1,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen07EnemyData:
	.db $30,$0B,$50,ENEMY_ESCAPEFLAME
	.db $80,$19,$B0,ENEMY_ESCAPEFLAME
	.db $D0,$0A,$50,ENEMY_ESCAPEFLAME
	.db $00
Level8Screen08EnemyData:
	.db $70,$03,$A1,ENEMY_TROOPERESCAPING
	.db $B0,$04,$91,ENEMY_TROOPERESCAPING
	.db $D0,$05,$51,ENEMY_TROOPERESCAPING
	.db $F0,$06,$91,ENEMY_TROOPERESCAPING
	.db $F0,$07,$51,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen0AEnemyData:
	.db $80,$1B,$B0,ENEMY_ESCAPEFLAME
	.db $D0,$0C,$40,ENEMY_LIFEUP
	.db $F0,$04,$51,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen0BEnemyData:
	.db $30,$19,$B0,ENEMY_ESCAPEFLAME
	.db $90,$0A,$50,ENEMY_ESCAPEFLAME
	.db $F0,$1B,$B0,ENEMY_ESCAPEFLAME
	.db $00
Level8Screen0CEnemyData:
	.db $30,$05,$A1,ENEMY_TROOPERESCAPING
	.db $B0,$06,$91,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen0DEnemyData:
	.db $30,$07,$A1,ENEMY_TROOPERESCAPING
	.db $70,$01,$91,ENEMY_TROOPERESCAPING
	.db $B0,$02,$61,ENEMY_TROOPERESCAPING
	.db $D0,$03,$61,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen0EEnemyData:
	.db $10,$04,$A1,ENEMY_TROOPERESCAPING
	.db $00
Level8Screen10EnemyData:
	.db $80,$08,$20,ENEMY_ESCAPEFLAME
	.db $B0,$05,$A1,ENEMY_TROOPERESCAPING
	.db $F0,$06,$A1,ENEMY_TROOPERESCAPING
Level8Screen12EnemyData:
	.db $00
Level8Screen13EnemyData:
	.db $90,$01,$40,ENEMY_ESCAPESHOOTER
	.db $80,$02,$68,ENEMY_ESCAPESHOOTER
	.db $90,$03,$90,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen14EnemyData:
	.db $01,$17,$A0,ENEMY_LIFEUP
	.db $F0,$04,$40,ENEMY_ESCAPESHOOTER
	.db $E0,$05,$68,ENEMY_ESCAPESHOOTER
	.db $F0,$01,$90,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen15EnemyData:
	.db $40,$02,$40,ENEMY_ESCAPESHOOTER
	.db $90,$26,$40,ENEMY_1UP
	.db $B0,$03,$80,ENEMY_ESCAPESHOOTER
	.db $B0,$04,$A0,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen16EnemyData:
	.db $C0,$05,$40,ENEMY_ESCAPESHOOTER
	.db $70,$37,$90,ENEMY_LIFEUP
	.db $00
Level8Screen17EnemyData:
	.db $10,$46,$90,ENEMY_1UP
	.db $50,$01,$20,ENEMY_ESCAPEFLAME
	.db $80,$02,$20,ENEMY_ESCAPEFLAME
	.db $A0,$57,$50,ENEMY_1UP
	.db $F0,$03,$A0,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen19EnemyData:
	.db $58,$06,$20,ENEMY_ESCAPEFLAME
	.db $C0,$17,$B0,ENEMY_ESCAPEFLAME
Level8Screen18EnemyData:
	.db $10,$01,$30,ENEMY_ESCAPESHOOTER
	.db $40,$02,$80,ENEMY_ESCAPESHOOTER
	.db $70,$03,$40,ENEMY_ESCAPESHOOTER
	.db $A0,$04,$90,ENEMY_ESCAPESHOOTER
	.db $D0,$05,$60,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen1AEnemyData:
	.db $5C,$46,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $9C,$41,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $DC,$42,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $00
Level8Screen1CEnemyData:
	.db $B0,$03,$60,ENEMY_BGGLASSPIPE
	.db $00
Level8Screen1DEnemyData:
	.db $D0,$61,$90,ENEMY_LIFEUP
	.db $F0,$34,$80,ENEMY_BGGLASSPIPE
	.db $00
Level8Screen1FEnemyData:
	.db $F0,$15,$60,ENEMY_BGGLASSPIPE
	.db $00
Level8Screen1EEnemyData:
	.db $50,$27,$60,ENEMY_BGGLASSPIPE
	.db $B0,$06,$60,ENEMY_BGGLASSPIPE
	.db $00
Level8Screen25EnemyData:
	.db $5C,$4A,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $9C,$4B,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $DC,$4C,$60,ENEMY_BEHBGAREABGGLPIPE
	.db $00
Level8Screen29EnemyData:
	.db $90,$01,$A0,ENEMY_ESCAPESHOOTER
Level8Screen27EnemyData:
	.db $90,$02,$40,ENEMY_ESCAPESHOOTER
	.db $90,$03,$70,ENEMY_ESCAPESHOOTER
Level8Screen28EnemyData:
	.db $00
Level8Screen2AEnemyData:
	.db $90,$04,$80,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen2BEnemyData:
	.db $90,$05,$90,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen2CEnemyData:
	.db $90,$01,$90,ENEMY_ESCAPESHOOTER
Level8Screen2DEnemyData:
	.db $00
Level8Screen2EEnemyData:
	.db $20,$12,$40,ENEMY_ESCAPESHOOTER
	.db $40,$13,$50,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen2FEnemyData:
	.db $90,$14,$70,ENEMY_ESCAPESHOOTER
	.db $70,$15,$90,ENEMY_ESCAPESHOOTER
Level8Screen30EnemyData:
	.db $00
Level8Screen32EnemyData:
	.db $20,$11,$88,ENEMY_ESCAPESHOOTER
	.db $00
Level8Screen33EnemyData:
	.db $20,$12,$58,ENEMY_ESCAPESHOOTER
	.db $20,$13,$78,ENEMY_ESCAPESHOOTER
	.db $20,$14,$98,ENEMY_ESCAPESHOOTER
Level8Screen34EnemyData:
	.db $00
Level8Screen37EnemyData:
	.db $80,$7A,$30,ENEMY_LIFEUP
	.db $00
Level8Screen38EnemyData:
	.db $80,$01,$68,ENEMY_ESCAPEMBSNAKE
	.db $80,$02,$28,ENEMY_ESCAPEMBSNAKE
	.db $80,$03,$3C,ENEMY_ESCAPEMBSNAKE
	.db $80,$04,$50,ENEMY_ESCAPEMBSNAKE
	.db $80,$05,$80,ENEMY_ESCAPEMBSNAKE
	.db $80,$06,$94,ENEMY_ESCAPEMBSNAKE
	.db $80,$07,$A8,ENEMY_ESCAPEMBSNAKE
	.db $80,$08,$28,ENEMY_ESCAPEMBSNAKE
	.db $80,$09,$A8,ENEMY_ESCAPEMBSNAKE
Level8Screen36EnemyData:
	.db $00
Level8Screen3CEnemyData:
	.db $80,$8A,$60,ENEMY_1UP
	.db $00
Level8Screen3DEnemyData:
	.db $80,$9A,$30,ENEMY_BONUSCOIN
	.db $00
Level8Screen3EEnemyData:
	.db $80,$AA,$90,ENEMY_LIFEUP
	.db $00
Level8Screen41EnemyData:
	.db $90,$01,$D0,ENEMY_ESCAPEMBSHIP
	.db $28,$02,$D0,ENEMY_ESCAPEMBSHIP
	.db $48,$03,$D0,ENEMY_ESCAPEMBSHIP
	.db $68,$04,$D0,ENEMY_ESCAPEMBSHIP
	.db $88,$05,$D0,ENEMY_ESCAPEMBSHIP
	.db $10,$06,$D0,ENEMY_ESCAPEMBSHIP
	.db $50,$07,$D0,ENEMY_ESCAPEMBSHIP
	.db $90,$08,$D0,ENEMY_ESCAPEMBSHIP
	.db $00
Level8Screen40EnemyData:
	.db $00
Level8Screen4AEnemyData:
	.db $80,$BC,$90,ENEMY_1UP
	.db $00
Level8Screen4BEnemyData:
	.db $80,$CC,$30,ENEMY_BONUSCOIN
	.db $00
Level8Screen4CEnemyData:
	.db $80,$DC,$60,ENEMY_LIFEUP
	.db $00
Level8Screen4FEnemyData:
	.db $D0,$EC,$40,ENEMY_LIFEUP
	.db $F0,$01,$D0,ENEMY_LEVEL8BOSS
Level8Screen4EEnemyData:
	.db $00

;;;;;;;;;;;;;;;;;;;;;;;
;STAGE SELECT ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;
RunGameMode_StageSelectSub:
	;Check if already inited
	lda GameSubmode
	bne RunGameMode_StageSelectSub_Main
	;Mark inited
	inc GameSubmode
	;Load enemies
	ldx #$01
RunGameMode_StageSelectSub_SpLoop:
	;Load enemy slot
	ldy StageSelectEnemyAnim-1,x
	jsr SetEnemyAnimation
	jsr ClearEnemy_L
	lda StageSelectEnemyX-1,x
	sta Enemy_X,x
	lda StageSelectEnemyY-1,x
	sta Enemy_Y,x
	lda StageSelectEnemyProps-1,x
	sta Enemy_Props,x
	;Loop for all slots
	inx
	cpx #$0B
	bne RunGameMode_StageSelectSub_SpLoop
	;Write stage select nametable
	ldx #$04
	jsr WriteNametableData
	;Clear timer
	lda #$00
	sta Enemy_Temp2+$0C
	;Move red moon and mask sprite to behind BG
	lda #$20
	sta Enemy_Props+$09
	sta Enemy_Props+$0A
RunGameMode_StageSelectSub_IncL:
	;Increment current level
	inc CurLevel
	lda CurLevel
	and #$03
	sta CurLevel
	tay
	lda LevelsCompletedFlags
	and ItemEnemyBitTable,y
	bne RunGameMode_StageSelectSub_IncL
	tya
	asl
	asl
	tay
	ldx #$01
RunGameMode_StageSelectSub_CPLoop:
	;Set stage select cursor sprites
	lda StageSelectCursorX,y
	sta Enemy_X,x
	lda StageSelectCursorY,y
	sta Enemy_Y,x
	iny
	inx
	cpx #$05
	bne RunGameMode_StageSelectSub_CPLoop
RunGameMode_StageSelectSub_Exit:
	rts
RunGameMode_StageSelectSub_Main:
	;Process enemies
	jsr MoveStageSelectEnemies
	;Increment timer
	inc Enemy_Temp2+$0C
	;Check to flash cursor
	lda Enemy_Temp2+$0C
	and #$08
	bne RunGameMode_StageSelectSub_Vis
	;Hide cursor sprites for flashing effect
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY)
	bne RunGameMode_StageSelectSub_SetF
RunGameMode_StageSelectSub_Vis:
	;Show cursor sprites
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
RunGameMode_StageSelectSub_SetF:
	sta Enemy_Flags+$01
	sta Enemy_Flags+$02
	sta Enemy_Flags+$03
	sta Enemy_Flags+$04
	;Check to start level
	lda JoypadDown
	and #JOY_START
	bne RunGameMode_StageSelectSub_Start
	;Check to increment current level
	lda JoypadDown
	and #(JOY_SELECT|JOY_UP|JOY_DOWN|JOY_LEFT|JOY_RIGHT)
	beq RunGameMode_StageSelectSub_Exit
	;Play sound
	ldy #SE_CURSMOVE
	jsr LoadSound
	;Increment current level
	jmp RunGameMode_StageSelectSub_IncL
RunGameMode_StageSelectSub_Start:
	;Next mode ($04: Ready)
	jsr GoToNextGameMode
	;Play sound
	jsr ClearSound
	ldy #SE_SELECT
	jsr LoadSound
	;Set player HP and clear enemies
	jmp RunGameSubmode_GameOverWait_NextNoClear

MoveStageSelectEnemies:
	;Process enemies
	ldx #$06
MoveStageSelectEnemies_Loop:
	;Process enemy
	jsr MoveStageSelectEnemySub
	;Clear scroll velocity
	lda #$00
	sta ScrollXVelHi
	sta ScrollYVelHi
	sta PlatformScrollXVel
	jsr MoveEnemy_L
	;Loop for all moving enemies
	inx
	cpx #$0A
	bne MoveStageSelectEnemies_Loop
	rts

MoveStageSelectEnemySub:
	;Check for moons
	cpx #$06
	bne MoveStageSelectMoons
	;Check if already inited
	lda Enemy_Temp0+$06
	bne MoveStageSelectEnemySub_Main
	;Set enemy Y acceleration and velocity
	lda #$F8
	sta Enemy_YAccel+$06
	lda #$70
	sta Enemy_YVelLo+$06
	;Mark inited
	inc Enemy_Temp0+$06
	bne MoveStageSelectToadShip_Left
MoveStageSelectEnemySub_Main:
	;Process toad ship
	jsr MoveStageSelectToadShip
	;If enemy Y velocity $70, accelerate up
	lda Enemy_YVelLo+$06
	cmp #$70
	beq MoveStageSelectEnemySub_Up
	;If enemy Y velocity $90, accelerate down
	cmp #$90
	bne MoveStageSelectToadShip_Exit
	;Set enemy Y acceleration down
	lda #$08
	bne MoveStageSelectEnemySub_SetY
MoveStageSelectEnemySub_Up:
	;Set enemy Y acceleration up
	lda #$F8
MoveStageSelectEnemySub_SetY:
	sta Enemy_YAccel+$06
	rts

MoveStageSelectToadShip:
	;If enemy X position $08, move right
	lda Enemy_X+$06
	cmp #$08
	beq MoveStageSelectToadShip_Right
	;If enemy X position $F8, move left
	cmp #$F8
	bne MoveStageSelectToadShip_Exit
MoveStageSelectToadShip_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi+$06
	lda #$E0
	sta Enemy_XVelLo+$06
	;Set enemy properties
	lda #$20
	bne MoveStageSelectToadShip_SetP
MoveStageSelectToadShip_Right:
	;Set enemy X velocity right
	lda #$00
	sta Enemy_XVelHi+$06
	lda #$20
	sta Enemy_XVelLo+$06
	;Set enemy properties
	lda #$60
MoveStageSelectToadShip_SetP:
	sta Enemy_Props+$06
MoveStageSelectToadShip_Exit:
	rts

MoveStageSelectMoons:
	;Check if already inited
	lda Enemy_Temp0,x
	bne MoveStageSelectMoons_Main
	;Mark inited
	inc Enemy_Temp0,x
	;Check for green moon
	cpx #$08
	beq MoveStageSelectMoons_Green
	bne MoveStageSelectMoons_NotGreen
MoveStageSelectMoons_Main:
	;If enemy X velocity right, check if enemy X position $F0
	lda Enemy_XVelHi,x
	bpl MoveStageSelectMoons_PosX
	;If enemy X position $70, set X velocity right
	lda Enemy_X,x
	cmp #$70
	bne MoveStageSelectToadShip_Exit
MoveStageSelectMoons_NotGreen:
	;Set enemy Y velocity down
	lda #$00
	sta Enemy_YVelHi,x
	lda #$08
	sta Enemy_YVelLo,x
	;Set enemy X velocity right
	lda #$00
	sta Enemy_XVelHi,x
	lda #$20
	sta Enemy_XVelLo,x
	;Set enemy properties and flags
	lda #$00
	sta Enemy_Props,x
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	bne MoveStageSelectMoons_SetF
MoveStageSelectMoons_PosX:
	;If enemy X position $F0, set enemy X velocity left
	lda Enemy_X,x
	cmp #$F0
	bne MoveStageSelectToadShip_Exit
MoveStageSelectMoons_Green:
	;Set enemy Y velocity up
	lda #$FF
	sta Enemy_YVelHi,x
	lda #$F8
	sta Enemy_YVelLo,x
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	lda #$E0
	sta Enemy_XVelLo,x
	;Set enemy properties and flags
	lda #$20
	sta Enemy_Props,x
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
MoveStageSelectMoons_SetF:
	sta Enemy_Flags,x
	rts

;STAGE SELECT ENEMY/SPRITE DATA
StageSelectEnemyX:
	.db $48,$66,$48,$66	;Cursor arrows for selected planet
	.db $C8			;Red planet
	.db $88			;Toad ship in background
	.db $70,$C0,$C0		;Purple/green/red moons for yellow planet
	.db $DC			;Mask sprite for moons
StageSelectEnemyY:
	.db $3E,$3E,$5E,$5E	;Cursor arrows for selected planet
	.db $50			;Red planet
	.db $78			;Toad ship in background
	.db $98,$B0,$A0		;Purple/green/red moons for yellow planet
	.db $B0			;Mask sprite for moons
StageSelectEnemyAnim:
	.db $65,$65,$61,$61	;Cursor arrows for selected planet
	.db $63			;Red planet
	.db $69			;Toad ship in background
	.db $67,$6B,$6D		;Purple/green/red moons for yellow planet
	.db $28			;Mask sprite for moons
StageSelectEnemyProps:
	.db $00,$40,$00,$40	;Cursor arrows for selected planet
	.db $00			;Red planet
	.db $00			;Toad ship in background
	.db $00,$00,$00		;Purple/green/red moons for yellow planet
	.db $00			;Mask sprite for moons
StageSelectCursorX:
	.db $48,$66,$48,$66	;Level 1 (Green planet)
	.db $B2,$E0,$B2,$E0	;Level 2 (Red planet)
	.db $30,$60,$30,$60	;Level 3 (Blue planet)
	.db $88,$D8,$88,$D8	;Level 4 (Yellow planet)
StageSelectCursorY:
	.db $40,$40,$5C,$5C	;Level 1 (Green planet)
	.db $3C,$3C,$60,$60	;Level 2 (Red planet)
	.db $7A,$7A,$AC,$AC	;Level 3 (Blue planet)
	.db $7C,$7C,$D2,$D2	;Level 4 (Yellow planet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DIALOG AND SCENE ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
FinishDialog:
	;Next submode
	lda #$00
	sta GameSubmode
	;Clear screen
	jsr ClearDialogScreen
	;Check for "captured after first 4 levels beaten" dialog
	lda DialogID
	eor #$05
	bne FinishDialog_NoCaptured
	;Set current character to Bucky
	sta CurCharacter
	;Disable all characters except Bucky and Blinky
	asl CharacterPowerMax+1
	lsr CharacterPowerMax+1
	asl CharacterPowerMax+2
	lsr CharacterPowerMax+2
	asl CharacterPowerMax+4
	lsr CharacterPowerMax+4
FinishDialog_NoCaptured:
	;Check for special values
	ldy SceneNextLevel
	beq FinishDialog_ToStageSelect
	dey
	beq FinishDialog_SetCaptured
	dey
	beq FinishDialog_ToEnd
	;Setup next mode ($03: Stage select)
	jsr ToStageSelect_EntDialog
	;Set player HP and clear enemies/item collected bits
	jsr RunGameSubmode_GameOverWait_NextClear
	;Set next level
	lda SceneNextLevel
	sta CurLevel
	rts
FinishDialog_ToEnd:
	;Next mode ($09: Ending)
	lda #$09
	sta GameMode
	rts
FinishDialog_ToStageSelect:
	;Setup next mode ($03: Stage select)
	jmp ToStageSelect
FinishDialog_SetCaptured:
	;Set captured dialog
	lda #$05
	sta DialogID
	bne RunGameMode_DialogSub_Finish

RunGameMode_DialogSub:
	;Check for captured dialog
	lda DialogID
	cmp #$05
	beq RunGameMode_DialogSub_Fast
	;Check for intro/level 1-7 beaten dialog
	cmp #$09
	bcc RunGameMode_DialogSub_Fast
	;Check for level 8 beaten/"THE END" dialog
	cmp #$0B
	bcc RunGameMode_DialogSub_NoFast
RunGameMode_DialogSub_Fast:
	;Check for A press
	bit JoypadCur
	bvc RunGameMode_DialogSub_NoFast
	;Clear fast text flag
	lda #$FF
	sta DialogFastTextFlag
RunGameMode_DialogSub_NoFast:
	;Set fast text flag
	inc DialogFastTextFlag
RunGameMode_DialogSub_Finish:
	;Increment scene speed divider index
	inc SceneSpeedDivIndex
	;If submode is 0 (init), don't update scene
	lda GameSubmode
	beq RunGameMode_DialogSub_JT
	;Update scene
	jsr UpdateScene
	;Get scene speed divider value
	lda SceneSpeedDivIndex
	and #$03
	tay
	lda SceneSpeedDivTable,y
	sta SceneSpeedDiv
	;Apply scene scroll velocity
	lda SceneScrollX
	jsr DivSceneSpeedNeg
	jsr UpdateSceneScrollX
	lda SceneScrollY
	jsr DivSceneSpeedNeg
	adc TempMirror_PPUSCROLL_Y
	sta TempMirror_PPUSCROLL_Y
	;Draw scene column
	lda SceneShipChaseMode
	jsr DoJumpTable_Dialog
	jmp RunGameMode_DialogSub_Enemy
	;NOP for alignment
	nop
SceneColumnJumpTable:
	.dw UpdateSceneScrollX_Exit	;$00  Nothing (dummy RTS pointer)
	.dw DrawShipChasingColumn_Stars	;$01  Stars
	.dw DrawShipChasingColumn	;$02 \Ship chasing
	.dw DrawShipChasingColumn	;$03 |
	.dw DrawShipChasingColumn	;$04 /
RunGameMode_DialogSub_Enemy:
	ldx #$0F
RunGameMode_DialogSub_Loop:
	;Check for enemy active flag
	lda Enemy_Flags,x
	bpl RunGameMode_DialogSub_Next
	;Apply enemy velocity
	lda Enemy_YVelHi,x
	jsr DivSceneSpeed
	adc Enemy_Y,x
	sta Enemy_Y,x
	lda Enemy_XVelHi,x
	jsr DivSceneSpeed
	ora #$00
	php
	adc Enemy_X,x
	sta Enemy_X,x
	bcc RunGameMode_DialogSub_XC
	plp
	bpl RunGameMode_DialogSub_NoXC
	bmi RunGameMode_DialogSub_Next
RunGameMode_DialogSub_XC:
	plp
	bpl RunGameMode_DialogSub_Next
RunGameMode_DialogSub_NoXC:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
RunGameMode_DialogSub_Next:
	;Go to next enemy
	dex
	bne RunGameMode_DialogSub_Loop
RunGameMode_DialogSub_JT:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
DialogSubJumpTable:
	.dw RunGameSubmode_DialogInit		;$00  Init
	.dw RunGameSubmode_DialogWaitInput	;$01  Wait for input
	.dw RunGameSubmode_DialogNext		;$02  Load next scene
	.dw RunGameSubmode_DialogWaitInput	;$03  Wait for input
	.dw RunGameSubmode_DialogTyping		;$04  Typing
	.dw RunGameSubmode_DialogWaitEnd	;$05  Wait for end
	.dw RunGameSubmode_DialogClear		;$06  Clear
	.dw RunGameSubmode_DialogPassword	;$07  Show password
	.dw RunGameSubmode_DialogEnd		;$08  End
;$00: Init
RunGameSubmode_DialogInit:
	;Clear dialog screen
	jsr ClearDialogScreen
	;Set scene ID
	ldy DialogID
	lda DialogStartSceneTable,y
	sta SceneID
	;Get dialog data pointer
	tya
	asl
	tay
	lda DialogDataPointerTable,y
	sta DialogDataPointer
	lda DialogDataPointerTable+1,y
	sta DialogDataPointer+1
	;Init dialog state
	lda #$01
	sta DialogLineClearIndex
	sta SceneBlackTimer
	lda #$00
	sta DialogAutoEnableFlag
	sta DialogClearFlag
	lda #$02
	sta SceneTimer
	sta DialogAutoEndTimers+1
	sta BlackScreenTimer
	lda #$14
	sta DialogAutoEndTimers
	;Next submode ($01: Wait for input)
	inc GameSubmode
	jmp RunGameSubmode_DialogWaitInput_Next
;$02: Load next scene
RunGameSubmode_DialogNext:
	;Set dialog text timer
	ldx #$04
	stx DialogTextTimer
	;Next submode ($03: Wait for input)
	stx GameSubmode
	;Show dialog arrow
	lda #$FF
	sta DialogArrowFlashFlag
	;Init dialog state
	lda #$00
	sta SceneSpeedDivIndex
	sta SceneCommandOffset
	jsr InitSceneDataPointer
	;Go to next scene
	inc SceneID
	inc SceneID
RunGameSubmode_DialogNext_Exit:
	rts
;$04: Typing
RunGameSubmode_DialogTyping:
	;If end of dialog, exit early
	lda DialogEndFlag
	bne RunGameSubmode_DialogNext_Exit
	;If fast text enabled, skip timer check
	lda DialogFastTextFlag
	beq RunGameSubmode_DialogTyping_NoDec
	;Decrement dialog text timer, check if 0
	dec DialogTextTimer
	bpl RunGameSubmode_DialogNext_Exit
RunGameSubmode_DialogTyping_NoDec:
	;Reset dialog text timer
	lda #$04
	sta DialogTextTimer
	;Get dialog data byte
	jsr LoadDialogByte
	;Check for command byte $FA-$FF
	lda DialogDataByte
	pha
	cmp #$FA
	bcs RunGameSubmode_DialogTyping_Cmd
	;Set VRAM buffer address
	jsr WriteVRAMBufferCmd_DlgChar
	;Set character in VRAM
	pla
	pha
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Increment dialog text cursor X position
	inc DialogCursorX
RunGameSubmode_DialogTyping_IncAddr:
	;Increment dialog data pointer
	inc DialogDataPointer
	bne RunGameSubmode_DialogTyping_NoC
	inc DialogDataPointer+1
RunGameSubmode_DialogTyping_NoC:
	;If space character, exit early
	pla
	beq RunGameSubmode_DialogNext_Exit
	;Check for command byte $80-$FF
	bmi RunGameSubmode_DialogNext_Exit
	;If fast text enabled, exit early
	lda DialogFastTextFlag
	beq RunGameSubmode_DialogNext_Exit
	;Check for level 8 beaten/"THE END"/password dialog
	lda DialogID
	cmp #$09
	bcs RunGameSubmode_DialogNext_Exit
	;Play sound
	ldy #SE_TYPING
	jmp LoadSound
RunGameSubmode_DialogTyping_Cmd:
	;Handle command byte $FA-$FC
	asl
	adc #$06
	bmi RunGameSubmode_DialogTyping_NextLine
	;Handle command byte $FD-$FF
	sta GameSubmode
	bpl RunGameSubmode_DialogTyping_IncAddr
RunGameSubmode_DialogTyping_NextLine:
	;Increment dialog text cursor Y position
	inc DialogCursorY
	;Reset dialog text cursor X position
	lda #$04
	sta DialogCursorX
	bne RunGameSubmode_DialogTyping_IncAddr
;$01: Wait for input
;$03: Wait for input
RunGameSubmode_DialogWaitInput:
	;If dialog clear flag set, clear single line of dialog
	lda DialogClearFlag
	bne RunGameSubmode_DialogWaitInput_ClearLine
	;Set dialog end flag
	lda #$FF
	sta DialogEndFlag
	;If dialog arrow hidden, don't check for A press
	lda DialogArrowFlashFlag
	beq RunGameSubmode_DialogWaitInput_NoInput
	;If auto input enabled, don't check for A press
	lda DialogAutoEnableFlag
	bmi RunGameSubmode_DialogWaitInput_DecT
	;Check for A press
	lda JoypadDown
	bmi RunGameSubmode_DialogWaitInput_ClearLine
RunGameSubmode_DialogWaitInput_NoInput:
	;Set VRAM buffer address
	jsr WriteVRAMBufferCmd_DlgChar
	;If bit 3 of scene speed divider index 0, show dialog arrow
	lda SceneSpeedDivIndex
	and #$08
	beq RunGameSubmode_DialogWaitInput_ShowArrow
	;Hide dialog arrow
	lda #$00
	beq RunGameSubmode_DialogWaitInput_SetArrow
RunGameSubmode_DialogWaitInput_ShowArrow:
	;Show dialog arrow
	lda #$29
RunGameSubmode_DialogWaitInput_SetArrow:
	and DialogArrowFlashFlag
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jmp WriteVRAMBufferCmd_End
RunGameSubmode_DialogWaitInput_DecT:
	;Decrement auto input timer, check if 0
	dec DialogAutoInputTimer
	bne RunGameSubmode_DialogWaitInput_TimerExit
RunGameSubmode_DialogWaitInput_ClearLine:
	;Clear single line of dialog
	jsr ClearDialogLine
	;If more lines remain, exit early
	bcs RunGameSubmode_DialogWaitInput_Next
RunGameSubmode_DialogWaitInput_TimerExit:
	rts
RunGameSubmode_DialogWaitInput_Next:
	;Next submode
	inc GameSubmode
	;Set dialog end flag based on submode
	lda GameSubmode
	eor #$04
	sta DialogEndFlag
	;Reset dialog text cursor position
	lda #$01
	sta DialogCursorY
	lda #$04
	sta DialogCursorX
	;Reset auto input timer
	lda #$A5
	sta DialogAutoInputTimer
	;Clear dialog clear flag
	lda #$00
	sta DialogClearFlag
RunGameSubmode_DialogWaitInput_Exit:
	rts
;$08: End
RunGameSubmode_DialogEnd:
	;Check for "THE END" dialog
	lda DialogID
	cmp #$0A
	beq RunGameSubmode_DialogWaitInput_Exit
	;Check for password dialogs
	bcs RunGameSubmode_DialogEnd_Finish
	;Check for START press
	lda JoypadDown
	and #JOY_START
	beq RunGameSubmode_DialogWaitInput_Exit
RunGameSubmode_DialogEnd_Finish:
	;Finish dialog
	jmp FinishDialog
;$05: Wait for end
RunGameSubmode_DialogWaitEnd:
	;Check for captured special value
	ldy SceneNextLevel
	dey
	beq RunGameSubmode_DialogWaitEnd_WaitInput
	;Check for intro dialog
	lda DialogID
	beq RunGameSubmode_DialogWaitEnd_WaitInput
	;Check for "THE END"/password dialogs
	cmp #$0A
	bcs RunGameSubmode_DialogWaitEnd_TheEndPassword
	;Check for level 8 beaten dialog
	cmp #$09
	beq RunGameSubmode_DialogWaitEnd_Level8Beaten
	jmp RunGameSubmode_DialogWaitEnd_Default
RunGameSubmode_DialogWaitEnd_WaitInput:
	;Check for A/START press
	lda JoypadDown
	and #(JOY_A|JOY_START)
	beq RunGameSubmode_DialogWaitInput_Exit
	;Finish dialog
	jmp FinishDialog
RunGameSubmode_DialogWaitEnd_Level8Beaten:
	;Decrement auto end timer
	dec DialogAutoEndTimers
	bne RunGameSubmode_DialogWaitInput_Exit
	dec DialogAutoEndTimers+1
	bne RunGameSubmode_DialogWaitInput_Exit
	;Finish dialog
	jmp FinishDialog
RunGameSubmode_DialogWaitEnd_Default:
	;Check for captured/levels 5-8 beaten/"THE END"/password dialogs
	cmp #$05
	bcs RunGameSubmode_DialogWaitEnd_Clear
	;Check for A/START press
	lda JoypadDown
	and #(JOY_A|JOY_START)
	beq RunGameSubmode_DialogWaitInput_Exit
	bne RunGameSubmode_DialogWaitEnd_Clear
RunGameSubmode_DialogWaitEnd_TheEndPassword:
	;Wait for input
	bne RunGameSubmode_DialogWaitEnd_WaitInput
RunGameSubmode_DialogWaitEnd_Clear:
	;Next submode ($06: Clear)
	inc GameSubmode
	rts
;$06: Clear
RunGameSubmode_DialogClear:
	;Clear single line of dialog
	jsr ClearDialogLine
	;If more lines remain, exit early
	bcc RunGameSubmode_DialogClear_Exit
	;Next submode ($07: Show password)
	inc GameSubmode
RunGameSubmode_DialogClear_Exit:
	rts
;$07: Show password
RunGameSubmode_DialogPassword:
	;Next submode ($08: End)
	inc GameSubmode
	;Check for "THE END" dialog
	lda DialogID
	cmp #$0A
	bne RunGameSubmode_DialogPassword_NoEnd
	;Write "THE END" text VRAM strip
	lda #$70
	jsr WriteVRAMStrip
	rts
RunGameSubmode_DialogPassword_NoEnd:
	ldx VRAMBufferOffset
	ldy #$00
RunGameSubmode_DialogPassword_VRAMLoop:
	;Set "PASSWORD" text to VRAM
	lda PasswordVRAMData,y
	sta VRAMBuffer,x
	inx
	iny
	cpy #$0E
	bne RunGameSubmode_DialogPassword_VRAMLoop
	stx VRAMBufferOffset
	;Check for levels 5/6/7 completed
	lda LevelsCompletedFlags
	and #$70
	lsr
	lsr
	lsr
	lsr
	ldy #$FF
RunGameSubmode_DialogPassword_LevelLoop:
	iny
	lsr
	bcs RunGameSubmode_DialogPassword_LevelLoop
	tya
	asl
	asl
	sta TempPasswordLevels567
	;Encode password
	lda #$00
	sta TempPasswordIndex
RunGameSubmode_DialogPassword_EncLoop:
	;Get character power max
	stx VRAMBufferOffset
	ldx TempPasswordIndex
	ldy #$03
	lda #$A4
RunGameSubmode_DialogPassword_PowLoop:
	;Encode character power max
	cmp CharacterPowerMax,x
	beq RunGameSubmode_DialogPassword_PowC
	dey
	beq RunGameSubmode_DialogPassword_PowC
	sec
	sbc #$0C
	bne RunGameSubmode_DialogPassword_PowLoop
RunGameSubmode_DialogPassword_PowC:
	;Encode levels 5/6/7 completed/character power max
	tya
	ora TempPasswordLevels567
	and EncodeCharacterPowerMaxTable,x
	sta $00
	;Encode random bits
	jsr GetPRNGValue
	and EncodeCharRandomTable,x
	;Encode constant bits
	ora EncodeCharCompareTable,x
	ora $00
	;Convert to character
	tay
	lda PasswordCharEncodeTable,y
	inx
	stx TempPasswordIndex
	;Set character to VRAM
	ldx VRAMBufferOffset
	sta VRAMBuffer,x
	;Go to next character
	inx
	;Check if at end of password
	lda #$05
	cmp TempPasswordIndex
	bne RunGameSubmode_DialogPassword_EncLoop
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	rts
PasswordVRAMData:
	.db $01
	.dw $2287
	;    P   A   S   S       W   O   R   D
	.db $10,$01,$13,$13,$00,$17,$0F,$12,$04,$00,$00
EncodeCharCompareTable:
	.db $04,$08,$04,$10,$04
EncodeCharRandomTable:
	.db $10,$10,$08,$08,$10
EncodeCharacterPowerMaxTable:
	.db $03,$03,$03,$07,$0B

UpdateScene_Exit:
	;Decrement timer and exit
	dec SceneTimer
	rts
UpdateScene_Next:
	;Increment scene data pointer
	lda SceneCommandOffset
	clc
	adc SceneDataPointer
	sta SceneDataPointer
	bcc UpdateScene
	inc SceneDataPointer+1
UpdateScene:
	;If timer not 0, branch to exit
	ldy SceneTimer
	bne UpdateScene_Exit
	;Clear command offset
	sty SceneCommandOffset
	;Get scene data byte and check MSB
	jsr GetSceneDataByte
	bpl UpdateScene_DoCmd
	jmp UpdateScene_AddSpr
UpdateScene_DoCmd:
	;Handle command byte $00-$7F
	jsr DoJumpTable_Dialog
	jmp UpdateScene_Next
	;NOP for alignment
	nop
UpdateSceneJumpTable:
	.dw SceneCommand00	;$00  Setup screen
	.dw SceneCommand01	;$01  Clear sound
	.dw SceneCommand02	;$02  Load sound
	.dw SceneCommand03	;$03  Set CHR bank 2
	.dw SceneCommand04	;$04  Set CHR bank 3
	.dw SceneCommand05	;$05  Set CHR bank 4
	.dw SceneCommand06	;$06  Auto advance to next dialog
	.dw SceneCommand07	;$07  Draw column
	.dw SceneCommand08	;$08  Disable black screen
	.dw SceneCommand09	;$09  Hide dialog arrow
	.dw SceneCommand0A	;$0A  Show dialog arrow
	.dw SceneCommand0B	;$0B  Loop section
	.dw SceneCommand0C	;$0C  Set timer
	.dw SceneCommand0D	;$0D  Set X scroll speed
	.dw SceneCommand0E	;$0E  Set Y scroll speed
	.dw SceneCommand0F	;$0F  End scene
	.dw SceneCommand10	;$10  Add explosion
	.dw SceneCommand11	;$11  Draw ship chasing column
	.dw SceneCommand12	;$12  Check for captured scene
	.dw SceneCommand13	;$13  Set next level
	.dw SceneCommand14	;$14  Jump
	.dw SceneCommand15	;$15  Swap nametable
	.dw SceneCommand16	;$16  Set Y scroll to $50
	.dw SceneCommand17	;$17  Add cursor arrows
	.dw SceneCommand18	;$18  Enable auto input
UpdateScene_AddSpr:
	;Get enemy slot index
	pha
	and #$0F
	tax
	pla
	;Handle command byte $80-$FF
	cmp #$C0
	bcs SceneCommandCX
	cmp #$B0
	bcs SceneCommandBX
	cmp #$90
	bcs SceneCommand9X
	jsr SceneCommand8X
	;Set enemy animation
	jsr GetSceneDataByte
	tay
	jsr SetEnemyAnimation
UpdateScene_JmpNext:
	jmp UpdateScene_Next

;$8X: Add enemy using animation
SceneCommand8X:
	;Set enemy position
	jsr SetSceneEnemyPos
	;Set enemy tile offset
	jsr GetSceneDataByte
	sta Enemy_Temp7,x
	;Set enemy props
	jsr GetSceneDataByte
	sta Enemy_Props,x
	;Clear velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	rts

SetSceneEnemyPos:
	;Set enemy position
	jsr GetSceneDataByte
	sta Enemy_X,x
	jsr GetSceneDataByte
	sta Enemy_Y,x
	rts

;$9X: Set enemy velocity
SceneCommand9X:
	;Set enemy velocity
	jsr GetSceneDataByte
	sta Enemy_XVelHi,x
	jsr GetSceneDataByte
	sta Enemy_YVelHi,x
	;Go to next command
	jmp UpdateScene_JmpNext

;$BX: Toggle visibility
SceneCommandBX:
	;Set enemy flags
	lda Enemy_Flags,x
	eor #EF_VISIBLE
	sta Enemy_Flags,x
	;Go to next command
	jmp UpdateScene_JmpNext

;$CX: Add enemy using sprite
SceneCommandCX:
	;Add enemy using animation
	jsr SceneCommand8X
	;Set enemy sprite
	jsr GetSceneDataByte
	sta Enemy_SpriteHi,x
	jsr GetSceneDataByte
	sta Enemy_SpriteLo,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	ora Enemy_Flags,x
	sta Enemy_Flags,x
	;Go to next command
	jmp UpdateScene_JmpNext

;$17: Add cursor arrows
SceneCommand17:
	;Add cursor arrows
	ldx #$05
SceneCommand17_Loop:
	;Loop for each cursor arrow
	dex
	beq SceneCommand17_Exit
	;Set enemy position
	jsr SetSceneEnemyPos
	;Set enemy tile offset
	lda #$80
	sta Enemy_Temp7,x
	;Set enemy props
	lda SceneCursorProps-1,x
	sta Enemy_Props,x
	;Set enemy animation
	ldy #$65
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #EF_ACTIVE
	sta Enemy_Flags,x
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	jmp SceneCommand17_Loop
SceneCommand17_Exit:
	rts
SceneCursorProps:
	.db $C0,$80,$40,$00

;$00: Setup scene
SceneCommand00:
	;Clear dialog screen
	jsr ClearDialogScreen
	;Clear dialog end flag
	lda #$00
	sta DialogEndFlag
	;Write nametable
	jsr GetSceneDataByte
	tax
	jsr WriteNametableData
	;Load CHR bank set
	jsr GetSceneDataByte
	tax
	jsr LoadCHRBankSet
	;Load palette strip
	jsr GetSceneDataByte
	jsr WritePaletteStrip8
	;Load IRQ buffer set
	jsr GetSceneDataByte
	tax
	jmp LoadIRQBufferSet

;$02: Load sound
SceneCommand02:
	;Play sound
	jsr GetSceneDataByte
	tay
	jmp LoadSound

;$01: Clear sound
SceneCommand01:
	;Clear sound
	lda #$00
	sta DisableSoundLoadFlag
	jmp ClearSound

;$03: Set CHR bank 2
SceneCommand03:
	;Load CHR bank
	jsr GetSceneDataByte
	sta TempCHRBanks+2
	rts

;$04: Set CHR bank 3
SceneCommand04:
	;Load CHR bank
	jsr GetSceneDataByte
	sta TempCHRBanks+3
	rts

;$05: Set CHR bank 4
SceneCommand05:
	;Load CHR bank
	jsr GetSceneDataByte
	sta TempCHRBanks+4
	rts

;$06: Auto advance to next dialog
SceneCommand06:
	;Auto advance to next dialog
	jsr GetSceneDataByte
	sta DialogAutoInputTimer
	lda #$00
	sta DialogEndFlag
	rts

;$18: Enable auto input
SceneCommand18:
	;Enable auto input
	lda DialogAutoEnableFlag
	eor #$FF
	sta DialogAutoEnableFlag
	;Set auto input timer
	lda #$A5
	sta DialogAutoInputTimer
	rts

;$07: Draw column
SceneCommand07:
	;Draw column
	jsr GetSceneDataByte
	sta SceneColumn
	jmp DrawSceneColumn_L

;$08: Disable black screen
SceneCommand08:
	;Disable black screen
	dec SceneBlackTimer
	rts

DrawStarColumn:
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	lda #$00
	sta $05
	lda #$24
	sta $06
	jsr GetSceneColumnVRAMAddr_L
	;Draw star column
	ldy #$11
DrawStarColumn_Loop:
	;If bits 0-5 of random value >= $1D, draw star tile
	jsr GetPRNGValue
	and #$1F
	cmp #$1D
	bcc DrawStarColumn_NoStar
	;Get star tile
	adc #$0B
	bne DrawStarColumn_SetT
DrawStarColumn_NoStar:
	lda #$00
DrawStarColumn_SetT:
	;Set tile in VRAM
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	dey
	bne DrawStarColumn_Loop
	jsr WriteVRAMBufferCmd_End
	rts

;$09: Hide dialog arrow
SceneCommand09:
	;Hide dialog arrow
	lda #$00
	sta DialogArrowFlashFlag
	sta DialogEndFlag
	rts

;$0A: Show dialog arrow
SceneCommand0A:
	;Show dialog arrow
	lda #$FF
	sta DialogArrowFlashFlag
	rts

;$0B: Loop section
SceneCommand0B:
	;Increment timer
	inc SceneTimer
	;If loop count 0, get loop count
	lda SceneLoopCount
	beq SceneCommand0B_SetCount
	;Get loop back offset
	inc SceneCommandOffset
	jsr GetSceneDataByte
	;Decrement loop count, check if 0
	dec SceneLoopCount
	beq SceneCommand0B_Next
SceneCommand0B_Jump:
	;Loop back
	ldy #$02
	sty SceneCommandOffset
	jsr GetSceneDataByte
	clc
	adc SceneDataPointer
	sta SceneDataPointer
	bcs SceneCommand0B_NoC
	dec SceneDataPointer+1
SceneCommand0B_NoC:
	lda #$00
	sta SceneCommandOffset
	rts
SceneCommand0B_Next:
	;Skip over loop
	lda #$03
	sta SceneCommandOffset
	rts
SceneCommand0B_SetCount:
	;Get loop count
	jsr GetSceneDataByte
	sta SceneLoopCount
	jmp SceneCommand0B_Jump

;$14: Jump
SceneCommand14:
	;Set scene data pointer
	jsr GetSceneDataByte
	sta $00
	jsr GetSceneDataByte
	sta SceneDataPointer+1
	lda $00
	sta SceneDataPointer
	;Clear scene data offset
	lda #$00
	sta SceneCommandOffset
	rts

;$0C: Set timer
SceneCommand0C:
	;Set timer
	jsr GetSceneDataByte
	sta SceneTimer
	rts

;$0D: Set X scroll speed
SceneCommand0D:
	;Set X scroll speed
	jsr GetSceneDataByte
	sta SceneScrollX
	rts

;$0E: Set Y scroll speed
SceneCommand0E:
	;Set Y scroll speed
	jsr GetSceneDataByte
	sta SceneScrollY
	rts

;$0F: End scene
SceneCommand0F:
	;Increment timer
	inc SceneTimer
	;Clear scene data offset
	lda #$00
	sta SceneCommandOffset
	rts

;$10: Add explosion
SceneCommand10:
	;Set enemy position
	ldx #$0F
	jsr SetSceneEnemyPos
	;Set timer
	lda #$0F
	sta SceneTimer
	;Set enemy X position randomly
	jsr GetPRNGValue
	and #$38
	adc Enemy_X,x
	sta Enemy_X,x
	;Set enemy Y position randomly
	jsr GetPRNGValue
	and #$38
	adc Enemy_Y,x
	sta Enemy_Y,x
	;Set enemy tile offset
	lda #$C0
	sta Enemy_Temp7,x
	;Set enemy animation
	ldy #$E4
	jsr SetEnemyAnimation
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	rts

;$11: Draw ship chasing column
SceneCommand11:
	;Draw ship chasing column
	jsr GetSceneDataByte
	sta SceneShipChaseMode
	rts

;$12: Check for captured scene
SceneCommand12:
	;Set next level to special value "stage select"
	lda #$00
	sta SceneNextLevel
	;Check if first 4 levels completed
	lda LevelsCompletedFlags
	and #$0F
	cmp #$0F
	bne SceneCommand12_Exit
	;Set next level to special value "captured scene"
	inc SceneNextLevel
SceneCommand12_Exit:
	rts

;$13: Set next level
SceneCommand13:
	;Set next level
	jsr GetSceneDataByte
	sta SceneNextLevel
	rts

DrawShipChasingColumn:
	;Set scene column
	lda SceneShipChaseMode
	clc
	adc #$02
	sta SceneColumn
	;Draw scene column
	jsr DrawSceneColumn_L
DrawShipChasingColumn_Stars:
	;Draw star column
	jmp DrawStarColumn

UpdateSceneScrollX:
	;Apply scroll X velocity
	clc
	pha
	adc TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_X
	;Check for overflow
	pla
	bcs UpdateSceneScrollX_XC
	bmi SceneCommand15
UpdateSceneScrollX_Exit:
	rts
UpdateSceneScrollX_XC:
	bpl SceneCommand15
	rts

;$15: Swap nametable
SceneCommand15:
	;Swap nametable
	lda #$01
	eor TempMirror_PPUCTRL
	sta TempMirror_PPUCTRL
	rts

;$16: Set Y scroll to $50
SceneCommand16:
	;Set Y scroll $50
	lda #$50
	sta TempMirror_PPUSCROLL_Y
	rts

WriteVRAMBufferCmd_DlgChar:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda DialogCursorY
	ror
	ror
	ror
	and #$C0
	ora DialogCursorX
	ldy #$22
	bcc WriteVRAMBufferCmd_DlgChar_NoC
	iny
WriteVRAMBufferCmd_DlgChar_NoC:
	jmp WriteVRAMBufferCmd_Addr

ClearDialogLine_ClrChase:
	;Clear ship chasing column task flag
	lda #$00
	sta SceneShipChaseFlag
	rts
ClearDialogLine:
	;Set dialog clear task flag
	lda #$FF
	sta DialogClearFlag
	;Check for ship chasing column task flag
	lda SceneShipChaseFlag
	bne ClearDialogLine_ClrChase
	;Set VRAM buffer address
	lda DialogLineClearIndex
	sta DialogCursorY
	lda #$04
	sta DialogCursorX
	jsr WriteVRAMBufferCmd_DlgChar
	;Clear single line of dialog
	ldy #$19
ClearDialogLine_Loop:
	;Clear character in VRAM
	lda #$00
	sta VRAMBuffer,x
	inx
	dey
	bne ClearDialogLine_Loop
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Go to next line
	inc DialogLineClearIndex
	;Check if at end of dialog
	lda DialogLineClearIndex
	eor #$06
	beq ClearDialogLine_End
	clc
	rts
ClearDialogLine_End:
	sec
	;Reset line number
	lda #$01
	sta DialogLineClearIndex
	rts

ClearDialogScreen:
	;Set black screen timer
	lda SceneBlackTimer
	sta BlackScreenTimer
	lda #$01
	sta SceneBlackTimer
	;Clear enemies and nametable
	jsr ClearEnemies
	txa
	pha
	jsr ClearNametableData
	pla
	tax
	;Init scene state
	lda #$00
	sta TempIRQEnableFlag
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	sta SceneShipChaseMode
	sta SceneScrollX
	sta SceneScrollY
	lsr TempMirror_PPUCTRL
	asl TempMirror_PPUCTRL
	rts

DoJumpTable_Dialog:
	;Adjust jump table index by 2
	clc
	adc #$02
	sta $02
	;Pull and push table offset to stack
	pla
	sta $00
	pla
	sta $01
	pha
	lda $00
	pha
	lda $01
	pha
	lda $00
	pha
	;Get adjusted jump table index and do jump table
	lda $02
	jmp DoJumpTable

DivSceneSpeedNeg:
	;Divide scene speed
	jsr DivSceneSpeed
	;Negate result
	eor #$FF
	adc #$01
	clc
	rts

DivSceneSpeed:
	;Divide scene speed
	clc
	adc SceneSpeedDiv
	lsr
	lsr
	sec
	sbc #$20
	clc
	rts

GetSceneDataByte:
	;Get scene data byte
	jsr LoadSceneByte
	lda SceneDataByte
	rts

InitSceneDataPointer:
	;Init scene data pointer
	ldy SceneID
	lda SceneDataPointerTable,y
	sta SceneDataPointer
	lda SceneDataPointerTable+1,y
	sta SceneDataPointer+1
	rts

;DIALOG AND SCENE DATA
SceneSpeedDivTable:
	.db $82,$81,$83,$80
DialogDataPointerTable:
	.dw Dialog00Data	;$00  Intro
	.dw Dialog01Data	;$01  Level 1 beaten (Blinky rescued)
	.dw Dialog02Data	;$02  Level 2 beaten (Dead-Eye rescued)
	.dw Dialog03Data	;$03  Level 3 beaten (Jenny rescued)
	.dw Dialog04Data	;$04  Level 4 beaten (Willy rescued)
	.dw Dialog05Data	;$05  Captured after first 4 levels beaten
	.dw Dialog06Data	;$06  Level 5 beaten
	.dw Dialog07Data	;$07  Level 6 beaten
	.dw Dialog08Data	;$08  Level 7 beaten
	.dw Dialog09Data	;$09  Level 8 beaten
	.dw Dialog0AData	;$0A  "THE END" screen
	.dw Dialog0BData	;$0B  Dummy for post-first 4 levels password
	.dw Dialog0CData	;$0C  Dummy for post-level 5 password
	.dw Dialog0DData	;$0D  Dummy for post-level 6 password
	.dw Dialog0EData	;$0E  Dummy for post-level 7 password
DialogStartSceneTable:
	.db $00,$0C,$0E,$10,$12,$2A,$14,$18,$1C,$20,$32,$30,$16,$1A,$1E
SceneDataPointerTable:
	.dw Scene00Data	;$00 \Intro
	.dw Scene02Data	;$02 |
	.dw Scene04Data	;$04 |
	.dw Scene06Data	;$06 |
	.dw Scene08Data	;$08 |
	.dw Scene0AData	;$0A /
	.dw Scene0CData	;$0C  Level 1 beaten (Blinky rescued)
	.dw Scene0EData	;$0E  Level 2 beaten (Dead-Eye rescued)
	.dw Scene10Data	;$10  Level 3 beaten (Jenny rescued)
	.dw Scene12Data	;$12  Level 4 beaten (Willy rescued)
	.dw Scene14Data	;$14 \Level 5 beaten
	.dw Scene16Data	;$16 /
	.dw Scene18Data	;$18 \Level 6 beaten
	.dw Scene1AData	;$1A /
	.dw Scene1CData	;$1C \Level 7 beaten
	.dw Scene1EData	;$1E /
	.dw Scene20Data	;$20 \Level 8 beaten
	.dw Scene22Data	;$22 |
	.dw Scene24Data	;$24 |
	.dw Scene26Data	;$26 |
	.dw Scene28Data	;$28 /
	.dw Scene2AData	;$2A \Captured after first 4 levels beaten
	.dw Scene2CData	;$2C |
	.dw Scene2EData	;$2E |
	.dw Scene30Data	;$30 /
	.dw Scene32Data	;$32 "THE END" screen
PasswordCharEncodeTable:
	;*: Star
	;@: Bunny icon
	;v: Down arrow
	;^: Up arrow
	;    B   D   G   H   J   K   L   M   N   P   Q   R   T   V   W   X
	.db $02,$04,$07,$08,$0A,$0B,$0C,$0D,$0E,$10,$11,$12,$14,$16,$17,$18
	;    Y   Z   ^   2   3   4   5   6   7   8   9   !   ?   *   @   v
	.db $19,$1A,$2A,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29

;UNUSED SPACE
	;$34 bytes of free space available
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF

	.org $C000
