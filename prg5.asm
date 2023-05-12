	.base $8000
	.org $8000
;BANK NUMBER
	.db $3A

;;;;;;;;;;;;;
;SPRITE DATA;
;;;;;;;;;;;;;
;SPRITE DATA 000-0FF
SpriteData000PointerTable:
	.dw Sprite000Data	;$000 \Bucky walking
	.dw Sprite002Data	;$002 |
	.dw Sprite004Data	;$004 /
	.dw Sprite006Data	;$006 \Dead-Eye walking
	.dw Sprite008Data	;$008 |
	.dw Sprite00AData	;$00A /
	.dw Sprite00CData	;$00C \Jenny walking
	.dw Sprite00EData	;$00E |
	.dw Sprite010Data	;$010 /
	.dw Sprite012Data	;$012 \Willy walking
	.dw Sprite014Data	;$014 |
	.dw Sprite016Data	;$016 /
	.dw Sprite018Data	;$018 \Blinky walking
	.dw Sprite01AData	;$01A |
	.dw Sprite01CData	;$01C /
	.dw Sprite01EData	;$01E \Trooper walking
	.dw Sprite020Data	;$020 |
	.dw Sprite022Data	;$022 /
	.dw Sprite024Data	;$024  Bucky/Dead-Eye idle
	.dw Sprite026Data	;$026  Crocodile
	.dw Sprite028Data	;$028  Jenny idle
	.dw Sprite02AData	;$02A  Willy idle
	.dw Sprite02CData	;$02C  Blinky idle
	.dw Sprite02EData	;$02E  Trooper in trench
	.dw Sprite030Data	;$030  Blinky ducking/charging
	.dw Sprite032Data	;$032 \Beetle in ground
	.dw Sprite034Data	;$034 /
	.dw Sprite036Data	;$036  Bucky/Dead-Eye/Blinky bullet
	.dw Sprite038Data	;$038  Crocodile
	.dw Sprite03AData	;$03A  Jenny/Willy bullet
	.dw Sprite03CData	;$03C \Crocodile
	.dw Sprite03EData	;$03E /
	.dw Sprite040Data	;$040  Enemy bullet
	.dw Sprite042Data	;$042  Bucky jumping
	.dw Sprite044Data	;$044  Dead-Eye jumping
	.dw Sprite046Data	;$046  Jenny jumping
	.dw Sprite048Data	;$048  Willy jumping
	.dw Sprite04AData	;$04A  Blinky jumping
	.dw Sprite04CData	;$04C  Bucky ducking/charging
	.dw Sprite04EData	;$04E  Dead-Eye ducking/charging
	.dw Sprite050Data	;$050  Jenny ducking
	.dw Sprite052Data	;$052  Willy ducking/charging
	.dw Sprite054Data	;$054  Bucky looking up
	.dw Sprite056Data	;$056  Bucky looking down
	.dw Sprite058Data	;$058 \Dead-Eye climbing up
	.dw Sprite05AData	;$05A /
	.dw Sprite05CData	;$05C \Dark room light with spotlight
	.dw Sprite05EData	;$05E /
	.dw Sprite060Data	;$060  Jenny charging
	.dw Sprite062Data	;$062 \Jenny light ball
	.dw Sprite064Data	;$064 |
	.dw Sprite066Data	;$066 |
	.dw Sprite068Data	;$068 |
	.dw Sprite06AData	;$06A |
	.dw Sprite06CData	;$06C /
	.dw Sprite06EData	;$06E \Blinky flying
	.dw Sprite070Data	;$070 /
	.dw Sprite072Data	;$072 \Level 4 boss back shooters
	.dw Sprite074Data	;$074 |
	.dw Sprite076Data	;$076 /
	.dw Sprite078Data	;$078 \Asteroid
	.dw Sprite07AData	;$07A /
	.dw Sprite07CData	;$07C \Willy charged bullet
	.dw Sprite07EData	;$07E |
	.dw Sprite080Data	;$080 /
	.dw Sprite082Data	;$082 \Dead-Eye climbing down
	.dw Sprite084Data	;$084 /
	.dw Sprite086Data	;$086 \Bee
	.dw Sprite088Data	;$088 /
	.dw Sprite08AData	;$08A \Caterpillar going left/right
	.dw Sprite08CData	;$08C /
	.dw Sprite08EData	;$08E \Spider
	.dw Sprite090Data	;$090 /
	.dw Sprite092Data	;$092 \Beetle in ceiling
	.dw Sprite094Data	;$094 /
	.dw Sprite096Data	;$096 \Swinging vine platform vine
	.dw Sprite098Data	;$098 |
	.dw Sprite09AData	;$09A |
	.dw Sprite09CData	;$09C |
	.dw Sprite09EData	;$09E |
	.dw Sprite0A0Data	;$0A0 /
	.dw Sprite0A2Data	;$0A2 \Fish
	.dw Sprite0A4Data	;$0A4 /
	.dw Sprite0A6Data	;$0A6  Swinging vine platform vine
	.dw Sprite0A8Data	;$0A8  Nothing
	.dw Sprite0AAData	;$0AA \Swinging vine platform vine
	.dw Sprite0ACData	;$0AC /
	.dw Sprite0AEData	;$0AE \Level 1 boss
	.dw Sprite0B0Data	;$0B0 |
	.dw Sprite0B2Data	;$0B2 |
	.dw Sprite0B4Data	;$0B4 |
	.dw Sprite0B6Data	;$0B6 |
	.dw Sprite0B8Data	;$0B8 |
	.dw Sprite0BAData	;$0BA /
	.dw Sprite0BCData	;$0BC  Falling tree platform left
	.dw Sprite0BEData	;$0BE  Falling tree platform right
	.dw Sprite0C0Data	;$0C0  Swinging vine platform log
	.dw Sprite0C2Data	;$0C2  Floating log
	.dw Sprite0C4Data	;$0C4 \Caterpillar going up
	.dw Sprite0C6Data	;$0C6 /
	.dw Sprite0C8Data	;$0C8  Crocodile
	.dw Sprite0CAData	;$0CA  Game over cursor
	.dw Sprite0CCData	;$0CC  Stage select mask for moons
	.dw Sprite0CEData	;$0CE  Level 6 boss laser
	.dw Sprite0D0Data	;$0D0  Nametable sprites, "Toad Ship Chase" toad ship
	.dw Sprite0D2Data	;$0D2 \Falling rock
	.dw Sprite0D4Data	;$0D4 |
	.dw Sprite0D6Data	;$0D6 |
	.dw Sprite0D8Data	;$0D8 |
	.dw Sprite0DAData	;$0DA |
	.dw Sprite0DCData	;$0DC /
	.dw Sprite0DEData	;$0DE  Vine platform mask
	.dw Sprite0E0Data	;$0E0  Swinging vine platform vine
	.dw Sprite0E2Data	;$0E2 \Caterpillar going down
	.dw Sprite0E4Data	;$0E4 /
	.dw Sprite0E6Data	;$0E6  Level 7 boss front shooters part 1
	.dw Sprite0E8Data	;$0E8 \Level 8 miniboss snake
	.dw Sprite0EAData	;$0EA |
	.dw Sprite0ECData	;$0EC /
	.dw Sprite0EEData	;$0EE  Level 8 miniboss snake part
	.dw Sprite0F0Data	;$0F0  Level 8 miniboss snake bullet
	.dw Sprite0F2Data	;$0F2  Beehive
	.dw Sprite0F4Data	;$0F4  Ship fin
	.dw Sprite0F6Data	;$0F6 \UNUSED
	.dw Sprite0F8Data	;$0F8 /
	.dw Sprite0FAData	;$0FA  Balance vine platform
	.dw Sprite0FCData	;$0FC \Swinging vine platform vine
	.dw Sprite0FEData	;$0FE /

;Bucky walking
Sprite000Data:
	.db $05
	.db $FE,$85,$03,$04
	.db $FE,$04,    $FC
	.db $FE,$03,    $F4
	.db $EE,$81,$02,$00
	.db $EE,$00,    $F8
Sprite002Data:
	.db $05
	.db $FD,$88,$03,$04
	.db $FD,$07,    $FC
	.db $FD,$06,    $F4
	.db $ED,$81,$02,$00
	.db $ED,$00,    $F8
Sprite004Data:
	.db $05
	.db $EE,$9A,$02,$00
	.db $EE,$19,    $F8
	.db $FE,$8B,$03,$04
	.db $FE,$0A,    $FC
	.db $FE,$09,    $F4
;Dead-Eye walking
Sprite006Data:
	.db $05
	.db $EE,$81,$02,$00
	.db $EE,$00,    $F8
	.db $FE,$85,$03,$04
	.db $FE,$04,    $FC
	.db $FE,$03,    $F4
Sprite008Data:
	.db $05
	.db $ED,$81,$02,$00
	.db $ED,$00,    $F8
	.db $FD,$88,$03,$04
	.db $FD,$07,    $FC
	.db $FD,$06,    $F4
Sprite00AData:
	.db $05
	.db $EE,$81,$02,$00
	.db $EE,$00,    $F8
	.db $FE,$8A,$03,$FC
	.db $FE,$0B,    $04
	.db $FE,$09,    $F4
;Jenny walking
Sprite00CData:
	.db $06
	.db $FE,$85,$02,$03
	.db $FE,$04,    $FB
	.db $FE,$83,$03,$F3
	.db $EE,$02,    $06
	.db $EE,$01,    $FE
	.db $EE,$00,    $F6
Sprite00EData:
	.db $06
	.db $FD,$88,$02,$02
	.db $FD,$07,    $FA
	.db $FD,$86,$03,$F2
	.db $ED,$02,    $06
	.db $ED,$01,    $FE
	.db $ED,$00,    $F6
Sprite010Data:
	.db $06
	.db $FE,$8B,$02,$03
	.db $FE,$0A,    $FB
	.db $FE,$89,$03,$F3
	.db $EE,$02,    $06
	.db $EE,$01,    $FE
	.db $EE,$00,    $F6
;Willy walking
Sprite012Data:
	.db $06
	.db $FE,$85,$03,$04
	.db $FE,$04,    $FC
	.db $FE,$03,    $F4
	.db $EE,$82,$02,$04
	.db $EE,$01,    $FC
	.db $EE,$00,    $F4
Sprite014Data:
	.db $06
	.db $FD,$88,$03,$04
	.db $FD,$07,    $FC
	.db $FD,$06,    $F4
	.db $ED,$82,$02,$04
	.db $ED,$01,    $FC
	.db $ED,$00,    $F4
Sprite016Data:
	.db $06
	.db $FE,$8B,$03,$04
	.db $FE,$0A,    $FC
	.db $FE,$09,    $F4
	.db $EE,$82,$02,$04
	.db $EE,$01,    $FC
	.db $EE,$00,    $F4
;Blinky walking
Sprite018Data:
	.db $05
	.db $EC,$81,$02,$01
	.db $FC,$83,$03,$00
	.db $FC,$02,    $F8
	.db $EC,$00,    $FE
	.db $F4,$8E,$02,$F9
Sprite01AData:
	.db $05
	.db $EB,$81,$02,$01
	.db $FB,$85,$03,$00
	.db $FB,$04,    $F8
	.db $EB,$00,    $FE
	.db $F3,$8E,$02,$F9
Sprite01CData:
	.db $05
	.db $EC,$81,$02,$01
	.db $FC,$87,$03,$00
	.db $FC,$06,    $F8
	.db $EC,$00,    $FE
	.db $F4,$8E,$02,$F9
;Trooper walking
Sprite01EData:
	.db $04
	.db $04,$A3,$00,$00
	.db $04,$22,    $F8
	.db $F4,$21,    $00
	.db $F4,$20,    $F8
Sprite020Data:
	.db $04
	.db $03,$A5,$00,$00
	.db $03,$24,    $F8
	.db $F3,$21,    $00
	.db $F3,$20,    $F8
Sprite022Data:
	.db $04
	.db $04,$A6,$00,$F6
	.db $F4,$21,    $00
	.db $F4,$20,    $F8
	.db $04,$27,    $02
;Bucky/Dead-Eye idle
Sprite024Data:
	.db $05
	.db $FE,$8E,$03,$04
	.db $FE,$0D,    $FC
	.db $FE,$0C,    $F4
	.db $EE,$80,$02,$F8
	.db $EE,$01,    $00
;Jenny idle
Sprite028Data:
	.db $06
	.db $FE,$8E,$02,$03
	.db $FE,$0D,    $FB
	.db $FE,$8C,$03,$F3
	.db $EE,$02,    $06
	.db $EE,$01,    $FE
	.db $EE,$00,    $F6
;Willy idle
Sprite02AData:
	.db $06
	.db $FE,$8E,$03,$04
	.db $FE,$0D,    $FC
	.db $FE,$0C,    $F4
	.db $EE,$82,$02,$04
	.db $EE,$01,    $FC
	.db $EE,$00,    $F4
;Blinky idle
Sprite02CData:
	.db $05
	.db $EC,$81,$02,$01
	.db $FC,$89,$03,$00
	.db $FC,$08,    $F8
	.db $EC,$00,    $FE
	.db $F4,$8E,$02,$F9
;Trooper in trench
Sprite02EData:
	.db $04
	.db $04,$A9,$00,$00
	.db $04,$28,    $F8
	.db $F4,$20,    $F8
	.db $F4,$21,    $00
;Blinky ducking/charging
Sprite030Data:
	.db $05
	.db $EF,$8B,$02,$04
	.db $FF,$8D,$03,$04
	.db $FF,$0C,    $FC
	.db $EF,$0A,    $01
	.db $F7,$8F,$02,$FC
;Beetle in ground
Sprite032Data:
	.db $0A
	.db $1C,$C9,$01,$31
	.db $12,$48,    $29
	.db $18,$47,    $05
	.db $FA,$46,    $17
	.db $04,$44,    $FB
	.db $0C,$45,    $F3
	.db $FC,$43,    $F1
	.db $F4,$42,    $09
	.db $EC,$41,    $01
	.db $EA,$40,    $F9
Sprite034Data:
	.db $08
	.db $1A,$D6,$01,$31
	.db $12,$55,    $29
	.db $12,$54,    $01
	.db $03,$53,    $1B
	.db $02,$52,    $FB
	.db $F4,$51,    $09
	.db $F2,$50,    $01
	.db $F2,$4D,    $F9
;Bucky/Dead-Eye/Blinky bullet
Sprite036Data:
	.db $01
	.db $F4,$9F,$03,$FC
;Jenny/Willy bullet
Sprite03AData:
	.db $02
	.db $F5,$9F,$02,$01
	.db $F5,$1E,    $F9
;Enemy bullet
Sprite040Data:
	.db $01
	.db $F4,$BF,$00,$FC
;Bucky jumping
Sprite042Data:
	.db $06
	.db $FE,$92,$03,$02
	.db $FE,$11,    $FA
	.db $FE,$10,    $F2
	.db $EE,$0F,    $F2
	.db $EE,$81,$02,$FF
	.db $EE,$00,    $F7
;Dead-Eye jumping
Sprite044Data:
	.db $06
	.db $FE,$93,$03,$04
	.db $FE,$12,    $FD
	.db $FE,$11,    $F5
	.db $EE,$81,$02,$02
	.db $EE,$10,    $FA
	.db $EE,$0F,    $F2
;Jenny jumping
Sprite046Data:
	.db $08
	.db $07,$93,$02,$FC
	.db $F7,$11,    $04
	.db $F7,$10,    $FC
	.db $07,$92,$03,$F4
	.db $F7,$0F,    $F4
	.db $E7,$02,    $06
	.db $E7,$01,    $FE
	.db $E7,$00,    $F6
;Willy jumping
Sprite048Data:
	.db $06
	.db $FE,$91,$03,$02
	.db $FE,$10,    $FA
	.db $FE,$0F,    $F2
	.db $EE,$82,$02,$02
	.db $EE,$01,    $FA
	.db $EE,$00,    $F2
;Blinky jumping
Sprite04AData:
	.db $05
	.db $EA,$81,$02,$01
	.db $FA,$97,$03,$00
	.db $FA,$16,    $F8
	.db $EA,$00,    $FE
	.db $F2,$8E,$02,$F9
;Bucky ducking/charging
Sprite04CData:
	.db $06
	.db $F2,$94,$02,$FA
	.db $F2,$15,    $02
	.db $F2,$93,$03,$F2
	.db $02,$16,    $F2
	.db $02,$17,    $FA
	.db $02,$18,    $02
;Dead-Eye ducking/charging
Sprite04EData:
	.db $06
	.db $F2,$81,$02,$04
	.db $F2,$00,    $FC
	.db $02,$97,$03,$04
	.db $02,$16,    $FC
	.db $02,$15,    $F4
	.db $F2,$14,    $F4
;Jenny ducking
Sprite050Data:
	.db $06
	.db $01,$99,$02,$02
	.db $01,$18,    $FA
	.db $F1,$14,    $F2
	.db $01,$97,$03,$F2
	.db $F1,$16,    $02
	.db $F1,$15,    $FA
;Willy ducking/charging
Sprite052Data:
	.db $06
	.db $02,$88,$03,$04
	.db $02,$16,    $FC
	.db $02,$15,    $F4
	.db $F2,$12,    $F4
	.db $F2,$94,$02,$04
	.db $F2,$13,    $FC
;Bucky looking up
Sprite054Data:
	.db $07
	.db $EF,$82,$02,$F9
	.db $EF,$01,    $F1
	.db $EF,$00,    $E9
	.db $FE,$85,$03,$FC
	.db $FE,$06,    $04
	.db $FE,$04,    $F4
	.db $EE,$03,    $FC
;Bucky looking down
Sprite056Data:
	.db $06
	.db $DF,$88,$02,$FE
	.db $DF,$07,    $F6
	.db $EE,$8C,$03,$FE
	.db $EE,$0B,    $F6
	.db $EE,$0A,    $EE
	.db $DE,$09,    $EE
;Dead-Eye climbing up
Sprite058Data:
	.db $05
	.db $FE,$84,$03,$03
	.db $FE,$03,    $FB
	.db $EE,$02,    $03
	.db $EE,$81,$02,$FF
	.db $EE,$00,    $F7
Sprite05AData:
	.db $05
	.db $FE,$87,$03,$03
	.db $FE,$06,    $FB
	.db $EE,$05,    $03
	.db $EE,$81,$02,$FF
	.db $EE,$00,    $F7
;Dead-Eye climbing down
Sprite082Data:
	.db $05
	.db $EE,$84,$83,$03
	.db $EE,$03,    $FB
	.db $FE,$02,    $03
	.db $FE,$81,$82,$FF
	.db $FE,$00,    $F7
Sprite084Data:
	.db $05
	.db $EE,$87,$83,$03
	.db $EE,$06,    $FB
	.db $FE,$05,    $03
	.db $FE,$81,$82,$FF
	.db $FE,$00,    $F7
;Unreferenced sprite data??? (BROKEN)
	.db $08,$EE,$89,$02,$08,$EE,$08,$00,$FE,$12,$F8,$FE,$94,$03,$08,$FE
	.db $13,$00,$FE,$11,$F0,$EE,$10,$F8,$EE,$0F,$F0,$06,$FE,$85,$02,$00
	.db $FE,$04,$F8,$FE,$03,$F0,$EE,$02,$00,$EE,$80,$03,$F8
;Jenny charging
Sprite060Data:
	.db $06
	.db $FE,$85,$02,$02
	.db $FE,$04,    $FA
	.db $EE,$02,    $04
	.db $EE,$01,    $F4
	.db $FE,$83,$03,$F2
	.db $EE,$00,    $FC
;Jenny light ball
Sprite062Data:
	.db $01
	.db $F4,$91,$02,$FC
Sprite064Data:
	.db $01
	.db $F4,$9B,$02,$FC
Sprite066Data:
	.db $02
	.db $F8,$92,$02,$F8
	.db $F8,$13,    $00
Sprite068Data:
	.db $02
	.db $F8,$94,$02,$F8
	.db $F8,$15,    $00
Sprite06AData:
	.db $02
	.db $F8,$96,$02,$F8
	.db $F8,$17,    $00
Sprite06CData:
	.db $02
	.db $F8,$98,$02,$F8
	.db $F8,$19,    $00
;Blinky flying
Sprite06EData:
	.db $06
	.db $06,$9A,$02,$F6
	.db $ED,$01,    $01
	.db $FD,$99,$03,$00
	.db $FD,$18,    $F8
	.db $ED,$00,    $FE
	.db $F5,$8E,$02,$F9
Sprite070Data:
	.db $06
	.db $06,$9B,$02,$F6
	.db $ED,$01,    $01
	.db $FD,$99,$03,$00
	.db $FD,$18,    $F8
	.db $ED,$00,    $FE
	.db $F5,$8E,$02,$F9
;Asteroid
Sprite078Data:
	.db $02
	.db $F9,$EA,$00,$01
	.db $F9,$69,    $F9
Sprite07AData:
	.db $02
	.db $F8,$E8,$00,$00
	.db $F8,$67,    $F8
;Willy charged bullet
Sprite07CData:
	.db $02
	.db $F4,$9D,$03,$03
	.db $F4,$1E,    $FB
Sprite07EData:
	.db $02
	.db $F4,$9B,$03,$03
	.db $F4,$1C,    $FB
Sprite080Data:
	.db $03
	.db $F4,$9B,$03,$0B
	.db $F4,$1C,    $03
	.db $F4,$1C,    $FB
;Caterpillar going left/right
Sprite08AData:
	.db $03
	.db $F5,$C5,$00,$04
	.db $F5,$44,    $FC
	.db $F5,$43,    $F4
Sprite08CData:
	.db $02
	.db $F5,$C7,$00,$01
	.db $F5,$46,    $F9
;Spider
Sprite08EData:
	.db $09
	.db $05,$C9,$41,$04
	.db $F5,$48,    $04
	.db $F8,$CA,$01,$FC
	.db $05,$49,    $F4
	.db $F5,$48,    $F4
	.db $E8,$D5,$00,$FC
	.db $D8,$55,    $FC
	.db $C8,$55,    $FC
	.db $B8,$55,    $FC
Sprite090Data:
	.db $09
	.db $05,$CC,$41,$04
	.db $F5,$4B,    $04
	.db $F8,$CD,$01,$FC
	.db $05,$4C,    $F4
	.db $F5,$4B,    $F4
	.db $E8,$D5,$00,$FC
	.db $D8,$55,    $FC
	.db $C8,$55,    $FC
	.db $B8,$55,    $FC
;Beetle in ceiling
Sprite092Data:
	.db $0A
	.db $D0,$C9,$C1,$C9
	.db $D9,$48,    $D1
	.db $D3,$47,    $F6
	.db $ED,$46,    $E3
	.db $EF,$43,    $09
	.db $DF,$45,    $07
	.db $E7,$44,    $FF
	.db $01,$40,    $01
	.db $FF,$41,    $F9
	.db $F7,$42,    $F1
Sprite094Data:
	.db $08
	.db $D1,$D6,$C1,$C9
	.db $E6,$53,    $E0
	.db $D9,$55,    $D1
	.db $D8,$54,    $F6
	.db $E9,$52,    $FF
	.db $F7,$51,    $F1
	.db $F9,$50,    $F9
	.db $F9,$4D,    $01
;Fish
Sprite0A2Data:
	.db $03
	.db $F8,$E5,$00,$01
	.db $F8,$64,    $F9
	.db $F8,$63,    $F1
Sprite0A4Data:
	.db $03
	.db $F8,$E8,$00,$01
	.db $F8,$67,    $F9
	.db $F8,$66,    $F1
;Balance vine platform
Sprite0FAData:
	.db $09
	.db $EC,$C4,$00,$FF
	.db $DC,$44,    $FF
	.db $CC,$44,    $FF
	.db $BC,$44,    $FF
	.db $AC,$44,    $FF
	.db $9C,$44,    $FF
	.db $FC,$ED,$01,$04
	.db $FC,$6D,    $F4
	.db $FC,$6D,    $FC
;Swinging vine platform vine
Sprite0A6Data:
	.db $04
	.db $30,$C4,$00,$FF
	.db $20,$44,    $FF
	.db $10,$44,    $FF
	.db $00,$44,    $FF
Sprite0E0Data:
	.db $04
	.db $30,$C4,$00,$00
	.db $20,$44,    $00
	.db $10,$44,    $FF
	.db $00,$44,    $FF
Sprite0AAData:
	.db $04
	.db $30,$C4,$00,$02
	.db $20,$44,    $01
	.db $10,$44,    $00
	.db $00,$44,    $FF
Sprite0ACData:
	.db $04
	.db $30,$C4,$00,$04
	.db $20,$45,    $02
	.db $10,$44,    $01
	.db $00,$45,    $FF
Sprite096Data:
	.db $04
	.db $30,$C5,$00,$05
	.db $20,$45,    $03
	.db $10,$45,    $01
	.db $00,$45,    $FF
Sprite098Data:
	.db $04
	.db $2F,$C5,$00,$07
	.db $1F,$69,    $04
	.db $10,$45,    $02
	.db $00,$69,    $FF
Sprite09AData:
	.db $04
	.db $2F,$E9,$00,$08
	.db $1F,$69,    $05
	.db $10,$69,    $02
	.db $00,$69,    $FF
Sprite09CData:
	.db $04
	.db $2F,$E9,$00,$0A
	.db $20,$6A,    $06
	.db $10,$69,    $03
	.db $00,$6A,    $FF
Sprite09EData:
	.db $04
	.db $2E,$EA,$00,$0B
	.db $1F,$6A,    $07
	.db $10,$6A,    $03
	.db $00,$6A,    $FF
Sprite0A0Data:
	.db $04
	.db $2E,$EA,$00,$0D
	.db $1F,$6B,    $08
	.db $10,$6A,    $04
	.db $00,$6B,    $FF
Sprite0FCData:
	.db $04
	.db $2D,$EB,$00,$0F
	.db $1E,$6C,    $09
	.db $0F,$6B,    $04
	.db $00,$6B,    $FF
Sprite0FEData:
	.db $04
	.db $2D,$EC,$00,$11
	.db $1E,$6C,    $0B
	.db $0F,$6C,    $05
	.db $00,$6C,    $FF
;Level 1 boss
Sprite0AEData:
	.db $0A
	.db $05,$C7,$01,$05
	.db $05,$46,    $FD
	.db $15,$C9,$00,$05
	.db $15,$48,    $FD
	.db $F5,$45,    $04
	.db $F5,$44,    $FC
	.db $F5,$43,    $F4
	.db $E5,$42,    $04
	.db $E5,$41,    $FC
	.db $E5,$40,    $F4
Sprite0B0Data:
	.db $0A
	.db $05,$C7,$01,$04
	.db $05,$46,    $FC
	.db $15,$C9,$00,$04
	.db $15,$48,    $FC
	.db $F5,$4F,    $04
	.db $F5,$4E,    $FC
	.db $F5,$4D,    $F4
	.db $E5,$4C,    $04
	.db $E5,$4B,    $FC
	.db $E5,$4A,    $F4
Sprite0B2Data:
	.db $0E
	.db $05,$DA,$01,$0C
	.db $05,$59,    $04
	.db $05,$58,    $FC
	.db $05,$57,    $F4
	.db $05,$DD,$00,$14
	.db $15,$5C,    $FC
	.db $15,$5B,    $F4
	.db $F5,$56,    $04
	.db $F5,$55,    $FC
	.db $F5,$54,    $F4
	.db $F5,$53,    $EC
	.db $E5,$52,    $04
	.db $E5,$51,    $FC
	.db $E5,$50,    $F4
Sprite0B4Data:
	.db $0B
	.db $05,$DF,$01,$04
	.db $05,$5E,    $FC
	.db $07,$DD,$00,$0C
	.db $15,$5C,    $FF
	.db $15,$5B,    $F7
	.db $F5,$4F,    $04
	.db $F5,$62,    $FC
	.db $F5,$61,    $F4
	.db $E5,$4C,    $04
	.db $E5,$60,    $FC
	.db $E5,$4A,    $F4
Sprite0B6Data:
	.db $0D
	.db $05,$D8,$01,$FF
	.db $05,$5A,    $0F
	.db $05,$59,    $07
	.db $05,$57,    $F7
	.db $05,$DD,$00,$17
	.db $15,$5C,    $FF
	.db $15,$5B,    $F7
	.db $F5,$45,    $04
	.db $F5,$44,    $FC
	.db $F5,$43,    $F4
	.db $E5,$42,    $04
	.db $E5,$41,    $FC
	.db $E5,$40,    $F4
Sprite0B8Data:
	.db $0A
	.db $06,$C7,$01,$05
	.db $06,$46,    $FD
	.db $16,$DC,$00,$07
	.db $16,$5B,    $FF
	.db $F6,$45,    $04
	.db $F6,$44,    $FC
	.db $F6,$43,    $F4
	.db $E6,$42,    $04
	.db $E6,$41,    $FC
	.db $E6,$40,    $F4
Sprite0BAData:
	.db $0B
	.db $05,$DF,$01,$06
	.db $05,$5E,    $FE
	.db $07,$DD,$00,$0E
	.db $15,$5C,    $01
	.db $15,$5B,    $F9
	.db $F5,$45,    $04
	.db $F5,$44,    $FC
	.db $F5,$43,    $F4
	.db $E5,$42,    $04
	.db $E5,$41,    $FC
	.db $E5,$40,    $F4
;Falling tree platform left
Sprite0BCData:
	.db $08
	.db $FF,$F9,$01,$0B
	.db $FF,$78,    $03
	.db $FF,$77,    $FB
	.db $FF,$76,    $F3
	.db $EF,$F4,$00,$07
	.db $EF,$73,    $FF
	.db $EF,$72,    $F7
	.db $EF,$71,    $EF
;Falling tree platform right
Sprite0BEData:
	.db $08
	.db $FF,$F9,$41,$EE
	.db $FF,$78,    $F6
	.db $FF,$77,    $FE
	.db $FF,$76,    $06
	.db $EF,$F4,$40,$F2
	.db $EF,$73,    $FA
	.db $EF,$72,    $02
	.db $EF,$71,    $0A
;Swinging vine platform log
Sprite0C0Data:
	.db $03
	.db $FC,$ED,$01,$03
	.db $FC,$6D,    $FB
	.db $FC,$6D,    $F3
;Floating log
Sprite0C2Data:
	.db $03
	.db $FC,$F0,$01,$04
	.db $FC,$6F,    $FC
	.db $FC,$6E,    $F4
;Caterpillar going up
Sprite0C4Data:
	.db $02
	.db $05,$CF,$00,$FC
	.db $F5,$4E,    $FC
Sprite0C6Data:
	.db $02
	.db $F8,$D1,$00,$FD
	.db $F8,$50,    $F5
;Caterpillar going down
Sprite0E2Data:
	.db $02
	.db $F5,$CF,$80,$FC
	.db $05,$4E,    $FC
Sprite0E4Data:
	.db $02
	.db $F8,$D1,$80,$FD
	.db $F8,$50,    $F5
;Game over cursor
Sprite0CAData:
	.db $01
	.db $F9,$EE,$00,$FC
;Stage select mask for moons
Sprite0CCData:
	.db $04
	.db $00,$C7,$00,$00
	.db $00,$47,    $F8
	.db $F0,$47,    $00
	.db $F0,$47,    $F8
;Nametable sprites, "Toad Ship Chase" toad ship
Sprite0D0Data:
	.db $08
	.db $FF,$DC,$02,$07
	.db $FF,$5B,    $FF
	.db $FF,$5A,    $F7
	.db $FF,$59,    $EF
	.db $EF,$58,    $07
	.db $EF,$57,    $FF
	.db $EF,$56,    $F7
	.db $EF,$55,    $EF
;Falling rock
Sprite0D2Data:
	.db $01
	.db $FD,$ED,$01,$FC
Sprite0D4Data:
	.db $01
	.db $FC,$EE,$01,$FC
Sprite0D6Data:
	.db $01
	.db $FC,$EF,$01,$FD
Sprite0D8Data:
	.db $01
	.db $FC,$F0,$01,$FC
Sprite0DAData:
	.db $01
	.db $FB,$F1,$01,$FC
Sprite0DCData:
	.db $02
	.db $FA,$F3,$01,$01
	.db $FA,$72,    $F9
;Vine platform mask
Sprite0DEData:
	.db $04
Sprite0A8Data:	;uses the $00 byte here to indicate no graphics
	.db $00,$CC,$00,$FD
	.db $10,$4B,    $FD
	.db $F0,$48,    $FD
	.db $E0,$47,    $FD
;Bee
Sprite086Data:
	.db $01
	.db $FA,$C0,$01,$FD
Sprite088Data:
	.db $01
	.db $FA,$C1,$01,$FD
;Beehive
Sprite0F2Data:
	.db $05
	.db $06,$D6,$01,$FD
	.db $06,$54,    $F5
	.db $F6,$53,    $05
	.db $F6,$52,    $FD
	.db $F6,$42,    $F5
;Ship fin
Sprite0F4Data:
	.db $04
	.db $F7,$DA,$00,$0C
	.db $F7,$59,    $04
	.db $F7,$58,    $FC
	.db $F7,$57,    $F4
;UNUSED
Sprite0F6Data:
	.db $05
	.db $F9,$DB,$01,$F2
	.db $03,$E0,$00,$02
	.db $03,$5F,    $FA
	.db $F3,$5E,    $02
	.db $F3,$5D,    $FA
Sprite0F8Data:
	.db $05
	.db $F9,$DC,$01,$F2
	.db $03,$E0,$00,$02
	.db $03,$5F,    $FA
	.db $F3,$5E,    $02
	.db $F3,$5D,    $FA
;Level 4 boss back shooters
Sprite072Data:
	.db $02
	.db $F8,$CD,$01,$F8
	.db $F8,$4E,    $00
Sprite074Data:
	.db $02
	.db $F8,$CF,$01,$F8
	.db $F8,$50,    $00
Sprite076Data:
	.db $02
	.db $F8,$D1,$01,$F8
	.db $F8,$52,    $00
;Dark room light with spotlight
Sprite05CData:
	.db $0F
	.db $E8,$D9,$01,$00
	.db $E8,$5A,    $08
	.db $E8,$5B,    $10
	.db $F8,$59,    $00
	.db $F8,$5C,    $08
	.db $F8,$D8,$40,$10
	.db $E8,$DA,$41,$18
	.db $E8,$59,    $20
	.db $F8,$5C,    $18
	.db $F8,$59,    $20
	.db $08,$D9,$81,$00
	.db $08,$5A,    $08
	.db $08,$5B,    $10
	.db $08,$DA,$C1,$18
	.db $08,$59,    $20
Sprite05EData:
	.db $0F
	.db $E8,$D9,$01,$D8
	.db $E8,$5A,    $E0
	.db $E8,$5B,    $E8
	.db $F8,$59,    $D8
	.db $F8,$5C,    $E0
	.db $F8,$D8,$40,$E8
	.db $E8,$DA,$41,$F0
	.db $E8,$59,    $F8
	.db $F8,$5C,    $F0
	.db $F8,$59,    $F8
	.db $08,$D9,$81,$D8
	.db $08,$5A,    $E0
	.db $08,$5B,    $E8
	.db $08,$DA,$C1,$F0
	.db $08,$59,    $F8
;Level 6 boss laser
Sprite0CEData:
	.db $01
	.db $F6,$F6,$01,$FC
;Unreferenced sprite data??? (BROKEN)
	.db $02,$F8,$F5,$00,$00,$F8,$6D,$F8,$03,$00,$F2,$01,$FC,$F0,$F5,$00
	.db $00,$F0,$6D,$F8,$03,$00,$E3,$01,$FC,$F0,$F5,$00,$00,$F0,$6D,$F8
	.db $04,$00,$E4,$41,$00,$00,$E4,$01,$F8,$F0,$F5,$00,$00,$F0,$6D,$F8
	.db $05,$10,$E7,$01,$FC,$00,$66,$FC,$F0,$65,$FC,$E0,$F5,$00,$00,$E0
	.db $6D,$F8,$06,$18,$E7,$01,$FC,$08,$66,$FC,$F8,$66,$FC,$E8,$66,$FC
	.db $D8,$F5,$00,$00,$D8,$6D,$F8,$09,$24,$E7,$01,$FC,$14,$66,$FC,$04
	.db $66,$FC,$F4,$66,$FC,$E4,$66,$FC,$D4,$66,$FC,$C4,$F5,$00,$00,$C4
	.db $6D,$F8,$0A,$34,$E7,$01,$FC,$14,$66,$FC,$24,$66,$FC,$04,$66,$FC
	.db $F4,$66,$FC,$E4,$66,$FC,$D4,$66,$FC,$C4,$66,$FC,$B4,$F5,$00,$00
	.db $B4,$6D,$F8,$03,$04,$D4,$01,$FA,$F4,$53,$02,$F4,$52,$FA,$03,$FA
	.db $D7,$01,$04,$FA,$56,$FC,$FA,$55,$F4,$04,$F8,$E9,$01,$00,$F8,$68
	.db $F8,$05,$F8,$EB,$01,$00,$F8,$6A,$F8,$06,$FC,$EC,$01,$FC
;Crocodile
Sprite026Data:
	.db $06
	.db $01,$E5,$01,$04
	.db $01,$64,    $FC
	.db $01,$63,    $F4
	.db $F1,$62,    $04
	.db $F1,$61,    $FC
	.db $F1,$60,    $F4
Sprite038Data:
	.db $06
	.db $01,$E9,$01,$04
	.db $01,$68,    $FC
	.db $01,$67,    $F4
	.db $F1,$66,    $04
	.db $F1,$61,    $FC
	.db $F1,$60,    $F4
Sprite03CData:
	.db $06
	.db $01,$ED,$01,$04
	.db $01,$6C,    $FC
	.db $01,$6B,    $F4
	.db $F1,$6A,    $04
	.db $F1,$61,    $FC
	.db $F1,$60,    $F4
Sprite03EData:
	.db $05
	.db $01,$F4,$01,$04
	.db $09,$73,    $FC
	.db $09,$72,    $F4
	.db $F9,$71,    $FC
	.db $F9,$70,    $F4
Sprite0C8Data:
	.db $06
	.db $01,$FA,$01,$04
	.db $01,$79,    $FC
	.db $01,$78,    $F4
	.db $F1,$77,    $04
	.db $F1,$76,    $FC
	.db $F1,$75,    $F4
;Unreferenced sprite data??? (BROKEN)
	.db $09,$F8,$F1,$01,$00,$F8,$70,$F8
;Level 7 boss front shooters part 1
Sprite0E6Data:
	.db $02
	.db $F8,$EF,$00,$00
	.db $F8,$6E,    $F8
;Level 8 miniboss snake
Sprite0E8Data:
	.db $05
	.db $00,$CD,$00,$FD
	.db $F0,$4C,    $FD
	.db $F8,$50,    $05
	.db $00,$4B,    $F5
	.db $F0,$4A,    $F5
Sprite0EAData:
	.db $05
	.db $00,$F8,$00,$05
	.db $F0,$77,    $05
	.db $00,$76,    $FD
	.db $F0,$52,    $FD
	.db $F8,$51,    $F5
Sprite0ECData:
	.db $05
	.db $03,$FD,$00,$00
	.db $F3,$7C,    $00
	.db $03,$7B,    $F8
	.db $F3,$7A,    $F8
	.db $FA,$79,    $F0
;Level 8 miniboss snake part
Sprite0EEData:
	.db $02
	.db $F7,$FE,$40,$08
	.db $F7,$FE,$00,$00
;Level 8 miniboss snake bullet
Sprite0F0Data:
	.db $01
	.db $FD,$FF,$40,$FC

;SPRITE DATA 100-1FF
SpriteData100PointerTable:
	.dw Sprite100Data	;$100  "1"
	.dw Sprite102Data	;$102  "2"
	.dw Sprite104Data	;$104  "3"
	.dw Sprite106Data	;$106  "4"
	.dw Sprite108Data	;$108  "5"
	.dw Sprite10AData	;$10A  "6"
	.dw Sprite10CData	;$10C  "7"
	.dw Sprite10EData	;$10E  "8"
	.dw Sprite110Data	;$110  "9"
	.dw Sprite112Data	;$112  "10"
	.dw Sprite114Data	;$114  "11"
	.dw Sprite116Data	;$116  "12"
	.dw Sprite118Data	;$118  "13"
	.dw Sprite11AData	;$11A  "14"
	.dw Sprite11CData	;$11C  "15"
	.dw Sprite11EData	;$11E \Trooper rolling
	.dw Sprite120Data	;$120 /
	.dw Sprite122Data	;$122 \Falling rock from volcano
	.dw Sprite124Data	;$124 |
	.dw Sprite126Data	;$126 |
	.dw Sprite128Data	;$128 |
	.dw Sprite12AData	;$12A /
	.dw Sprite12CData	;$12C  UNUSED
	.dw Sprite12EData	;$12E \Lava bubble splash
	.dw Sprite130Data	;$130 |
	.dw Sprite132Data	;$132 /
	.dw Sprite134Data	;$134 \Volcano eruption
	.dw Sprite136Data	;$136 /
	.dw Sprite138Data	;$138  Level 2 boss inside
	.dw Sprite13AData	;$13A \Level 2 boss eyes
	.dw Sprite13CData	;$13C /
	.dw Sprite13EData	;$13E  Level 2 boss dot
	.dw Sprite140Data	;$140  Trooper throwing ice block left
	.dw Sprite142Data	;$142  BG snake water mask
	.dw Sprite144Data	;$144  "ceLL"
	.dw Sprite146Data	;$146  "salvage CHUTE"
	.dw Sprite148Data	;$148 \Level 2 boss legs
	.dw Sprite14AData	;$14A /
	.dw Sprite14CData	;$14C \Boulder
	.dw Sprite14EData	;$14E /
	.dw Sprite150Data	;$150 \Side flower
	.dw Sprite152Data	;$152 |
	.dw Sprite154Data	;$154 /
	.dw Sprite156Data	;$156 \Trooper in trench
	.dw Sprite158Data	;$158 /
	.dw Sprite15AData	;$15A \Explosion
	.dw Sprite15CData	;$15C /
	.dw Sprite15EData	;$15E  Bucky dead
	.dw Sprite160Data	;$160  Dead-Eye dead
	.dw Sprite162Data	;$162  Jenny dead
	.dw Sprite164Data	;$164  Willy dead
	.dw Sprite166Data	;$166  Blinky dead
	.dw Sprite168Data	;$168 \Ship down laser
	.dw Sprite16AData	;$16A |
	.dw Sprite16CData	;$16C /
	.dw Sprite16EData	;$16E \UNUSED
	.dw Sprite170Data	;$170 |
	.dw Sprite172Data	;$172 /
	.dw Sprite174Data	;$174 \Lava bubble going up
	.dw Sprite176Data	;$176 /
	.dw Sprite178Data	;$178 \Lava bubble going down
	.dw Sprite17AData	;$17A /
	.dw Sprite17CData	;$17C \Volcano eruption
	.dw Sprite17EData	;$17E /
	.dw Sprite180Data	;$180 \Rocks flying out of volcano
	.dw Sprite182Data	;$182 /
	.dw Sprite184Data	;$184  BG snake moving right
	.dw Sprite186Data	;$186  "ACT"
	.dw Sprite188Data	;$188  "PLANET"
	.dw Sprite18AData	;$18A  "G"
	.dw Sprite18CData	;$18C  "A"
	.dw Sprite18EData	;$18E  "M"
	.dw Sprite190Data	;$190  "E"
	.dw Sprite192Data	;$192  "O"
	.dw Sprite194Data	;$194  "V"
	.dw Sprite196Data	;$196  "R"
	.dw Sprite198Data	;$198 \Trooper throwing icicle
	.dw Sprite19AData	;$19A /
	.dw Sprite19CData	;$19C  Trooper throwing ice block right
	.dw Sprite19EData	;$19E  Ice spike
	.dw Sprite1A0Data	;$1A0 \Rolling spike
	.dw Sprite1A2Data	;$1A2 /
	.dw Sprite1A4Data	;$1A4 \Ice block shoot particles
	.dw Sprite1A6Data	;$1A6 /
	.dw Sprite1A8Data	;$1A8  Nothing
	.dw Sprite1AAData	;$1AA \Ice block spike particles
	.dw Sprite1ACData	;$1AC /
	.dw Sprite1AEData	;$1AE  UNUSED
	.dw Sprite1B0Data	;$1B0  Icicle
	.dw Sprite1B2Data	;$1B2  Icicle sideways
	.dw Sprite1B4Data	;$1B4 \Trooper throwing ice spike
	.dw Sprite1B6Data	;$1B6 /
	.dw Sprite1B8Data	;$1B8 \Trooper melting ice
	.dw Sprite1BAData	;$1BA |
	.dw Sprite1BCData	;$1BC /
	.dw Sprite1BEData	;$1BE  Trooper rolling
	.dw Sprite1C0Data	;$1C0  Level 8 miniboss ship laser
	.dw Sprite1C2Data	;$1C2 \Level 3 boss
	.dw Sprite1C4Data	;$1C4 |
	.dw Sprite1C6Data	;$1C6 |
	.dw Sprite1C8Data	;$1C8 /
	.dw Sprite1CAData	;$1CA  Level 3 boss missle
	.dw Sprite1CCData	;$1CC  Level 3 boss lightning
	.dw Sprite1CEData	;$1CE  "center OF magma TANKER"
	.dw Sprite1D0Data	;$1D0  "escaPE!"
	.dw Sprite1D2Data	;$1D2  BG snake moving down
	.dw Sprite1D4Data	;$1D4  BG snake moving right
	.dw Sprite1D6Data	;$1D6 \Level 2 boss right arm
	.dw Sprite1D8Data	;$1D8 |
	.dw Sprite1DAData	;$1DA |
	.dw Sprite1DCData	;$1DC |
	.dw Sprite1DEData	;$1DE /
	.dw Sprite1E0Data	;$1E0  BG snake moving down
	.dw Sprite1E2Data	;$1E2  Level 2 boss right arm
	.dw Sprite1E4Data	;$1E4 \Level 2 boss left arm
	.dw Sprite1E6Data	;$1E6 |
	.dw Sprite1E8Data	;$1E8 |
	.dw Sprite1EAData	;$1EA |
	.dw Sprite1ECData	;$1EC /
	.dw Sprite1EEData	;$1EE  Level 2 boss laser
	.dw Sprite1F0Data	;$1F0 \Level 2 boss right arm
	.dw Sprite1F2Data	;$1F2 /
	.dw Sprite1F4Data	;$1F4  Ice block
	.dw Sprite1F6Data	;$1F6 \Ice water decoration
	.dw Sprite1F8Data	;$1F8 |
	.dw Sprite1FAData	;$1FA /
	.dw Sprite1FCData	;$1FC \Trooper with jetpack
	.dw Sprite1FEData	;$1FE /

;"1"
Sprite100Data:
	.db $01
Sprite1A8Data:	;uses the $00 byte here to indicate no graphics
	.db $00,$E8,$00,$00
;"2"
Sprite102Data:
	.db $01
	.db $00,$CE,$00,$00
;"3"
Sprite104Data:
	.db $01
	.db $00,$E9,$00,$00
;"4"
Sprite106Data:
	.db $01
	.db $00,$CF,$00,$00
;"5"
Sprite108Data:
	.db $01
	.db $00,$EA,$00,$00
;"6"
Sprite10AData:
	.db $01
	.db $00,$D0,$00,$00
;"7"
Sprite10CData:
	.db $01
	.db $00,$EB,$00,$00
;"8"
Sprite10EData:
	.db $01
	.db $00,$D1,$00,$00
;"9"
Sprite110Data:
	.db $01
	.db $00,$EC,$00,$00
;"10"
Sprite112Data:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$4D,    $04
;"11"
Sprite114Data:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$68,    $04
;"12"
Sprite116Data:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$4E,    $04
;"13"
Sprite118Data:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$69,    $04
;"14"
Sprite11AData:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$4F,    $04
;"15"
Sprite11CData:
	.db $02
	.db $00,$E8,$00,$FC
	.db $00,$6A,    $04
;"ACT"
Sprite186Data:
	.db $03
	.db $00,$C0,$00,$F8
	.db $00,$41,    $00
	.db $00,$66,    $08
;"PLANET"
Sprite188Data:
	.db $06
	.db $00,$E4,$01,$F0
	.db $00,$62,    $F8
	.db $00,$40,    $00
	.db $00,$63,    $08
	.db $00,$42,    $10
	.db $00,$66,    $18
;"ceLL"
Sprite144Data:
	.db $02
	.db $00,$E2,$01,$E8
	.db $00,$62,    $F0
;"salvage CHUTE"
Sprite146Data:
	.db $05
	.db $00,$C1,$01,$F8
	.db $00,$61,    $00
	.db $00,$4A,    $08
	.db $00,$66,    $10
	.db $00,$42,    $18
;"center OF magma TANKER"
Sprite1CEData:
	.db $08
	.db $00,$C7,$01,$C8
	.db $00,$60,    $D0
	.db $00,$66,    $10
	.db $00,$40,    $18
	.db $00,$63,    $20
	.db $00,$45,    $28
	.db $00,$42,    $30
	.db $00,$65,    $38
;"escaPE!"
Sprite1D0Data:
	.db $03
	.db $00,$E4,$01,$F0
	.db $00,$42,    $F8
	.db $00,$67,    $00
;"G"
Sprite18AData:
	.db $01
	.db $00,$C3,$00,$00
;"A"
Sprite18CData:
	.db $01
	.db $00,$C0,$00,$00
;"M"
Sprite18EData:
	.db $01
	.db $00,$C6,$00,$00
;"E"
Sprite190Data:
	.db $01
	.db $00,$C2,$00,$00
;"O"
Sprite192Data:
	.db $01
	.db $00,$C7,$00,$00
;"V"
Sprite194Data:
	.db $01
	.db $00,$ED,$00,$00
;"R"
Sprite196Data:
	.db $01
	.db $00,$E5,$00,$00
;Trooper in trench
Sprite156Data:
	.db $04
	.db $04,$A9,$00,$FF
	.db $04,$28,    $F7
	.db $F4,$41,    $FF
	.db $F4,$40,    $F7
Sprite158Data:
	.db $04
	.db $F4,$C3,$00,$FF
	.db $F4,$42,    $F7
	.db $04,$29,    $FF
	.db $04,$28,    $F7
;Trooper rolling
Sprite1BEData:
	.db $02
	.db $FB,$C9,$00,$00
	.db $FB,$48,    $F8
Sprite11EData:
	.db $02
	.db $FB,$CB,$00,$00
	.db $FB,$4A,    $F8
Sprite120Data:
	.db $02
	.db $FB,$CD,$00,$00
	.db $FB,$4C,    $F8
;Falling rock from volcano
Sprite122Data:
	.db $01
	.db $FD,$CE,$01,$FC
Sprite124Data:
	.db $01
	.db $FC,$CF,$01,$FC
Sprite126Data:
	.db $01
	.db $FC,$D0,$01,$FC
Sprite128Data:
	.db $01
	.db $FD,$D1,$01,$FC
Sprite12AData:
	.db $01
	.db $FC,$D2,$01,$FC
;Unreferenced sprite data??? (BROKEN)
	.db $01,$F4,$D4,$01,$FD,$01,$F4,$D3,$01,$FD
;Level 2 boss inside
Sprite138Data:
	.db $04
	.db $F7,$FE,$01,$10
	.db $F7,$7E,    $D8
	.db $F7,$E1,$00,$00
	.db $F7,$60,    $F8
;Level 2 boss eyes
Sprite13AData:
	.db $04
	.db $F3,$E2,$00,$E8
	.db $F3,$63,    $F0
	.db $F3,$E3,$40,$08
	.db $F3,$62,    $10
Sprite13CData:
	.db $04
	.db $F3,$E4,$00,$E8
	.db $F3,$65,    $F0
	.db $F3,$E5,$40,$08
	.db $F3,$64,    $10
;Level 2 boss dot
Sprite13EData:
	.db $01
	.db $FC,$E6,$00,$FD
;Level 2 boss legs
Sprite148Data:
	.db $04
	.db $F8,$EC,$41,$D8
	.db $F8,$6B,    $E0
	.db $F8,$EB,$01,$18
	.db $F8,$6C,    $20
Sprite14AData:
	.db $04
	.db $F8,$EE,$41,$D8
	.db $F8,$6D,    $E0
	.db $F8,$ED,$01,$18
	.db $F8,$6E,    $20
;Boulder
Sprite14CData:
	.db $06
	.db $05,$DC,$01,$05
	.db $05,$5B,    $FD
	.db $05,$47,    $F5
	.db $F5,$46,    $05
	.db $F5,$45,    $FD
	.db $F5,$44,    $F5
Sprite14EData:
	.db $06
	.db $05,$DC,$01,$05
	.db $05,$72,    $FD
	.db $05,$71,    $F5
	.db $F5,$5F,    $05
	.db $F5,$5E,    $FD
	.db $F5,$5D,    $F5
;Side flower
Sprite150Data:
	.db $04
	.db $EA,$D5,$01,$0E
	.db $EA,$54,    $06
	.db $F6,$D9,$00,$03
	.db $F6,$58,    $FB
Sprite152Data:
	.db $04
	.db $E6,$D3,$41,$07
	.db $E6,$D3,$01,$FF
	.db $F6,$DA,$00,$03
	.db $F6,$58,    $FB
Sprite154Data:
	.db $04
	.db $E9,$D5,$41,$F2
	.db $E9,$54,    $FA
	.db $F6,$DC,$00,$03
	.db $F6,$5B,    $FB
;Explosion
Sprite15AData:
	.db $02
	.db $F8,$AC,$00,$F8
	.db $F8,$2D,    $00
Sprite15CData:
	.db $06
	.db $F4,$AE,$00,$F4
	.db $F4,$2F,    $FC
	.db $04,$3D,    $F4
	.db $04,$3E,    $FC
	.db $04,$BD,$40,$04
	.db $F4,$2E,    $04
;Bucky dead
Sprite15EData:
	.db $04
	.db $FE,$9E,$02,$08
	.db $FE,$1D,    $00
	.db $FE,$9C,$03,$F8
	.db $FE,$1B,    $F0
;Dead-Eye dead
Sprite160Data:
	.db $04
	.db $FE,$9A,$02,$00
	.db $FE,$9B,$03,$08
	.db $FE,$19,    $F8
	.db $FE,$18,    $F0
;Jenny dead
Sprite162Data:
	.db $04
	.db $FE,$9D,$03,$08
	.db $FE,$1C,    $00
	.db $FE,$1B,    $F8
	.db $FE,$1A,    $F0
;Willy dead
Sprite164Data:
	.db $04
	.db $FE,$9A,$02,$08
	.db $FE,$19,    $00
	.db $FE,$98,$03,$F8
	.db $FE,$17,    $F0
;Blinky dead
Sprite166Data:
	.db $06
	.db $F5,$90,$02,$01
	.db $F7,$95,$03,$06
	.db $F7,$14,    $FE
	.db $07,$1E,    $06
	.db $07,$1D,    $FE
	.db $07,$1C,    $F6
;Ship down laser
Sprite168Data:
	.db $01
	.db $F8,$DB,$00,$FC
Sprite16AData:
	.db $01
	.db $F8,$DC,$00,$FC
Sprite16CData:
	.db $01
	.db $F8,$DD,$00,$FC
;UNUSED
Sprite16EData:
	.db $01
	.db $F8,$DE,$00,$00
Sprite170Data:
	.db $01
	.db $F8,$DF,$00,$00
Sprite172Data:
	.db $03
	.db $08,$E2,$00,$10
	.db $08,$61,    $08
	.db $F8,$60,    $00
;Lava bubble going up
Sprite174Data:
	.db $01
	.db $F8,$D3,$01,$FC
Sprite176Data:
	.db $01
	.db $F8,$D4,$01,$FC
;Lava bubble going down
Sprite178Data:
	.db $01
	.db $F8,$D3,$81,$FC
Sprite17AData:
	.db $01
	.db $F8,$D4,$81,$FC
;UNUSED
Sprite12CData:
	.db $02
	.db $F8,$D5,$41,$00
	.db $F8,$D5,$01,$F8
;Lava bubble splash
Sprite12EData:
	.db $05
	.db $F8,$D8,$41,$00
	.db $E8,$56,    $04
	.db $E8,$57,    $FC
	.db $E8,$D6,$01,$F4
	.db $F8,$58,    $F8
Sprite130Data:
	.db $05
	.db $F8,$F3,$41,$00
	.db $E8,$59,    $04
	.db $F8,$F3,$01,$F8
	.db $E8,$5A,    $FC
	.db $E8,$59,    $F4
Sprite132Data:
	.db $05
	.db $F8,$F5,$41,$04
	.db $E8,$74,    $00
	.db $F8,$F6,$01,$FC
	.db $F8,$75,    $F4
	.db $E8,$74,    $F8
;Volcano eruption
Sprite134Data:
	.db $02
	.db $F9,$F7,$41,$00
	.db $F9,$F7,$01,$F8
Sprite136Data:
	.db $02
	.db $F9,$F8,$41,$00
	.db $F9,$F8,$01,$F8
Sprite17CData:
	.db $04
	.db $F9,$FA,$41,$00
	.db $E9,$79,    $00
	.db $F9,$FA,$01,$F8
	.db $E9,$79,    $F8
Sprite17EData:
	.db $04
	.db $F9,$FC,$41,$00
	.db $E9,$7B,    $00
	.db $F9,$FC,$01,$F8
	.db $E9,$7B,    $F8
;Rocks flying out of volcano
Sprite180Data:
	.db $01
	.db $F9,$FD,$01,$FD
Sprite182Data:
	.db $01
	.db $F9,$FD,$41,$FC
;Trooper throwing icicle
Sprite198Data:
	.db $06
	.db $E5,$D7,$01,$FF
	.db $E5,$56,    $F7
	.db $05,$C3,$00,$FF
	.db $05,$42,    $F7
	.db $F5,$41,    $FF
	.db $F5,$40,    $F7
Sprite19AData:
	.db $04
	.db $01,$C7,$00,$00
	.db $01,$46,    $F8
	.db $F1,$45,    $FE
	.db $F1,$44,    $F6
;Trooper throwing ice block right
Sprite19CData:
	.db $06
	.db $E5,$FB,$01,$FF
	.db $E5,$7A,    $F7
	.db $05,$C3,$00,$FF
	.db $05,$42,    $F7
	.db $F5,$41,    $FF
	.db $F5,$40,    $F7
;Trooper throwing ice block left
Sprite140Data:
	.db $06
	.db $E5,$FB,$41,$F7
	.db $E5,$7A,    $FF
	.db $05,$C3,$00,$FF
	.db $05,$42,    $F7
	.db $F5,$41,    $FF
	.db $F5,$40,    $F7
;Ice spike
Sprite19EData:
	.db $02
	.db $FC,$CA,$01,$01
	.db $FC,$49,    $F9
;Rolling spike
Sprite1A0Data:
	.db $02
	.db $F8,$CC,$01,$01
	.db $F8,$4B,    $F9
Sprite1A2Data:
	.db $02
	.db $F8,$CE,$01,$01
	.db $F8,$4D,    $F9
;Ice block shoot particles
Sprite1A4Data:
	.db $02
	.db $F7,$F0,$41,$F8
	.db $F7,$6F,    $00
Sprite1A6Data:
	.db $02
	.db $FA,$F2,$41,$F7
	.db $F6,$71,    $00
;Ice block spike particles
Sprite1AAData:
	.db $01
	.db $F8,$F3,$41,$FC
Sprite1ACData:
	.db $02
	.db $F1,$D4,$41,$03
	.db $F1,$D4,$01,$F6
;UNUSED
Sprite1AEData:
	.db $02
	.db $F1,$D3,$01,$F5
	.db $EE,$D3,$41,$05
;Icicle
Sprite1B0Data:
	.db $01
	.db $FA,$D5,$01,$FD
;Icicle sideways
Sprite1B2Data:
	.db $02
	.db $F4,$D7,$01,$01
	.db $F4,$56,    $F9
;Trooper melting ice
Sprite1B8Data:
	.db $0A
	.db $E4,$DB,$41,$02
	.db $D4,$5A,    $02
	.db $0C,$7C,    $00
	.db $0C,$FC,$01,$F8
	.db $E4,$5B,    $FA
	.db $D4,$5A,    $FA
	.db $04,$A9,$00,$00
	.db $04,$28,    $F8
	.db $F4,$59,    $00
	.db $F4,$58,    $F8
Sprite1BAData:
	.db $08
	.db $E4,$FD,$41,$02
	.db $0C,$7C,    $00
	.db $E4,$FD,$01,$FA
	.db $0C,$7C,    $F8
	.db $04,$A9,$00,$00
	.db $04,$28,    $F8
	.db $F4,$59,    $00
	.db $F4,$58,    $F8
Sprite1BCData:
	.db $06
	.db $0C,$FC,$41,$00
	.db $0C,$FC,$01,$F8
	.db $04,$A9,$00,$00
	.db $04,$28,    $F8
	.db $F4,$21,    $00
	.db $F4,$20,    $F8
;Level 3 boss
Sprite1C2Data:
	.db $09
	.db $F9,$C4,$01,$FD
	.db $09,$C8,$00,$05
	.db $09,$47,    $FD
	.db $09,$46,    $F5
	.db $F9,$45,    $05
	.db $F9,$43,    $F5
	.db $E9,$42,    $05
	.db $E9,$41,    $FD
	.db $E9,$40,    $F5
Sprite1C4Data:
	.db $09
	.db $F9,$C4,$01,$FD
	.db $09,$CF,$00,$05
	.db $09,$4E,    $FD
	.db $09,$4D,    $F5
	.db $F9,$4C,    $05
	.db $F9,$4B,    $F5
	.db $E9,$41,    $FD
	.db $E9,$4A,    $05
	.db $E9,$49,    $F5
Sprite1C6Data:
	.db $09
	.db $FA,$D4,$01,$FD
	.db $0A,$CF,$00,$05
	.db $0A,$4E,    $FD
	.db $0A,$4D,    $F5
	.db $FA,$55,    $05
	.db $FA,$53,    $F5
	.db $EA,$52,    $05
	.db $EA,$51,    $FD
	.db $EA,$50,    $F5
Sprite1C8Data:
	.db $09
	.db $EE,$C2,$00,$05
	.db $EE,$41,    $FD
	.db $EE,$40,    $F5
	.db $0E,$5B,    $05
	.db $0E,$5A,    $FD
	.db $0E,$59,    $F5
	.db $FE,$58,    $05
	.db $FE,$56,    $F5
	.db $FE,$D7,$01,$FD
;Level 3 boss missile
Sprite1CAData:
	.db $02
	.db $FC,$DD,$00,$01
	.db $FC,$5C,    $F9
;Level 3 boss lightning
Sprite1CCData:
	.db $08
	.db $11,$DF,$01,$E0
	.db $11,$5E,    $E8
	.db $01,$5F,    $F0
	.db $01,$5E,    $F8
	.db $F1,$5F,    $00
	.db $F1,$5E,    $08
	.db $E1,$5F,    $10
	.db $E1,$5E,    $18
;BG snake moving down
Sprite1D2Data:
	.db $08
	.db $EF,$D9,$C0,$F0
	.db $EF,$58,    $F8
	.db $EF,$57,    $00
	.db $EF,$56,    $08
	.db $FF,$55,    $F0
	.db $FF,$54,    $F8
	.db $FF,$53,    $00
	.db $FF,$52,    $08
;BG snake moving right
Sprite1D4Data:
	.db $08
	.db $EF,$D1,$C0,$F0
	.db $EF,$50,    $F8
	.db $EF,$4F,    $00
	.db $EF,$4E,    $08
	.db $FF,$4D,    $F0
	.db $FF,$4C,    $F8
	.db $FF,$4B,    $00
	.db $FF,$4A,    $08
;BG snake moving down
Sprite1E0Data:
	.db $08
	.db $EF,$D9,$C0,$F0
	.db $EF,$58,    $F8
	.db $EF,$5C,    $00
	.db $EF,$5A,    $08
	.db $FF,$55,    $F0
	.db $FF,$54,    $F8
	.db $FF,$5B,    $00
	.db $FF,$49,    $08
;BG snake moving right
Sprite184Data:
	.db $08
	.db $EF,$D1,$C0,$F0
	.db $EF,$48,    $F8
	.db $EF,$46,    $00
	.db $EF,$45,    $08
	.db $FF,$4D,    $F0
	.db $FF,$4C,    $F8
	.db $FF,$4B,    $00
	.db $FF,$4A,    $08
;BG snake water mask
Sprite142Data:
	.db $04
	.db $F8,$C7,$00,$F0
	.db $F8,$47,    $F8
	.db $F8,$47,    $00
	.db $F8,$47,    $08
;Level 2 boss right arm
Sprite1D6Data:
	.db $04
	.db $FD,$E6,$00,$F0
	.db $F6,$C7,$01,$F7
	.db $F6,$46,    $EF
	.db $F6,$54,    $FF
Sprite1D8Data:
	.db $04
	.db $FD,$E6,$00,$F0
	.db $F6,$C7,$01,$F7
	.db $F6,$48,    $EF
	.db $F6,$54,    $FF
Sprite1DAData:
	.db $03
	.db $E9,$C9,$01,$F6
	.db $F6,$56,    $FF
	.db $F6,$55,    $F7
Sprite1DCData:
	.db $02
	.db $E6,$C9,$01,$FF
	.db $F6,$57,    $FF
Sprite1DEData:
	.db $04
	.db $EF,$E6,$00,$05
	.db $EB,$C9,$01,$07
	.db $F6,$59,    $07
	.db $F6,$58,    $FF
Sprite1E2Data:
	.db $04
	.db $F6,$DC,$01,$0F
	.db $F6,$5D,    $17
	.db $F6,$5B,    $07
	.db $F6,$5A,    $FF
;Level 2 boss left arm
Sprite1E4Data:
	.db $01
	.db $F6,$D4,$41,$FA
Sprite1E6Data:
	.db $03
	.db $E7,$CA,$01,$00
	.db $F6,$D6,$41,$FA
	.db $F6,$55,    $02
Sprite1E8Data:
	.db $02
	.db $E6,$CA,$01,$FA
	.db $F6,$D7,$41,$FA
Sprite1EAData:
	.db $04
	.db $EF,$DE,$01,$E4
	.db $EF,$4C,    $EC
	.db $F6,$D9,$41,$F2
	.db $F6,$58,    $FA
Sprite1ECData:
	.db $04
	.db $F6,$CC,$01,$EA
	.db $F6,$4B,    $E2
	.db $F6,$DB,$41,$F2
	.db $F6,$5A,    $FA
;Level 2 boss laser
Sprite1EEData:
	.db $01
	.db $F8,$DF,$01,$FC
;Level 2 boss right arm
Sprite1F0Data:
	.db $04
	.db $ED,$E6,$00,$F4
	.db $E9,$C9,$01,$F6
	.db $F6,$56,    $FF
	.db $F6,$55,    $F7
Sprite1F2Data:
	.db $03
	.db $EA,$E6,$00,$FD
	.db $E6,$C9,$01,$FF
	.db $F6,$57,    $FF
;Ice block
Sprite1F4Data:
	.db $02
	.db $F8,$FB,$01,$01
	.db $F8,$7A,    $F9
;Ice water decoration
Sprite1F6Data:
	.db $02
	.db $F8,$FF,$01,$00
	.db $F8,$7E,    $F8
Sprite1F8Data:
	.db $02
	.db $F8,$F9,$01,$00
	.db $F8,$78,    $F8
Sprite1FAData:
	.db $02
	.db $F8,$F7,$01,$01
	.db $F8,$76,    $F9
;Trooper throwing ice spike
Sprite1B4Data:
	.db $06
	.db $E7,$CA,$01,$FF
	.db $E7,$49,    $F7
	.db $05,$C3,$00,$FF
	.db $05,$42,    $F7
	.db $F5,$41,    $FF
	.db $F5,$40,    $F7
Sprite1B6Data:
	.db $04
	.db $05,$C8,$00,$F6
	.db $04,$48,    $FB
	.db $F5,$45,    $FB
	.db $F5,$44,    $F3
;Trooper with jetpack
Sprite1FCData:
	.db $05
	.db $FB,$BB,$01,$F1
	.db $04,$A9,$00,$01
	.db $04,$28,    $F9
	.db $F4,$21,    $01
	.db $F4,$20,    $F9
Sprite1FEData:
	.db $05
	.db $FB,$BC,$01,$F1
	.db $04,$A9,$00,$01
	.db $04,$28,    $F9
	.db $F4,$21,    $01
	.db $F4,$20,    $F9
;Level 8 miniboss ship laser
Sprite1C0Data:
	.db $03
	.db $FC,$FD,$01,$04
	.db $FC,$7E,    $FC
	.db $FC,$FD,$41,$F4

;SPRITE DATA 200-2FF
SpriteData200PointerTable:
	.dw Sprite200Data	;$200  Rock that destroys iceberg
	.dw Sprite202Data	;$202  Dive bomber
	.dw Sprite204Data	;$204 \Asteroid
	.dw Sprite206Data	;$206 /
	.dw Sprite208Data	;$208 \Crater snake
	.dw Sprite20AData	;$20A /
	.dw Sprite20CData	;$20C  Crater snake part
	.dw Sprite20EData	;$20E  Crater gun
	.dw Sprite210Data	;$210 \Level 4 boss large beam
	.dw Sprite212Data	;$212 |
	.dw Sprite214Data	;$214 /
	.dw Sprite216Data	;$216  Flashing arrow
	.dw Sprite218Data	;$218  Level 4 boss bullet
	.dw Sprite21AData	;$21A  Nametable sprites, "Intro Part 5" Air Marshal
	.dw Sprite21CData	;$21C  Level 8 boss
	.dw Sprite21EData	;$21E  Crater gun bullet
	.dw Sprite220Data	;$220  Stage select cursor arrows
	.dw Sprite222Data	;$222  Stage select red planet
	.dw Sprite224Data	;$224  Stage select cursor arrows
	.dw Sprite226Data	;$226  Stage select moon, purple
	.dw Sprite228Data	;$228  Stage select toad ship in background
	.dw Sprite22AData	;$22A  Stage select moon, green
	.dw Sprite22CData	;$22C  Stage select moon, red
	.dw Sprite22EData	;$22E \Crater snake
	.dw Sprite230Data	;$230 /
	.dw Sprite232Data	;$232  Blue side spike
	.dw Sprite234Data	;$234  Minecart
	.dw Sprite236Data	;$236  Nametable sprites, "Intro Part 6" Bucky
	.dw Sprite238Data	;$238 \Homing boss missile
	.dw Sprite23AData	;$23A |
	.dw Sprite23CData	;$23C /
	.dw Sprite23EData	;$23E \Level 4 boss eye
	.dw Sprite240Data	;$240 /
	.dw Sprite242Data	;$242 \Level 4 boss sattelite dish
	.dw Sprite244Data	;$244 |
	.dw Sprite246Data	;$246 |
	.dw Sprite248Data	;$248 |
	.dw Sprite24AData	;$24A |
	.dw Sprite24CData	;$24C |
	.dw Sprite24EData	;$24E |
	.dw Sprite250Data	;$250 /
	.dw Sprite252Data	;$252 \UNUSED
	.dw Sprite254Data	;$254 /
	.dw Sprite256Data	;$256 \Caged pig
	.dw Sprite258Data	;$258 |
	.dw Sprite25AData	;$25A /
	.dw Sprite25CData	;$25C \Dark room light without spotlight
	.dw Sprite25EData	;$25E /
	.dw Sprite260Data	;$260  Caged pig
	.dw Sprite262Data	;$262  UNUSED
	.dw Sprite264Data	;$264 \Level 8 boss
	.dw Sprite266Data	;$266 /
	.dw Sprite268Data	;$268  Level 8 boss platform
	.dw Sprite26AData	;$26A  Spike bug
	.dw Sprite26CData	;$26C  BG fake block
	.dw Sprite26EData	;$26E  Yoku block
	.dw Sprite270Data	;$270 \Block particles
	.dw Sprite272Data	;$272 |
	.dw Sprite274Data	;$274 /
	.dw Sprite276Data	;$276  Ceiling laser
	.dw Sprite278Data	;$278 \UNUSED
	.dw Sprite27AData	;$27A /
	.dw Sprite27CData	;$27C  Level 8 boss platform
	.dw Sprite27EData	;$27E \Hypnotic beam
	.dw Sprite280Data	;$280 |
	.dw Sprite282Data	;$282 /
	.dw Sprite284Data	;$284 \Ceiling slug
	.dw Sprite286Data	;$286 /
	.dw Sprite288Data	;$288 \Ceiling slug, medium
	.dw Sprite28AData	;$28A /
	.dw Sprite28CData	;$28C \Ceiling slug, large
	.dw Sprite28EData	;$28E /
	.dw Sprite290Data	;$290  Ceiling slug jumping
	.dw Sprite292Data	;$292 \Lava worm
	.dw Sprite294Data	;$294 |
	.dw Sprite296Data	;$296 /
	.dw Sprite298Data	;$298 \Arrow platform
	.dw Sprite29AData	;$29A /
	.dw Sprite29CData	;$29C  UNUSED
	.dw Sprite29EData	;$29E  Lava mask
	.dw Sprite2A0Data	;$2A0 \Beetle moving up/down, green
	.dw Sprite2A2Data	;$2A2 /
	.dw Sprite2A4Data	;$2A4 \Beetle moving up, pink
	.dw Sprite2A6Data	;$2A6 /
	.dw Sprite2A8Data	;$2A8  Nothing
	.dw Sprite2AAData	;$2AA  Beetle moving down, pink
	.dw Sprite2ACData	;$2AC  Ceiling laser
	.dw Sprite2AEData	;$2AE  Level 6 boss frog
	.dw Sprite2B0Data	;$2B0  Level 6 boss bottom
	.dw Sprite2B2Data	;$2B2  Tanker side spikes
	.dw Sprite2B4Data	;$2B4 \BG robot from behind glass
	.dw Sprite2B6Data	;$2B6 |
	.dw Sprite2B8Data	;$2B8 |
	.dw Sprite2BAData	;$2BA |
	.dw Sprite2BCData	;$2BC /
	.dw Sprite2BEData	;$2BE \Level 7 boss bullet
	.dw Sprite2C0Data	;$2C0 |
	.dw Sprite2C2Data	;$2C2 /
	.dw Sprite2C4Data	;$2C4  Level 7 boss front shooters part 2
	.dw Sprite2C6Data	;$2C6 \Bucky on escape pod
	.dw Sprite2C8Data	;$2C8 |
	.dw Sprite2CAData	;$2CA |
	.dw Sprite2CCData	;$2CC /
	.dw Sprite2CEData	;$2CE \Dead-Eye on escape pod
	.dw Sprite2D0Data	;$2D0 |
	.dw Sprite2D2Data	;$2D2 |
	.dw Sprite2D4Data	;$2D4 /
	.dw Sprite2D6Data	;$2D6 \Blinky on escape pod
	.dw Sprite2D8Data	;$2D8 |
	.dw Sprite2DAData	;$2DA |
	.dw Sprite2DCData	;$2DC /
	.dw Sprite2DEData	;$2DE \Jenny on escape pod
	.dw Sprite2E0Data	;$2E0 |
	.dw Sprite2E2Data	;$2E2 |
	.dw Sprite2E4Data	;$2E4 /
	.dw Sprite2E6Data	;$2E6 \Willy on escape pod
	.dw Sprite2E8Data	;$2E8 |
	.dw Sprite2EAData	;$2EA |
	.dw Sprite2ECData	;$2EC /
	.dw Sprite2EEData	;$2EE \Trooper trying to grab escape pod
	.dw Sprite2F0Data	;$2F0 /
	.dw Sprite2F2Data	;$2F2 \Trooper grabbing escape pod
	.dw Sprite2F4Data	;$2F4 /
	.dw Sprite2F6Data	;$2F6 \Background monitor talking animation
	.dw Sprite2F8Data	;$2F8 |
	.dw Sprite2FAData	;$2FA |
	.dw Sprite2FCData	;$2FC /
	.dw Sprite2FEData	;$2FE  Beetle moving down, pink

;Rock that destroys iceberg
Sprite200Data:
	.db $02
	.db $F9,$EB,$01
Sprite2A8Data:	;uses the $00 byte here to indicate no graphics
	.db             $00
	.db $F9,$EA,$01,$F8
;Dive bomber
Sprite202Data:
	.db $06
	.db $F8,$C2,$40,$FA
	.db $E8,$44,    $F2
	.db $E9,$44,    $F6
	.db $F8,$43,    $F2
	.db $F8,$41,    $02
	.db $F8,$40,    $0A
;Asteroid
Sprite204Data:
	.db $06
	.db $06,$CA,$01,$04
	.db $06,$49,    $FC
	.db $06,$48,    $F4
	.db $F6,$47,    $04
	.db $F6,$46,    $FC
	.db $F6,$45,    $F4
Sprite206Data:
	.db $06
	.db $06,$D0,$01,$04
	.db $06,$4F,    $FC
	.db $06,$4E,    $F4
	.db $F6,$4D,    $04
	.db $F6,$4C,    $FC
	.db $F6,$4B,    $F4
;Crater snake
Sprite208Data:
	.db $06
	.db $04,$D4,$00,$FC
	.db $04,$53,    $F4
	.db $F4,$52,    $FC
	.db $F4,$51,    $F4
	.db $04,$D3,$40,$04
	.db $F4,$51,    $04
Sprite22EData:
	.db $06
	.db $EC,$D4,$80,$FC
	.db $EC,$53,    $F4
	.db $FC,$52,    $FC
	.db $FC,$51,    $F4
	.db $EC,$D3,$C0,$04
	.db $FC,$51,    $04
Sprite20AData:
	.db $06
	.db $04,$DC,$00,$04
	.db $04,$5B,    $FC
	.db $04,$5A,    $F4
	.db $F4,$59,    $04
	.db $F4,$58,    $FC
	.db $F4,$57,    $F4
Sprite230Data:
	.db $06
	.db $EC,$DC,$80,$04
	.db $EC,$5B,    $FC
	.db $EC,$5A,    $F4
	.db $FC,$59,    $04
	.db $FC,$58,    $FC
	.db $FC,$57,    $F4
;Crater snake part
Sprite20CData:
	.db $02
	.db $F8,$D6,$00,$00
	.db $F8,$55,    $F8
;Crater gun
Sprite20EData:
	.db $06
	.db $04,$E5,$41,$F8
	.db $04,$64,    $00
	.db $F4,$63,    $F0
	.db $F4,$62,    $F8
	.db $F4,$61,    $00
	.db $FC,$60,    $08
;Level 4 boss large beam
Sprite210Data:
	.db $02
	.db $F5,$DF,$00,$02
	.db $F5,$5E,    $FA
Sprite212Data:
	.db $02
	.db $05,$F2,$00,$FD
	.db $F5,$71,    $FD
Sprite214Data:
	.db $03
	.db $F5,$DD,$00,$FA
	.db $F5,$5D,    $02
	.db $05,$73,    $02
;Flashing arrow
Sprite216Data:
	.db $02
	.db $F9,$E8,$00,$00
	.db $F9,$67,    $F8
;Level 4 boss bullet
Sprite218Data:
	.db $01
	.db $F4,$C7,$00,$FD
;Nametable sprites, "Intro Part 5" Air Marshal
Sprite21AData:
	.db $0C
	.db $06,$FB,$01,$0A
	.db $06,$7A,    $02
	.db $06,$79,    $FA
	.db $EE,$78,    $0A
	.db $F6,$77,    $02
	.db $F6,$76,    $F2
	.db $E6,$F5,$00,$12
	.db $E6,$74,    $02
	.db $E6,$73,    $FA
	.db $E6,$72,    $F2
	.db $E6,$71,    $EA
	.db $E6,$70,    $E2
;Crater gun bullet
Sprite21EData:
	.db $01
	.db $F4,$E6,$00,$FC
;Stage select red planet
Sprite222Data:
	.db $11
	.db $08,$ED,$01,$0B
	.db $08,$63,    $03
	.db $08,$62,    $FB
	.db $08,$61,    $F3
	.db $08,$60,    $EB
	.db $F8,$7E,    $11
	.db $F8,$3D,    $09
	.db $F8,$2F,    $01
	.db $F8,$2E,    $F9
	.db $F8,$2D,    $F1
	.db $F8,$2C,    $E9
	.db $E8,$2B,    $11
	.db $E8,$2A,    $09
	.db $E8,$29,    $01
	.db $E8,$28,    $F9
	.db $E8,$27,    $F1
	.db $E8,$26,    $E9
;Stage select cursor arrows
Sprite224Data:
	.db $01
	.db $F8,$9D,$00,$FC
Sprite220Data:
	.db $01
	.db $F8,$9D,$80,$FC
;Stage select moon, purple
Sprite226Data:
	.db $01
	.db $F9,$BC,$00,$FD
;Stage select moon, green
Sprite22AData:
	.db $01
	.db $F9,$F2,$02,$FC
;Stage select moon, red
Sprite22CData:
	.db $01
	.db $F9,$FD,$02,$FD
;Stage select toad ship in background
Sprite228Data:
	.db $06
	.db $02,$9C,$03,$04
	.db $02,$1B,    $FC
	.db $02,$1A,    $F4
	.db $F2,$99,$02,$04
	.db $F2,$18,    $FC
	.db $F2,$17,    $F4
;Blue side spike
Sprite232Data:
	.db $06
	.db $F0,$FF,$01,$01
	.db $F0,$6A,    $F9
	.db $F0,$69,    $F1
	.db $00,$7F,    $01
	.db $00,$6A,    $F9
	.db $00,$69,    $F1
;Minecart
Sprite234Data:
	.db $08
	.db $06,$F2,$01,$08
	.db $06,$71,    $00
	.db $06,$70,    $F8
	.db $06,$6F,    $F0
	.db $F6,$6E,    $08
	.db $F6,$6D,    $00
	.db $F6,$6C,    $F8
	.db $F6,$6B,    $F0
;Nametable sprites, "Intro Part 6" Bucky
Sprite236Data:
	.db $0E
	.db $00,$E9,$00,$E6
	.db $00,$6C,    $16
	.db $00,$6B,    $0E
	.db $00,$6D,    $DE
	.db $08,$EA,$01,$FE
	.db $F8,$68,    $06
	.db $F8,$67,    $F6
	.db $F8,$66,    $EE
	.db $E8,$65,    $06
	.db $E8,$64,    $FE
	.db $E8,$63,    $F6
	.db $E8,$62,    $EE
	.db $D8,$61,    $F6
	.db $D8,$60,    $DE
;Homing boss missile
Sprite238Data:
	.db $01
	.db $F9,$CA,$01,$FD
Sprite23AData:
	.db $02
	.db $F9,$D4,$01,$00
	.db $F9,$53,    $F8
Sprite23CData:
	.db $02
	.db $FC,$C9,$01,$00
	.db $FC,$48,    $F8
;Level 4 boss eye
Sprite23EData:
	.db $02
	.db $F8,$F0,$00,$03
	.db $F8,$6F,    $FB
Sprite240Data:
	.db $02
	.db $F8,$DC,$00,$03
	.db $F8,$6F,    $FB
;Level 4 boss sattelite dish
Sprite242Data:
	.db $01
	.db $F9,$D5,$00,$FC
Sprite244Data:
	.db $01
	.db $F9,$D6,$00,$FC
Sprite246Data:
	.db $02
	.db $F9,$D8,$00,$01
	.db $F9,$57,    $F9
Sprite248Data:
	.db $01
	.db $F9,$D6,$40,$FC
Sprite24AData:
	.db $01
	.db $F9,$D5,$40,$FC
Sprite24CData:
	.db $01
	.db $F9,$D9,$00,$FC
Sprite24EData:
	.db $01
	.db $F9,$D9,$40,$FC
Sprite250Data:
	.db $02
	.db $F9,$DB,$00,$01
	.db $F9,$5A,    $F9
;UNUSED
Sprite252Data:
	.db $02
	.db $F8,$D5,$41,$01
	.db $F8,$D5,$01,$F9
Sprite254Data:
	.db $04
	.db $FF,$C5,$01,$00
	.db $FF,$44,    $F8
	.db $EF,$C1,$00,$00
	.db $EF,$40,    $F8
;Caged pig
Sprite256Data:
	.db $04
	.db $FF,$C7,$01,$00
	.db $FF,$46,    $F8
	.db $EF,$C1,$00,$00
	.db $EF,$40,    $F8
Sprite258Data:
	.db $04
	.db $FF,$C9,$01,$00
	.db $FF,$48,    $F8
	.db $EF,$C1,$00,$00
	.db $EF,$40,    $F8
Sprite25AData:
	.db $04
	.db $FF,$CB,$01,$00
	.db $FF,$4A,    $F8
	.db $EF,$C1,$00,$00
	.db $EF,$40,    $F8
;Level 8 boss
Sprite264Data:
	.db $05
	.db $EC,$F5,$41,$00
	.db $EC,$F5,$01,$F8
	.db $FC,$F8,$00,$04
	.db $FC,$77,    $FC
	.db $FC,$76,    $F4
Sprite266Data:
	.db $05
	.db $EC,$F5,$41,$00
	.db $EC,$F5,$01,$F8
	.db $FC,$FB,$00,$04
	.db $FC,$7A,    $FC
	.db $FC,$79,    $F4
;Level 8 boss platform
Sprite268Data:
	.db $03
	.db $F9,$FC,$41,$04
	.db $F9,$FD,$01,$FC
	.db $F9,$FC,$01,$F4
;Spike bug
Sprite26AData:
	.db $03
	.db $F8,$D7,$40,$02
	.db $F8,$D9,$41,$F7
	.db $F8,$58,    $FF
;BG fake block
Sprite26CData:
	.db $01
	.db $F5,$D6,$00,$FD
;Yoku block
Sprite26EData:
	.db $02
	.db $F8,$DE,$01,$01
	.db $F8,$5D,    $F9
;Block particles
Sprite270Data:
	.db $02
	.db $FA,$E7,$41,$00
	.db $F7,$E7,$01,$F8
Sprite272Data:
	.db $02
	.db $F9,$E8,$41,$00
	.db $F7,$E8,$01,$F8
Sprite274Data:
	.db $01
	.db $FB,$E9,$01,$FC
;Ceiling laser
Sprite276Data:
	.db $02
	.db $F0,$DF,$01,$FC
	.db $00,$DF,$41,$FC
Sprite2ACData:
	.db $02
	.db $F0,$DF,$41,$FC
	.db $00,$DF,$01,$FC
;UNUSED
Sprite278Data:
	.db $06
	.db $00,$F8,$41,$04
	.db $F0,$77,    $04
	.db $00,$F6,$01,$FC
	.db $F0,$75,    $FC
	.db $00,$74,    $F4
	.db $F0,$73,    $F4
Sprite27AData:
	.db $04
	.db $00,$FA,$01,$F4
	.db $F0,$79,    $F4
	.db $00,$FA,$41,$04
	.db $F0,$79,    $04
;Level 8 boss platform
Sprite27CData:
	.db $03
	.db $F9,$FE,$41,$04
	.db $F9,$FF,$01,$FC
	.db $F9,$7E,    $F4
;Hypnotic beam
Sprite27EData:
	.db $09
	.db $22,$EB,$01,$FC
	.db $12,$6A,    $FC
	.db $02,$6A,    $FC
	.db $F2,$6A,    $FC
	.db $E2,$6A,    $FC
	.db $D2,$6A,    $FC
	.db $C2,$6A,    $FC
	.db $B2,$6A,    $FC
	.db $A2,$6A,    $FC
Sprite280Data:
	.db $09
	.db $22,$ED,$01,$FC
	.db $12,$6C,    $FC
	.db $02,$6C,    $FC
	.db $F2,$6C,    $FC
	.db $E2,$6C,    $FC
	.db $D2,$6C,    $FC
	.db $C2,$6C,    $FC
	.db $B2,$6C,    $FC
	.db $A2,$6C,    $FC
Sprite282Data:
	.db $0E
	.db $A2,$F2,$01,$FC
	.db $B2,$72,    $FC
	.db $C2,$72,    $FC
	.db $D2,$72,    $FC
	.db $E2,$72,    $FC
	.db $F2,$72,    $FC
	.db $02,$72,    $FC
	.db $12,$72,    $FC
	.db $32,$70,    $F0
	.db $22,$6F,    $F0
	.db $22,$6E,    $F8
	.db $32,$F0,$41,$08
	.db $22,$6F,    $08
	.db $22,$6E,    $00
;Ceiling slug
Sprite284Data:
	.db $02
	.db $F8,$E1,$00,$00
	.db $F8,$60,    $F8
Sprite286Data:
	.db $02
	.db $F8,$E2,$00,$00
	.db $F8,$60,    $F8
;Ceiling slug, medium
Sprite288Data:
	.db $04
	.db $EB,$E6,$00,$01
	.db $EB,$65,    $F9
	.db $FB,$64,    $01
	.db $FB,$63,    $F9
Sprite28AData:
	.db $04
	.db $EB,$E8,$00,$01
	.db $EB,$67,    $F9
	.db $FB,$64,    $01
	.db $FB,$63,    $F9
;Ceiling slug, large
Sprite28CData:
	.db $04
	.db $F0,$EC,$00,$01
	.db $F0,$6B,    $F9
	.db $00,$6A,    $01
	.db $00,$69,    $F9
Sprite28EData:
	.db $04
	.db $F0,$EE,$00,$01
	.db $F0,$6D,    $F9
	.db $00,$6A,    $01
	.db $00,$69,    $F9
;Ceiling slug jumping
Sprite290Data:
	.db $02
	.db $F9,$F0,$00,$01
	.db $F9,$6F,    $F9
;Lava worm
Sprite292Data:
	.db $04
	.db $F2,$E3,$01,$01
	.db $F2,$62,    $F9
	.db $E2,$61,    $04
	.db $E2,$60,    $F5
Sprite294Data:
	.db $04
	.db $F2,$E8,$01,$01
	.db $F2,$66,    $F9
	.db $E2,$65,    $01
	.db $E2,$64,    $F8
Sprite296Data:
	.db $04
	.db $F2,$EC,$01,$01
	.db $F2,$6B,    $F9
	.db $E2,$6A,    $02
	.db $E2,$69,    $F9
;Arrow platform
Sprite298Data:
	.db $02
	.db $F8,$DB,$01,$00
	.db $F8,$5A,    $F8
Sprite29AData:
	.db $02
	.db $F8,$DC,$41,$00
	.db $F8,$DC,$01,$F8
;Dark room light without spotlight
Sprite25CData:
	.db $01
	.db $F8,$D8,$40,$10
Sprite25EData:
	.db $01
	.db $F8,$D8,$40,$E8
;Beetle moving up/down, green
Sprite2A0Data:
	.db $01
	.db $F8,$CA,$00,$FD
Sprite2A2Data:
	.db $01
	.db $F8,$CB,$00,$FD
;Beetle moving up, pink
Sprite2A4Data:
	.db $04
	.db $FF,$D7,$41,$01
	.db $EF,$CC,$41,$01
	.db $FF,$D7,$01,$F9
	.db $EF,$CC,$01,$F9
Sprite2A6Data:
	.db $04
	.db $FF,$DE,$41,$01
	.db $EF,$DD,$41,$01
	.db $FF,$DE,$01,$F9
	.db $EF,$DD,$01,$F9
;Beetle moving down, pink
Sprite2FEData:
	.db $04
	.db $EF,$D7,$C1,$01
	.db $EF,$D7,$81,$F9
	.db $FF,$CC,$C1,$01
	.db $FF,$CC,$81,$F9
Sprite2AAData:
	.db $04
	.db $EF,$DE,$C1,$01
	.db $FF,$DD,$C1,$01
	.db $EF,$DE,$81,$F9
	.db $FF,$DD,$81,$F9
;Caged pig
Sprite260Data:
	.db $04
	.db $F7,$CD,$01,$00
	.db $F7,$4C,    $F8
	.db $E7,$C3,$00,$00
	.db $E7,$42,    $F8
;UNUSED
Sprite262Data:
	.db $04
	.db $FF,$CF,$01,$00
	.db $FF,$4E,    $F8
	.db $EF,$C1,$00,$00
	.db $EF,$40,    $F8
Sprite29CData:
	.db $04
	.db $FF,$D1,$01,$07
	.db $FF,$50,    $FF
	.db $EF,$C1,$00,$07
	.db $EF,$40,    $FF
;Level 6 boss frog
Sprite2AEData:
	.db $03
	.db $F8,$F3,$00,$03
	.db $F8,$72,    $FB
	.db $F8,$71,    $F3
;Level 6 boss bottom
Sprite2B0Data:
	.db $02
	.db $F3,$F5,$01,$00
	.db $F3,$74,    $F8
;Lava mask
Sprite29EData:
	.db $18
	.db $F0,$80,$00,$FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $F0,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $00,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
	.db $10,$00,    $FC
;Tanker side spikes
Sprite2B2Data:
	.db $04
	.db $EF,$D1,$01,$04
	.db $EF,$50,    $FC
	.db $FE,$51,    $04
	.db $FE,$50,    $FC
;Robot from behind glass
Sprite2B4Data:
	.db $09
	.db $06,$DF,$40,$04
	.db $F6,$DE,$00,$04
	.db $06,$45,    $FC
	.db $06,$44,    $F4
	.db $F6,$43,    $FC
	.db $F6,$42,    $F4
	.db $E6,$5D,    $04
	.db $E6,$41,    $FC
	.db $E6,$40,    $F4
Sprite2B6Data:
	.db $09
	.db $06,$CE,$00,$04
	.db $06,$4D,    $FC
	.db $06,$4C,    $F4
	.db $F6,$4B,    $04
	.db $F6,$4A,    $FC
	.db $F6,$49,    $F4
	.db $E6,$48,    $04
	.db $E6,$47,    $FC
	.db $E6,$46,    $F4
Sprite2B8Data:
	.db $09
	.db $F6,$C9,$00,$F4
	.db $06,$53,    $04
	.db $06,$52,    $FC
	.db $06,$51,    $F4
	.db $F6,$50,    $04
	.db $F6,$4F,    $FC
	.db $E6,$48,    $04
	.db $E6,$47,    $FC
	.db $E6,$46,    $F4
Sprite2BAData:
	.db $08
	.db $06,$D7,$00,$04
	.db $06,$56,    $FC
	.db $F6,$55,    $04
	.db $F6,$54,    $FC
	.db $F6,$49,    $F4
	.db $E6,$48,    $04
	.db $E6,$47,    $FC
	.db $E6,$46,    $F4
Sprite2BCData:
	.db $09
	.db $06,$DC,$00,$04
	.db $06,$5B,    $FC
	.db $06,$5A,    $F4
	.db $F6,$59,    $04
	.db $F6,$58,    $FC
	.db $F6,$49,    $F4
	.db $E6,$48,    $04
	.db $E6,$47,    $FC
	.db $E6,$46,    $F4
;Bucky on escape pod
Sprite2C6Data:
	.db $07
	.db $00,$C8,$01,$04
	.db $08,$47,    $FC
	.db $08,$46,    $F4
	.db $F0,$89,$02,$00
	.db $F0,$08,    $F8
	.db $F8,$8A,$03,$F4
	.db $00,$0B,    $FC
Sprite2C8Data:
	.db $07
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$40,    $F4
	.db $EE,$81,$02,$00
	.db $EE,$00,    $F8
	.db $FE,$83,$03,$FC
	.db $F6,$02,    $F4
Sprite2CAData:
	.db $07
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$49,    $F4
	.db $EE,$81,$02,$00
	.db $EE,$00,    $F8
	.db $FE,$83,$03,$FC
	.db $F6,$02,    $F4
Sprite2CCData:
	.db $07
	.db $00,$C5,$01,$04
	.db $08,$44,    $FC
	.db $08,$43,    $F4
	.db $F0,$85,$02,$FF
	.db $F0,$04,    $F7
	.db $00,$87,$03,$FC
	.db $F8,$06,    $F4
;Dead-Eye on escape pod
Sprite2CEData:
	.db $07
	.db $00,$C8,$01,$04
	.db $08,$47,    $FC
	.db $08,$46,    $F4
	.db $F0,$99,$02,$FF
	.db $F0,$18,    $F7
	.db $00,$9B,$03,$FC
	.db $F8,$1A,    $F4
Sprite2D0Data:
	.db $07
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$40,    $F4
	.db $EE,$91,$02,$FF
	.db $EE,$10,    $F7
	.db $FE,$93,$03,$FC
	.db $F6,$12,    $F4
Sprite2D2Data:
	.db $07
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$49,    $F4
	.db $EE,$91,$02,$FF
	.db $EE,$10,    $F7
	.db $FE,$93,$03,$FC
	.db $F6,$12,    $F4
Sprite2D4Data:
	.db $07
	.db $00,$C5,$01,$04
	.db $08,$44,    $FC
	.db $08,$43,    $F4
	.db $F0,$95,$02,$FF
	.db $F0,$14,    $F7
	.db $00,$97,$03,$FC
	.db $F8,$16,    $F4
;Blinky on escape pod
Sprite2D6Data:
	.db $07
	.db $F0,$87,$02,$FC
	.db $F7,$1E,    $F4
	.db $00,$C8,$01,$04
	.db $08,$47,    $FC
	.db $08,$46,    $F4
	.db $F8,$9B,$03,$FC
	.db $F8,$1A,    $F4
Sprite2D8Data:
	.db $07
	.db $EE,$87,$02,$FC
	.db $F6,$1E,    $F4
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$40,    $F4
	.db $F6,$99,$03,$FC
	.db $F6,$18,    $F4
Sprite2DAData:
	.db $07
	.db $EE,$87,$02,$FC
	.db $F6,$1E,    $F4
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$49,    $F4
	.db $F6,$99,$03,$FC
	.db $F6,$18,    $F4
Sprite2DCData:
	.db $07
	.db $F1,$87,$02,$FC
	.db $F9,$1E,    $F4
	.db $08,$C3,$01,$F4
	.db $00,$45,    $04
	.db $08,$44,    $FC
	.db $F8,$9D,$03,$FC
	.db $F8,$1C,    $F4
;Jenny on escape pod
Sprite2DEData:
	.db $08
	.db $00,$C8,$01,$04
	.db $08,$47,    $FC
	.db $08,$46,    $F4
	.db $00,$8E,$02,$FC
	.db $F8,$0D,    $F4
	.db $F0,$8C,$03,$04
	.db $F0,$0B,    $FC
	.db $F0,$0A,    $F4
Sprite2E0Data:
	.db $08
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$40,    $F4
	.db $FE,$84,$02,$FC
	.db $F6,$03,    $F4
	.db $EE,$82,$03,$04
	.db $EE,$01,    $FC
	.db $EE,$00,    $F4
Sprite2E2Data:
	.db $08
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$49,    $F4
	.db $FE,$84,$02,$FC
	.db $F6,$03,    $F4
	.db $EE,$82,$03,$04
	.db $EE,$01,    $FC
	.db $EE,$00,    $F4
Sprite2E4Data:
	.db $08
	.db $00,$C5,$01,$04
	.db $08,$44,    $FC
	.db $08,$43,    $F4
	.db $F0,$87,$03,$04
	.db $F0,$06,    $FC
	.db $F0,$05,    $F4
	.db $00,$89,$02,$FC
	.db $F8,$08,    $F4
;Willy on escape pod
Sprite2E6Data:
	.db $08
	.db $00,$C8,$01,$04
	.db $08,$47,    $FC
	.db $08,$46,    $F4
	.db $F0,$9B,$02,$04
	.db $F0,$1A,    $FC
	.db $F0,$19,    $F4
	.db $00,$9D,$03,$FC
	.db $F8,$1C,    $F4
Sprite2E8Data:
	.db $08
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$40,    $F4
	.db $FE,$93,$03,$FC
	.db $F6,$12,    $F4
	.db $EE,$91,$02,$04
	.db $EE,$10,    $FC
	.db $EE,$0F,    $F4
Sprite2EAData:
	.db $08
	.db $FE,$C2,$01,$04
	.db $06,$41,    $FC
	.db $06,$49,    $F4
	.db $FE,$93,$03,$FC
	.db $F6,$12,    $F4
	.db $EE,$91,$02,$04
	.db $EE,$10,    $FC
	.db $EE,$0F,    $F4
Sprite2ECData:
	.db $08
	.db $00,$C5,$01,$04
	.db $08,$44,    $FC
	.db $08,$43,    $F4
	.db $F0,$96,$02,$04
	.db $F0,$15,    $FC
	.db $F0,$14,    $F4
	.db $00,$98,$03,$FC
	.db $F8,$17,    $F4
;Trooper trying to grab escape pod
Sprite2EEData:
	.db $04
	.db $00,$E8,$00,$F8
	.db $F0,$72,    $00
	.db $F0,$71,    $F8
	.db $00,$63,    $00
Sprite2F0Data:
	.db $04
	.db $00,$E8,$00,$F8
	.db $00,$63,    $00
	.db $F0,$65,    $01
	.db $F0,$64,    $F9
;Trooper grabbing escape pod
Sprite2F2Data:
	.db $04
	.db $00,$E1,$00,$05
	.db $00,$60,    $FD
	.db $F0,$67,    $0A
	.db $F0,$66,    $02
Sprite2F4Data:
	.db $04
	.db $00,$ED,$00,$06
	.db $00,$6C,    $FE
	.db $F0,$6B,    $0B
	.db $F0,$62,    $03
;Background monitor talking animation
Sprite2F6Data:
	.db $03
	.db $F8,$C2,$00,$05
	.db $F8,$41,    $FD
	.db $F8,$40,    $F5
Sprite2F8Data:
	.db $03
	.db $F8,$C5,$00,$05
	.db $F8,$44,    $FD
	.db $F8,$43,    $F5
Sprite2FAData:
	.db $03
	.db $F8,$C8,$00,$05
	.db $F8,$47,    $FD
	.db $F8,$46,    $F5
Sprite2FCData:
	.db $03
	.db $F8,$CB,$00,$05
	.db $F8,$4A,    $FD
	.db $F8,$49,    $F5
;Level 7 boss bullet
Sprite2BEData:
	.db $02
	.db $F8,$E1,$01,$00
	.db $F8,$60,    $F8
Sprite2C0Data:
	.db $02
	.db $F8,$EB,$01,$00
	.db $F8,$62,    $F8
Sprite2C2Data:
	.db $01
	.db $FC,$EC,$01,$FC
;Level 7 boss front shooters part 2
Sprite2C4Data:
	.db $02
	.db $F8,$F1,$01,$00
	.db $F8,$70,    $F8
;Level 8 boss
Sprite21CData:
	.db $08
	.db $E8,$E3,$00,$F0
	.db $E8,$62,    $E8
	.db $00,$78,    $04
	.db $00,$77,    $FC
	.db $00,$74,    $F4
	.db $F8,$71,    $EC
	.db $F0,$F5,$41,$00
	.db $F0,$F5,$01,$F8

;SPRITE DATA 300-3FF
SpriteData300PointerTable:
	.dw Sprite300Data	;$300 \Background monitor kissing animation
	.dw Sprite302Data	;$302 /
	.dw Sprite304Data	;$304 \Background monitor speech bubbles ("I HATE YOU!!")
	.dw Sprite306Data	;$306 |                                  ("HEY! YOU!!")
	.dw Sprite308Data	;$308 /                                  ("REMEMBER!")
	.dw Sprite30AData	;$30A \BG glass robot shards from breaking out
	.dw Sprite30CData	;$30C /
	.dw Sprite30EData	;$30E  Lightning
	.dw Sprite310Data	;$310 \Platform on vertical conveyor
	.dw Sprite312Data	;$312 |
	.dw Sprite314Data	;$314 /
	.dw Sprite316Data	;$316  Escape pod
	.dw Sprite318Data	;$318 \Platform on vertical conveyor
	.dw Sprite31AData	;$31A /
	.dw Sprite31CData	;$31C \Mecha-frog top
	.dw Sprite31EData	;$31E /
	.dw Sprite320Data	;$320 \Mecha-frog middle
	.dw Sprite322Data	;$322 /
	.dw Sprite324Data	;$324 \Mecha-frog bottom
	.dw Sprite326Data	;$326 |
	.dw Sprite328Data	;$328 /
	.dw Sprite32AData	;$32A \Mecha-frog
	.dw Sprite32CData	;$32C |
	.dw Sprite32EData	;$32E |
	.dw Sprite330Data	;$330 /
	.dw Sprite332Data	;$332  Nametable sprites, "Hero Ship"
	.dw Sprite334Data	;$334  Nametable sprites, "THE END"
	.dw Sprite336Data	;$336  Nametable sprites, "Dialog..." Bucky
	.dw Sprite338Data	;$338  Nametable sprites, "Dialog..." Dead-Eye
	.dw Sprite33AData	;$33A  Nametable sprites, "Dialog..." Jenny
	.dw Sprite33CData	;$33C  Nametable sprites, "Dialog..." Willy
	.dw Sprite33EData	;$33E  Nametable sprites, "Dialog..." Blinky
	.dw Sprite340Data	;$340  Nametable sprites, "Toad Ship Distant" toad ship
	.dw Sprite342Data	;$342  Nametable sprites, "Toad Ship Distant" tractor beam bubble
	.dw Sprite344Data	;$344 \Nametable sprites, "Toad Ship Distant" tractor beam
	.dw Sprite346Data	;$346 /
	.dw Sprite348Data	;$348  Nametable sprites, "Toad Ship Distant" hero ship
	.dw Sprite34AData	;$34A  Nametable sprites, "Toad Ship Chase" hero ship
	.dw Sprite34CData	;$34C \Level 7 boss top shooter
	.dw Sprite34EData	;$34E |
	.dw Sprite350Data	;$350 |
	.dw Sprite352Data	;$352 |
	.dw Sprite354Data	;$354 |
	.dw Sprite356Data	;$356 |
	.dw Sprite358Data	;$358 |
	.dw Sprite35AData	;$35A /
	.dw Sprite35CData	;$35C \Rotating room arrow
	.dw Sprite35EData	;$35E /
	.dw Sprite360Data	;$360  Lifeup item
	.dw Sprite362Data	;$362  Powerup item
	.dw Sprite364Data	;$364  1-UP
	.dw Sprite366Data	;$366 \Level 8 boss bomb
	.dw Sprite368Data	;$368 /
	.dw Sprite36AData	;$36A \Lifeup item
	.dw Sprite36CData	;$36C /
	.dw Sprite36EData	;$36E  UNUSED
	.dw Sprite370Data	;$370 \Powerup item
	.dw Sprite372Data	;$372 /
	.dw Sprite374Data	;$374  UNUSED
	.dw Sprite376Data	;$376 \1-UP
	.dw Sprite378Data	;$378 /
	.dw Sprite37AData	;$37A  UNUSED
	.dw Sprite37CData	;$37C \Bonus coin
	.dw Sprite37EData	;$37E /
	.dw Sprite380Data	;$380  UNUSED
	.dw Sprite382Data	;$382  Bonus coin
	.dw Sprite384Data	;$384  Lightning
	.dw Sprite386Data	;$386 \Escape shooter
	.dw Sprite388Data	;$388 |
	.dw Sprite38AData	;$38A /
	.dw Sprite38CData	;$38C \Escape flame, ceiling
	.dw Sprite38EData	;$38E |
	.dw Sprite390Data	;$390 |
	.dw Sprite392Data	;$392 |
	.dw Sprite394Data	;$394 |
	.dw Sprite396Data	;$396 |
	.dw Sprite398Data	;$398 |
	.dw Sprite39AData	;$39A /
	.dw Sprite39CData	;$39C \Escape flame, floor
	.dw Sprite39EData	;$39E |
	.dw Sprite3A0Data	;$3A0 |
	.dw Sprite3A2Data	;$3A2 |
	.dw Sprite3A4Data	;$3A4 |
	.dw Sprite3A6Data	;$3A6 |
	.dw Sprite3A8Data	;$3A8 |
	.dw Sprite3AAData	;$3AA /
	.dw Sprite3ACData	;$3AC  Lava platform
	.dw Sprite3AEData	;$3AE  Rotating room arrow
	.dw Sprite3B0Data	;$3B0  Rotating room shooter
	.dw Sprite3B2Data	;$3B2 \BG snake moving left
	.dw Sprite3B4Data	;$3B4 /
	.dw Sprite3B6Data	;$3B6 \BG snake moving up
	.dw Sprite3B8Data	;$3B8 /

;UNUSED
Sprite36EData:
Sprite374Data:
Sprite37AData:
Sprite380Data:
;BG snake moving left
Sprite3B2Data:
	.db $08
	.db $FF,$D1,$00,$08
	.db $FF,$50,    $00
	.db $FF,$4F,    $F8
	.db $FF,$4E,    $F0
	.db $EF,$4D,    $08
	.db $EF,$4C,    $00
	.db $EF,$4B,    $F8
	.db $EF,$4A,    $F0
;BG snake moving up
Sprite3B6Data:
	.db $08
	.db $01,$D9,$00,$08
	.db $01,$58,    $00
	.db $01,$57,    $F8
	.db $01,$56,    $F0
	.db $F1,$55,    $08
	.db $F1,$54,    $00
	.db $F1,$53,    $F8
	.db $F1,$52,    $F0
;BG snake moving left
Sprite3B4Data:
	.db $08
	.db $FF,$D1,$00,$08
	.db $FF,$48,    $00
	.db $FF,$46,    $F8
	.db $FF,$45,    $F0
	.db $EF,$4D,    $08
	.db $EF,$4C,    $00
	.db $EF,$4B,    $F8
	.db $EF,$4A,    $F0
;BG snake moving up
Sprite3B8Data:
	.db $08
	.db $01,$D9,$00,$08
	.db $01,$58,    $00
	.db $01,$5C,    $F8
	.db $01,$5A,    $F0
	.db $F1,$55,    $08
	.db $F1,$54,    $00
	.db $F1,$5B,    $F8
	.db $F1,$49,    $F0
;Background monitor kissing animation
Sprite300Data:
	.db $03
	.db $F8,$D0,$01,$05
	.db $F8,$4D,    $FD
	.db $F8,$4C,    $F5
Sprite302Data:
	.db $03
	.db $F8,$DF,$01,$05
	.db $F8,$52,    $FD
	.db $F8,$51,    $F5
;Background monitor speech bubbles
Sprite304Data:
	.db $04
	.db $F8,$D6,$00,$08
	.db $F8,$55,    $00
	.db $F8,$54,    $F8
	.db $F8,$53,    $F0
Sprite306Data:
	.db $04
	.db $F8,$DA,$00,$08
	.db $F8,$59,    $00
	.db $F8,$58,    $F8
	.db $F8,$57,    $F0
Sprite308Data:
	.db $04
	.db $F8,$DE,$00,$08
	.db $F8,$5D,    $00
	.db $F8,$5C,    $F8
	.db $F8,$5B,    $F0
;BG glass robot shards from breaking out
Sprite30AData:
	.db $0A
	.db $16,$F2,$01,$F1
	.db $1E,$74,    $E1
	.db $06,$71,    $E9
	.db $FE,$74,    $21
	.db $16,$72,    $11
	.db $06,$71,    $09
	.db $E6,$72,    $09
	.db $F6,$71,    $11
	.db $F6,$72,    $E9
	.db $E6,$71,    $F1
Sprite30CData:
	.db $08
	.db $1E,$F4,$01,$11
	.db $0E,$72,    $21
	.db $FE,$74,    $19
	.db $EE,$72,    $11
	.db $0E,$74,    $D1
	.db $26,$74,    $E1
	.db $FE,$74,    $D9
	.db $EE,$72,    $E1
;Lightning
Sprite30EData:
	.db $08
	.db $30,$F3,$01,$FD
	.db $10,$73,    $FD
	.db $F0,$73,    $FD
	.db $D0,$73,    $FD
	.db $20,$F3,$41,$FD
	.db $00,$73,    $FD
	.db $E0,$73,    $FD
	.db $C0,$73,    $FD
Sprite384Data:
	.db $08
	.db $30,$F3,$41,$FD
	.db $10,$73,    $FD
	.db $F0,$73,    $FD
	.db $D0,$73,    $FD
	.db $20,$F3,$01,$FD
	.db $00,$73,    $FD
	.db $E0,$73,    $FD
	.db $C0,$73,    $FD
;Platform on vertical conveyor
Sprite310Data:
	.db $02
	.db $FA,$F6,$01,$08
	.db $FA,$75,    $00
Sprite312Data:
	.db $02
	.db $FA,$F8,$01,$08
	.db $FA,$77,    $00
Sprite314Data:
	.db $01
	.db $FA,$F9,$01,$00
Sprite318Data:
	.db $02
	.db $EA,$F8,$81,$08
	.db $EA,$77,    $00
Sprite31AData:
	.db $01
	.db $EA,$F9,$81,$00
;Escape pod
Sprite316Data:
	.db $03
	.db $F7,$C2,$01,$03
	.db $FF,$41,    $FB
	.db $FF,$49,    $F3
;Mecha-frog top
Sprite31CData:
	.db $05
	.db $FD,$C4,$00,$05
	.db $FD,$43,    $FD
	.db $FD,$42,    $F5
	.db $ED,$C1,$01,$00
	.db $ED,$40,    $F8
Sprite31EData:
	.db $05
	.db $FD,$C7,$00,$05
	.db $FD,$46,    $FD
	.db $FD,$45,    $F5
	.db $ED,$C1,$01,$00
	.db $ED,$40,    $F8
;Mecha-frog middle
Sprite320Data:
	.db $05
	.db $ED,$C9,$01,$00
	.db $ED,$48,    $F8
	.db $FD,$CC,$00,$05
	.db $FD,$4B,    $FD
	.db $FD,$4A,    $F5
Sprite322Data:
	.db $05
	.db $ED,$C9,$01,$00
	.db $ED,$48,    $F8
	.db $FD,$CF,$00,$05
	.db $FD,$4E,    $FD
	.db $FD,$4D,    $F5
;Mecha-frog bottom
Sprite324Data:
	.db $05
	.db $EB,$D1,$01,$FE
	.db $EB,$50,    $F6
	.db $FB,$D4,$00,$05
	.db $FB,$53,    $FD
	.db $FB,$52,    $F5
Sprite326Data:
	.db $08
	.db $E5,$D1,$01,$FC
	.db $E5,$50,    $F4
	.db $05,$DA,$00,$0B
	.db $05,$59,    $03
	.db $05,$58,    $FB
	.db $F5,$57,    $03
	.db $F5,$56,    $FB
	.db $F5,$55,    $F3
Sprite328Data:
	.db $07
	.db $E7,$D1,$01,$FD
	.db $E7,$50,    $F5
	.db $07,$DF,$00,$04
	.db $07,$5E,    $FC
	.db $F7,$5D,    $04
	.db $F7,$5C,    $FC
	.db $F7,$5B,    $F4
;Mecha-frog
Sprite32AData:
	.db $08
	.db $E4,$C1,$01,$FF
	.db $E4,$40,    $F7
	.db $04,$D4,$00,$06
	.db $04,$53,    $FE
	.db $04,$52,    $F6
	.db $F4,$47,    $05
	.db $F4,$46,    $FD
	.db $F4,$45,    $F5
Sprite32CData:
	.db $0B
	.db $0D,$DA,$00,$0C
	.db $0D,$59,    $04
	.db $0D,$58,    $FC
	.db $FD,$57,    $04
	.db $FD,$56,    $FC
	.db $FD,$55,    $F4
	.db $ED,$47,    $04
	.db $ED,$46,    $FC
	.db $ED,$45,    $F4
	.db $DD,$C1,$01,$FE
	.db $DD,$40,    $F6
Sprite32EData:
	.db $0A
	.db $0F,$DF,$00,$06
	.db $0F,$5E,    $FE
	.db $FF,$5D,    $06
	.db $FF,$5C,    $FE
	.db $FF,$5B,    $F6
	.db $EF,$47,    $06
	.db $EF,$46,    $FE
	.db $EF,$45,    $F6
	.db $DF,$C1,$01,$00
	.db $DF,$40,    $F8
Sprite330Data:
	.db $0B
	.db $14,$E5,$00,$06
	.db $04,$64,    $06
	.db $14,$63,    $FE
	.db $04,$62,    $FE
	.db $14,$61,    $F6
	.db $04,$60,    $F6
	.db $F4,$47,    $05
	.db $F4,$46,    $FD
	.db $F4,$45,    $F5
	.db $E4,$C1,$01,$FF
	.db $E4,$40,    $F7
;Nametable sprites, "THE END"
Sprite334Data:
	.db $16
	.db $ED,$EC,$01,$35
	.db $ED,$6B,    $2D
	.db $F0,$64,    $1B
	.db $F9,$63,    $13
	.db $FD,$62,    $0B
	.db $ED,$61,    $0C
	.db $E5,$3E,    $E2
	.db $F5,$3D,    $DD
	.db $05,$24,    $E1
	.db $10,$23,    $D3
	.db $00,$22,    $D5
	.db $00,$21,    $CD
	.db $05,$20,    $C5
	.db $DD,$E6,$02,$35
	.db $DD,$65,    $2D
	.db $0B,$E0,$03,$FD
	.db $0B,$5F,    $F5
	.db $ED,$DE,$00,$FA
	.db $DD,$5D,    $FA
	.db $ED,$5C,    $F2
	.db $DD,$5B,    $F2
	.db $E5,$3F,    $EA
;Nametable sprites, "Dialog..." Bucky
Sprite336Data:
	.db $06
	.db $F8,$D9,$01,$04
	.db $E8,$58,    $08
	.db $01,$57,    $FC
	.db $01,$7F,    $F4
	.db $F1,$7E,    $FC
	.db $F1,$7D,    $F4
;Nametable sprites, "Dialog..." Dead-Eye
Sprite338Data:
	.db $07
	.db $03,$80,$01,$0A
	.db $F4,$5F,    $02
	.db $FC,$5E,    $FA
	.db $FC,$5D,    $F2
	.db $EC,$5C,    $FA
	.db $EC,$5B,    $F2
	.db $F4,$5A,    $EA
;Nametable sprites, "Dialog..." Jenny
Sprite33AData:
	.db $0A
	.db $10,$8A,$00,$20
	.db $00,$09,    $20
	.db $10,$08,    $18
	.db $00,$07,    $18
	.db $10,$06,    $10
	.db $00,$05,    $10
	.db $08,$04,    $08
	.db $F8,$03,    $08
	.db $18,$02,    $00
	.db $08,$01,    $00
;Nametable sprites, "Dialog..." Willy
Sprite33CData:
	.db $06
	.db $00,$90,$01,$04
	.db $00,$0F,    $FC
	.db $00,$8E,$02,$F4
	.db $F0,$0D,    $04
	.db $F0,$0C,    $FC
	.db $F0,$0B,    $F4
;Nametable sprites, "Dialog..." Blinky
Sprite33EData:
	.db $04
	.db $06,$94,$03,$FE
	.db $06,$13,    $F6
	.db $F6,$12,    $FE
	.db $F6,$11,    $F6
;Nametable sprites, "Toad Ship Distant" toad ship
Sprite340Data:
	.db $08
	.db $06,$9C,$01,$12
	.db $06,$1B,    $09
	.db $06,$1A,    $F8
	.db $06,$19,    $EA
	.db $F6,$18,    $1A
	.db $EE,$17,    $0A
	.db $EE,$16,    $F5
	.db $EE,$15,    $E2
;Nametable sprites, "Toad Ship Distant" tractor beam bubble
Sprite342Data:
	.db $08
	.db $01,$9E,$C1,$00
	.db $01,$1D,    $08
	.db $01,$9E,$81,$F8
	.db $01,$1D,    $F0
	.db $F1,$9E,$41,$00
	.db $F1,$1D,    $08
	.db $F1,$9E,$01,$F8
	.db $F1,$1D,    $F0
;Nametable sprites, "Toad Ship Distant" tractor beam
Sprite344Data:
	.db $02
	.db $01,$BC,$01,$09
	.db $01,$1F,    $01
Sprite346Data:
	.db $02
	.db $01,$BD,$01,$01
	.db $01,$3E,    $09
;Nametable sprites, "Toad Ship Distant" hero ship
Sprite348Data:
	.db $04
	.db $00,$CC,$43,$01
	.db $F0,$3F,    $01
	.db $00,$CC,$03,$F9
	.db $F0,$3F,    $F9
;Nametable sprites, "Toad Ship Chase" hero ship
Sprite34AData:
	.db $07
	.db $FB,$FF,$00,$09
	.db $FB,$7E,    $01
	.db $FB,$7D,    $F9
	.db $FB,$5E,    $F1
	.db $EB,$5D,    $01
	.db $EB,$5C,    $F9
	.db $EB,$4D,    $F1
;Level 7 boss top shooter
Sprite34CData:
	.db $02
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite34EData:
	.db $03
	.db $C8,$F2,$01,$FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite350Data:
	.db $03
	.db $C8,$E3,$01,$FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite352Data:
	.db $04
	.db $C8,$E4,$41,$00
	.db $C8,$E4,$01,$F8
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite354Data:
	.db $05
	.db $E8,$E7,$01,$FC
	.db $D8,$66,    $FC
	.db $C8,$65,    $FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite356Data:
	.db $07
	.db $08,$E7,$01,$FC
	.db $F8,$66,    $FC
	.db $E8,$66,    $FC
	.db $D8,$66,    $FC
	.db $C8,$66,    $FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite358Data:
	.db $09
	.db $28,$E7,$01,$FC
	.db $18,$66,    $FC
	.db $08,$66,    $FC
	.db $F8,$66,    $FC
	.db $E8,$66,    $FC
	.db $D8,$66,    $FC
	.db $C8,$66,    $FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
Sprite35AData:
	.db $0C
	.db $58,$E6,$01,$FC
	.db $48,$66,    $FC
	.db $38,$66,    $FC
	.db $28,$66,    $FC
	.db $18,$66,    $FC
	.db $08,$66,    $FC
	.db $F8,$66,    $FC
	.db $E8,$66,    $FC
	.db $D8,$66,    $FC
	.db $C8,$66,    $FC
	.db $B8,$F5,$00,$00
	.db $B8,$6D,    $F8
;Rotating room arrow
Sprite35CData:
	.db $03
	.db $04,$F4,$01,$FA
	.db $F4,$73,    $02
	.db $F4,$72,    $FA
Sprite3AEData:
	.db $03
	.db $EC,$F4,$C1,$FE
	.db $FC,$73,    $F6
	.db $FC,$72,    $FE
Sprite35EData:
	.db $03
	.db $FA,$F7,$01,$04
	.db $FA,$76,    $FC
	.db $FA,$75,    $F4
;Level 8 boss bomb
Sprite366Data:
	.db $02
	.db $F8,$E1,$00,$00
	.db $F8,$60,    $F8
Sprite368Data:
	.db $02
	.db $F8,$E3,$00,$00
	.db $F8,$62,    $F8
;Lifeup item
Sprite36AData:
	.db $02
	.db $F8,$B1,$00,$00
	.db $F8,$30,    $F8
Sprite36CData:
	.db $01
	.db $F8,$AA,$00,$FC
;Powerup item
Sprite370Data:
	.db $02
	.db $F8,$B3,$00,$00
	.db $F8,$32,    $F8
Sprite372Data:
	.db $01
	.db $F8,$AB,$00,$FC
;1-UP
Sprite376Data:
	.db $02
	.db $F8,$B5,$00,$00
	.db $F8,$34,    $F8
Sprite378Data:
	.db $01
	.db $F8,$B8,$00,$FC
;Bonus coin
Sprite37CData:
	.db $02
	.db $F8,$B7,$00,$00
	.db $F8,$36,    $F8
Sprite37EData:
	.db $01
	.db $F8,$B9,$00,$FC
;Lifeup item
Sprite360Data:
	.db $01
	.db $F8,$AA,$40,$FC
;Powerup item
Sprite362Data:
	.db $01
	.db $F8,$AB,$40,$FC
;1-UP
Sprite364Data:
	.db $01
	.db $F8,$B8,$40,$FC
;Bonus coin
Sprite382Data:
	.db $01
	.db $F8,$B9,$40,$FC
;Escape shooter
Sprite386Data:
	.db $02
	.db $F8,$D4,$00,$00
	.db $F8,$53,    $F8
Sprite388Data:
	.db $02
	.db $F8,$D6,$00,$00
	.db $F8,$55,    $F8
Sprite38AData:
	.db $02
	.db $F8,$D8,$00,$00
	.db $F8,$57,    $F8
;Escape flame, ceiling
Sprite38CData:
	.db $02
	.db $F8,$DA,$01,$00
	.db $F8,$59,    $F8
Sprite38EData:
	.db $02
	.db $F8,$DA,$41,$F8
	.db $F8,$59,    $00
Sprite390Data:
	.db $04
	.db $00,$DE,$01,$00
	.db $00,$5D,    $F8
	.db $F0,$5C,    $00
	.db $F0,$5B,    $F8
Sprite392Data:
	.db $06
	.db $F8,$F0,$01,$00
	.db $F8,$5F,    $F8
	.db $08,$DE,$41,$F8
	.db $08,$5D,    $00
	.db $E8,$5C,    $F8
	.db $E8,$5B,    $00
Sprite394Data:
	.db $08
	.db $00,$FC,$01,$00
	.db $00,$7B,    $F8
	.db $10,$F9,$41,$F8
	.db $10,$7A,    $00
	.db $F0,$7C,    $F8
	.db $F0,$7B,    $00
	.db $E0,$6F,    $F8
	.db $E0,$6E,    $00
Sprite396Data:
	.db $0A
	.db $F8,$FC,$41,$F8
	.db $F8,$7B,    $00
	.db $18,$F9,$01,$00
	.db $18,$7A,    $F8
	.db $08,$7C,    $00
	.db $08,$7B,    $F8
	.db $E8,$7C,    $00
	.db $E8,$7B,    $F8
	.db $D8,$6F,    $00
	.db $D8,$6E,    $F8
Sprite398Data:
	.db $0C
	.db $10,$FC,$01,$00
	.db $10,$7B,    $F8
	.db $F0,$7C,    $00
	.db $F0,$7B,    $F8
	.db $20,$F9,$41,$F8
	.db $20,$7A,    $00
	.db $00,$7C,    $F8
	.db $00,$7B,    $00
	.db $E0,$7C,    $F8
	.db $E0,$7B,    $00
	.db $D0,$6F,    $F8
	.db $D0,$6E,    $00
Sprite39AData:
	.db $0C
	.db $10,$FC,$41,$F8
	.db $10,$7B,    $00
	.db $F0,$7C,    $F8
	.db $F0,$7B,    $00
	.db $20,$F9,$01,$00
	.db $20,$7A,    $F8
	.db $00,$7C,    $00
	.db $00,$7B,    $F8
	.db $E0,$7C,    $00
	.db $E0,$7B,    $F8
	.db $D0,$6F,    $00
	.db $D0,$6E,    $F8
;Escape flame, floor
Sprite39CData:
	.db $02
	.db $F1,$DA,$C1,$F8
	.db $F1,$59,    $00
Sprite39EData:
	.db $02
	.db $F1,$DA,$81,$00
	.db $F1,$59,    $F8
Sprite3A0Data:
	.db $04
	.db $E9,$DE,$81,$00
	.db $E9,$5D,    $F8
	.db $F9,$5C,    $00
	.db $F9,$5B,    $F8
Sprite3A2Data:
	.db $06
	.db $E1,$DE,$C1,$F8
	.db $E1,$5D,    $00
	.db $01,$5C,    $F8
	.db $01,$5B,    $00
	.db $F1,$F0,$81,$00
	.db $F1,$5F,    $F8
Sprite3A4Data:
	.db $08
	.db $E9,$FC,$C1,$F8
	.db $E9,$7B,    $00
	.db $D9,$F9,$81,$00
	.db $D9,$7A,    $F8
	.db $F9,$7C,    $00
	.db $F9,$7B,    $F8
	.db $09,$6F,    $00
	.db $09,$6E,    $F8
Sprite3A6Data:
	.db $0A
	.db $D1,$F9,$C1,$F8
	.db $D1,$7A,    $00
	.db $E1,$7C,    $F8
	.db $E1,$7B,    $00
	.db $01,$7C,    $F8
	.db $01,$7B,    $00
	.db $11,$6F,    $F8
	.db $11,$6E,    $00
	.db $F1,$FC,$81,$00
	.db $F1,$7B,    $F8
Sprite3A8Data:
	.db $0C
	.db $D9,$FC,$C1,$F8
	.db $D9,$7B,    $00
	.db $F9,$7C,    $F8
	.db $F9,$7B,    $00
	.db $09,$FC,$81,$00
	.db $09,$7B,    $F8
	.db $19,$6F,    $00
	.db $19,$6E,    $F8
	.db $E9,$7C,    $00
	.db $E9,$7B,    $F8
	.db $C9,$79,    $00
	.db $C9,$7A,    $F8
Sprite3AAData:
	.db $0C
	.db $F9,$FC,$81,$00
	.db $F9,$7B,    $F8
	.db $D9,$7C,    $00
	.db $D9,$7B,    $F8
	.db $C9,$F9,$C1,$F8
	.db $C9,$7A,    $00
	.db $E9,$7C,    $F8
	.db $E9,$7B,    $00
	.db $09,$7C,    $F8
	.db $09,$7B,    $00
	.db $19,$6F,    $F8
	.db $19,$6E,    $00
;Lava platform
Sprite3ACData:
	.db $02
	.db $F8,$ED,$40,$00
	.db $F8,$ED,$00,$F8
;Rotating room shooter
Sprite3B0Data:
	.db $02
	.db $F8,$DE,$41,$00
	.db $F8,$DE,$01,$F8
;Nametable sprites, "Hero Ship"
Sprite332Data:
	.db $08
	.db $09,$B4,$01,$13
	.db $09,$33,    $0B
	.db $E9,$32,    $0D
	.db $E9,$31,    $05
	.db $09,$B0,$00,$EB
	.db $09,$2F,    $E3
	.db $F9,$2E,    $E3
	.db $F9,$2D,    $DB

;;;;;;;;;;;;;;;;
;ANIMATION DATA;
;;;;;;;;;;;;;;;;
AnimationData00PointerTable:
	.dw Anim00Data		;$00  Bucky walking
	.dw Anim02Data		;$02  Dead-Eye walking
	.dw Anim04Data		;$04  Jenny walking
	.dw Anim06Data		;$06  Willy walking
	.dw Anim08Data		;$08  Blinky walking
	.dw Anim0AData		;$0A  Trooper walking
	.dw Anim0CData		;$0C  Level 7 boss top shooter
	.dw Anim0EData		;$0E  Level 7 boss front shooters part 1
	.dw Anim10Data		;$10  Rotating room arrow
	.dw Anim12Data		;$12  Rotating room shooter
	.dw Anim14Data		;$14  Level 7 boss bullet large
	.dw Anim16Data		;$16  Trooper in trench
	.dw Anim18Data		;$18  Blinky ducking/charging
	.dw Anim1AData		;$1A  Bucky/Dead-Eye/Blinky bullet
	.dw Anim1CData		;$1C  Level 7 boss bullet small
	.dw Anim1EData		;$1E  Jenny/Willy bullet
	.dw Anim20Data		;$20  Level 7 boss front shooters part 2
	.dw Anim22Data		;$22  Crocodile walking
	.dw Anim24Data		;$24  Enemy bullet
	.dw Anim26Data		;$26  Game over cursor
	.dw Anim28Data		;$28  Stage select mask for moons
	.dw Anim2AData		;$2A  Volcano eruption
	.dw Anim2CData		;$2C \Ready sprites
	.dw Anim2EData		;$2E /
	.dw Anim30Data		;$30  Game over sprites
	.dw Anim32Data		;$32  Crocodile jumping
	.dw Anim34Data		;$34  Level 8 miniboss snake
	.dw Anim36Data		;$36  Level 8 miniboss snake part
	.dw Anim38Data		;$38  Level 8 miniboss snake bullet
	.dw Anim3AData		;$3A  Level 8 miniboss ship laser
	.dw Anim3CData		;$3C  Level 8 boss bomb
	.dw Anim3EData		;$3E  Bucky jumping
	.dw Anim40Data		;$40  Dead-Eye jumping
	.dw Anim42Data		;$42  Jenny jumping
	.dw Anim44Data		;$44  Willy jumping
	.dw Anim46Data		;$46  Blinky jumping
	.dw Anim48Data		;$48  Bucky ducking/charging
	.dw Anim4AData		;$4A  Dead-Eye ducking/charging
	.dw Anim4CData		;$4C  Jenny ducking
	.dw Anim4EData		;$4E  Willy ducking/charging
	.dw Anim50Data		;$50  Bucky looking up
	.dw Anim52Data		;$52  Bucky looking down
	.dw Anim54Data		;$54  Dead-Eye climbing up
	.dw Anim56Data		;$56  Dark room light
	.dw Anim58Data		;$58  Jenny charging
	.dw Anim5AData		;$5A \Jenny light ball
	.dw Anim5CData		;$5C |
	.dw Anim5EData		;$5E /
	.dw Anim60Data		;$60  Blinky flying
	.dw Anim62Data		;$62  Beetle in ground
	.dw Anim64Data		;$64  Ceiling slug on ceiling
	.dw Anim66Data		;$66  Ceiling slug, medium
	.dw Anim68Data		;$68  Ceiling slug, large
	.dw Anim6AData		;$6A  Ceiling slug jumping
	.dw Anim6CData		;$6C \Willy charged bullet
	.dw Anim6EData		;$6E |
	.dw Anim70Data		;$70 /
	.dw Anim72Data		;$72  Dead-Eye climbing down
	.dw Anim74Data		;$74  Bee
	.dw Anim76Data		;$76  Caterpillar going left/right
	.dw Anim78Data		;$78  Spider
	.dw Anim7AData		;$7A  Beetle moving up/down, green
	.dw Anim7CData		;$7C  Side flower
	.dw Anim7EData		;$7E  Rotating room shooter laser
	.dw Anim80Data		;$80  Fish
	.dw Anim82Data		;$82  Swinging vine
	.dw Anim84Data		;$84  Swinging vine platform
	.dw Anim86Data		;$86  Floating log platform
	.dw Anim88Data		;$88  Level 1 boss jumping
	.dw Anim8AData		;$8A  Level 1 boss throwing
	.dw Anim8CData		;$8C  Level 1 boss idle
	.dw Anim8EData		;$8E  Level 1 boss running
	.dw Anim90Data		;$90  Falling tree platform left
	.dw Anim92Data		;$92  Falling tree platform right
	.dw Anim94Data		;$94  Caterpillar going up
	.dw Anim96Data		;$96  Escape shooter
	.dw Anim98Data		;$98  Lava worm
	.dw Anim9AData		;$9A \Falling rock
	.dw Anim9CData		;$9C |
	.dw Anim9EData		;$9E |
	.dw AnimA0Data		;$A0 |
	.dw AnimA2Data		;$A2 |
	.dw AnimA4Data		;$A4 /
	.dw AnimA6Data		;$A6  Vine platform mask
	.dw AnimA8Data		;$A8  Nothing
	.dw AnimAAData		;$AA  Caterpillar going down
	.dw AnimACData		;$AC  Escape flame, ceiling
	.dw AnimAEData		;$AE  Lifeup item
	.dw AnimB0Data		;$B0  Powerup item
	.dw AnimB2Data		;$B2  1-UP
	.dw AnimB4Data		;$B4  Lava platform
	.dw AnimB6Data		;$B6  Bonus coin
	.dw AnimB8Data		;$B8  Beehive
	.dw AnimBAData		;$BA  Ship fin
	.dw AnimBCData		;$BC  UNUSED
	.dw AnimBEData		;$BE \Trooper in trench
	.dw AnimC0Data		;$C0 /
	.dw AnimC2Data		;$C2  Trooper rolling
	.dw AnimC4Data		;$C4 \Falling rock from volcano
	.dw AnimC6Data		;$C6 |
	.dw AnimC8Data		;$C8 |
	.dw AnimCAData		;$CA |
	.dw AnimCCData		;$CC /
	.dw AnimCEData		;$CE  Lava bubble splash
	.dw AnimD0Data		;$D0 \Rocks flying out of volcano
	.dw AnimD2Data		;$D2 /
	.dw AnimD4Data		;$D4  Level 2 boss inside
	.dw AnimD6Data		;$D6  Level 2 boss eyes
	.dw AnimD8Data		;$D8  Level 2 boss dot
	.dw AnimDAData		;$DA \Mecha-frog
	.dw AnimDCData		;$DC /
	.dw AnimDEData		;$DE  Level 2 boss legs
	.dw AnimE0Data		;$E0  Boulder
	.dw AnimE2Data		;$E2  Balance vine platform
	.dw AnimE4Data		;$E4  Boss explosion
	.dw AnimE6Data		;$E6  Bucky dead
	.dw AnimE8Data		;$E8  Dead-Eye dead
	.dw AnimEAData		;$EA  Jenny dead
	.dw AnimECData		;$EC  Willy dead
	.dw AnimEEData		;$EE  Blinky dead
	.dw AnimF0Data		;$F0  UNUSED
	.dw AnimF2Data		;$F2  Lava bubble going up
	.dw AnimF4Data		;$F4  Lava bubble going down
	.dw AnimF6Data		;$F6  Volcano eruption
	.dw AnimF8Data		;$F8 \Arrow platform
	.dw AnimFAData		;$FA /
	.dw AnimFCData		;$FC  Beetle moving up, pink
	.dw AnimFEData		;$FE  Ice spike

Anim00Data:
	.db $87,$00
	.db $07,$02
	.db $07,$04
	.db $07,$02
Anim02Data:
	.db $87,$06
	.db $07,$08
	.db $07,$0A
	.db $07,$08
Anim04Data:
	.db $87,$0C
	.db $07,$0E
	.db $07,$10
	.db $07,$0E
Anim06Data:
	.db $87,$12
	.db $07,$14
	.db $07,$16
	.db $07,$14
Anim08Data:
	.db $87,$18
	.db $07,$1A
	.db $07,$1C
	.db $07,$1A
Anim0AData:
	.db $87,$1E
	.db $07,$20
	.db $07,$22
	.db $07,$20
Anim16Data:
	.db $FF,$2E
Anim18Data:
	.db $FF,$30
Anim1AData:
	.db $FF,$36
Anim1EData:
	.db $FF,$3A
Anim24Data:
	.db $FF,$40
Anim2CData:
	.db $FF,$86
Anim2EData:
	.db $FF,$88
Anim30Data:
	.db $FF,$8A
Anim3EData:
	.db $FF,$42
Anim40Data:
	.db $FF,$44
Anim42Data:
	.db $FF,$46
Anim44Data:
	.db $FF,$48
Anim46Data:
	.db $FF,$4A
Anim48Data:
	.db $FF,$4C
Anim4AData:
	.db $FF,$4E
Anim4CData:
	.db $FF,$50
Anim4EData:
	.db $FF,$52
Anim50Data:
	.db $FF,$54
Anim52Data:
	.db $FF,$56
Anim54Data:
	.db $8E,$58
	.db $0E,$5A
Anim72Data:
	.db $8E,$82
	.db $0E,$84
Anim58Data:
	.db $FF,$60
Anim5AData:
	.db $8E,$62
	.db $0E,$64
Anim5CData:
	.db $8E,$66
	.db $0E,$68
Anim5EData:
	.db $8E,$6A
	.db $0E,$6C
Anim60Data:
	.db $8E,$6E
	.db $0E,$70
Anim62Data:
	.db $8E,$32
	.db $0E,$34
Anim64Data:
	.db $88,$84
	.db $08,$86
Anim66Data:
	.db $88,$88
	.db $08,$8A
Anim68Data:
	.db $88,$8C
	.db $08,$8E
Anim6AData:
	.db $FF,$90
Anim6CData:
	.db $FF,$7C
Anim6EData:
	.db $FF,$7E
Anim70Data:
	.db $FF,$80
Anim74Data:
	.db $82,$86
	.db $02,$88
Anim76Data:
	.db $94,$8A
	.db $14,$8C
Anim78Data:
	.db $8E,$8E
	.db $0E,$90
Anim7AData:
	.db $88,$A0
	.db $08,$A2
Anim7CData:
	.db $8E,$50
	.db $0E,$52
	.db $0E,$54
	.db $0E,$52
Anim80Data:
	.db $8E,$A2
	.db $0E,$A4
AnimE2Data:
	.db $FF,$FA
Anim82Data:
	.db $FF,$A6
	.db $7F,$E0
	.db $7F,$AA
	.db $7F,$AC
	.db $7F,$96
	.db $7F,$98
	.db $7F,$9A
	.db $7F,$9C
	.db $7F,$9E
	.db $7F,$A0
	.db $7F,$FC
	.db $7F,$FE
	.db $7F,$FC
	.db $7F,$A0
	.db $7F,$9E
	.db $7F,$9C
	.db $7F,$9A
	.db $7F,$98
	.db $7F,$96
	.db $7F,$AC
	.db $7F,$AA
	.db $7F,$E0
Anim84Data:
	.db $FF,$C0
Anim86Data:
	.db $FF,$C2
Anim88Data:
	.db $FF,$AE
Anim8AData:
	.db $FF,$B0
	.db $7F,$B2
Anim8CData:
	.db $FF,$B4
Anim8EData:
	.db $86,$B6
	.db $06,$B8
	.db $06,$BA
	.db $06,$B8
Anim90Data:
	.db $FF,$BC
Anim92Data:
	.db $FF,$BE
Anim94Data:
	.db $94,$C4
	.db $14,$C6
Anim98Data:
	.db $88,$92
	.db $08,$94
	.db $08,$96
Anim26Data:
	.db $FF,$CA
Anim28Data:
	.db $FF,$CC
Anim2AData:
	.db $8E,$92
	.db $0E,$94
Anim9AData:
	.db $FF,$D2
Anim9CData:
	.db $FF,$D4
Anim9EData:
	.db $FF,$D6
AnimA0Data:
	.db $FF,$D8
AnimA2Data:
	.db $FF,$DA
AnimA4Data:
	.db $FF,$DC
AnimA6Data:
	.db $FF,$DE
AnimA8Data:
	.db $FF,$A8
AnimAAData:
	.db $94,$E2
	.db $14,$E4
AnimAEData:
	.db $8C,$6A
	.db $0C,$6C
	.db $0C,$60
AnimB0Data:
	.db $8C,$70
	.db $0C,$72
	.db $0C,$62
AnimB2Data:
	.db $8C,$76
	.db $0C,$78
	.db $0C,$64
AnimB6Data:
	.db $8C,$7C
	.db $0C,$7E
	.db $0C,$82
AnimB8Data:
	.db $FF,$F2
AnimBAData:
	.db $FF,$F4
AnimBCData:
	.db $8E,$F6
	.db $0E,$F8
AnimBEData:
	.db $FF,$56
AnimC0Data:
	.db $FF,$58
AnimC2Data:
	.db $88,$BE
	.db $08,$1E
	.db $08,$20
AnimC4Data:
	.db $FF,$22
AnimC6Data:
	.db $FF,$24
AnimC8Data:
	.db $FF,$26
AnimCAData:
	.db $FF,$28
AnimCCData:
	.db $FF,$2A
AnimD4Data:
	.db $FF,$38
AnimD6Data:
	.db $8E,$3A
	.db $0E,$3C
	.db $0E,$3A
	.db $40,$3C
	.db $0E,$3A
	.db $40,$3C
AnimD8Data:
	.db $FF,$3E
AnimDAData:
	.db $90,$2A
	.db $08,$30
AnimDCData:
	.db $90,$2C
	.db $10,$2E
	.db $10,$2A
AnimDEData:
	.db $D8,$48
	.db $7F,$4A
AnimE0Data:
	.db $8C,$4C
	.db $0C,$4E
AnimE4Data:
	.db $84,$5A
	.db $04,$5C
AnimE6Data:
	.db $FF,$5E
AnimE8Data:
	.db $FF,$60
AnimEAData:
	.db $FF,$62
AnimECData:
	.db $FF,$64
AnimEEData:
	.db $FF,$66
Anim7EData:
	.db $84,$68
	.db $04,$6A
	.db $04,$68
	.db $04,$6A
	.db $04,$68
	.db $04,$6A
	.db $7F,$6C
AnimF0Data:
	.db $88,$6E
	.db $08,$70
	.db $7F,$72
AnimF2Data:
	.db $8E,$74
	.db $0E,$76
AnimF4Data:
	.db $8E,$78
	.db $0E,$7A
AnimCEData:
	.db $FE,$A8
	.db $0B,$2C
	.db $0B,$2E
	.db $0B,$30
	.db $0B,$32
AnimF6Data:
	.db $8A,$34
	.db $0A,$36
	.db $0A,$7C
	.db $0A,$7E
AnimF8Data:
	.db $FF,$98
AnimFAData:
	.db $FF,$9A
AnimD0Data:
	.db $FF,$80
AnimD2Data:
	.db $FF,$82
AnimFEData:
	.db $FF,$9E
AnimFCData:
	.db $88,$A4
	.db $08,$A6
Anim56Data:
	.db $FF,$5E
Anim0CData:
	.db $88,$4C
	.db $08,$4E
	.db $08,$50
	.db $08,$52
	.db $02,$54
	.db $02,$56
	.db $02,$58
	.db $7F,$5A
Anim10Data:
	.db $FF,$5C
Anim14Data:
	.db $83,$BE
	.db $03,$C0
Anim1CData:
	.db $FF,$C2
Anim20Data:
	.db $FF,$C4
Anim22Data:
	.db $8C,$26
	.db $0C,$38
	.db $0C,$3C
	.db $0C,$38
Anim32Data:
	.db $9C,$C8
	.db $1C,$3E
Anim3AData:
	.db $FF,$C0
Anim3CData:
	.db $A8,$66
	.db $4E,$68
Anim0EData:
	.db $FF,$E6
Anim34Data:
	.db $88,$E8
	.db $08,$EA
	.db $08,$EC
Anim36Data:
	.db $FF,$EE
Anim38Data:
	.db $FF,$F0
Anim96Data:
	.db $8C,$86
	.db $0C,$88
	.db $0C,$8A
AnimACData:
	.db $FF,$8C
AnimB4Data:
	.db $FF,$AC
Anim12Data:
	.db $FF,$B0
	.db $80

AnimationData01PointerTable:
	.dw Anim01Data		;$01  Rolling spike
	.dw Anim03Data		;$03  Ice block shoot particles
	.dw Anim05Data		;$05  Ice block spike particles
	.dw Anim07Data		;$07  Icicle
	.dw Anim09Data		;$09  Icicle sideways
	.dw Anim0BData		;$0B  Trooper throwing icicle
	.dw Anim0DData		;$0D  Trooper throwing ice spike
	.dw Anim0FData		;$0F  Trooper throwing ice blocks right
	.dw Anim11Data		;$11  Nametable sprites, "Toad ship chase" hero ship
	.dw Anim13Data		;$13  Level 3 boss idle
	.dw Anim15Data		;$15  Level 3 boss jumping
	.dw Anim17Data		;$17  Level 3 boss shooting lightning
	.dw Anim19Data		;$19  Level 3 boss shooting missile
	.dw Anim1BData		;$1B  Level 3 boss missle
	.dw Anim1DData		;$1D  Level 3 boss lightning
	.dw Anim1FData		;$1F  BG snake moving left
	.dw Anim21Data		;$21  BG snake moving up
	.dw Anim23Data		;$23  BG snake moving down
	.dw Anim25Data		;$25  BG snake moving right
	.dw Anim27Data		;$27  Level 2 boss right arm idle
	.dw Anim29Data		;$29  Level 2 boss left arm idle
	.dw Anim2BData		;$2B  Level 2 boss right arm throwing
	.dw Anim2DData		;$2D  Level 2 boss left arm shooting
	.dw Anim2FData		;$2F  Level 2 boss laser
	.dw Anim31Data		;$31  Trooper melting ice
	.dw Anim33Data		;$33  Ice block
	.dw Anim35Data		;$35 \Ice water decoration
	.dw Anim37Data		;$37 |
	.dw Anim39Data		;$39 /
	.dw Anim3BData		;$3B  Trooper throwing ice blocks left
	.dw Anim3DData		;$3D  Trooper with jetpack
	.dw Anim3FData		;$3F  Rock that destroys iceberg
	.dw Anim41Data		;$41  BG snake water mask
	.dw Anim43Data		;$43  Dive bomber
	.dw Anim45Data		;$45 \Asteroid
	.dw Anim47Data		;$47 /
	.dw Anim49Data		;$49 \Crater snake
	.dw Anim4BData		;$4B /
	.dw Anim4DData		;$4D  Crater snake part
	.dw Anim4FData		;$4F  Crater gun
	.dw Anim51Data		;$51  Level 4 boss back shooters
	.dw Anim53Data		;$53  Level 4 boss large beam
	.dw Anim55Data		;$55  Nametable sprites, "Intro part 5" Air Marshal
	.dw Anim57Data		;$57  Flashing arrow
	.dw Anim59Data		;$59  Level 4 boss bullet
	.dw Anim5BData		;$5B \Asteroid
	.dw Anim5DData		;$5D /
	.dw Anim5FData		;$5F  Crater gun bullet
	.dw Anim61Data		;$61  Stage select cursor arrows
	.dw Anim63Data		;$63  Stage select red planet
	.dw Anim65Data		;$65  Stage select cursor arrows
	.dw Anim67Data		;$67  Stage select moon, purple
	.dw Anim69Data		;$69  Stage select toad ship in background
	.dw Anim6BData		;$6B  Stage select moon, green
	.dw Anim6DData		;$6D  Stage select moon, red
	.dw Anim6FData		;$6F \Crater snake
	.dw Anim71Data		;$71 /
	.dw Anim73Data		;$73  Blue side spikes
	.dw Anim75Data		;$75  Minecart
	.dw Anim77Data		;$77  Nametable sprites, "Intro part 6" Bucky
	.dw Anim79Data		;$79  Homing boss missile
	.dw Anim7BData		;$7B  Level 4 boss eyes
	.dw Anim7DData		;$7D  Level 4 boss satellite dish
	.dw Anim7FData		;$7F  Level 4 boss large beam
	.dw Anim81Data		;$81  UNUSED
	.dw Anim83Data		;$83  UNUSED
	.dw Anim85Data		;$85  Caged pig walking
	.dw Anim87Data		;$87  Caged pig jumping
	.dw Anim89Data		;$89  UNUSED
	.dw Anim8BData		;$8B  Level 8 boss
	.dw Anim8DData		;$8D  Level 8 boss platform
	.dw Anim8FData		;$8F  Spike bug
	.dw Anim91Data		;$91  BG fake block
	.dw Anim93Data		;$93  Yoku block
	.dw Anim95Data		;$95  Spike particles
	.dw Anim97Data		;$97  Ceiling laser
	.dw Anim99Data		;$99  UNUSED
	.dw Anim9BData		;$9B  Hypnotic beam
	.dw Anim9DData		;$9D  Beetle moving down, pink
	.dw Anim9FData		;$9F  Level 6 boss frog
	.dw AnimA1Data		;$A1  Level 6 boss bottom
	.dw AnimA3Data		;$A3  Level 6 boss laser
	.dw AnimA5Data		;$A5  Lava mask
	.dw AnimA7Data		;$A7  Tanker side spikes
	.dw AnimA9Data		;$A9  BG robot from behind glass falling
	.dw AnimABData		;$AB  BG robot from behind glass landing
	.dw AnimADData		;$AD  BG robot from behind glass walking
	.dw AnimAFData		;$AF  UNUSED
	.dw AnimB1Data		;$B1  Bucky on escape pod
	.dw AnimB3Data		;$B3  Dead-Eye on escape pod
	.dw AnimB5Data		;$B5  Blinky on escape pod
	.dw AnimB7Data		;$B7  Jenny on escape pod
	.dw AnimB9Data		;$B9  Willy on escape pod
	.dw AnimBBData		;$BB  Trooper trying to grab escape pod
	.dw AnimBDData		;$BD  Background monitor talking animation
	.dw AnimBFData		;$BF  Background monitor kissing animation
	.dw AnimC1Data		;$C1 \Background monitor speech bubbles ("I HATE YOU!!")
	.dw AnimC3Data		;$C3 |                                  ("HEY! YOU!!")
	.dw AnimC5Data		;$C5 /                                  ("REMEMBER!")
	.dw AnimC7Data		;$C7  BG glass robot shards from breaking out
	.dw AnimC9Data		;$C9  Lightning
	.dw AnimCBData		;$CB  Platform on vertical conveyor
	.dw AnimCDData		;$CD  Bucky going up on escape pod
	.dw AnimCFData		;$CF  Bucky going down on escape pod
	.dw AnimD1Data		;$D1  Dead-Eye going up on escape pod
	.dw AnimD3Data		;$D3  Dead-Eye going down on escape pod
	.dw AnimD5Data		;$D5  Blinky going up on escape pod
	.dw AnimD7Data		;$D7  Blinky going down on escape pod
	.dw AnimD9Data		;$D9  Jenny going up on escape pod
	.dw AnimDBData		;$DB  Jenny going down on escape pod
	.dw AnimDDData		;$DD  Willy going up on escape pod
	.dw AnimDFData		;$DF  Willy going down on escape pod
	.dw AnimE1Data		;$E1  Escape pod
	.dw AnimE3Data		;$E3  Mecha-frog top
	.dw AnimE5Data		;$E5  Mecha-frog middle
	.dw AnimE7Data		;$E7  Mecha-frog bottom
	.dw AnimE9Data		;$E9  Mecha-frog
	.dw AnimEBData		;$EB  Trooper grabbing escape pod
	.dw AnimEDData		;$ED  Nametable sprites, "THE END"
	.dw AnimEFData		;$EF  Nametable sprites, "Dialog..." Bucky
	.dw AnimF1Data		;$F1  Nametable sprites, "Dialog..." Dead-Eye
	.dw AnimF3Data		;$F3  Nametable sprites, "Dialog..." Jenny
	.dw AnimF5Data		;$F5  Nametable sprites, "Dialog..." Willy
	.dw AnimF7Data		;$F7  Nametable sprites, "Dialog..." Blinky
	.dw AnimF9Data		;$F9  UNUSED
	.dw AnimFBData		;$FB  Nametable sprites, "Toad ship distant" tractor beam bubble
	.dw AnimFDData		;$FD  Nametable sprites, "Toad ship distant" tractor beam
	.dw AnimFFData		;$FF  Nametable sprites, "Toad ship distant" hero ship

AnimF9Data:
Anim01Data:
	.db $84,$A0
	.db $04,$A2
Anim03Data:
	.db $88,$A4
	.db $08,$A6
	.db $7F,$AA
Anim05Data:
	.db $9E,$AC
	.db $1E,$AE
Anim07Data:
	.db $FF,$B0
Anim09Data:
	.db $FF,$B2
Anim0BData:
	.db $10,$98
	.db $7F,$9A
Anim0DData:
	.db $FF,$B6
	.db $10,$B4
Anim0FData:
	.db $FF,$B6
	.db $10,$9C
Anim3BData:
	.db $FF,$B6
	.db $10,$40
Anim11Data:
	.db $FF,$4A
Anim13Data:
	.db $FF,$C2
Anim15Data:
	.db $FF,$C4
Anim17Data:
	.db $FF,$C6
Anim19Data:
	.db $FF,$C8
Anim1BData:
	.db $FF,$CA
Anim1DData:
	.db $FF,$CC
Anim1FData:
	.db $88,$B2
	.db $08,$B4
Anim21Data:
	.db $88,$B6
	.db $08,$B8
Anim23Data:
	.db $88,$D2
	.db $08,$E0
Anim25Data:
	.db $88,$D4
	.db $08,$84
Anim27Data:
	.db $D0,$D6
	.db $08,$DA
	.db $FE,$DC
Anim29Data:
	.db $D8,$E4
	.db $08,$E6
	.db $FE,$E8
Anim2BData:
	.db $88,$DA
	.db $08,$D6
	.db $08,$D8
	.db $08,$D6
	.db $08,$F0
	.db $08,$F2
	.db $08,$DE
	.db $08,$E2
	.db $04,$DE
	.db $04,$F2
	.db $04,$F0
	.db $02,$D6
	.db $08,$DA
	.db $7F,$DC
Anim2DData:
	.db $88,$E8
	.db $08,$EA
	.db $08,$EC
	.db $08,$EA
	.db $7F,$E8
Anim2FData:
	.db $FF,$EE
Anim31Data:
	.db $FF,$BC
	.db $08,$B8
	.db $08,$BA
	.db $08,$B8
	.db $08,$BA
Anim33Data:
	.db $FF,$F4
Anim35Data:
	.db $FF,$F6
Anim37Data:
	.db $FF,$F8
Anim39Data:
	.db $FF,$FA
Anim3DData:
	.db $8E,$FC
	.db $0E,$FE
Anim3FData:
	.db $FF,$00
Anim41Data:
	.db $FF,$42
Anim43Data:
	.db $FF,$02
Anim45Data:
	.db $FF,$04
Anim47Data:
	.db $FF,$06
Anim49Data:
	.db $FF,$08
Anim4BData:
	.db $FF,$0A
Anim4DData:
	.db $FF,$0C
Anim4FData:
	.db $FF,$0E
Anim53Data:
	.db $FF,$12
Anim55Data:
	.db $FF,$1A
Anim57Data:
	.db $FF,$16
Anim59Data:
	.db $FF,$18
Anim5BData:
	.db $FF,$78
Anim5DData:
	.db $FF,$7A
Anim5FData:
	.db $FF,$1E
Anim63Data:
	.db $FF,$22
Anim61Data:
	.db $FF,$20
Anim65Data:
	.db $FF,$24
Anim67Data:
	.db $FF,$26
Anim69Data:
	.db $FF,$28
Anim6BData:
	.db $FF,$2A
Anim6DData:
	.db $FF,$2C
Anim6FData:
	.db $FF,$2E
Anim71Data:
	.db $FF,$30
Anim73Data:
	.db $FF,$32
Anim75Data:
	.db $FF,$34
Anim77Data:
	.db $FF,$36
Anim79Data:
	.db $FF,$3C
	.db $7F,$3A
	.db $7F,$38
Anim7BData:
	.db $C0,$3E
	.db $08,$40
	.db $40,$3E
	.db $08,$40
	.db $10,$3E
	.db $08,$40
Anim7DData:
	.db $88,$42
	.db $08,$44
	.db $08,$46
	.db $08,$48
	.db $08,$4A
	.db $08,$4C
	.db $08,$4E
	.db $08,$50
Anim7FData:
	.db $FF,$10
	.db $7F,$14
Anim51Data:
	.db $88,$72
	.db $08,$74
	.db $08,$76
Anim81Data:
	.db $FF,$52
Anim83Data:
	.db $FF,$54
Anim85Data:
	.db $88,$56
	.db $08,$58
	.db $08,$5A
Anim87Data:
	.db $FF,$60
Anim89Data:
	.db $8E,$62
	.db $0E,$9C
Anim8BData:
	.db $88,$64
	.db $10,$66
	.db $08,$64
	.db $30,$66
Anim8DData:
	.db $86,$68
	.db $06,$7C
Anim8FData:
	.db $FF,$6A
Anim91Data:
	.db $FF,$6C
Anim93Data:
	.db $FF,$6E
Anim95Data:
	.db $88,$70
	.db $08,$72
	.db $7F,$74
Anim97Data:
	.db $84,$76
	.db $04,$AC
Anim99Data:
	.db $88,$78
	.db $08,$7A
Anim9BData:
	.db $FE,$7E
Anim9DData:
	.db $88,$FE
	.db $08,$AA
Anim9FData:
	.db $FF,$AE
AnimA1Data:
	.db $FF,$B0
AnimA3Data:
	.db $FF,$CE
AnimA5Data:
	.db $FE,$9E
AnimA7Data:
	.db $FF,$B2
AnimA9Data:
	.db $FF,$B4
AnimABData:
	.db $FF,$B6
AnimADData:
	.db $9C,$B8
	.db $0C,$BA
	.db $1C,$BC
	.db $0C,$BA
AnimAFData:
	.db $88,$4C
	.db $08,$4E
	.db $08,$50
	.db $08,$52
AnimB1Data:
	.db $88,$C8
	.db $08,$CA
AnimB3Data:
	.db $88,$D0
	.db $08,$D2
AnimB5Data:
	.db $88,$D8
	.db $08,$DA
AnimB7Data:
	.db $88,$E0
	.db $08,$E2
AnimB9Data:
	.db $88,$E8
	.db $08,$EA
AnimBBData:
	.db $88,$EE
	.db $08,$F0
AnimBDData:
	.db $88,$F6
	.db $08,$A8
	.db $08,$F6
	.db $08,$A8
	.db $08,$F6
	.db $08,$A8
	.db $08,$F8
	.db $08,$FA
	.db $08,$F8
	.db $08,$FA
	.db $08,$F8
	.db $08,$FA
	.db $08,$F8
	.db $08,$FC
AnimBFData:
	.db $A4,$00
	.db $68,$02
AnimC1Data:
	.db $FF,$04
AnimC3Data:
	.db $FF,$06
AnimC5Data:
	.db $FF,$08
AnimC7Data:
	.db $88,$0A
	.db $08,$0C
AnimC9Data:
	.db $84,$0E
	.db $04,$84
AnimCBData:
	.db $FF,$14
AnimCDData:
	.db $FF,$C6
AnimCFData:
	.db $FF,$CC
AnimD1Data:
	.db $FF,$CE
AnimD3Data:
	.db $FF,$D4
AnimD5Data:
	.db $FF,$D6
AnimD7Data:
	.db $FF,$DC
AnimD9Data:
	.db $FF,$DE
AnimDBData:
	.db $FF,$E4
AnimDDData:
	.db $FF,$E6
AnimDFData:
	.db $FF,$EC
AnimE1Data:
	.db $FF,$16
AnimE3Data:
	.db $90,$1C
	.db $0E,$1E
AnimE5Data:
	.db $90,$20
	.db $08,$22
AnimE7Data:
	.db $90,$24
	.db $10,$26
	.db $0A,$28
AnimE9Data:
	.db $8E,$2A
	.db $20,$30
AnimEBData:
	.db $85,$F2
	.db $08,$F4
AnimEDData:
	.db $FF,$34
AnimEFData:
	.db $FF,$36
AnimF1Data:
	.db $FF,$38
AnimF3Data:
	.db $FF,$3A
AnimF5Data:
	.db $FF,$3C
AnimF7Data:
	.db $FF,$3E
AnimFBData:
	.db $FF,$42
AnimFDData:
	.db $88,$46
	.db $08,$44
AnimFFData:
	.db $FF,$48
	.db $80

AnimationInfo00PointerTable:
	.dw Anim00Info		;$00  Bucky walking
	.dw Anim02Info		;$02  Dead-Eye walking
	.dw Anim04Info		;$04  Jenny walking
	.dw Anim06Info		;$06  Willy walking
	.dw Anim08Info		;$08  Blinky walking
	.dw Anim0AInfo		;$0A  Trooper walking
	.dw Anim0CInfo		;$0C  Level 7 boss top shooter
	.dw Anim0EInfo		;$0E  Level 7 boss front shooters part 1
	.dw Anim10Info		;$10  Rotating room arrow
	.dw Anim12Info		;$12  Rotating room shooter
	.dw Anim14Info		;$14  Level 7 boss bullet large
	.dw Anim16Info		;$16  Trooper in trench
	.dw Anim18Info		;$18  Blinky ducking/charging
	.dw Anim1AInfo		;$1A  Bucky/Dead-Eye/Blinky bullet
	.dw Anim1CInfo		;$1C  Level 7 boss bullet small
	.dw Anim1EInfo		;$1E  Jenny/Willy bullet
	.dw Anim20Info		;$20  Level 7 boss front shooters part 2
	.dw Anim22Info		;$22  Crocodile walking
	.dw Anim24Info		;$24  Enemy bullet
	.dw Anim26Info		;$26  Game over cursor
	.dw Anim28Info		;$28  Stage select mask for moons
	.dw Anim2AInfo		;$2A  Volcano eruption
	.dw Anim2CInfo		;$2C \Ready sprites
	.dw Anim2EInfo		;$2E /
	.dw Anim30Info		;$30  Game over sprites
	.dw Anim32Info		;$32  Crocodile jumping
	.dw Anim34Info		;$34  Level 8 miniboss snake
	.dw Anim36Info		;$36  Level 8 miniboss snake part
	.dw Anim38Info		;$38  Level 8 miniboss snake bullet
	.dw Anim3AInfo		;$3A  Level 8 miniboss ship laser
	.dw Anim3CInfo		;$3C  Level 8 boss bomb
	.dw Anim3EInfo		;$3E  Bucky jumping
	.dw Anim40Info		;$40  Dead-Eye jumping
	.dw Anim42Info		;$42  Jenny jumping
	.dw Anim44Info		;$44  Willy jumping
	.dw Anim46Info		;$46  Blinky jumping
	.dw Anim48Info		;$48  Bucky ducking/charging
	.dw Anim4AInfo		;$4A  Dead-Eye ducking/charging
	.dw Anim4CInfo		;$4C  Jenny ducking
	.dw Anim4EInfo		;$4E  Willy ducking/charging
	.dw Anim50Info		;$50  Bucky looking up
	.dw Anim52Info		;$52  Bucky looking down
	.dw Anim54Info		;$54  Dead-Eye climbing up
	.dw Anim56Info		;$56  Dark room light
	.dw Anim58Info		;$58  Jenny charging
	.dw Anim5AInfo		;$5A \Jenny light ball
	.dw Anim5CInfo		;$5C |
	.dw Anim5EInfo		;$5E /
	.dw Anim60Info		;$60  Blinky flying
	.dw Anim62Info		;$62  Beetle in ground
	.dw Anim64Info		;$64  Ceiling slug on ceiling
	.dw Anim66Info		;$66  Ceiling slug, medium
	.dw Anim68Info		;$68  Ceiling slug, large
	.dw Anim6AInfo		;$6A  Ceiling slug jumping
	.dw Anim6CInfo		;$6C \Willy charged bullet
	.dw Anim6EInfo		;$6E |
	.dw Anim70Info		;$70 /
	.dw Anim72Info		;$72  Dead-Eye climbing down
	.dw Anim74Info		;$74  Bee
	.dw Anim76Info		;$76  Caterpillar going left/right
	.dw Anim78Info		;$78  Spider
	.dw Anim7AInfo		;$7A  Beetle moving up/down, green
	.dw Anim7CInfo		;$7C  Side flower
	.dw Anim7EInfo		;$7E  Rotating room shooter laser
	.dw Anim80Info		;$80  Fish
	.dw Anim82Info		;$82  Swinging vine
	.dw Anim84Info		;$84  Swinging vine platform
	.dw Anim86Info		;$86  Floating log platform
	.dw Anim88Info		;$88  Level 1 boss jumping
	.dw Anim8AInfo		;$8A  Level 1 boss throwing
	.dw Anim8CInfo		;$8C  Level 1 boss idle
	.dw Anim8EInfo		;$8E  Level 1 boss running
	.dw Anim90Info		;$90  Falling tree platform left
	.dw Anim92Info		;$92  Falling tree platform right
	.dw Anim94Info		;$94  Caterpillar going up
	.dw Anim96Info		;$96  Escape shooter
	.dw Anim98Info		;$98  Lava worm
	.dw Anim9AInfo		;$9A \Falling rock
	.dw Anim9CInfo		;$9C |
	.dw Anim9EInfo		;$9E |
	.dw AnimA0Info		;$A0 |
	.dw AnimA2Info		;$A2 |
	.dw AnimA4Info		;$A4 /
	.dw AnimA6Info		;$A6  Vine platform mask
	.dw AnimA8Info		;$A8  Nothing
	.dw AnimAAInfo		;$AA  Caterpillar going down
	.dw AnimACInfo		;$AC  Escape flame, ceiling
	.dw AnimAEInfo		;$AE  Lifeup item
	.dw AnimB0Info		;$B0  Powerup item
	.dw AnimB2Info		;$B2  1-UP
	.dw AnimB4Info		;$B4  Lava platform
	.dw AnimB6Info		;$B6  Bonus coin
	.dw AnimB8Info		;$B8  Beehive
	.dw AnimBAInfo		;$BA  Ship fin
	.dw AnimBCInfo		;$BC  UNUSED
	.dw AnimBEInfo		;$BE \Trooper in trench
	.dw AnimC0Info		;$C0 /
	.dw AnimC2Info		;$C2  Trooper rolling
	.dw AnimC4Info		;$C4 \Falling rock from volcano
	.dw AnimC6Info		;$C6 |
	.dw AnimC8Info		;$C8 |
	.dw AnimCAInfo		;$CA |
	.dw AnimCCInfo		;$CC /
	.dw AnimCEInfo		;$CE  Lava bubble splash
	.dw AnimD0Info		;$D0 \Rocks flying out of volcano
	.dw AnimD2Info		;$D2 /
	.dw AnimD4Info		;$D4  Level 2 boss inside
	.dw AnimD6Info		;$D6  Level 2 boss eyes
	.dw AnimD8Info		;$D8  Level 2 boss dot
	.dw AnimDAInfo		;$DA \Mecha-frog
	.dw AnimDCInfo		;$DC /
	.dw AnimDEInfo		;$DE  Level 2 boss legs
	.dw AnimE0Info		;$E0  Boulder
	.dw AnimE2Info		;$E2  Balance vine platform
	.dw AnimE4Info		;$E4  Boss explosion
	.dw AnimE6Info		;$E6  Bucky dead
	.dw AnimE8Info		;$E8  Dead-Eye dead
	.dw AnimEAInfo		;$EA  Jenny dead
	.dw AnimECInfo		;$EC  Willy dead
	.dw AnimEEInfo		;$EE  Blinky dead
	.dw AnimF0Info		;$F0  UNUSED
	.dw AnimF2Info		;$F2  Lava bubble going up
	.dw AnimF4Info		;$F4  Lava bubble going down
	.dw AnimF6Info		;$F6  Volcano eruption
	.dw AnimF8Info		;$F8 \Arrow platform
	.dw AnimFAInfo		;$FA /
	.dw AnimFCInfo		;$FC  Beetle moving up, pink
	.dw AnimFEInfo		;$FE  Ice spike

Anim00Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim02Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim04Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim06Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim08Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $07,$0B
Anim0AInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0D
Anim0CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $03,$FF
Anim0EInfo:
	.db EF_ACTIVE|EF_NOANIM
	.db $07,$07
Anim10Info:
	.db EF_ACTIVE|EF_NOANIM
	.db $03,$C3
Anim12Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0A,$CD
Anim14Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $07,$87
Anim16Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0D
Anim18Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $07,$07
Anim1AInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $05,$03
Anim1CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$83
Anim1EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $07,$03
Anim20Info:
	.db EF_ACTIVE|EF_NOANIM
	.db $07,$87
Anim22Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $08,$08
Anim24Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $02,$02
Anim26Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $02,$02
Anim28Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $02,$02
Anim2AInfo:
	.db EF_ACTIVE
	.db $08,$08
Anim2CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $02,$42
Anim2EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $02,$42
Anim30Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $02,$42
Anim32Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $08,$08
Anim34Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $07,$07
Anim36Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $05,$05
Anim38Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$03
Anim3AInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $07,$43
Anim3CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $05,$C5
Anim3EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim40Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim42Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim44Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim46Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $07,$0B
Anim48Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$09
Anim4AInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$09
Anim4CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$09
Anim4EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$09
Anim50Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim52Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim54Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim56Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY
	.db $03,$83
Anim58Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim5AInfo:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $04,$04
Anim5CInfo:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $06,$06
Anim5EInfo:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$08
Anim60Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $07,$0B
Anim62Info:
	.db EF_ACTIVE
	.db $08,$08
Anim64Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$87
Anim66Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $07,$87
Anim68Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $07,$87
Anim6AInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$87
Anim6CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $08,$02
Anim6EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $0A,$03
Anim70Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $0C,$04
Anim72Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $08,$0D
Anim74Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $03,$06
Anim76Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $08,$04
Anim78Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY
	.db $08,$08
Anim7AInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $03,$86
Anim7CInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$4F
Anim7EInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $01,$4F
Anim80Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$0F
Anim82Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$0F
Anim84Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $0A,$06
Anim86Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $0A,$06
Anim88Info:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0E
Anim8AInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0E
Anim8CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0E
Anim8EInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$0E
Anim90Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $0C,$09
Anim92Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $0C,$09
Anim94Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $04,$08
Anim96Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY
	.db $07,$C7
Anim98Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $04,$8A
Anim9AInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$03
Anim9CInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$03
Anim9EInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$03
AnimA0Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$04
AnimA2Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$05
AnimA4Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $04,$05
AnimA6Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0A,$0F
AnimA8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $0A,$06
AnimAAInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $04,$08
AnimACInfo:
	.db EF_ACTIVE|EF_NOANIM
	.db $05,$C8
AnimAEInfo:
	.db EF_ACTIVE|EF_HITENEMY
	.db $07,$C7
AnimB0Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $07,$C7
AnimB2Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $07,$C7
AnimB4Info:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_PLATFORM|EF_HITBULLET|EF_VISIBLE
	.db $07,$C9
AnimB6Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $07,$C7
AnimB8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_VISIBLE
	.db $0A,$0F
AnimBAInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $0A,$0F
AnimBCInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$0F
AnimBEInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4A
AnimC0Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4A
AnimC2Info:
	.db EF_ACTIVE
	.db $07,$4B
AnimC4Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $01,$41
AnimC6Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $01,$41
AnimC8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $01,$41
AnimCAInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $02,$42
AnimCCInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $02,$42
AnimCEInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$4F
AnimD0Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $03,$43
AnimD2Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $03,$43
AnimD4Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $07,$4F
AnimD6Info:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_PLATFORM|EF_HITBULLET|EF_VISIBLE
	.db $16,$4B
AnimD8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $04,$44
AnimDAInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$CF
AnimDCInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$CF
AnimDEInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $16,$60
AnimE0Info:
	.db EF_ACTIVE|EF_PLATFORM|EF_VISIBLE
	.db $0C,$4C
AnimE2Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM
	.db $0A,$06
AnimE4Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$4F
AnimE6Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$4D
AnimE8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$4D
AnimEAInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$4D
AnimECInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $08,$4D
AnimEEInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $07,$4B
AnimF0Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $04,$44
AnimF2Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $03,$45
AnimF4Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $03,$45
AnimF6Info:
	.db EF_ACTIVE|EF_NOANIM
	.db $04,$44
AnimF8Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $09,$8A
AnimFAInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $09,$8A
AnimFCInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$8E
AnimFEInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $04,$44

AnimationInfo01PointerTable:
	.dw Anim01Info		;$01  Rolling spike
	.dw Anim03Info		;$03  Ice block shoot particles
	.dw Anim05Info		;$05  Ice block spike particles
	.dw Anim07Info		;$07  Icicle
	.dw Anim09Info		;$09  Icicle sideways
	.dw Anim0BInfo		;$0B  Trooper throwing icicle
	.dw Anim0DInfo		;$0D  Trooper throwing ice spike
	.dw Anim0FInfo		;$0F  Trooper throwing ice blocks right
	.dw Anim11Info		;$11  Nametable sprites, "Toad ship chase" hero ship
	.dw Anim13Info		;$13  Level 3 boss idle
	.dw Anim15Info		;$15  Level 3 boss jumping
	.dw Anim17Info		;$17  Level 3 boss shooting lightning
	.dw Anim19Info		;$19  Level 3 boss shooting missile
	.dw Anim1BInfo		;$1B  Level 3 boss missle
	.dw Anim1DInfo		;$1D  Level 3 boss lightning
	.dw Anim1FInfo		;$1F  BG snake moving left
	.dw Anim21Info		;$21  BG snake moving up
	.dw Anim23Info		;$23  BG snake moving down
	.dw Anim25Info		;$25  BG snake moving right
	.dw Anim27Info		;$27  Level 2 boss right arm idle
	.dw Anim29Info		;$29  Level 2 boss left arm idle
	.dw Anim2BInfo		;$2B  Level 2 boss right arm throwing
	.dw Anim2DInfo		;$2D  Level 2 boss left arm shooting
	.dw Anim2FInfo		;$2F  Level 2 boss laser
	.dw Anim31Info		;$31  Trooper melting ice
	.dw Anim33Info		;$33  Ice block
	.dw Anim35Info		;$35 \Ice water decoration
	.dw Anim37Info		;$37 |
	.dw Anim39Info		;$39 /
	.dw Anim3BInfo		;$3B  Trooper throwing ice blocks left
	.dw Anim3DInfo		;$3D  Trooper with jetpack
	.dw Anim3FInfo		;$3F  Rock that destroys iceberg
	.dw Anim41Info		;$41  BG snake water mask
	.dw Anim43Info		;$43  Dive bomber
	.dw Anim45Info		;$45 \Asteroid
	.dw Anim47Info		;$47 /
	.dw Anim49Info		;$49 \Crater snake
	.dw Anim4BInfo		;$4B /
	.dw Anim4DInfo		;$4D  Crater snake part
	.dw Anim4FInfo		;$4F  Crater gun
	.dw Anim51Info		;$51  Level 4 boss back shooters
	.dw Anim53Info		;$53  Level 4 boss large beam
	.dw Anim55Info		;$55  Nametable sprites, "Intro part 5" Air Marshal
	.dw Anim57Info		;$57  Flashing arrow
	.dw Anim59Info		;$59  Level 4 boss bullet
	.dw Anim5BInfo		;$5B \Asteroid
	.dw Anim5DInfo		;$5D /
	.dw Anim5FInfo		;$5F  Crater gun bullet
	.dw Anim61Info		;$61  Stage select cursor arrows
	.dw Anim63Info		;$63  Stage select red planet
	.dw Anim65Info		;$65  Stage select cursor arrows
	.dw Anim67Info		;$67  Stage select moon, purple
	.dw Anim69Info		;$69  Stage select toad ship in background
	.dw Anim6BInfo		;$6B  Stage select moon, green
	.dw Anim6DInfo		;$6D  Stage select moon, red
	.dw Anim6FInfo		;$6F \Crater snake
	.dw Anim71Info		;$71 /
	.dw Anim73Info		;$73  Blue side spikes
	.dw Anim75Info		;$75  Minecart
	.dw Anim77Info		;$77  Nametable sprites, "Intro part 6" Bucky
	.dw Anim79Info		;$79  Homing boss missile
	.dw Anim7BInfo		;$7B  Level 4 boss eyes
	.dw Anim7DInfo		;$7D  Level 4 boss satellite dish
	.dw Anim7FInfo		;$7F  Level 4 boss large beam
	.dw Anim81Info		;$81  UNUSED
	.dw Anim83Info		;$83  UNUSED
	.dw Anim85Info		;$85  Caged pig walking
	.dw Anim87Info		;$87  Caged pig jumping
	.dw Anim89Info		;$89  UNUSED
	.dw Anim8BInfo		;$8B  Level 8 boss
	.dw Anim8DInfo		;$8D  Level 8 boss platform
	.dw Anim8FInfo		;$8F  Spike bug
	.dw Anim91Info		;$91  BG fake block
	.dw Anim93Info		;$93  Yoku block
	.dw Anim95Info		;$95  Spike particles
	.dw Anim97Info		;$97  Ceiling laser
	.dw Anim99Info		;$99  UNUSED
	.dw Anim9BInfo		;$9B  Hypnotic beam
	.dw Anim9DInfo		;$9D  Beetle moving down, pink
	.dw Anim9FInfo		;$9F  Level 6 boss frog
	.dw AnimA1Info		;$A1  Level 6 boss bottom
	.dw AnimA3Info		;$A3  Level 6 boss laser
	.dw AnimA5Info		;$A5  Lava mask
	.dw AnimA7Info		;$A7  Tanker side spikes
	.dw AnimA9Info		;$A9  BG robot from behind glass falling
	.dw AnimABInfo		;$AB  BG robot from behind glass landing
	.dw AnimADInfo		;$AD  BG robot from behind glass walking
	.dw AnimAFInfo		;$AF  UNUSED
	.dw AnimB1Info		;$B1  Bucky on escape pod
	.dw AnimB3Info		;$B3  Dead-Eye on escape pod
	.dw AnimB5Info		;$B5  Blinky on escape pod
	.dw AnimB7Info		;$B7  Jenny on escape pod
	.dw AnimB9Info		;$B9  Willy on escape pod
	.dw AnimBBInfo		;$BB  Trooper trying to grab escape pod
	.dw AnimBDInfo		;$BD  Background monitor talking animation
	.dw AnimBFInfo		;$BF  Background monitor kissing animation
	.dw AnimC1Info		;$C1 \Background monitor speech bubbles ("I HATE YOU!!")
	.dw AnimC3Info		;$C3 |                                  ("HEY! YOU!!")
	.dw AnimC5Info		;$C5 /                                  ("REMEMBER!")
	.dw AnimC7Info		;$C7  BG glass robot shards from breaking out
	.dw AnimC9Info		;$C9  Lightning
	.dw AnimCBInfo		;$CB  Platform on vertical conveyor
	.dw AnimCDInfo		;$CD  Bucky going up on escape pod
	.dw AnimCFInfo		;$CF  Bucky going down on escape pod
	.dw AnimD1Info		;$D1  Dead-Eye going up on escape pod
	.dw AnimD3Info		;$D3  Dead-Eye going down on escape pod
	.dw AnimD5Info		;$D5  Blinky going up on escape pod
	.dw AnimD7Info		;$D7  Blinky going down on escape pod
	.dw AnimD9Info		;$D9  Jenny going up on escape pod
	.dw AnimDBInfo		;$DB  Jenny going down on escape pod
	.dw AnimDDInfo		;$DD  Willy going up on escape pod
	.dw AnimDFInfo		;$DF  Willy going down on escape pod
	.dw AnimE1Info		;$E1  Escape pod
	.dw AnimE3Info		;$E3  Mecha-frog top
	.dw AnimE5Info		;$E5  Mecha-frog middle
	.dw AnimE7Info		;$E7  Mecha-frog bottom
	.dw AnimE9Info		;$E9  Mecha-frog
	.dw AnimEBInfo		;$EB  Trooper grabbing escape pod
	.dw AnimEDInfo		;$ED  Nametable sprites, "THE END"
	.dw AnimEFInfo		;$EF  Nametable sprites, "Dialog..." Bucky
	.dw AnimF1Info		;$F1  Nametable sprites, "Dialog..." Dead-Eye
	.dw AnimF3Info		;$F3  Nametable sprites, "Dialog..." Jenny
	.dw AnimF5Info		;$F5  Nametable sprites, "Dialog..." Willy
	.dw AnimF7Info		;$F7  Nametable sprites, "Dialog..." Blinky
	.dw AnimF9Info		;$F9  UNUSED
	.dw AnimFBInfo		;$FB  Nametable sprites, "Toad ship distant" tractor beam bubble
	.dw AnimFDInfo		;$FD  Nametable sprites, "Toad ship distant" tractor beam
	.dw AnimFFInfo		;$FF  Nametable sprites, "Toad ship distant" hero ship

AnimF9Info:
Anim01Info:
	.db EF_ACTIVE
	.db $04,$44
Anim03Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$4F
Anim05Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$4F
Anim07Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$46
Anim09Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$43
Anim0BInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim0DInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim0FInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim11Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $0A,$CF
Anim13Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$57
Anim15Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$57
Anim17Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$57
Anim19Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$57
Anim1BInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$43
Anim1DInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $03,$43
Anim1FInfo:
	.db EF_ACTIVE|EF_HITENEMY
	.db $0D,$CD
Anim21Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $0D,$CD
Anim23Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $0D,$4D
Anim25Info:
	.db EF_ACTIVE|EF_HITENEMY
	.db $0D,$4D
Anim27Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim29Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim2BInfo:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim2DInfo:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim2FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $02,$42
Anim31Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim33Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $01,$41
Anim35Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim37Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim39Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $07,$47
Anim3BInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim3DInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$4B
Anim3FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim41Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$46
Anim43Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0B,$8B
Anim45Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim47Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim49Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $0B,$86
Anim4BInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $0B,$86
Anim4DInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim4FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY
	.db $0B,$8B
Anim51Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY
	.db $06,$06
Anim53Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$86
Anim55Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim57Info:
	.db EF_ACTIVE|EF_NOANIM
	.db $06,$86
Anim59Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$83
Anim5BInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $06,$06
Anim5DInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $06,$06
Anim5FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim61Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim63Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $06,$86
Anim65Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim67Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim69Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $06,$86
Anim6BInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim6DInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $06,$86
Anim6FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $0B,$8B
Anim71Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $0B,$8B
Anim73Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $06,$8C
Anim75Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $10,$8B
Anim77Info:
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db $04,$84
Anim79Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim7BInfo:
	.db EF_ACTIVE
	.db $06,$86
Anim7DInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY
	.db $08,$88
Anim7FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$86
Anim81Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$86
Anim83Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY
	.db $06,$8A
Anim85Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY
	.db $06,$8A
Anim87Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$8A
Anim89Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$8A
Anim8BInfo:
	.db EF_ACTIVE|EF_PRIORITY|EF_HITENEMY|EF_VISIBLE
	.db $0E,$86
Anim8DInfo:
	.db EF_ACTIVE|EF_PRIORITY|EF_HITENEMY|EF_VISIBLE
	.db $0E,$86
Anim8FInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim91Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $06,$86
Anim93Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $09,$88
Anim95Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$83
Anim97Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $03,$8F
Anim99Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $07,$87
Anim9BInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$BF
Anim9DInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $06,$8E
Anim9FInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_VISIBLE
	.db $0B,$87
AnimA1Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_VISIBLE
	.db $07,$87
AnimA3Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $03,$03
AnimA5Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY
	.db $03,$83
AnimA7Info:
	.db EF_ACTIVE|EF_NOANIM
	.db $07,$8F
AnimA9Info:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$95
AnimABInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$95
AnimADInfo:
	.db EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0A,$95
AnimAFInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY
	.db $0A,$8C
AnimB1Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimB3Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimB5Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimB7Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimB9Info:
	.db EF_ACTIVE|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimBBInfo:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$8F
AnimBDInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$83
AnimBFInfo:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$C3
AnimC1Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$C3
AnimC3Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$C3
AnimC5Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $03,$C3
AnimC7Info:
	.db EF_ACTIVE|EF_VISIBLE
	.db $05,$C5
AnimC9Info:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $03,$FF
AnimCBInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db $0D,$C8
AnimCDInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimCFInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimD1Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimD3Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimD5Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimD7Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimD9Info:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimDBInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimDDInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimDFInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db $0B,$8B
AnimE1Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$DF
AnimE3Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimE5Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimE7Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimE9Info:
	.db EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $0F,$D2
AnimEBInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $07,$8F
AnimEDInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimEFInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimF1Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimF3Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimF5Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimF7Info:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
;Unreferenced animation data???
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimFBInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimFDInfo:
	.db EF_ACTIVE|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7
AnimFFInfo:
	.db EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE
	.db $0F,$C7

;;;;;;;;;;;;;
;DIALOG DATA;
;;;;;;;;;;;;;
Dialog0BData:
	;(end dialog)
	.db $FF
Dialog0CData:
	;(end dialog)
	.db $FF
Dialog0DData:
	;(end dialog)
	.db $FF
Dialog0EData:
	;(end dialog)
	.db $FF
Dialog00Data:
	;    B   U   C   K   Y       O   '   H   A   R   E       A   N   D       H   I   S   \n
	.db $02,$15,$03,$0B,$19,$00,$0F,$2F,$08,$01,$12,$05,$00,$01,$0E,$04,$00,$08,$09,$13,$FC
	;    C   R   E   W       -   -       B   L   I   N   K   Y   ,       D   E   A   D   E   Y   E   ,   \n
	.db $03,$12,$05,$17,$00,$2D,$2D,$00,$02,$0C,$09,$0E,$0B,$19,$2E,$00,$04,$05,$01,$04,$05,$19,$05,$2E,$FC
	;    J   E   N   N   Y   ,       W   I   L   L   Y       F   I   G   H   T
	.db $0A,$05,$0E,$0E,$19,$2E,$00,$17,$09,$0C,$0C,$19,$00,$06,$09,$07,$08,$14,$00
	;(clear text)
	.db $FE
	;    T   O       S   A   V   E       T   H   E       A   N   I   V   E   R   S   E   \n
	.db $14,$0F,$00,$13,$01,$16,$05,$00,$14,$08,$05,$00,$01,$0E,$09,$16,$05,$12,$13,$05,$FC
	;    F   R   O   M       T   H   E       T   O   A   D       M   E   N   A   C   E   .   \n
	.db $06,$12,$0F,$0D,$00,$14,$08,$05,$00,$14,$0F,$01,$04,$00,$0D,$05,$0E,$01,$03,$05,$39,$FC
	;(clear text and go to next scene)
	.db $FD
	;    O   N   E       D   A   Y   ,       A       T   R   A   N   S   P   O   R   T   \n
	.db $0F,$0E,$05,$00,$04,$01,$19,$2E,$00,$01,$00,$14,$12,$01,$0E,$13,$10,$0F,$12,$14,$FC
	;    B   R   I   N   G   I   N   G       B   U   C   K   Y   '   S       C   R   E   W   \n
	.db $02,$12,$09,$0E,$07,$09,$0E,$07,$00,$02,$15,$03,$0B,$19,$2F,$13,$00,$03,$12,$05,$17,$FC
	;    T   O       T   H   E       R   I   G   H   T   E   O   U   S       W   A   S   \n
	.db $14,$0F,$00,$14,$08,$05,$00,$12,$09,$07,$08,$14,$05,$0F,$15,$13,$00,$17,$01,$13,$FC
	;    A   T   A   C   K   E   D   .
	.db $01,$14,$01,$03,$0B,$05,$04,$39,$00
	;(clear text)
	.db $FE
	;    T   H   E       T   O   A   D   S       K   I   D   N   A   P   E   D   \n
	.db $14,$08,$05,$00,$14,$0F,$01,$04,$13,$00,$0B,$09,$04,$0E,$01,$10,$05,$04,$FC
	;    B   U   C   K   Y   '   S       C   R   E   W   .
	.db $02,$15,$03,$0B,$19,$2F,$13,$00,$03,$12,$05,$17,$39,$00
	;(clear text and go to next scene)
	.db $FD
	;    B   L   I   N   K   Y       I   S       A       C   A   P   T   I   V   E       O   N   \n
	.db $02,$0C,$09,$0E,$0B,$19,$00,$09,$13,$00,$01,$00,$03,$01,$10,$14,$09,$16,$05,$00,$0F,$0E,$FC
	;    T   H   E       G   R   E   E   N       P   L   A   N   E   T   ,   \n
	.db $14,$08,$05,$00,$07,$12,$05,$05,$0E,$00,$10,$0C,$01,$0E,$05,$14,$2E,$FC
	;    D   E   A   D   E   Y   E       I   S       S   E   N   T       T   O       T   H   E   \n
	.db $04,$05,$01,$04,$05,$19,$05,$00,$09,$13,$00,$13,$05,$0E,$14,$00,$14,$0F,$00,$14,$08,$05,$FC
	;    R   E   D       P   L   A   N   E   T   .
	.db $12,$05,$04,$00,$10,$0C,$01,$0E,$05,$14,$39,$00
	;(clear text and go to next scene)
	.db $FD
	;    J   E   N   N   Y       I   S       H   E   L   D       A   T       T   H   E   \n
	.db $0A,$05,$0E,$0E,$19,$00,$09,$13,$00,$08,$05,$0C,$04,$00,$01,$14,$00,$14,$08,$05,$FC
	;    B   L   U   E       P   L   A   N   E   T   ,       W   I   L   L   Y       I   S   \n
	.db $02,$0C,$15,$05,$00,$10,$0C,$01,$0E,$05,$14,$2E,$00,$17,$09,$0C,$0C,$19,$00,$09,$13,$FC
	;    H   E   L   D       O   N       T   H   E       Y   E   L   L   O   W   \n
	.db $08,$05,$0C,$04,$00,$0F,$0E,$00,$14,$08,$05,$00,$19,$05,$0C,$0C,$0F,$17,$FC
	;    P   L   A   N   E   T   .
	.db $10,$0C,$01,$0E,$05,$14,$39,$00
	;(clear text and go to next scene)
	.db $FD
	;    A   I   R       M   A   R   S   H   A   L   :
	.db $01,$09,$12,$00,$0D,$01,$12,$13,$08,$01,$0C,$38,$FC
	;    "   H   A   !       H   A   !       B   U   C   K   Y       O   '   H   A   R   E   !   \n
	.db $2B,$08,$01,$25,$00,$08,$01,$25,$00,$02,$15,$03,$0B,$19,$00,$0F,$2F,$08,$01,$12,$05,$25,$FC
	;    Y   O   U   R       F   R   I   E   N   D   S       A   R   E       M   I   N   E   !   \n
	.db $19,$0F,$15,$12,$00,$06,$12,$09,$05,$0E,$04,$13,$00,$01,$12,$05,$00,$0D,$09,$0E,$05,$25,$FC
	;    Y   O   U       A   R   E       N   E   X   T   !   "
	.db $19,$0F,$15,$00,$01,$12,$05,$00,$0E,$05,$18,$14,$25,$2C,$00
	;(clear text and go to next scene)
	.db $FD
	;    B   U   C   K   Y       E   S   C   A   P   E   D       T   H   E       T   O   A   D   \n
	.db $02,$15,$03,$0B,$19,$00,$05,$13,$03,$01,$10,$05,$04,$00,$14,$08,$05,$00,$14,$0F,$01,$04,$FC
	;    A   R   M   A   D   A       B   Y       A       H   A   R   E   '   S   \n
	.db $01,$12,$0D,$01,$04,$01,$00,$02,$19,$00,$01,$00,$08,$01,$12,$05,$2F,$13,$FC
	;    W   H   I   S   K   E   R   .       N   O   W       H   E       M   U   S   T   \n
	.db $17,$08,$09,$13,$0B,$05,$12,$39,$00,$0E,$0F,$17,$00,$08,$05,$00,$0D,$15,$13,$14,$FC
	;    S   A   V   E       H   I   S       L   O   Y   A   L       C   R   E   W   .   .   .   \n
	.db $13,$01,$16,$05,$00,$08,$09,$13,$00,$0C,$0F,$19,$01,$0C,$00,$03,$12,$05,$17,$39,$39,$39,$FC
	;(clear text)
	.db $FE
	;    F   R   O   M       E   N   S   L   A   V   E   M   E   N   T       B   Y   \n
	.db $06,$12,$0F,$0D,$00,$05,$0E,$13,$0C,$01,$16,$05,$0D,$05,$0E,$14,$00,$02,$19,$FC
	;    T   H   E       T   E   R   R   I   B   L   E       T   O   A   D   S   .
	.db $14,$08,$05,$00,$14,$05,$12,$12,$09,$02,$0C,$05,$00,$14,$0F,$01,$04,$13,$39
	;(end dialog)
	.db $FF
Dialog01Data:
	;    "   T   H   A   N   K       Y   O   U   ,   C   A   P   T   A   I   N   .   \n
	.db $2B,$14,$08,$01,$0E,$0B,$00,$19,$0F,$15,$2E,$03,$01,$10,$14,$01,$09,$0E,$39,$FC
	;    I   '   V   E       R   E   S   C   U   E   D       A       T   O   A   D   \n
	.db $09,$2F,$16,$05,$00,$12,$05,$13,$03,$15,$05,$04,$00,$01,$00,$14,$0F,$01,$04,$FC
	;    W   E   A   P   O   N       T   H   A   T       W   I   L   L       S   M   A   S   H   \n
	.db $17,$05,$01,$10,$0F,$0E,$00,$14,$08,$01,$14,$00,$17,$09,$0C,$0C,$00,$13,$0D,$01,$13,$08,$FC
	;    W   A   L   L   S       O   F       I   C   E       A   N   D       S   T   O   N   E   .   "   \n
	.db $17,$01,$0C,$0C,$13,$00,$0F,$06,$00,$09,$03,$05,$00,$01,$0E,$04,$00,$13,$14,$0F,$0E,$05,$39,$2C,$FC
	;(clear text)
	.db $FE
	;    "   I   T       A   L   S   O       A   C   T   S       A   S       A   \n
	.db $2B,$09,$14,$00,$01,$0C,$13,$0F,$00,$01,$03,$14,$13,$00,$01,$13,$00,$01,$FC
	;    R   O   C   K   E   T       P   A   C   K   ,       C   A   P   T   A   I   N   \n
	.db $12,$0F,$03,$0B,$05,$14,$00,$10,$01,$03,$0B,$2E,$00,$03,$01,$10,$14,$01,$09,$0E,$FC
	;    O   '   H   A   R   E   ,       A   L   L   O   W   I   N   G       Y   O   U   \n
	.db $0F,$2F,$08,$01,$12,$05,$2E,$00,$01,$0C,$0C,$0F,$17,$09,$0E,$07,$00,$19,$0F,$15,$FC
	;    T   O       F   L   Y   .   "   \n
	.db $14,$0F,$00,$06,$0C,$19,$39,$2C,$FC
	;(end dialog)
	.db $FF
Dialog02Data:
	;    "   D   E   A   D   E   Y   E   ,       H   E   R   E   '   S       A       T   O   A   D   \n
	.db $2B,$04,$05,$01,$04,$05,$19,$05,$2E,$00,$08,$05,$12,$05,$2F,$13,$00,$01,$00,$14,$0F,$01,$04,$FC
	;    B   L   A   S   T   E   R       W   H   I   C   H       I       J   U   S   T   \n
	.db $02,$0C,$01,$13,$14,$05,$12,$00,$17,$08,$09,$03,$08,$00,$09,$00,$0A,$15,$13,$14,$FC
	;    L   I   F   T   E   D       F   R   O   M       A       T   O   A   D   \n
	.db $0C,$09,$06,$14,$05,$04,$00,$06,$12,$0F,$0D,$00,$01,$00,$14,$0F,$01,$04,$FC
	;    A   R   S   E   N   A   L   .   "
	.db $01,$12,$13,$05,$0E,$01,$0C,$39,$2C,$00
	;(clear text)
	.db $FE
	;    "   I   T       W   A   S       N   O       P   R   O   B   L   E   M   \n
	.db $2B,$09,$14,$00,$17,$01,$13,$00,$0E,$0F,$00,$10,$12,$0F,$02,$0C,$05,$0D,$FC
	;    Z   A   P   P   I   N   '       A   R   O   U   N   D       I   N       T   H   I   S   \n
	.db $1A,$01,$10,$10,$09,$0E,$2F,$00,$01,$12,$0F,$15,$0E,$04,$00,$09,$0E,$00,$14,$08,$09,$13,$FC
	;    T   O   A   D       R   O   C   K   E   T       P   A   C   K   .   "
	.db $14,$0F,$01,$04,$00,$12,$0F,$03,$0B,$05,$14,$00,$10,$01,$03,$0B,$39,$2C,$00
	;(clear text)
	.db $FE
	;    "   Z   O   O   M   E   D       R   I   G   H   T       O   V   E   R   \n
	.db $2B,$1A,$0F,$0F,$0D,$05,$04,$00,$12,$09,$07,$08,$14,$00,$0F,$16,$05,$12,$FC
	;    T   H   E       T   O   A   D       W   A   L   L   S   .   "
	.db $14,$08,$05,$00,$14,$0F,$01,$04,$00,$17,$01,$0C,$0C,$13,$39,$2C
	;(end dialog)
	.db $FF
Dialog03Data:
	;    "   A   Y   E       C   A   P   T   A   I   N   ,       W   E       C   A   N   \n
	.db $2B,$01,$19,$05,$00,$03,$01,$10,$14,$01,$09,$0E,$2E,$00,$17,$05,$00,$03,$01,$0E,$FC
	;    C   R   O   A   K       A   L   L       T   H   E       T   O   A   D   S       W   I   T   H   \n
	.db $03,$12,$0F,$01,$0B,$00,$01,$0C,$0C,$00,$14,$08,$05,$00,$14,$0F,$01,$04,$13,$00,$17,$09,$14,$08,$FC
	;    M   Y       B   E   A   M       B   L   A   S   T   E   R       A   N   D       \n
	.db $0D,$19,$00,$02,$05,$01,$0D,$00,$02,$0C,$01,$13,$14,$05,$12,$00,$01,$0E,$04,$00,$FC
	;    T   O   A   D       T   U   R   B   O       B   A   L   L   .   "
	.db $14,$0F,$01,$04,$00,$14,$15,$12,$02,$0F,$00,$02,$01,$0C,$0C,$39,$2C
	;(end dialog)
	.db $FF
Dialog04Data:
	;    "   T   H   A   N   K   S   ,       B   U   C   K   Y   .       W   H   I   L   E       I   \n
	.db $2B,$14,$08,$01,$0E,$0B,$13,$2E,$00,$02,$15,$03,$0B,$19,$39,$00,$17,$08,$09,$0C,$05,$00,$09,$FC
	;    W   A   S       H   E   L   D       C   A   P   T   I   V   E   ,       I       K   E   P   T   \n
	.db $17,$01,$13,$00,$08,$05,$0C,$04,$00,$03,$01,$10,$14,$09,$16,$05,$2E,$00,$09,$00,$0B,$05,$10,$14,$FC
	;    B   U   S   Y       P   U   T   T   I   N   G       T   O   G   E   T   H   E   R       A   \n
	.db $02,$15,$13,$19,$00,$10,$15,$14,$14,$09,$0E,$07,$00,$14,$0F,$07,$05,$14,$08,$05,$12,$00,$01,$FC
	;    N   E   W       W   E   A   P   O   N   .   "   \n
	.db $0E,$05,$17,$00,$17,$05,$01,$10,$0F,$0E,$39,$2C,$FC
	;(clear text)
	.db $FE
	;    "   I   T   '   S       M   Y       O   N   E   -   S   H   O   T   -   D   O   E   S   -   \n
	.db $2B,$09,$14,$2F,$13,$00,$0D,$19,$00,$0F,$0E,$05,$2D,$13,$08,$0F,$14,$2D,$04,$0F,$05,$13,$2D,$FC
	;    I   T   -   A   L   L       B   L   A   S   T   E   R   .       Y   O   U       C   A   N   \n
	.db $09,$14,$2D,$01,$0C,$0C,$00,$02,$0C,$01,$13,$14,$05,$12,$39,$00,$19,$0F,$15,$00,$03,$01,$0E,$FC
	;    C   A   L   L       I   T       T   H   U   M   B   E   R   .   "   \n
	.db $03,$01,$0C,$0C,$00,$09,$14,$00,$14,$08,$15,$0D,$02,$05,$12,$39,$2C,$FC
	;(clear text)
	.db $FE
	;    "   I   F       Y   O   U       P   R   E   S   S       T   H   E       F   I   R   E       \n
	.db $2B,$09,$06,$00,$19,$0F,$15,$00,$10,$12,$05,$13,$13,$00,$14,$08,$05,$00,$06,$09,$12,$05,$00,$FC
	;    B   U   T   T   O   N       L   O   N   G   E   R   ,       I   T       J   U   S   T   \n
	.db $02,$15,$14,$14,$0F,$0E,$00,$0C,$0F,$0E,$07,$05,$12,$2E,$00,$09,$14,$00,$0A,$15,$13,$14,$FC
	;    G   E   T   S       S   T   R   O   N   G   E   R   !   !   "
	.db $07,$05,$14,$13,$00,$13,$14,$12,$0F,$0E,$07,$05,$12,$25,$25,$2C
	;(end dialog)
	.db $FF
Dialog05Data:
	;    \n
	.db $FC
	;    \n
	.db $FC
	;    B   U   C   K   Y       B   R   O   U   G   H   T       H   I   S       B   R   A   V   E   \n
	.db $02,$15,$03,$0B,$19,$00,$02,$12,$0F,$15,$07,$08,$14,$00,$08,$09,$13,$00,$02,$12,$01,$16,$05,$FC
	;    C   R   E   W       T   O   G   E   T   H   E   R       A   G   A   I   N   .
	.db $03,$12,$05,$17,$00,$14,$0F,$07,$05,$14,$08,$05,$12,$00,$01,$07,$01,$09,$0E,$39
	;(clear text and go to next scene)
	.db $FD
	;    \n
	.db $FC
	;    \n
	.db $FC
	;    O   H       N   O   .   .   .       I   T   '   S       A       T   R   I   C   K   \n
	.db $0F,$08,$00,$0E,$0F,$39,$39,$39,$00,$09,$14,$2F,$13,$00,$01,$00,$14,$12,$09,$03,$0B,$FC
	;    W   H   I   C   H       T   H   E       T   O   A   D   S       S   E   T       T   O   \n
	.db $17,$08,$09,$03,$08,$00,$14,$08,$05,$00,$14,$0F,$01,$04,$13,$00,$13,$05,$14,$00,$14,$0F,$FC
	;    C   A   P   T   U   R   E       B   U   C   K   Y       O   '   H   A   R   E   .
	.db $03,$01,$10,$14,$15,$12,$05,$00,$02,$15,$03,$0B,$19,$00,$0F,$2F,$08,$01,$12,$05,$39
	;(clear text and go to next scene)
	.db $FD
	;    B   U   C   K   Y   :   \n
	.db $02,$15,$03,$0B,$19,$38,$FC
	;    "   W   A   K   E       U   P       B   L   I   N   K   Y   .   "
	.db $2B,$17,$01,$0B,$05,$00,$15,$10,$00,$02,$0C,$09,$0E,$0B,$19,$39,$2C,$00
	;(clear text)
	.db $FE
	;    B   L   I   N   K   Y   :   \n
	.db $02,$0C,$09,$0E,$0B,$19,$38,$FC
	;    "   C   A   P   T   A   I   N   ,       W   E   '   R   E       T   R   A   P   P   E   D   \n
	.db $2B,$03,$01,$10,$14,$01,$09,$0E,$2E,$00,$17,$05,$2F,$12,$05,$00,$14,$12,$01,$10,$10,$05,$04,$FC
	;    I   N       A       T   O   A   D       M   O   T   H   E   R       S   H   I   P   !   "   \n
	.db $09,$0E,$00,$01,$00,$14,$0F,$01,$04,$00,$0D,$0F,$14,$08,$05,$12,$00,$13,$08,$09,$10,$25,$2C,$FC
	;(clear text)
	.db $FE
	;    B   U   C   K   Y   :   \n
	.db $02,$15,$03,$0B,$19,$38,$FC
	;    "   T   H   E   Y   '   V   E       T   A   K   E   N       M   Y       C   R   E   W   \n
	.db $2B,$14,$08,$05,$19,$2F,$16,$05,$00,$14,$01,$0B,$05,$0E,$00,$0D,$19,$00,$03,$12,$05,$17,$FC
	;    F   O   R       S   P   O   R   T   !   "   \n
	.db $06,$0F,$12,$00,$13,$10,$0F,$12,$14,$25,$2C,$FC
	;(clear text)
	.db $FE
	;    B   L   I   N   K   Y   :   \n
	.db $02,$0C,$09,$0E,$0B,$19,$38,$FC
	;    "   C   A   P   T   A   I   N   ,       W   E       M   U   S   T       S   A   V   E   \n
	.db $2B,$03,$01,$10,$14,$01,$09,$0E,$2E,$00,$17,$05,$00,$0D,$15,$13,$14,$00,$13,$01,$16,$05,$FC
	;    T   H   E       C   R   E   W       B   E   F   O   R   E   .   .   .   "
	.db $14,$08,$05,$00,$03,$12,$05,$17,$00,$02,$05,$06,$0F,$12,$05,$39,$39,$39,$2C,$00
	;(clear text and go to next scene)
	.db $FD
	;(end dialog)
	.db $FF
Dialog06Data:
	;    J   E   N   N   Y   :   \n
	.db $0A,$05,$0E,$0E,$19,$38,$FC
	;    "   C   A   P   T   A   I   N   !   !   \n
	.db $2B,$03,$01,$10,$14,$01,$09,$0E,$25,$25,$FC
	;    W   H   A   T       S   H   A   L   L       W   E       D   O       ?   "   \n
	.db $17,$08,$01,$14,$00,$13,$08,$01,$0C,$0C,$00,$17,$05,$00,$04,$0F,$00,$26,$2C,$FC
	;(clear text)
	.db $FE
	;    B   U   C   K   Y   :   \n
	.db $02,$15,$03,$0B,$19,$38,$FC
	;    "   W   E       H   A   V   E       T   O       \n
	.db $2B,$17,$05,$00,$08,$01,$16,$05,$00,$14,$0F,$00,$FC
	;    E   S   C   A   P   E   ,       J   E   N   N   Y   .   .   \n
	.db $05,$13,$03,$01,$10,$05,$2E,$00,$0A,$05,$0E,$0E,$19,$39,$39,$FC
	;    N   O   W   !   "
	.db $0E,$0F,$17,$25,$2C
	;(clear text)
	.db $FE
	;    W   I   L   L   Y   :   \n
	.db $17,$09,$0C,$0C,$19,$38,$FC
	;    "   W   E   L   L   .   .   .       W   H   E   R   E       A   R   E   \n
	.db $2B,$17,$05,$0C,$0C,$39,$39,$39,$00,$17,$08,$05,$12,$05,$00,$01,$12,$05,$FC
	;    W   E       N   O   W       ?   "
	.db $17,$05,$00,$0E,$0F,$17,$00,$26,$2C,$00
	;(clear text)
	.db $FE
	;    B   L   I   N   K   Y   :   \n
	.db $02,$0C,$09,$0E,$0B,$19,$38,$FC
	;    I       C   A   L   C   U   L   A   T   E       W   E       A   R   E   \n
	.db $09,$00,$03,$01,$0C,$03,$15,$0C,$01,$14,$05,$00,$17,$05,$00,$01,$12,$05,$FC
	;    N   E   A   R       T   H   E       C   O   R   E       O   F       T   H   E   \n
	.db $0E,$05,$01,$12,$00,$14,$08,$05,$00,$03,$0F,$12,$05,$00,$0F,$06,$00,$14,$08,$05,$FC
	;    M   A   G   M   A       T   A   N   K   E   R   .   "
	.db $0D,$01,$07,$0D,$01,$00,$14,$01,$0E,$0B,$05,$12,$39,$2C,$00
	;(clear text)
	.db $FE
	;    B   U   C   K   Y   :   \n
	.db $02,$15,$03,$0B,$19,$38,$FC
	;    "   L   E   T   '   S       F   O   L   L   O   W       T   H   E   \n
	.db $2B,$0C,$05,$14,$2F,$13,$00,$06,$0F,$0C,$0C,$0F,$17,$00,$14,$08,$05,$FC
	;    S   A   L   V   A   G   E       C   H   U   T   E       D   O   W   N       T   O   \n
	.db $13,$01,$0C,$16,$01,$07,$05,$00,$03,$08,$15,$14,$05,$00,$04,$0F,$17,$0E,$00,$14,$0F,$FC
	;    T   H   E       C   E   N   T   E   R   .       T   H   E   N       W   E       C   A   N   \n
	.db $14,$08,$05,$00,$03,$05,$0E,$14,$05,$12,$39,$00,$14,$08,$05,$0E,$00,$17,$05,$00,$03,$01,$0E,$FC
	;    B   L   O   W       T   H   E   I   R       T   A   N   K   S   !   "
	.db $02,$0C,$0F,$17,$00,$14,$08,$05,$09,$12,$00,$14,$01,$0E,$0B,$13,$25,$2C,$00
	;(clear text)
	.db $FE
	;    D   E   A   D   E   Y   E   :   \n
	.db $04,$05,$01,$04,$05,$19,$05,$38,$FC
	;    "   Y   O   ,       B   U   C   K   Y   ,       L   E   T   '   S   \n
	.db $2B,$19,$0F,$2E,$00,$02,$15,$03,$0B,$19,$2E,$00,$0C,$05,$14,$2F,$13,$FC
	;    I   O   N   I   Z   E       T   H   E       S   L   I   M   E   \n
	.db $09,$0F,$0E,$09,$1A,$05,$00,$14,$08,$05,$00,$13,$0C,$09,$0D,$05,$FC
	;    E   A   T   I   N   '       T   O   A   D   I   E   S   !   "
	.db $05,$01,$14,$09,$0E,$2F,$00,$14,$0F,$01,$04,$09,$05,$13,$25,$2C,$00
	;(clear text and go to next scene)
	.db $FD
	;(end dialog)
	.db $FF
Dialog07Data:
	;    J   E   N   N   Y   :   \n
	.db $0A,$05,$0E,$0E,$19,$38,$FC
	;    "   T   H   I   S       I   S       T   H   E       C   O   R   E   ,   \n
	.db $2B,$14,$08,$09,$13,$00,$09,$13,$00,$14,$08,$05,$00,$03,$0F,$12,$05,$2E,$FC
	;    C   A   P   T   A   I   N   .       T   H   E       M   A   G   M   A       I   S   \n
	.db $03,$01,$10,$14,$01,$09,$0E,$39,$00,$14,$08,$05,$00,$0D,$01,$07,$0D,$01,$00,$09,$13,$FC
	;    S   T   O   R   E   D       H   E   R   E   !   "
	.db $13,$14,$0F,$12,$05,$04,$00,$08,$05,$12,$05,$25,$2C,$00
	;(clear text)
	.db $FE
	;    B   U   C   K   Y   :   \n
	.db $02,$15,$03,$0B,$19,$38,$FC
	;    "   W   E   '   V   E       G   O   T       T   O       B   L   O   W       T   H   I   S   \n
	.db $2B,$17,$05,$2F,$16,$05,$00,$07,$0F,$14,$00,$14,$0F,$00,$02,$0C,$0F,$17,$00,$14,$08,$09,$13,$FC
	;    T   W   O   -   B   I   T       T   A   N   K   E   R   !       G   U   Y   S   !   "   \n
	.db $14,$17,$0F,$2D,$02,$09,$14,$00,$14,$01,$0E,$0B,$05,$12,$2E,$00,$07,$15,$19,$13,$25,$2C,$FC
	;(clear text and go to next scene)
	.db $FD
	;(end dialog)
	.db $FF
Dialog08Data:
	;    "   H   U   R   R   Y       U   P   !       L   E   T   '   S       B   U   S   T   \n
	.db $2B,$08,$15,$12,$12,$19,$00,$15,$10,$25,$00,$0C,$05,$14,$2F,$13,$00,$02,$15,$13,$14,$FC
	;    O   U   T       O   F       H   E   R   E       T   R   O   O   P   S   .   \n
	.db $0F,$15,$14,$00,$0F,$06,$00,$08,$05,$12,$05,$00,$14,$12,$0F,$0F,$10,$13,$39,$FC
	;    T   H   I   S       T   H   I   N   G   '   S   A   B   O   U   T       \n
	.db $14,$08,$09,$13,$00,$14,$08,$09,$0E,$07,$2F,$13,$01,$02,$0F,$15,$14,$00,$FC
	;    T   O       B   L   O   W   !   "
	.db $14,$0F,$00,$02,$0C,$0F,$17,$25,$2C,$00
	;(clear text)
	.db $FE
	;    "   W   E   '   R   E       O   U   T   T   A       H   E   R   E   \n
	.db $2B,$17,$05,$2F,$12,$05,$00,$0F,$15,$14,$14,$01,$00,$08,$05,$12,$05,$FC
	;    C   A   P   '   N   !   "
	.db $03,$01,$10,$2F,$0E,$25,$2C,$00
	;(clear text and go to next scene)
	.db $FD
	;(end dialog)
	.db $FF
Dialog09Data:
	;    B   U   C   K   Y       O   '   H   A   R   E       A   N   D       H   I   S   \n
	.db $02,$15,$03,$0B,$19,$00,$0F,$2F,$08,$01,$12,$05,$00,$01,$0E,$04,$00,$08,$09,$13,$FC
	;    B   O   L   D       C   R   E   W       D   I   S   A   B   L   E   D   \n
	.db $02,$0F,$0C,$04,$00,$03,$12,$05,$17,$00,$04,$09,$13,$01,$02,$0C,$05,$04,$FC
	;    T   H   E       T   O   A   D       M   O   T   H   E   R       S   H   I   P   \n
	.db $14,$08,$05,$00,$14,$0F,$01,$04,$00,$0D,$0F,$14,$08,$05,$12,$00,$13,$08,$09,$10,$FC
	;    A   N   D       E   S   C   A   P   E   D       W   I   T   H       T   H   E   I   R   \n
	.db $01,$0E,$04,$00,$05,$13,$03,$01,$10,$05,$04,$00,$17,$09,$14,$08,$00,$14,$08,$05,$09,$12,$FC
	;    L   I   V   E   S   .
	.db $0C,$09,$16,$05,$13,$39
	;(clear text and go to next scene)
	.db $FD
	;    T   H   E       R   I   G   H   T   E   O   U   S   \n
	.db $14,$08,$05,$00,$12,$09,$07,$08,$14,$05,$0F,$15,$13,$FC
	;    P   R   O   U   D   L   Y       F   L   Y   S       A   G   A   I   N   !
	.db $10,$12,$0F,$15,$04,$0C,$19,$00,$06,$0C,$19,$13,$00,$01,$07,$01,$09,$0E,$25
	;(clear text and go to next scene)
	.db $FD
	;    T   H   E       T   O   A   D       M   E   N   A   C   E       W   I   L   L   \n
	.db $14,$08,$05,$00,$14,$0F,$01,$04,$00,$0D,$05,$0E,$01,$03,$05,$00,$17,$09,$0C,$0C,$FC
	;    N   O   T       B   E       S   T   O   P   P   E   D       W   I   T   H   \n
	.db $0E,$0F,$14,$00,$02,$05,$00,$13,$14,$0F,$10,$10,$05,$04,$00,$17,$09,$14,$08,$FC
	;    O   N   E       V   I   C   T   O   R   Y   .   \n
	.db $0F,$0E,$05,$00,$16,$09,$03,$14,$0F,$12,$19,$39,$FC
	;    T   H   E       F   I   G   H   T       W   I   L   L       G   O       O   N   .
	.db $14,$08,$05,$00,$06,$09,$07,$08,$14,$00,$17,$09,$0C,$0C,$00,$07,$0F,$00,$0F,$0E,$39
	;(clear text and go to next scene)
	.db $FD
	;    B   U   C   K   Y       O   '   H   A   R   E       A   N   D       H   I   S   \n
	.db $02,$15,$03,$0B,$19,$00,$0F,$2F,$08,$01,$12,$05,$00,$01,$0E,$04,$00,$08,$09,$13,$FC
	;    C   R   E   W       W   O   N   '   T       R   E   S   T       U   N   T   I   L   \n
	.db $03,$12,$05,$17,$00,$17,$0F,$0E,$2F,$14,$00,$12,$05,$13,$14,$00,$15,$0E,$14,$09,$0C,$FC
	;    T   H   E       A   N   I   V   E   R   S   E       I   S       F   R   E   E   .
	.db $14,$08,$05,$00,$01,$0E,$09,$16,$05,$12,$13,$05,$00,$09,$13,$00,$06,$12,$05,$05,$39
	;(clear text and go to next scene)
	.db $FD
	;    \n
	.db $FC
	;    \n
	.db $FC
	;            L   E   T   '   S       C   R   O   A   K       T   O   A   D   S   !   !
	.db $00,$00,$0C,$05,$14,$2F,$13,$00,$03,$12,$0F,$01,$0B,$00,$14,$0F,$01,$04,$13,$25,$25
	;(end dialog)
	.db $FF
Dialog0AData:
	;(end dialog)
	.db $FF

;;;;;;;;;;;;
;SCENE DATA;
;;;;;;;;;;;;
Scene00Data:
	.db $13,$00,$00,$0C,$34,$3A,$22,$04,$55,$C1,$85,$56,$00,$00,$03,$32
	.db $01,$02,$4E
	.db $0F
Scene02Data:
	.db $00,$0E,$34,$3A,$22,$01,$02,$4F,$0A,$0C,$02,$11,$02,$C1,$19,$40
	.db $00,$00,$00,$D0,$0D,$E0,$0C,$28,$11,$03,$0C,$10,$11,$04,$0C,$40
	.db $03,$63,$82,$1E,$6E,$80,$03,$43,$92,$10,$00,$0C,$14,$83,$1E,$6E
	.db $80,$03,$43,$92,$08,$F8,$93,$10,$00,$0C,$14,$84,$1E,$6E,$80,$03
	.db $43,$92,$08,$F8,$93,$08,$F8,$94,$10,$00,$0C,$14,$91,$F0,$00,$92
	.db $FC,$00,$93,$FE,$02,$94,$04,$00,$11,$01,$0C,$50,$92,$00,$02,$93
	.db $04,$00,$94,$00,$FC,$0C,$50,$05,$56,$92,$10,$00,$93,$F8,$00,$94
	.db $F8,$00,$0C,$14,$92,$00,$00,$93,$00,$00,$94,$F8,$00,$0C,$28,$93
	.db $00,$FF,$94,$00,$01,$0C,$28,$93,$00,$01,$94,$00,$FF,$0C,$2C,$11
	.db $00,$07,$01,$0C,$04,$07,$02,$0C,$04,$C1,$E5,$56,$00,$00,$03,$32
	.db $91,$E0,$00,$07,$03,$0C,$02,$11,$01,$0C,$0A,$11,$00,$0D,$00,$92
	.db $20,$00,$93,$20,$00,$94,$20,$00,$91,$00,$00,$10,$70,$30,$86,$00
	.db $6E,$80,$03,$43,$96,$20,$00,$10,$70,$30,$87,$00,$28,$80,$03,$43
	.db $97,$20,$00,$10,$70,$30,$88,$00,$46,$80,$03,$43,$98,$20,$00,$0B
	.db $03,$DC,$10,$70,$30,$0B,$00,$FD
	.db $0F
Scene04Data:
	.db $00,$10,$42,$3B,$22,$03,$54,$04,$54,$81,$50,$60,$00,$02,$EE,$82
	.db $B0,$58,$80,$40,$E8
	.db $0F
Scene06Data:
	.db $00,$12,$44,$3C,$22,$03,$53,$04,$53,$81,$50,$52,$80,$42,$EA,$82
	.db $B0,$60,$00,$00,$EC
	.db $0F
Scene08Data:
	.db $00,$14,$3C,$3D,$22,$81,$7E,$51,$00,$00,$55
	.db $0F
Scene0AData:
	.db $00,$16,$3C,$3E,$22,$81,$82,$5F,$00,$00,$77
	.db $0F
Scene0CData:
	.db $12,$01,$02,$50
	.db $14
	.dw ScenePassword2Data
Scene0EData:
	.db $12,$00,$1E,$4A,$48,$22,$01,$02,$50,$03,$74,$81,$B4,$4E,$00,$00
	.db $EF,$82,$4E,$51,$00,$00,$F1
	.db $0F
Scene10Data:
	.db $12,$00,$1A,$4A,$48,$22,$01,$02,$50,$03,$74,$81,$B4,$4E,$00,$00
	.db $EF,$82,$37,$37,$00,$00,$F3
	.db $0F
Scene12Data:
	.db $12,$00,$20,$4A,$48,$22,$01,$02,$50,$03,$74,$81,$B4,$4E,$00,$00
	.db $EF,$82,$4D,$4A,$00,$00,$F5
	.db $0F
Scene32Data:
	.db $09,$13,$03,$00,$08,$5A,$4F,$2C,$04,$65,$81,$7B,$52,$00,$00,$ED
	.db $0F
Scene20Data:
	.db $18,$13,$02,$00,$24,$58,$4E,$22,$03,$74,$04,$6F,$05,$56,$C2,$66
	.db $49,$00,$00,$03,$40,$15,$16,$02,$3C,$10,$40,$40,$0B,$04,$FB,$0E
	.db $01,$92,$00,$01,$02,$3C,$10,$40,$50,$0B,$13,$FB,$0E,$00,$92,$00
	.db $00,$BF,$09,$0C,$20,$0A,$06,$F4
	.db $0F
Scene22Data:
	.db $00,$0C,$34,$3A,$22,$04,$55,$C1,$85,$56,$00,$00,$03,$32,$06,$B4
	.db $0F
Scene24Data:
	.db $06,$B4
	.db $0F
Scene26Data:
	.db $06,$F0
	.db $0F
Scene28Data:
	.db $06,$01
	.db $0F
Scene2AData:
	.db $18,$13,$04,$00,$24,$58,$4E,$2C,$01,$02,$4E,$03,$74,$04,$6F,$81
	.db $6D,$1D,$00,$00,$FF,$0C,$01,$91,$01,$01,$0C,$C8,$91,$00,$00
	.db $0F
Scene2CData:
	.db $0C,$01,$15,$09,$01,$02,$4B,$C2,$66,$99,$00,$00,$03,$40,$92,$00
	.db $FF,$81,$9F,$4F,$00,$00,$FF,$91,$00,$01,$0E,$FF,$0C,$C8,$91,$00
	.db $00,$0C,$DC,$92,$01,$00,$91,$FE,$00,$0D,$01,$0E,$00,$0C,$5A,$92
	.db $00,$00,$0D,$00,$0C,$28,$92,$FF,$00,$91,$02,$00,$0D,$FF,$0C,$5A
	.db $92,$00,$00,$0D,$00,$07,$07,$0C,$0A,$07,$08,$0C,$0A,$02,$2F,$83
	.db $68,$48,$00,$00,$FD,$0C,$0A,$84,$78,$58,$00,$00,$FD,$0C,$0A,$91
	.db $00,$00,$85,$88,$68,$00,$00,$FD,$0C,$0A,$86,$A0,$80,$00,$00,$FB
	.db $B1,$0B,$1F,$FF,$91,$FF,$FF,$96,$FF,$FF,$0C,$20,$B5,$0C,$40,$B4
	.db $00,$0E,$34,$5C,$22,$03,$6D,$04,$73,$07,$06,$81,$90,$70,$80,$20
	.db $11,$91,$FE,$00,$C2,$19,$40,$00,$00,$00,$D0,$0C,$E6,$B1,$07,$05
	.db $0C,$10,$07,$04,$02,$36,$0C,$10,$0A
	.db $0F
Scene2EData:
	.db $18,$01,$02,$4E
	.db $14
	.dw ScenePassword2Data
Scene30Data:
	.db $13,$04,$00,$22,$4C,$49,$2C,$0C,$03,$17,$26,$38,$DB,$38,$26,$BE
	.db $DB,$BE
	.db $14
	.dw ScenePasswordData
Scene16Data:
	.db $13,$05,$00,$22,$4C,$49,$2C,$0C,$03,$17,$25,$08,$B3,$08,$25,$8E
	.db $B3,$8E
	.db $14
	.dw ScenePasswordData
Scene1AData:
	.db $13,$06,$00,$22,$4C,$49,$2C,$0C,$03,$17,$35,$20,$C3,$20,$35,$A6
	.db $C3,$A6
	.db $14
	.dw ScenePasswordData
Scene1EData:
	.db $13,$07,$00,$22,$4C,$49,$2C,$0C,$03,$17,$47,$1C,$D9,$1C,$47,$A6
	.db $D9,$A6
	.db $14
	.dw ScenePasswordData
SceneDialogAllData:
	.db $00,$18,$4A,$48,$22,$03,$74,$01,$02,$50,$81,$CC,$4E,$00,$00,$EF
	.db $82,$76,$71,$00,$00,$F1,$83,$5F,$17,$00,$00,$F3,$84,$35,$2A,$00
	.db $00,$F5,$85,$3C,$69,$00,$00,$F7
	.db $0F
Scene14Data:
	.db $13,$05
	.db $14
	.dw SceneDialogAllData
Scene18Data:
	.db $13,$06
	.db $14
	.dw SceneDialogAllData
Scene1CData:
	.db $13,$07
	.db $14
	.dw SceneDialogAllData
ScenePasswordData:
	.db $0C,$0A,$B1,$B2,$B3,$B4,$94,$04,$04,$93,$FC,$04,$92,$04,$FC,$91
	.db $FC,$FC,$0C,$40,$91,$00,$00,$92,$00,$00,$93,$00,$00,$94,$00,$00
	.db $B1,$B2,$B3,$B4,$0C,$10,$B1,$B2,$B3,$B4,$02,$3B,$0C,$10,$0B,$00
	.db $F2
ScenePassword2Data:
	.db $00,$1C,$4A,$48,$22,$03,$74,$81,$54,$49,$00,$00,$F7,$82,$B4,$4E
	.db $00,$00,$EF
	.db $0F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DRAW SCENE COLUMN ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SceneColumnDataPointerTable:
	.dw SceneColumn01Data	;$01 \Hero ship
	.dw SceneColumn02Data	;$02 |
	.dw SceneColumn03Data	;$03 /
	.dw SceneColumn04Data	;$04 \Ship chasing
	.dw SceneColumn05Data	;$05 |
	.dw SceneColumn06Data	;$06 /
	.dw SceneColumn07Data	;$07
	.dw SceneColumn08Data	;$08

SceneColumn01Data:
	.db $28
	.dw $24E0
	.db $B8,$00,$00,$00,$00,$00,$D9
	.db $FF
	.dw $24E1
	.db $B9,$00,$00,$00,$00,$00,$DA
	.db $FF
	.dw $24E2
	.db $BA,$BD,$C2,$C7,$CD,$D4,$DB
	.db $FF
	.dw $24E3
	.db $BB,$BE,$C3,$C8,$CE,$D5,$DC
	.db $FF
	.db $5F,$55,$F5
SceneColumn02Data:
	.db $28
	.dw $24E0
	.db $00,$BF,$C4,$C9,$CF,$D6,$DD
	.db $FF
	.dw $24E1
	.db $BC,$C0,$C5,$CA,$D0,$D7,$DE
	.db $FF
	.dw $24E2
	.db $00,$C1,$C6,$CB,$D1,$D8,$DF
	.db $FF
	.dw $24E3
	.db $00,$00,$00,$CC,$D2,$00,$00
	.db $FF
	.db $5F,$15,$F5
SceneColumn03Data:
	.db $0A
	.dw $24E0
	.db $00,$00,$00,$00,$D3,$00,$00
	.db $FF
	.db $FF,$00,$FF
SceneColumn04Data:
	.db $34
	.dw $20E1
	.db $01,$04,$06,$0A,$0F,$14,$16,$16,$1B
	.db $FF
	.dw $20E2
	.db $02,$00,$07,$0B,$10,$14,$16,$16,$1C
	.db $FF
	.dw $20E3
	.db $03,$05,$00,$0C,$11,$14,$16,$19,$1D
	.db $FF
	.dw $2124
	.db $08,$0D,$12,$14,$17,$1A
	.db $FF
	.dw $2125
	.db $09,$0E,$13,$15
	.db $FF
	.db $AA,$AA,$FF
SceneColumn05Data:
	.db $33
	.dw $20E1
	.db $01,$04,$06,$0A,$0F,$1E,$16,$16,$1B
	.db $FF
	.dw $20E2
	.db $02,$00,$07,$0B,$0F,$1F,$20,$16,$1C
	.db $FF
	.dw $20E3
	.db $03,$05,$00,$0C,$11,$00,$21,$19,$1D
	.db $FF
	.dw $2124
	.db $08,$0D,$12,$00,$22,$23
	.db $FF
	.dw $2125
	.db $09,$0E,$13
	.db $FF
	.db $AA,$AA,$FF
SceneColumn06Data:
	.db $34
	.dw $20E1
	.db $01,$04,$06,$0A,$0F,$24,$25,$26,$1B
	.db $FF
	.dw $20E2
	.db $02,$00,$07,$0B,$0F,$00,$00,$27,$28
	.db $FF
	.dw $20E3
	.db $03,$05,$00,$0C,$11,$00,$00,$00,$00
	.db $FF
	.dw $2124
	.db $08,$0D,$12,$00,$00,$00
	.db $FF
	.dw $2125
	.db $09,$0E,$13,$00
	.db $FF
	.db $AA,$AA,$FF
SceneColumn07Data:
	.db $08
	.dw $22CC
	.db $E3
	.db $FF
	.dw $22CD
	.db $E4
	.db $FF
	.db $55,$55,$FF
SceneColumn08Data:
	.db $08
	.dw $22CC
	.db $E5
	.db $FF
	.dw $22CD
	.db $E6
	.db $FF
	.db $55,$55,$FF

GetSceneColumnVRAMAddr:
	;Save X/Y registers
	sty $0F
	stx $0E
	;Add X scroll low to address
	lda TempMirror_PPUSCROLL_X
	lsr
	lsr
	lsr
	adc $05
	;Check for overflow
	pha
	eor $05
	and #$E0
	beq GetSceneColumnVRAMAddr_NoXC
	;Adjust address for overflow
	pla
	clc
	adc #$E0
	pha
	;Set carry flag
	sec
	bcs GetSceneColumnVRAMAddr_XC
GetSceneColumnVRAMAddr_NoXC:
	;Clear carry flag
	clc
GetSceneColumnVRAMAddr_XC:
	;Set low byte of address
	pla
	sta $05
	;Check for right nametable
	ldy $06
	lda TempMirror_PPUCTRL
	and #$01
	beq GetSceneColumnVRAMAddr_Left
	;Check for previous overflow
	bcs GetSceneColumnVRAMAddr_SetHi
GetSceneColumnVRAMAddr_Right:
	;Add X scroll high to address
	iny
	iny
	iny
	iny
	clc
GetSceneColumnVRAMAddr_Left:
	;Check for previous overflow
	bcs GetSceneColumnVRAMAddr_Right
GetSceneColumnVRAMAddr_SetHi:
	;Set high byte of address
	sty $06
	lda $05
	;Restore X/Y registers
	ldx $0E
	;Set VRAM buffer address
	jsr WriteVRAMBufferCmd_Addr
	ldy $0F
GetSceneColumnVRAMAddr_Exit:
	rts

DrawSceneColumn:
	;Set ship chasing column task flag
	lda #$FF
	sta SceneShipChaseFlag
	;Get scene column
	lda SceneColumn
	asl
	beq GetSceneColumnVRAMAddr_Exit
	;Get scene column data pointer/size
	tay
	lda SceneColumnDataPointerTable-2,y
	sta $03
	lda SceneColumnDataPointerTable-2+1,y
	sta $04
	ldx VRAMBufferOffset
	ldy #$00
	lda ($03),y
	sta $02
DrawSceneColumn_NextCol:
	;Init VRAM buffer column
	lda #$02
	sta VRAMBuffer,x
	;Set VRAM buffer address
	inx
	iny
	lda ($03),y
	sta $05
	iny
	lda ($03),y
	sta $06
	jsr GetSceneColumnVRAMAddr
DrawSceneColumn_TileLoop:
	;Set tile in VRAM
	iny
	lda ($03),y
	sta VRAMBuffer,x
	inx
	;Check if at end of column
	cmp #$FF
	bne DrawSceneColumn_TileLoop
	;Check if at end of data
	cpy $02
	bcc DrawSceneColumn_NextCol
	;End VRAM buffer
	stx VRAMBufferOffset
	;Get column VRAM attribute address
	lda $05
	and #$1C
	lsr
	lsr
	ora #$C8
	sta $05
	lda #$03
	sta $02
	ora $06
	sta $06
DrawSceneColumn_AttrLoop:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set attribute in VRAM
	lda $05
	sta VRAMBuffer,x
	inx
	adc #$08
	sta $05
	lda $06
	sta VRAMBuffer,x
	inx
	iny
	lda ($03),y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Go to next attribute
	dec $02
	bne DrawSceneColumn_AttrLoop
	rts

;;;;;;;;;;;;;;;
;DEMO ROUTINES;
;;;;;;;;;;;;;;;
RunGameSubmode_EndingDemoInitSub:
	;Set max power for characters Dead-Eye and Blinky
	lda #$A4
	sta CharacterPowerMax+3
	sta CharacterPowerMax+2
	;Set item collected bits
	lda #$FF
	sta ItemCollectedBits
	sta ItemCollectedBits+1
	;Set demo index
	lda #$FF
	sta DemoIndex
	;Set disable sound load flag
	sta DisableSoundLoadFlag

RunGameSubmode_EndingDemoEndSub:
	;Init demo state
	lda #$00
	sta DemoEndFlag
	sta DemoInputTimer
	;Init level state
	sta LevelGlobalTimer
	sta BGFireArchTimer
	;Init demo state
	sta DemoEndAllFlag
	;Get demo input data index
	inc DemoIndex
	ldx DemoIndex
	lda DemoDataIndex,x
	sta DemoInputDownIndex
	sta DemoInputCurIndex
	;Set demo level
	lda DemoLevelCharacter,x
	and #$0F
	sta CurLevel
	;Set demo character
	lda DemoLevelCharacter,x
	lsr
	lsr
	lsr
	lsr
	sta CurCharacter
	;Set demo area
	lda DemoArea,x
	sta CurArea
	;Set level area number
	jsr SetLevelAreaNum
	;Load area
	jsr RunGameSubmode_ReadyEnd_NoMusic
	;Clear demo timer
	lda #$00
	sta DemoTimer
	sta DemoTimer+1
	;Next mode ($09: Ending)
	lda #$09
	sta GameMode
	;Next submode ($01: Main)
	lda #$01
	sta GameSubmode
	rts
DemoDataIndex:
	.db $00,$0B,$1B,$3B,$2B,$48,$53,$59,$64,$72,$81,$8E,$9B,$A8,$BD,$CC
DemoLevelCharacter:
	.db $00,$00,$11,$32,$11,$42,$23,$13,$04,$34,$45,$35,$26,$26,$47,$07
DemoArea:
	.db $20,$28,$18,$30,$40,$48,$30,$38,$60,$78,$20,$28,$10,$70,$08,$30

UpdateDemoInputSub:
	;Increment demo input timer
	inc DemoInputTimer
	;Check for new joypad down bits
	ldx DemoInputDownIndex
	lda DemoInputDownLen,x
	cmp DemoInputTimer
	bne UpdateDemoInputSub_NoNextDown
	;Increment demo input down index
	inc DemoInputDownIndex
	inx
UpdateDemoInputSub_NoNextDown:
	;Set joypad down bits
	lda DemoInputDownData,x
	sta JoypadDown
	;Check for new joypad current bits
	ldx DemoInputCurIndex
	lda DemoInputCurLen,x
	cmp DemoInputTimer
	bne UpdateDemoInputSub_NoNextCur
	;Increment demo input current index
	inc DemoInputCurIndex
	inx
UpdateDemoInputSub_NoNextCur:
	;Set joypad current bits
	lda DemoInputCurData,x
	sta JoypadCur
	rts

RunGameSubmode_EndingDemoWaitSub:
	;Do jump table
	lda DemoWaitMode
	jsr DoJumpTable
EndingDemoWaitSubJumpTable:
	.dw EndingDemoWaitSub_Sub0	;$00  Init
	.dw EndingDemoWaitSub_Sub1	;$01  Scroll right
	.dw EndingDemoWaitSub_Sub2	;$02  Wait
	.dw EndingDemoWaitSub_Sub3	;$03  Scroll left
	.dw EndingDemoWaitSub_Sub4	;$04  "THE END" init
;$00: Init
EndingDemoWaitSub_Sub0:
	;Write clear VRAM strip
	ldy DemoCreditsIndex
	lda EndingVRAMClearTable-1,y
	jsr WriteVRAMStrip
	;If all clear VRAM strips not written, exit early
	dec DemoCreditsIndex
	bne EndingDemoWaitSub_Sub1_Exit
	;Next task ($01: Scroll right)
	inc DemoWaitMode
	;Write credits name VRAM strip
	lda DemoIndex
	clc
	adc #$5E
	jsr WriteVRAMStrip
	;Write credits header VRAM strip
	ldy DemoIndex
	lda EndingVRAMStripTable,y
	beq EndingDemoWaitSub_Sub1_Exit
	jmp WriteVRAMStrip
EndingVRAMClearTable:
	.db $9F,$9E,$97,$96
EndingVRAMStripTable:
	.db $00,$00,$00,$6E,$6E,$6E,$00,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$00,$00
;$01: Scroll right
EndingDemoWaitSub_Sub1:
	;Scroll right $06
	ldx TempIRQCount
	lda TempIRQBufferScrollX-1,x
	clc
	adc #$06
	sta TempIRQBufferScrollX-1,x
	;If scroll X position not $FC, exit early
	cmp #$FC
	bne EndingDemoWaitSub_Sub1_Exit
	;Set animation timer
	lda #$48
EndingDemoWaitSub_Sub1_SetT:
	sta DemoCreditsTimerLo
	lda #$02
	sta DemoCreditsTimerHi
	;Next task
	inc DemoWaitMode
EndingDemoWaitSub_Sub1_Exit:
	rts
;$02: Wait
EndingDemoWaitSub_Sub2:
	;Decrement animation timer, check if 0
	dec DemoCreditsTimerLo
	bne EndingDemoWaitSub_Sub1_Exit
	dec DemoCreditsTimerHi
	bne EndingDemoWaitSub_Sub1_Exit
	;Next task ($03: Scroll left)
	inc DemoWaitMode
	;If not on last demo, exit early
	lda DemoIndex
	cmp #$0F
	bne EndingDemoWaitSub_Sub1_Exit
	;Set all demos end flag
	lda #$99
	sta DemoEndAllFlag
	;Setup next task ($04: "THE END" init)
	bne EndingDemoWaitSub_Sub1_SetT
;$03: Scroll left
EndingDemoWaitSub_Sub3:
	;Scroll left $06
	ldx TempIRQCount
	lda TempIRQBufferScrollX-1,x
	sec
	sbc #$06
	sta TempIRQBufferScrollX-1,x
	;If scroll X position not $00, exit early
	bne EndingDemoWaitSub_Sub1_Exit
	;Next submode ($04: "THE END" init)
	inc GameSubmode
	;Set black screen timer
	lda #$03
	sta BlackScreenTimer
	rts
;$04: "THE END" init
EndingDemoWaitSub_Sub4:
	;Decrement animation timer, check if 0
	dec DemoCreditsTimerLo
	bne EndingDemoWaitSub_Sub1_Exit
	dec DemoCreditsTimerHi
	bne EndingDemoWaitSub_Sub1_Exit
	;Set "THE END" dialog
	lda #$0A
	sta DialogID
	;Next mode ($02: Dialog)
	lda #$02
	sta GameMode
	;Next submode ($00: Init)
	lda #$00
	sta GameSubmode
	;Clear demo end flag
	sta DemoEndFlag
	;Set black screen timer
	lda #$03
	sta BlackScreenTimer
	rts

;DEMO DATA
	.db $00
DemoInputDownLen:
	;$00
	.db $F5,$F6,$18,$19,$60,$61,$75,$76,$83,$84,$00
	;$0B
	.db $73,$74,$3F,$40,$5C,$5D,$96,$97,$BA,$BB,$CB,$CC,$E8,$E9,$EA,$00
	;$1B
	.db $A0,$A1,$A8,$A9,$C7,$C8,$E4,$E5,$FF,$00,$2C,$2D,$49,$4A,$56,$00
	;$2B
	.db $59,$5A,$CC,$CD,$E8,$E9,$73,$74,$89,$8A,$DF,$E0,$F5,$F6,$FE,$00
	;$3B
	.db $75,$76,$BF,$C0,$EE,$EF,$1E,$1F,$9E,$9F,$DD,$DE,$00
	;$48
	.db $A0,$A1,$F1,$F2,$52,$53,$B9,$BA,$F1,$F2,$00
	;$53
	.db $70,$71,$91,$92,$00,$00
	;$59
	.db $F7,$F8,$00,$01,$2D,$2E,$91,$92,$D7,$D8,$00
	;$64
	.db $32,$33,$2B,$2C,$42,$43,$62,$63,$A1,$A2,$B9,$BA,$E0,$00
	;$72
	.db $A2,$A3,$BE,$BF,$CE,$CF,$E0,$E1,$EF,$F0,$00,$01,$E0,$E1,$00
	;$81
	.db $B5,$B6,$D0,$D1,$8B,$8C,$92,$93,$C7,$C8,$F3,$F4,$00
	;$8E
	.db $3C,$3D,$6A,$6B,$0C,$0D,$52,$53,$D3,$D4,$D7,$D8,$00
	;$9B
	.db $13,$14,$82,$83,$BB,$BC,$31,$32,$C1,$C2,$CE,$CF,$00
	;$A8
	.db $73,$74,$76,$77,$B8,$B9,$F8,$F9,$0F,$10,$2C,$2D,$77,$78,$B9,$BA
	.db $D8,$D9,$F4,$F5,$00
	;$BD
	.db $08,$09,$41,$42,$6F,$70,$2B,$2C,$65,$66,$8E,$8F,$B1,$B2,$00
	;$CC
	.db $2F,$30,$31,$32,$01,$02,$1B,$1C,$4C,$4D,$72,$73,$A5,$A6,$E8,$E9
DemoInputDownData:
	;$00
	.db $00,$01,$00,$80,$00,$02,$00,$01,$00,$80,$00
	;$0B
	.db $00,$01,$00,$02,$00,$81,$00,$02,$00,$02,$00,$80,$00,$08,$00,$01
	;$1B
	.db $00,$01,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$04
	;$2B
	.db $00,$01,$00,$80,$00,$40,$00,$80,$00,$02,$00,$81,$00,$40,$00,$02
	;$3B
	.db $00,$01,$00,$40,$00,$40,$00,$01,$00,$40,$00,$40,$00
	;$48
	.db $00,$01,$00,$80,$00,$80,$00,$80,$00,$40,$00
	;$53
	.db $00,$02,$00,$80,$00,$00
	;$59
	.db $00,$02,$00,$80,$00,$04,$00,$40,$00,$01,$00
	;$64
	.db $00,$02,$00,$08,$00,$40,$00,$01,$00,$02,$00,$08,$00,$40
	;$72
	.db $00,$01,$00,$40,$00,$40,$00,$40,$00,$40,$00,$08,$00,$02,$00
	;$81
	.db $00,$01,$00,$80,$00,$01,$00,$80,$00,$01,$00,$80,$00
	;$8E
	.db $00,$01,$00,$40,$00,$08,$00,$01,$00,$01,$00,$80,$00
	;$9B
	.db $00,$02,$00,$01,$00,$40,$00,$01,$00,$08,$00,$08,$00
	;$A8
	.db $00,$80,$01,$00,$40,$00,$40,$00,$40,$00,$40,$00,$40,$00,$40,$00
	.db $40,$00,$40,$00,$40
	;$BD
	.db $00,$01,$00,$04,$00,$40,$00,$40,$00,$08,$00,$04,$00,$08,$00
	;$CC
	.db $00,$08,$00,$01,$00,$04,$00,$40,$00,$08,$00,$01,$00,$01,$00,$02
	.db $00,$00
DemoInputCurLen:
	;$00
	.db $F5,$18,$38,$52,$60,$66,$75,$83,$8F,$D5,$00
	;$0B
	.db $73,$BB,$3F,$5C,$78,$95,$96,$A2,$BA,$CB,$E8,$E9,$EA,$04,$39,$00
	;$1B
	.db $A0,$A8,$AF,$C7,$D1,$E4,$F7,$FF,$0A,$2C,$31,$49,$4D,$56,$5A,$00
	;$2B
	.db $59,$8C,$CC,$D8,$E8,$F0,$73,$82,$89,$A8,$DF,$EE,$EF,$F5,$FD,$00
	;$3B
	.db $75,$9C,$BF,$C4,$EE,$F4,$1E,$37,$9E,$A8,$DD,$F3,$00
	;$48
	.db $A0,$BF,$F1,$0D,$52,$6E,$B9,$CB,$F1,$F9,$00
	;$53
	.db $70,$91,$AA,$AB,$00,$00
	;$59
	.db $F7,$00,$14,$2D,$91,$97,$D6,$D7,$E8,$53,$00
	;$64
	.db $32,$52,$2B,$42,$49,$62,$6D,$75,$A1,$A9,$B9,$DF,$E7,$00
	;$72
	.db $A2,$BE,$C5,$CE,$D5,$E0,$E6,$EF,$F6,$00,$02,$03,$E0,$00,$00
	;$81
	.db $B5,$D0,$D9,$19,$8B,$92,$9D,$B0,$C7,$F3,$FA,$00,$00
	;$8E
	.db $3C,$64,$6A,$0C,$1C,$52,$5C,$6D,$D3,$D7,$F5,$A1,$00
	;$9B
	.db $13,$61,$82,$86,$BB,$31,$C1,$C8,$C9,$CE,$00,$00,$00
	;$A8
	.db $73,$76,$8D,$90,$B8,$BE,$F8,$02,$0F,$18,$2C,$34,$77,$80,$B9,$C1
	.db $D8,$DE,$F4,$FB,$00
	;$BD
	.db $08,$1C,$41,$49,$6F,$74,$2B,$2E,$65,$7D,$8E,$A4,$B1,$C4,$00
	;$CC
	.db $2F,$31,$4B,$4C,$01,$13,$1B,$20,$4C,$63,$72,$7A,$A5,$C9,$E8,$F2
DemoInputCurData:
	;$00
	.db $00,$01,$81,$01,$00,$02,$00,$01,$81,$01,$00
	;$0B
	.db $00,$01,$00,$02,$81,$01,$00,$02,$00,$02,$82,$0A,$08,$01,$00,$01
	;$1B
	.db $00,$01,$81,$01,$81,$01,$81,$01,$81,$01,$81,$01,$81,$01,$05,$04
	;$2B
	.db $00,$01,$00,$80,$00,$40,$00,$80,$00,$02,$00,$81,$01,$41,$40,$00
	;$3B
	.db $00,$01,$00,$40,$00,$40,$00,$01,$00,$40,$00,$40,$00
	;$48
	.db $00,$01,$00,$80,$00,$80,$00,$80,$00,$40,$00
	;$53
	.db $00,$02,$82,$80,$00,$00
	;$59
	.db $00,$02,$82,$02,$04,$44,$04,$00,$01,$00,$02
	;$64
	.db $00,$02,$00,$08,$48,$08,$09,$01,$00,$02,$00,$08,$48,$08
	;$72
	.db $00,$01,$41,$01,$41,$01,$41,$01,$41,$01,$09,$01,$00,$02,$00
	;$81
	.db $00,$01,$81,$01,$00,$01,$81,$01,$00,$01,$81,$01,$00
	;$8E
	.db $00,$01,$00,$40,$48,$08,$09,$01,$00,$01,$81,$00,$01
	;$9B
	.db $00,$02,$00,$01,$00,$40,$41,$49,$41,$01,$09,$00,$00
	;$A8
	.db $00,$80,$81,$01,$00,$40,$00,$40,$00,$40,$00,$40,$00,$40,$00,$40
	.db $00,$01,$00,$40,$00
	;$BD
	.db $00,$01,$00,$04,$00,$40,$00,$40,$00,$08,$00,$04,$00,$08,$00
	;$CC
	.db $00,$08,$09,$01,$00,$04,$00,$40,$00,$08,$00,$01,$00,$01,$00,$02
	.db $00

;UNUSED SPACE
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$FF

	.org $C000
