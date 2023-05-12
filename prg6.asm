	.base $8000
	.org $8000
;BANK NUMBER
	.db $3C

;;;;;;;;;;;;;;;;
;SOUND ROUTINES;
;;;;;;;;;;;;;;;;
ClearSoundSub:
	;Clear sound
	ldx #$05
	jsr ClearSoundState
	jsr ClearSoundRegs
	;Clear other sound registers
	lda #$0F
	sta SND_CHN
	lda #$00
	sta DMC_FREQ
	sta DMC_RAW
	sta DMC_START
	sta DMC_LEN
	lda #$1F
	sta SND_CHN
	rts

ClearMusic:
	;Clear only music channels sound state
	lda #$00
	sta SoundID+5
	sta SoundControlFlags+5
	ldx #$02
	jsr ClearSoundState
	ldx #$02
ClearMusic_Loop:
	stx SoundCurChannel
	jsr SoundCommandFF_NoSet
	dex
	bpl ClearMusic_Loop
	rts

ClearSoundState:
	;Clear sound state
	lda #$FF
	sta SoundOutFreqHi,x
	lda #$00
	sta SoundID,x
	sta SoundControlFlags,x
	sta SoundPriority,x
	dex
	bpl ClearSoundState
	sta SoundFadeoutTimer+1
	sta SoundFadeoutTimer
	sta SoundFadeoutCompare
	sta SoundFadeoutCompare+1
	sta SoundTriLinearReload
	sta SoundTriLinearTimer
	sta SoundTempoCompare
	sta SoundTempoTimer
	rts

LoadSoundSub:
	;Check for valid sound ID
	sta SoundLoadID
	cmp #$5E
	bcc LoadSoundSub_Valid
	jmp ClearSoundSub
LoadSoundSub_Valid:
	;Check for DMC
	cmp #$5B
	bcc LoadSoundSub_NoDMC
	jmp LoadSoundDMC
LoadSoundSub_NoDMC:
	;Check for fadeout command
	cmp #$58
	bcc LoadSoundInit
	;Init fadeout compare and timer
	sec
	sbc #$58
	tax
	lda LoadSoundFadeoutLo,x
	sta SoundFadeoutCompare
	lda LoadSoundFadeoutHi,x
	sta SoundFadeoutCompare+1
	lda #$01
	sta SoundFadeoutTimer+1
	lda #$00
	sta SoundFadeoutTimer
	rts
LoadSoundFadeoutLo:
	.db $30,$15,$48
LoadSoundFadeoutHi:
	.db $05,$06,$06

LoadSoundInit:
	;Get sound header pointer
	lda SoundLoadID
	asl
	tax
	lda SoundHeaderPointerTable-2,x
	sta TempSoundInitPointer
	lda SoundHeaderPointerTable-2+1,x
	sta TempSoundInitPointer+1
	;Get priority and number of channels
	ldy #$00
	lda (TempSoundInitPointer),y
	sta SoundLoadPriority
	iny
	lda (TempSoundInitPointer),y
	rol
	rol
	rol
	and #$03
	sta SoundLoadNumChannels
LoadSoundInit_Loop:
	;Get current channel
	lda (TempSoundInitPointer),y
	and #$07
	tax
	sta SoundLoadCurChannel
	;If music, skip priority check
	lda SoundLoadID
	cmp #$42
	bcs LoadSoundInit_Over
	;If playing lower priority sound, exit
	lda SoundLoadPriority
	cmp SoundPriority,x
	bcs LoadSoundInit_Over
	jmp LoadSoundInit_Exit
LoadSoundInit_Over:
	;Check for sound effect
	lda (TempSoundInitPointer),y
	and #$20
	beq LoadSoundInit_NoSE
	lda #SF_SNDEFF
LoadSoundInit_NoSE:
	sta SoundControlFlags,x
	lda SoundLoadPriority
	sta SoundPriority,x
	lda #$00
	sta SoundID,x
	cpx #$04
	bcs LoadSoundInit_Comm
	cpx #$03
	beq LoadSoundInit_SESq
	cpx #$02
	beq LoadSoundInit_Tri
	;Init square-only state variables
	lda #$FF
	sta SoundOutFreqHi,x
	lda #$00
	sta SoundEchoDuty,x
	sta SoundInst2Multiplier,x
	sta SoundEchoAmount,x
	sta SoundEchoTimer,x
LoadSoundInit_Tri:
	;Init square/tri-only state variables
	sta SoundPitchShift,x
	sta SoundGlobalPitchShift
LoadSoundInit_SESq:
	;Init square/tri/SFX square-only state variables
	sta SoundPitch,x
	sta SoundFade,x
LoadSoundInit_Comm:
	;Init common state variables
	sta SoundRepeat1Counter,x
	sta SoundRepeat2Counter,x
	sta SoundTimerHi,x
	lda #$01
	sta SoundTimerLo,x
	;Get sound pointers
	iny
	lda (TempSoundInitPointer),y
	sta SoundPointersLo,x
	sta SoundRepeat1PtrLo,x
	sta SoundRepeat2PtrLo,x
	iny
	lda (TempSoundInitPointer),y
	sta SoundPointersHi,x
	sta SoundRepeat1PtrHi,x
	sta SoundRepeat2PtrHi,x
	;Check for square output channel
	cpx #$03
	beq LoadSoundInit_Sq
	cpx #$02
	bcs LoadSoundInit_NoSq
	cpx #$00
	bne LoadSoundInit_Sq
	lda SoundID+3
	bne LoadSoundInit_NoSq
LoadSoundInit_Sq:
	;Init square sound registers
	lda SoundOutIndexTable,x
	tax
	lda #$30
	sta SQ1_VOL,x
	jsr OutputSoundDummy
	lda #$7F
	sta SQ1_SWEEP,x
	jsr OutputSoundDummy
	lda #$08
	sta SQ1_HI,x
	sta SQ1_HI,x
	jsr OutputSoundDummy
	ldx SoundLoadCurChannel
	sta SoundOutFreqHi,x
LoadSoundInit_NoSq:
	;Set ID
	lda SoundLoadID
	sta SoundID,x
	;Go to next channel
	lda SoundLoadNumChannels
	beq LoadSoundInit_Exit
	dec SoundLoadNumChannels
	iny
	jmp LoadSoundInit_Loop
LoadSoundInit_Exit:
	lda #$00
	sta TempSoundInitPointer+1
	ldx SoundCurChannel
	rts

LoadSoundDMC:
	;Get DMC instrument table offset
	lda SoundLoadID
	sec
	sbc #$5C
	asl
	asl
	clc
	adc #$03
	tax
	;Disable DMC output
	lda #$0F
	sta SND_CHN
	sty TempSoundDataIndex
	;Init DMC sound registers state
	ldy #$03
LoadSoundDMC_Loop:
	lda DMCInstrumentTable,x
	sta DMC_FREQ,y
	dex
	dey
	bpl LoadSoundDMC_Loop
	;Enable DMC output
	ldy TempSoundDataIndex
	lda #$1F
	sta SND_CHN
	ldx SoundCurChannel
	rts

.db $FF

UpdateSoundSub:
	;Check if game is paused
	lda PausedFlag
	beq UpdateSoundSub_Unpause
	;Check if sound is paused too
	cmp SoundPausedFlag
	beq UpdateSoundSub_NoPause
	;Clear sound
	jsr ClearSoundRegs
	;Clear SFX noise channel
	lda #$00
	sta SoundID+4
	sta SoundPriority+4
	beq UpdateSoundSub_NoPause
	;Clear square 1 channel
	lda #$00
	sta SoundID+1
	jmp UpdateSoundSub_NoPause
UpdateSoundSub_Unpause:
	;Check if sound is unpaused too
	cmp SoundPausedFlag
	beq UpdateSoundSub_NoPause
	;Check for pause sound effect
	lda SoundID+3
	cmp #SE_PAUSE
	beq UpdateSoundSub_NoPause
	jsr SetSoundRegs
UpdateSoundSub_NoPause:
	;Set paused sound flag
	lda PausedFlag
	sta SoundPausedFlag
	;If paused, don't update fadeout/tempo
	lda PausedFlag
	beq UpdateSoundSub_DoFT
	jmp UpdateSoundSub_NoFT
UpdateSoundSub_DoFT:
	;If fadeout timer 0, don't update fadeout
	lda SoundFadeoutTimer+1
	beq UpdateSoundSub_NoFadeTri
	;Increment fadeout timer and compare
	inc SoundFadeoutTimer
	lda SoundFadeoutTimer
	cmp SoundFadeoutCompare
	bne UpdateSoundSub_NoFadeTri
	inc SoundFadeoutTimer+1
	lda #$00
	sta SoundFadeoutTimer
	lda SoundFadeoutTimer+1
	cmp SoundFadeoutCompare+1
	bne UpdateSoundSub_NoFadeClear
	jmp ClearSoundSub
UpdateSoundSub_NoFadeClear:
	;If fadeout timer $0400, clear noise channel
	cmp #$04
	bne UpdateSoundSub_NoFadeNoise
	lda #$00
	sta SoundID+5
UpdateSoundSub_NoFadeNoise:
	;If fadeout timer $0300, clear triangle channel
	cmp #$03
	bne UpdateSoundSub_NoFadeTri
	lda #$00
	sta SoundID+2
	sta TRI_LINEAR
UpdateSoundSub_NoFadeTri:
	;If tempo compare 0, don't update tempo
	lda SoundTempoCompare
	beq UpdateSoundSub_NoFT
	;Increment tempo timer
	inc SoundTempoTimer
	;If tempo timer = tempo compare, don't update tempo
	cmp SoundTempoTimer
	bne UpdateSoundSub_NoFT
	;Reset tempo timer
	lda #$00
	sta SoundTempoTimer
	;Increment sound timers
	ldx #$05
UpdateSoundSub_TempoLoop:
	;Increment sound timer
	inc SoundTimerLo,x
	bne UpdateSoundSub_NoC
	inc SoundTimerHi,x
UpdateSoundSub_NoC:
	;Check for noise channel
	cpx #$05
	bne UpdateSoundSub_NoNoise
	;Skip over SFX channels
	ldx #$03
UpdateSoundSub_NoNoise:
	;Go to next channel
	dex
	bpl UpdateSoundSub_TempoLoop
UpdateSoundSub_NoFT:
	;Update sound channels
	ldx #$00
	ldy #$00
UpdateSoundSub_Loop:
	stx SoundCurChannel
	;Check if channel is active
	lda SoundID,x
	beq UpdateSoundSub_Next
	;Update sound channel
	jsr UpdateSoundChannel
UpdateSoundSub_Next:
	;Go to next channel
	ldx SoundCurChannel
	inx
	cpx #$06
	bne UpdateSoundSub_Loop
	rts

UpdateSoundChannel:
	;Get sound data pointer
	jsr GetSoundPointer
	;If paused, only allow pause sound effect through
	lda PausedFlag
	beq UpdateSoundChannel_Pause
	lda SoundID,x
	cmp #SE_PAUSE
	beq UpdateSoundChannel_Pause
	rts
UpdateSoundChannel_Pause:
	;If triangle channel, increment triangle linear timer
	cpx #$02
	bne UpdateSoundChannel_NoIncTri
	inc SoundTriLinearTimer
UpdateSoundChannel_NoIncTri:
	;Decrement sound timer
	lda SoundTimerLo,x
	sec
	sbc #$01
	sta SoundTimerLo,x
	lda SoundTimerHi,x
	sbc #$00
	sta SoundTimerHi,x
	;Check if timer expired
	lda SoundTimerLo,x
	ora SoundTimerHi,x
	bne UpdateSoundChannel_Continue
	;Get next command byte
	jmp UpdateSoundChannel_GetByte
UpdateSoundChannel_Tri:
	;If triangle "volume" 0 or less, exit
	lda SoundVol,x
	beq UpdateSoundChannel_TriExit
	bmi UpdateSoundChannel_TriExit
	;If triangle linear timer not expired, exit
	lda SoundTriLinearTimer
	and #$0F
	bne UpdateSoundChannel_TriExit
	;Reload triangle linear timer
	lda SoundTriLinearReload
	sec
	sbc #$40
	bcc UpdateSoundChannel_TriExit
	sta SoundTriLinearReload
	sta TRI_LINEAR
	jsr OutputSoundDummy
	lda SoundFreqHi+2
	ora #$08
	sta TRI_HI
	jsr OutputSoundDummy
UpdateSoundChannel_TriExit:
	rts
UpdateSoundChannel_Continue:
	;Check for noise/DMC channel
	cpx #$05
	beq UpdateSoundChannel_TriExit
	;Check for triangle channel
	cpx #$02
	beq UpdateSoundChannel_Tri
	;Check for SFX noise
	cpx #$04
	beq UpdateSoundChannel_TriExit
	;Check for rest or sound effect flags
	lda SoundControlFlags,x
	and #(SF_REST|SF_SNDEFF)
	beq UpdateSoundChannel_NoRSE
	bne UpdateSoundChannel_TriExit
UpdateSoundChannel_NoRSE:
	;Set remainder low byte to $00
	lda #$00
	sta $E4
	;Check if echo enabled
	lda SoundEchoAmount,x
	bmi UpdateSoundChannel_DoEcho
	jmp UpdateSoundChannel_NoEcho
UpdateSoundChannel_DoEcho:
	;Divide SoundTimer by SoundBaseLength and store remainder in lo:$E4, hi:$E5
	lda SoundTimerLo,x
	sta $E4
	lda SoundTimerHi,x
	sta $E5
UpdateSoundChannel_EchoDivLoop:
	lda $E4
	sec
	sbc SoundBaseLength,x
	sta $E4
	bcs UpdateSoundChannel_EchoDivNoC
	lda $E5
	sec
	sbc #$01
	bcs UpdateSoundChannel_EchoDivEnd
	sta $E5
UpdateSoundChannel_EchoDivNoC:
	lda $E4
	ora $E5
	beq UpdateSoundChannel_EchoBufSet
	jmp UpdateSoundChannel_EchoDivLoop
UpdateSoundChannel_EchoDivEnd:
	;Check for end of note
	lda SoundTimerHi,x
	cmp SoundEchoEndHi,x
	beq UpdateSoundChannel_EchoBSHi
	bcs UpdateSoundChannel_NoEcho
UpdateSoundChannel_EchoBSHi:
	lda SoundTimerLo,x
	cmp SoundEchoEndLo,x
	bcs UpdateSoundChannel_NoEcho
	sty TempSoundDataIndex
	jmp UpdateSoundChannel_EchoBufGet
UpdateSoundChannel_EchoBufSet:
	;Increment echo timer
	inc SoundEchoTimer,x
	sty TempSoundDataIndex
	;Get echo buffer offset
	lda SoundEchoTimer,x
	and #$03
	jsr UpdateSoundChannel_EchoOffs
	tay
	;Set frequency to echo buffer
	lda SoundFreqLo,x
	sta SoundEchoBufferLo,y
	lda SoundFreqHi,x
	sta SoundEchoBufferHi,y
	;Check for end of note
	lda SoundTimerHi,x
	cmp SoundEchoEndHi,x
	beq UpdateSoundChannel_EchoBGHi
	bcs UpdateSoundChannel_NoEcho
UpdateSoundChannel_EchoBGHi:
	lda SoundTimerLo,x
	cmp SoundEchoEndLo,x
	bcc UpdateSoundChannel_EchoBufGet
	ldy TempSoundDataIndex
	jmp UpdateSoundChannel_NoEcho
UpdateSoundChannel_EchoBufGet:
	;Get echo buffer offset
	lda SoundEchoTimer,x
	sec
	sbc SoundEchoAmount,x
	and #$03
	jsr UpdateSoundChannel_EchoOffs
	tay
	;Get frequency from echo buffer
	lda SoundEchoBufferLo,y
	sta $EA
	lda SoundEchoBufferHi,y
	sta $EB
	ldy TempSoundDataIndex
	jsr SoundCommandNote_NoPitchCh
	jmp UpdateSoundChannel_NoInst2
UpdateSoundChannel_EchoOffs:
	;Check for square 2 channel
	cpx #$01
	bne UpdateSoundChannel_NoOffs
	clc
	adc #$04
UpdateSoundChannel_NoOffs:
	rts
UpdateSoundChannel_NoEcho:
	;If instrument pitch multiplier is 0, don't update
	lda SoundInst2Multiplier,x
	beq UpdateSoundChannel_NoInst2
	;Update instrument pitch
	dec SoundInst2Timer,x
	bne UpdateSoundChannel_NoInst2
	inc SoundInst2Pointer,x
	jsr UpdateInstrumentPitch
	jsr GetSoundPitch
	jsr SoundCommandNote_NoPitchInst
UpdateSoundChannel_NoInst2:
	;Check if instrument volume or fadeout command
	lda SoundInst1,x
	and #$80
	beq UpdateSoundChannel_NoFade
	;Update fadeout
	lda SoundInst1Pointer,x
	beq UpdateSoundChannel_NoInst1
	dec SoundInst1Pointer,x
	inc SoundEchoFade,x
	jmp UpdateSoundChannel_NoInst1
UpdateSoundChannel_NoFade:
	;Update instrument volume
	dec SoundInst1Timer,x
	bne UpdateSoundChannel_NoInst1
	inc SoundInst1Pointer,x
	jsr UpdateInstrumentVolume
UpdateSoundChannel_NoInst1:
	;Get normal duty
	lda SoundDuty,x
	sta $E5
	;Check for end of note
	lda SoundTimerHi,x
	cmp SoundEchoEndHi,x
	beq UpdateSoundChannel_EchoFDHi
	bcs UpdateSoundChannel_NoEchoD
UpdateSoundChannel_EchoFDHi:
	lda SoundTimerLo,x
	cmp SoundEchoEndLo,x
	bcs UpdateSoundChannel_NoEchoD
	;Update echo fadeout
	dec SoundEchoFadeTimer,x
	bne UpdateSoundChannel_NoEchoF
	lda SoundEchoSettings,x
	and #$0F
	sta SoundEchoFadeTimer,x
	inc SoundEchoFade,x
UpdateSoundChannel_NoEchoF:
	;Update echo duty
	lda SoundEchoDuty,x
	and #$02
	beq UpdateSoundChannel_NoEchoD
	lda SoundEchoDuty,x
	and #$F0
	sta $E5
UpdateSoundChannel_NoEchoD:
	;Update echo volume/duty
	jsr UpdateEchoVolumeDuty
	;Check if SFX square channel is playing over square 1 channel
	jsr CheckForChannel0
	bcs UpdateSoundChannel_NoVolSet
	jmp OutputSoundVol
UpdateSoundChannel_NoVolSet:
	rts
UpdateSoundChannel_NextByte:
	;Increment sound data index
	iny
UpdateSoundChannel_GetByte:
	;Check for command byte $FB-$FF
	lda (TempSoundDataPointer),y
	cmp #$FB
	bcc UpdateSoundChannel_NoFx
	;Do jump table
	sec
	sbc #$FB
	jsr DoJumpTable_Sound
SoundCommandFxJumpTable:
	.dw SoundCommandFB	;$FB  Loop begin 2
	.dw SoundCommandFC	;$FC  Loop begin 1
	.dw SoundCommandFD	;$FD  Call
	.dw SoundCommandFE	;$FE  Loop end
	.dw SoundCommandFF	;$FF  Return
UpdateSoundChannel_NoFx:
	;Check for sound effect flag
	lda SoundControlFlags,x
	and #SF_SNDEFF
	beq UpdateSoundChannel_NoSE
	jmp UpdateSoundChannel_SE
	iny
UpdateSoundChannel_NoSE:
	;Get command byte
	lda (TempSoundDataPointer),y
	;Check for noise/DMC channel
	cpx #$05
	bne UpdateSoundChannel_NoNoise
	;Check for command byte $00-$DF (note command)
	cmp #$E0
	bcs UpdateSoundChannel_NoiseNoN
	jmp SoundCommandNote
UpdateSoundChannel_NoiseNoN:
	;Check for command byte $E0 (set base length)
	and #$0F
	bne UpdateSoundChannel_NoiseEx
	jmp SoundCommandE7
UpdateSoundChannel_NoiseEx:
	;Handle command byte $E1-$EF (set base length)
	sta SoundBaseLength,x
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_NoNoise:
	;Check for command byte $F0-$FA (set fade amount)
	cmp #$F0
	bcc UpdateSoundChannel_NoFxFade
	;Check for triangle channel
	cpx #$02
	beq UpdateSoundChannel_FxFadeTri
	;Set fade amount
	and #$0F
	sta SoundFade,x
UpdateSoundChannel_FxFadeTri:
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_NoFxFade:
	;Check for command byte $00-$CF (note command)
	cmp #$D0
	bcs UpdateSoundChannel_NoNote
	jmp SoundCommandNote
UpdateSoundChannel_NoNote:
	;Check for command byte $D0-$DF
	cmp #$E0
	bcc UpdateSoundChannel_Dx
	;Check for command byte $E0 (set instrument)
	cmp #$E0
	bne UpdateSoundChannel_Ex
	jmp SoundCommandE0
UpdateSoundChannel_Ex:
	;Check for command byte $E1-$E6 (set octave)
	and #$0F
	cmp #$07
	bcs UpdateSoundChannel_ExNoO
	;Set octave
	sta SoundOctave,x
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_ExNoO:
	;Handle command byte $E7-$EF
	sec
	sbc #$07
	;Check for triangle channel
	cpx #$02
	beq UpdateSoundChannel_ExTri
	jsr DoJumpTable_Sound
SoundCommandExJumpTable:
	.dw SoundCommandE7	;$E7  Set base length
	.dw SoundCommandE8	;$E8  Set echo settings
	.dw SoundCommandE9	;$E9  Set duty
	.dw SoundCommandEA	;$EA  Set pitch shift
	.dw SoundCommandEB	;$EB  Set instrument pitch
	.dw SoundCommandEC	;$EC  Set instrument volume
	.dw SoundCommandED	;$ED  Set pitch bend
	.dw SoundCommandEE	;$EE  Set tempo
	.dw SoundCommandEF	;$EF  Set global pitch shift
UpdateSoundChannel_Dx:
	;Check for triangle channel
	cpx #$02
	bne UpdateSoundChannel_DxNoTri
	;Check for command byte $D0
	cmp #$D0
	beq UpdateSoundChannel_DxNoTri
	jmp SoundCommandEx
UpdateSoundChannel_DxNoTri:
	;Handle command byte $D0-$DF
	and #$0F
	jsr DoJumpTable_Sound
SoundCommandDxJumpTable:
	.dw SoundCommandD0	;$D0  Tie
	.dw SoundCommandD1	;$D1  Set echo amount
	.dw SoundCommandD2	;$D2  Toggle portamento flag
	.dw SoundCommandD0	;$D3
	.dw SoundCommandD0	;$D4
	.dw SoundCommandD0	;$D5
	.dw SoundCommandD0	;$D6
	.dw SoundCommandD0	;$D7
	.dw SoundCommandD0	;$D8
	.dw SoundCommandD0	;$D9
	.dw SoundCommandD0	;$DA
	.dw SoundCommandD0	;$DB
	.dw SoundCommandD0	;$DC
	.dw SoundCommandD0	;$DD
	.dw SoundCommandD0	;$DE
	.dw SoundCommandD0	;$DF
UpdateSoundChannel_ExTri:
	;Handle command byte $E7-$EF
	jsr DoJumpTable_Sound
SoundCommandExTriJumpTable:
	.dw SoundCommandE7	;$E7  Set base length
	.dw SoundCommandEx	;$E8  No-op
	.dw SoundCommandEx	;$E9  No-op
	.dw SoundCommandEA	;$EA  Set pitch shift
	.dw SoundCommandEx	;$EB  No-op
	.dw SoundCommandEx	;$EC  No-op
	.dw SoundCommandED	;$ED  Set pitch bend
	.dw SoundCommandEE	;$EE  Set tempo
	.dw SoundCommandEF	;$EF  Set global pitch shift

;SOUND COMMAND ROUTINES
	iny
	iny

;$Ex: No-op
SoundCommandEx:
	iny
	jmp UpdateSoundChannel_NextByte

;$D0: Tie
SoundCommandD0:
	;Set tie flag
	lda SoundControlFlags,x
	ora #SF_TIE
	sta SoundControlFlags,x
	iny
	jmp SoundCommandNote

;$D1: Set echo amount
SoundCommandD1:
	;Set echo amount
	iny
	lda (TempSoundDataPointer),y
	beq SoundCommandD1_NoEcho
	cmp #$04
	bcc SoundCommandD1_SetEcho
	cmp #$07
	bcc SoundCommandD1_Inc
	lda #$07
	bne SoundCommandD1_SetEcho
SoundCommandD1_Inc:
	clc
	adc #$01
SoundCommandD1_SetEcho:
	ora #$C0
SoundCommandD1_NoEcho:
	sta SoundEchoAmount,x
	jmp UpdateSoundChannel_NextByte

;$D2: Toggle portamento flag
SoundCommandD2:
	;Toggle portamento flag
	lda SoundControlFlags,x
	eor #SF_PORTA
	sta SoundControlFlags,x
	jmp UpdateSoundChannel_NextByte

;$E0: Set instrument
SoundCommandE0:
	;Set base length and volume
	iny
	lda (TempSoundDataPointer),y
	sta SoundBaseLength,x
	iny
	lda (TempSoundDataPointer),y
	sta SoundVol,x
	;Check for triangle channel
	cpx #$02
	bne SoundCommandE0_NoTri
	jmp UpdateSoundChannel_NextByte
SoundCommandE0_NoTri:
	;Set duty and fade amount
	and #$F0
	sta SoundDuty,x
	lda SoundVol,x
	and #$0F
	sta SoundFade,x
	sta SoundVol,x
	;Set instrument volume
	iny
	lda (TempSoundDataPointer),y
	sta SoundInst1,x
	;Check if instrument volume or fadeout command
	and #$80
	beq SoundCommandE0_NoFade
	;Init fadeout command
	lda (TempSoundDataPointer),y
	and #$0F
	sta SoundInst1Pointer,x
	lda #$00
	sta SoundFade,x
SoundCommandE0_NoFade:
	;Set echo settings
	iny
	lda (TempSoundDataPointer),y
SoundCommandE0_SetEcho:
	;Check for echo fadeout timer
	sta SoundEchoSettings,x
	and #$0F
	bne SoundCommandE0_EchoFade
	;Disable echo fadeout timer
	lda SoundEchoSettings,x
	ora #$01
	sta SoundEchoSettings,x
	and #$0F
SoundCommandE0_EchoFade:
	sta SoundEchoFadeTimer,x
	jmp UpdateSoundChannel_NextByte

;$E7: Set base length
SoundCommandE7:
	;Set base length
	iny
	lda (TempSoundDataPointer),y
	sta SoundBaseLength,x
	jmp UpdateSoundChannel_NextByte

;$E8: Set echo settings
SoundCommandE8:
	;Set echo settings
	iny
	lda (TempSoundDataPointer),y
	jmp SoundCommandE0_SetEcho

;$E9: Set duty
SoundCommandE9:
	;Set duty
	lda #$0F
	sta SoundJumpTableSaveY
	iny
	lda (TempSoundDataPointer),y
	sta $E4
	beq SoundCommandE9_Echo
	bit SoundJumpTableSaveY
	beq SoundCommandE9_Norm
SoundCommandE9_Echo:
	;Set echo duty
	lda $E4
	sta SoundEchoDuty,x
	jmp UpdateSoundChannel_NextByte
SoundCommandE9_Norm:
	;Set normal duty
	sta SoundDuty,x
	jmp UpdateSoundChannel_NextByte

;$EA: Set pitch shift
SoundCommandEA:
	;Set pitch shift
	iny
	lda (TempSoundDataPointer),y
	sta SoundPitchShift,x
	jmp UpdateSoundChannel_NextByte

;$EB: Set instrument pitch
SoundCommandEB:
	;Set instrument pitch
	iny
	lda (TempSoundDataPointer),y
	sta SoundInst2,x
	;Check for pitch multiplier
	iny
	lda (TempSoundDataPointer),y
	bne SoundCommandEB_SetMult
	sta SoundInst2Multiplier,x
	jmp UpdateSoundChannel_NextByte
SoundCommandEB_SetMult:
	and #$0F
	sta SoundInst2Multiplier,x
	;Multiply instrument pitch timer start value by SoundBaseLength
	lda (TempSoundDataPointer),y
	lsr
	lsr
	lsr
	lsr
	beq SoundCommandEB_SetTimer
	sta $E4
	lda SoundBaseLength,x
SoundCommandEB_Loop:
	dec $E4
	beq SoundCommandEB_SetTimer
	clc
	adc SoundBaseLength,x
	jmp SoundCommandEB_Loop
SoundCommandEB_SetTimer:
	;Set instrument pitch timer start
	sta SoundInst2TimerStart,x
	jmp UpdateSoundChannel_NextByte

;$EC: Set instrument volume
SoundCommandEC:
	;Set instrument volume
	iny
	lda (TempSoundDataPointer),y
	sta SoundInst1,x
	jmp UpdateSoundChannel_NextByte

;$ED: Set pitch bend
SoundCommandED:
	;Set pitch bend
	iny
	lda (TempSoundDataPointer),y
	sta SoundPitch,x
	jmp UpdateSoundChannel_NextByte

;$EE: Set tempo
SoundCommandEE:
	;Set tempo
	iny
	lda (TempSoundDataPointer),y
	sta SoundTempoCompare
	lda #$00
	sta SoundTempoTimer
	jmp UpdateSoundChannel_NextByte

;$EF: Set global pitch shift
SoundCommandEF:
	;Set global pitch shift
	iny
	lda (TempSoundDataPointer),y
	sta SoundGlobalPitchShift
	jmp UpdateSoundChannel_NextByte

;$FB: Loop begin 2
SoundCommandFB:
	jsr IncSoundPointer
	;Set loop 2 flag
	lda SoundControlFlags,x
	ora #SF_LOOP2
	sta SoundControlFlags,x
	sty TempSoundDataIndex
	;Use repeat 2 pointers
	lda SoundCurChannel
	clc
	adc #(SoundRepeat2PtrLo-SoundRepeat1PtrLo)
	tay
SoundCommandFB_SetLoop:
	lda SoundPointersLo,x
	sta SoundRepeat1PtrLo,y
	lda SoundPointersHi,x
	sta SoundRepeat1PtrHi,y
	;Setup sound data pointers
	ldy TempSoundDataIndex
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte

;$FC: Loop begin 1
SoundCommandFC:
	jsr IncSoundPointer
	sty TempSoundDataIndex
	;Use repeat 1 pointers
	ldy SoundCurChannel
	jmp SoundCommandFB_SetLoop

;$FD: Call
SoundCommandFD:
	;Set in subroutine flag
	lda SoundControlFlags,x
	ora #SF_INSUB
	sta SoundControlFlags,x
	;Setup sound data pointers
	jsr SetSoundPointer
	jsr SetSoundReturnPointer
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte

;$FE: Loop end
SoundCommandFE:
	;Get loop count
	iny
	sty TempSoundDataIndex
	lda (TempSoundDataPointer),y
	sta $E4
	;Check for infinite loop
	cmp #$FF
	beq SoundCommandFE_DoInfin
	;Check for loop 2 flag
	ldy SoundCurChannel
	lda SoundControlFlags,x
	and #SF_LOOP2
	beq SoundCommandFE_NoLoop2
	;Use repeat 2 pointers
	lda SoundCurChannel
	clc
	adc #(SoundRepeat2PtrLo-SoundRepeat1PtrLo)
	tay
SoundCommandFE_NoLoop2:
	;Check for end of loop
	lda SoundRepeat1Counter,y
	clc
	adc #$01
	cmp $E4
	beq SoundCommandFE_EndLoop
	bmi SoundCommandFE_DoLoop
	;Decrement loop counter
	sec
	sbc #$01
SoundCommandFE_DoLoop:
	sta SoundRepeat1Counter,y
	;Setup sound data pointers
	lda SoundRepeat1PtrLo,y
	sta SoundPointersLo,x
	lda SoundRepeat1PtrHi,y
	sta SoundPointersHi,x
	ldy TempSoundDataIndex
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte
SoundCommandFE_EndLoop:
	;Check for loop 2 flag
	lda #SF_LOOP2
	sta $E4
	lda SoundControlFlags,x
	bit $E4
	beq SoundCommandFE_NoEnd2
	;Clear loop 2 flag
	and #~SF_LOOP2
	sta SoundControlFlags,x
SoundCommandFE_NoEnd2:
	;Clear loop counter
	lda #$00
	sta SoundRepeat1Counter,y
	;Setup sound data pointers
	ldy TempSoundDataIndex
	jsr IncSoundPointer
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte
SoundCommandFE_DoInfin:
	;Check for ending music
	lda SoundID
	cmp #MUSIC_CREDITS
	bne SoundCommandFE_NoEnding
	;Check for square 0 channel
	cpx #$00
	bne SoundCommandFE_NoEnding
	;Check if all demos have finished
	lda DemoEndAllFlag
	beq SoundCommandFE_NoEnding
	;Clear sound
	jsr ClearSoundSub
	;Load "THE END" music
	lda #MUSIC_THEEND
	sta SoundLoadID
	jmp LoadSoundInit
SoundCommandFE_NoEnding:
	;Setup sound data pointers
	jsr SetSoundPointer
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte

;$FF: Return
SoundCommandFF:
	;Check for in subroutine flag
	lda SoundControlFlags,x
	and #SF_INSUB
	beq SoundCommandFF_NoSub
	;Clear in subroutine flag
	lda SoundControlFlags,x
	and #~SF_INSUB
	sta SoundControlFlags,x
	;Setup sound data pointers
	lda SoundReturnPtrLo,x
	sta SoundPointersLo,x
	lda SoundReturnPtrHi,x
	sta SoundPointersHi,x
	jsr GetSoundPointer
	jmp UpdateSoundChannel_GetByte
SoundCommandFF_NoSub:
	;Get sound ID
	lda SoundID,x
	sta $E4
	;Clear sound state
	lda #$00
	sta SoundID,x
	sta SoundControlFlags,x
	sta SoundPriority,x
	;Check for noise/DMC channel
	cpx #$05
	beq SoundCommandFF_NoNoise
	;Clear square/tri/SFX square/SFX noise-only state variables
	sta SoundOutFreqHi,x
SoundCommandFF_NoNoise:
	;Check for noise/DMC channel
	cpx #$05
	beq SoundCommandFF_Exit
	;Check for SFX square channel
	cpx #$03
	bne SoundCommandFF_NoSet
	;Check for no music
	lda SoundID
	beq SoundCommandFF_NoSet
	jmp SetSoundRegs
SoundCommandFF_NoSet:
	;Check for triangle channel
	cpx #$02
	beq SoundCommandFF_Tri
	;Check if SFX square channel is playing over square 1 channel
	lda #$30
SoundCommandFF_Tri:
	jsr CheckForChannel0
	bcs SoundCommandFF_Exit
	jsr OutputSoundVol
	;Check for triangle channel
	cpx #$02
	bne SoundCommandFF_Exit
	;Set triangle channel rest output
	lda #$FF
	sta SoundOutFreqHi+2
	sta TRI_HI
SoundCommandFF_Exit:
	rts

SoundCommandNote_Noise:
	;If noise/DMC patch ID is 0, exit
	lda (TempSoundDataPointer),y
	lsr
	lsr
	lsr
	lsr
	beq SoundCommandNote_NoiseExit
	;Check for DMC patch
	sec
	sbc #$01
	tax
	cmp #$09
	bcc SoundCommandNote_GetID
	;Get DMC patch sound ID
	lda NoiseSoundIDTable,x
	sta SoundLoadID
	;Check for DMC snare drum
	cmp #DMC_SNARE
	beq SoundCommandNote_NoiseDMCSnare
	;Load DMC bass drum
	jmp LoadSoundDMC
SoundCommandNote_NoiseDMCSnare:
	;Load DMC snare drum
	jsr LoadSoundDMC
	lda #SE_SNARENOISE
	bne SoundCommandNote_SetID
SoundCommandNote_GetID:
	;Get noise patch sound ID
	lda NoiseSoundIDTable,x
SoundCommandNote_SetID:
	;Load sound
	sta SoundLoadID
	jsr LoadSoundInit
	ldx SoundCurChannel
SoundCommandNote_NoiseExit:
	rts
NoiseSoundIDTable:
	;$00
	.db SE_CLOSEDHHAT
	.db SE_OPENHHAT
	.db SE_SNARENOISE
	.db SE_BASSNOISE
	.db SE_BASSNOISE
	.db SE_BASSNOISE
	.db SE_BASSNOISE
	.db SE_BASSNOISE
	.db SE_BASSNOISE
	;$09
	.db DMC_SNARE
	.db DMC_BASS
	.db DMC_BASS
SoundCommandNote:
	;Get note length
	jsr IncSoundPointer
	dey
	lda (TempSoundDataPointer),y
	and #$0F
	bne SoundCommandNote_NoLen10
	lda #$10
SoundCommandNote_NoLen10:
	sta $E7
	;Check for tie
	lda SoundControlFlags,x
	bpl SoundCommandNote_NoTie
SoundCommandNote_TieLoop:
	;Check for end of tie
	iny
	lda (TempSoundDataPointer),y
	cmp #$D0
	beq SoundCommandNote_EndTie
	;Get tie length
	and #$0F
	bne SoundCommandNote_NoLen10T
	lda #$10
SoundCommandNote_NoLen10T:
	clc
	adc $E7
	sta $E7
	jmp SoundCommandNote_TieLoop
SoundCommandNote_EndTie:
	;Go to next byte and clear tie flag
	jsr IncSoundPointer
	dey
	dey
	lda SoundControlFlags,x
	and #(~SF_TIE)&$FF
	sta SoundControlFlags,x
SoundCommandNote_NoTie:
	;Multiply note length by base length
	lda SoundBaseLength,x
	tax
	jsr MultiplyNoteLength
	;Set note length timer
	lda $E5
	sta SoundTimerHi,x
	lda $E6
	sta SoundTimerLo,x
	;Check for noise/DMC channel
	cpx #$05
	bne SoundCommandNote_NoNoise
	jmp SoundCommandNote_Noise
SoundCommandNote_NoNoise:
	;Check for rest
	lda (TempSoundDataPointer),y
	and #$F0
	bne SoundCommandNote_NoRest
	;Set rest flag
	lda #SF_REST
	ora SoundControlFlags,x
	sta SoundControlFlags,x
	;Check for triangle channel
	cpx #$02
	beq SoundCommandNote_RestTri
	;Check for portamento
	lda SoundControlFlags,x
	and #SF_PORTA
	bne SoundCommandNote_RestExit
	;Check if SFX square channel is playing over square 1 channel
	lda #$30
	ora SoundDuty,x
	jsr CheckForChannel0
	bcs SoundCommandNote_RestExit
	jmp OutputSoundVol
SoundCommandNote_RestExit:
	rts
SoundCommandNote_RestTri:
	;Set triangle channel rest output
	lda #$00
	jsr OutputSoundVol
	lda #$FF
	sta SoundOutFreqHi+2
	jmp OutputSoundHi
SoundCommandNote_NoRest:
	;Clear rest flag
	lda SoundControlFlags,x
	and #~SF_REST
	sta SoundControlFlags,x
	;Check for triangle channel
	cpx #$02
	bne SoundCommandNote_NoTri
	;If triangle "volume" 0 or less, init triangle linear counter with special value
	lda SoundVol,x
	beq SoundCommandNote_TriVolZ
	bmi SoundCommandNote_TriVolN
	;Clear triangle linear timer
	lda #$00
	sta SoundTriLinearTimer
	;Calculate triangle linear timer reload value
	lda (TempSoundDataPointer),y
	and #$0F
	sta $E4
	lda $E4
	bne SoundCommandNote_NoLen10Tri
	lda #$10
SoundCommandNote_NoLen10Tri:
	sta $E4
SoundCommandNote_TriLinearLoop:
	clc
	adc SoundVol,x
	bcs SoundCommandNote_TriVolZ
	dec $E4
	bne SoundCommandNote_TriLinearLoop
	cmp #$80
	bne SoundCommandNote_TriLinearOver
	lda #$7F
SoundCommandNote_TriLinearOver:
	sta SoundTriLinearReload
SoundCommandNote_TriVolSet:
	sta $E4
	jmp SoundCommandNote_VolSet
SoundCommandNote_TriVolN:
	;Init triangle linear counter with $7F (control flag clear)
	and #$7F
	bpl SoundCommandNote_TriVolSet
SoundCommandNote_TriVolZ:
	;Init triangle linear counter with $8F (control flag set)
	lda #$8F
	bmi SoundCommandNote_TriVolSet
SoundCommandNote_NoTri:
	;Calculate echo end time
	sty TempSoundDataIndex
	lda #$00
	sta $E4
	sta $E5
	lda SoundEchoSettings,x
	lsr
	lsr
	lsr
	lsr
	sta $E6
	beq SoundCommandNote_NoEchoEnd
	tay
	lda #$00
SoundCommandNote_EELoLoop:
	clc
	adc SoundTimerLo,x
	bcc SoundCommandNote_EELoC
	inc $E5
SoundCommandNote_EELoC:
	dey
	bne SoundCommandNote_EELoLoop
	sta $E4
	lda $E6
	tay
	lda #$00
SoundCommandNote_EEHiLoop:
	clc
	adc SoundTimerHi,x
	bcc SoundCommandNote_EEHiC
	lda #$FF
	bne SoundCommandNote_EEHiSet
SoundCommandNote_EEHiC:
	dey
	bne SoundCommandNote_EEHiLoop
	clc
	adc $E5
SoundCommandNote_EEHiSet:
	sta $E5
	ldy #$04
SoundCommandNote_EEShLoop:
	lsr $E5
	ror $E4
	dey
	bne SoundCommandNote_EEShLoop
SoundCommandNote_NoEchoEnd:
	;Set echo end time
	lda $E5
	sta SoundEchoEndHi,x
	lda $E4
	sta SoundEchoEndLo,x
	;Clear instrument pointers/counters
	ldy TempSoundDataIndex
	lda #$00
	sta SoundInst1Pointer,x
	sta SoundInst1RepeatPointer,x
	sta SoundInst1RepeatCounter,x
	sta SoundEchoFade,x
	sta SoundInst2Pointer,x
	sta SoundInst2RepeatPointer,x
	sta SoundInst2RepeatCounter,x
	;Clear instrument timers
	lda #$01
	sta SoundInst1Timer,x
	lda SoundInst2TimerStart,x
	sta SoundInst2Timer,x
	;Check if instrument volume or fadeout command
	lda #$80
	sta SoundJumpTableSaveY
	lda SoundInst1,x
	bit SoundJumpTableSaveY
	bne SoundCommandNote_NoVol
	;Init instrument volume
	jsr UpdateInstrumentVolume
	jmp SoundCommandNote_NoFade
SoundCommandNote_NoVol:
	;Init instrument fadeout
	and #$0F
	sta SoundInst1Pointer,x
SoundCommandNote_NoFade:
	;Init echo volume/duty
	jsr InitEchoVolumeDuty
	jsr UpdateEchoVolumeDuty
	;Check if SFX square channel is playing over square 1 channel
	jsr CheckForChannel0
	bcs SoundCommandNote_NoVolSet
SoundCommandNote_VolSet:
	jsr OutputSoundVol
SoundCommandNote_NoVolSet:
	;Convert note number to frequency table index
	lda (TempSoundDataPointer),y
	lsr
	lsr
	lsr
	lsr
	sta $E4
	dec $E4
	lda SoundOctave,x
	tay
	lda $E4
SoundCommandNote_OctLoop:
	dey
	bmi SoundCommandNote_OctEnd
	clc
	adc #$0C
	bne SoundCommandNote_OctLoop
SoundCommandNote_OctEnd:
	sta $E4
	;Check for channel pitch shift
	lda SoundPitchShift,x
	beq SoundCommandNote_NoPSCh
	sta $E5
	jsr PitchShiftNote
SoundCommandNote_NoPSCh:
	;Check for global pitch shift
	lda SoundGlobalPitchShift
	beq SoundCommandNote_NoPSGlb
	sta $E5
	jsr PitchShiftNote
SoundCommandNote_NoPSGlb:
	;Check for frequency index $30-$5F
	lda $E4
	cmp #$30
	bcs SoundCommandNote_FreqHi
	;Handle frequency index $00-$2F
	asl
	tay
	lda FrequencyTable16+1,y
	sta SoundFreqHi,x
	lda FrequencyTable16,y
	sta SoundFreqLo,x
	jmp SoundCommandNote_DoEchoPitch
SoundCommandNote_FreqHi:
	;Handle frequency index $30-$5F
	clc
	adc #(FrequencyTable8-FrequencyTable16-$30)
	tay
	lda FrequencyTable16,y
	sta SoundFreqLo,x
	lda #$00
	sta SoundFreqHi,x
SoundCommandNote_DoEchoPitch:
	;Set length counter to max length (254 APU cycles)
	lda SoundFreqHi,x
	ora #$08
	sta SoundFreqHi,x
	;Check for square channel
	cpx #$02
	bcs SoundCommandNote_NoEcho
	;Check to fill echo buffer
	lda #$40
	sta $E4
	lda SoundEchoAmount,x
	bit $E4
	beq SoundCommandNote_EchoNoFill
	and #$BF
	sta SoundEchoAmount,x
	sty TempSoundDataIndex
	;Get echo buffer offset
	lda #$03
	sta $E4
	jsr UpdateSoundChannel_EchoOffs
	tay
SoundCommandNote_EchoFillLoop:
	;Set frequency to echo buffer
	lda SoundFreqLo,x
	sta SoundEchoBufferLo,y
	lda SoundFreqHi,x
	sta SoundEchoBufferHi,y
	;Loop to fill buffer
	dey
	dec $E4
	bpl SoundCommandNote_EchoFillLoop
	ldy TempSoundDataIndex
	jmp SoundCommandNote_NoEcho
SoundCommandNote_EchoNoFill:
	;Increment echo timer
	inc SoundEchoTimer,x
	sty TempSoundDataIndex
	;Get echo buffer offset
	lda SoundEchoTimer,x
	and #$03
	jsr UpdateSoundChannel_EchoOffs
	tay
	;Set frequency to echo buffer
	lda SoundFreqLo,x
	sta SoundEchoBufferLo,y
	lda SoundFreqHi,x
	sta SoundEchoBufferHi,y
	ldy TempSoundDataIndex
SoundCommandNote_NoEcho:
	;Init instrument pitch
	jsr GetSoundPitch
	lda #$00
	sta $E4
	;Check for triangle channel
	cpx #$02
	beq SoundCommandNote_PitchTri
	;Check for SFX noise channel
	cpx #$04
	beq SoundCommandNote_NoPitchCh
	;Check for sound effect
	lda SoundControlFlags,x
	and #SF_SNDEFF
	bne SoundCommandNote_NoPitchInst
	;If instrument pitch multiplier 0, don't update instrument pitch
	lda SoundInst2Multiplier,x
	beq SoundCommandNote_NoPitchInst
	;If instrument pitch timer not 0, don't update instrument pitch
	lda SoundInst2Timer,x
	bne SoundCommandNote_NoPitchInst
	;Update instrument pitch
	jsr UpdateInstrumentPitch
SoundCommandNote_NoPitchInst:
	;Check for bending pitch down
	lda $E4
	bmi SoundCommandNote_DownInst
	;Bend pitch up
	lda $EA
	sec
	sbc $E4
	sta $EA
	bcs SoundCommandNote_PitchC
	dec $EB
	jmp SoundCommandNote_PitchC
SoundCommandNote_DownInst:
	;Bend pitch down
	lda $EA
	sec
	sbc $E4
	sta $EA
	bcc SoundCommandNote_PitchC
	inc $EB
SoundCommandNote_PitchC:
	;Check for pitch bend
	lda SoundPitch,x
	beq SoundCommandNote_NoPitchCh
	;Check for bending pitch up
	bpl SoundCommandNote_UpCh
	;Bend pitch down
	and #$7F
	clc
	adc $EA
	sta $EA
	bcc SoundCommandNote_NoPitchCh
	inc $EB
	jmp SoundCommandNote_NoPitchCh
SoundCommandNote_UpCh:
	;Bend pitch up
	sta $E4
	lda $EA
	sec
	sbc $E4
	sta $EA
	bcs SoundCommandNote_NoPitchCh
	dec $EB
SoundCommandNote_NoPitchCh:
	;Check if output frequency is different
	lda $EB
	cmp SoundOutFreqHi,x
	bne SoundCommandNote_PitchNE
	;Check for 25% or 75% duty
	lda SoundDuty,x
	and #$10
	beq SoundCommandNote_PitchTri
	;Check for sweep flag
	lda SoundControlFlags,x
	and #SF_SWEEP
	bne SoundCommandNote_PitchTri
	beq SoundCommandNote_NoHiSet
SoundCommandNote_PitchNE:
	;Set output frequency hi
	sta SoundOutFreqHi,x
SoundCommandNote_PitchTri:
	;Check if SFX square channel is playing over square 1 channel
	lda $EB
	jsr CheckForChannel0
	bcs SoundCommandNote_NoHiSet
	;Output frequency hi
	jsr OutputSoundHi
SoundCommandNote_NoHiSet:
	;Check if SFX square channel is playing over square 1 channel
	lda $EA
	sta SoundOutFreqLo,x
	jsr CheckForChannel0
	bcs SoundCommandNote_NoLoSet
	;Output frequency lo
	jsr OutputSoundLo
SoundCommandNote_NoLoSet:
	rts

FrequencyTable16:
	.dw $0D5B,$0C9B,$0BE7,$0B3B,$0A99,$0A01,$0971,$08E9,$0869,$07F1,$077F,$0713
	.dw $06AD,$064D,$05F3,$059D,$054C,$0500,$04B8,$0474,$0434,$03F8,$03BF,$0389
	.dw $0356,$0326,$02F9,$02CE,$02A6,$0280,$025C,$023A,$021A,$01FB,$01DF,$01C4
	.dw $01AB,$0193,$017C,$0167,$0152,$013F,$012D,$011C,$010C,$00FD,$00EF,$00E1
FrequencyTable8:
	.db $D5,$C9,$BD,$B3,$A9,$9F,$96,$8E,$86,$7E,$77,$70
	.db $6A,$64,$5E,$59,$54,$4F,$4A,$46,$42,$3F,$3B,$38
	.db $34,$31,$2E,$2C,$29,$27,$25,$23,$21,$1F,$1D,$1B
	.db $1A,$18,$17,$15,$14,$13,$12,$11,$10,$0F,$0E,$0D

	.db $FF

UpdateSoundChannel_SE:
	;Check for command byte $00-$0F (rest/set base length)
	lda (TempSoundDataPointer),y
	and #$F0
	beq UpdateSoundChannel_SE_Base
	jmp UpdateSoundChannel_SE_Cmd
UpdateSoundChannel_SE_Base:
	;Check for triangle channel
	cpx #$02
	beq UpdateSoundChannel_SE_BaseTri
	;Check for SFX noise channel
	cpx #$04
	beq UpdateSoundChannel_SE_BaseNoise
	jmp UpdateSoundChannel_SE_BaseSq
UpdateSoundChannel_SE_BaseSq:
	;Check for $00 (rest)
	lda (TempSoundDataPointer),y
	bne UpdateSoundChannel_SE_NoSqRest
	;Set SFX square channel rest output
	lda SoundBaseLength,x
	sta SoundTimerLo,x
	lda #$30
	sta SQ1_VOL
	jmp IncSoundPointer
UpdateSoundChannel_SE_NoSqRest:
	;Set base length
	sta SoundBaseLength,x
	;Set duty
	iny
	lda (TempSoundDataPointer),y
	and #$F0
	sta SoundDuty,x
UpdateSoundChannel_SE_DF:
	;Set sweep flag
	iny
	lda SoundControlFlags,x
	ora #SF_SWEEP
	sta SoundControlFlags,x
	;Check if sweep value $00 or $88 (sweep disabled)
	lda (TempSoundDataPointer),y
	beq UpdateSoundChannel_SE_NoSweep
	cmp #$88
	bne UpdateSoundChannel_SE_Sweep
UpdateSoundChannel_SE_NoSweep:
	;Clear sweep flag
	lda SoundControlFlags,x
	and #~SF_SWEEP
	sta SoundControlFlags,x
UpdateSoundChannel_SE_Sweep:
	;Check if SFX square channel is playing over square 1 channel
	lda (TempSoundDataPointer),y
	jsr CheckForChannel0
	bcs UpdateSoundChannel_SE_NoSweepSet
	;Output sweep
	jsr OutputSoundSweep
	;Output frequency hi
	lda SoundOutFreqHi,x
	jsr OutputSoundHi
UpdateSoundChannel_SE_NoSweepSet:
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_SE_BaseTri:
	;Set base length
	lda (TempSoundDataPointer),y
	sta SoundBaseLength,x
	;Set linear timer
	iny
	lda (TempSoundDataPointer),y
	sta TRI_LINEAR
	jsr OutputSoundDummy
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_SE_BaseNoise:
	;Check for $00 (rest)
	lda (TempSoundDataPointer),y
	bne UpdateSoundChannel_SE_NoNoiseRest
	;Set SFX noise channel rest output
	lda SoundBaseLength,x
	sta SoundTimerLo,x
	lda #$30
	sta NOISE_VOL
	jmp IncSoundPointer
UpdateSoundChannel_SE_NoNoiseRest:
	;Set base length
	sta SoundBaseLength,x
	;Set duty
	lda #$30
	sta SoundDuty,x
	jmp UpdateSoundChannel_NextByte
UpdateSoundChannel_SE_Cmd:
	;Check for triangle channel
	cpx #$02
	bne UpdateSoundChannel_SE_CmdNoTri
	jmp UpdateSoundChannel_SE_CmdTri
UpdateSoundChannel_SE_CmdNoTri:
	;Check for SFX noise channel
	cpx #$04
	bne UpdateSoundChannel_SE_CmdNoNoise
	jmp UpdateSoundChannel_SE_CmdNoise
UpdateSoundChannel_SE_CmdNoNoise:
	;Check for command byte $DF (set sweep command)
	lda (TempSoundDataPointer),y
	cmp #$DF
	bne UpdateSoundChannel_SE_NoDF
	jmp UpdateSoundChannel_SE_DF
UpdateSoundChannel_SE_NoDF:
	;Check for command byte $E7-$EF
	cmp #$F0
	bcs UpdateSoundChannel_SE_Note
	cmp #$E7
	bcc UpdateSoundChannel_SE_Note
	jmp UpdateSoundChannel_SE_DoJump
UpdateSoundChannel_SE_NoteL:
	;Long note command (used if data would otherwise be a command byte value)
	iny
UpdateSoundChannel_SE_Note:
	;Init note
	jsr UpdateSoundChannel_SE_NoteSub
	;Check if SFX square channel is playing over square 1 channel
	jsr CheckForChannel0
	bcs UpdateSoundChannel_SE_NoVolSet
	jsr OutputSoundVol
UpdateSoundChannel_SE_NoVolSet:
	;Check for repeat flag
	lda SoundControlFlags,x
	and #SF_REPEAT
	bne UpdateSoundChannel_SE_NoRepeat
	;Set frequency
	lda (TempSoundDataPointer),y
	and #$07
	sta SoundFreqHi,x
	iny
	lda (TempSoundDataPointer),y
	sta SoundFreqLo,x
UpdateSoundChannel_SE_NoRepeat:
	;Update instrument echo/pitch
	jsr SoundCommandNote_DoEchoPitch
	jmp IncSoundPointer
UpdateSoundChannel_SE_CmdTri:
	;Set timer
	lda SoundBaseLength,x
	sta SoundTimerLo,x
	bne UpdateSoundChannel_SE_NoVolSet
UpdateSoundChannel_SE_CmdNoise:
	;Check for command byte $10 (long note command, used if data would otherwise be a command byte value)
	lda (TempSoundDataPointer),y
	cmp #$10
	bne UpdateSoundChannel_SE_NoNoteL
	iny
UpdateSoundChannel_SE_NoNoteL:
	;Init note
	jsr UpdateSoundChannel_SE_NoteSub
	jsr OutputSoundVol
	;Set frequency
	lda #$00
	sta SoundFreqHi,x
	lda (TempSoundDataPointer),y
	and #$0F
	sta SoundFreqLo,x
	jmp UpdateSoundChannel_SE_NoRepeat
UpdateSoundChannel_SE_NoteSub:
	;Set timer
	lda SoundBaseLength,x
	sta SoundTimerLo,x
	;Check for volume 0
	lda (TempSoundDataPointer),y
	lsr
	lsr
	lsr
	lsr
	beq UpdateSoundChannel_SE_VolZ
	;Check for SFX noise channel
	cpx #$04
	bne UpdateSoundChannel_SE_NoPatch
	;Check for noise patch
	sta $E4
	lda SoundID+4
	cmp #$05
	bcc UpdateSoundChannel_SE_Patch
	lda $E4
	jmp UpdateSoundChannel_SE_NoPatch
UpdateSoundChannel_SE_Patch:
	;Subtract fade volume
	lda $E4
	sec
	sbc SoundFadeoutTimer+1
	bcc UpdateSoundChannel_SE_VolC
UpdateSoundChannel_SE_NoPatch:
	;Check for SFX noise channel
	cpx #$04
	beq UpdateSoundChannel_SE_NoFade
	;Subtract fade volume
	sec
	sbc SoundFade,x
UpdateSoundChannel_SE_NoFade:
	ora #$00
	beq UpdateSoundChannel_SE_VolC
	bcs UpdateSoundChannel_SE_VolZ
UpdateSoundChannel_SE_VolC:
	;If underflow, set volume to 1
	lda #$01
UpdateSoundChannel_SE_VolZ:
	;Combine volume and duty values
	ora SoundDuty,x
	rts
UpdateSoundChannel_SE_DoJump:
	;Do jump table
	sec
	sbc #$E7
	jsr DoJumpTable_Sound
SoundCommandExSEJumpTable:
	.dw SoundCommandE7_SE		;$E7  Set base length
	.dw SoundCommandE8_SE		;$E8  Set fade amount
	.dw SoundCommandE9_SE		;$E9  Set duty
	.dw SoundCommandEA_SE		;$EA  Toggle repeat flag
	.dw UpdateSoundChannel_SE_NoteL	;$EB  Note
	.dw UpdateSoundChannel_SE_NoteL	;$EC
	.dw SoundCommandED		;$ED  Set pitch bend
	.dw SoundCommandED		;$EE
	.dw SoundCommandED		;$EF

;SOUND COMMAND ROUTINES (SOUND EFFECTS)
;$E7: Set base length
SoundCommandE7_SE:
	;Set base length
	iny
	lda (TempSoundDataPointer),y
	sta SoundBaseLength,x
	jmp UpdateSoundChannel_NextByte

;$EA: Toggle repeat flag
SoundCommandEA_SE:
	;Toggle repeat flag
	lda SoundControlFlags,x
	eor #SF_REPEAT
	sta SoundControlFlags,x
	jmp UpdateSoundChannel_NextByte

;$E8: Set fade amount
SoundCommandE8_SE:
	;Set fade amount
	iny
	lda (TempSoundDataPointer),y
	and #$0F
	sta SoundFade,x
	jmp UpdateSoundChannel_NextByte

;$E9: Set duty
SoundCommandE9_SE:
	;Set duty
	iny
	lda (TempSoundDataPointer),y
	and #$F0
	sta SoundDuty,x
	jmp UpdateSoundChannel_NextByte

.db $FF

UpdateInstrumentPitch:
	;Get instrument pitch pointer
	lda #$00
	sta $E4
	lda SoundInst2,x
	asl
	sty TempSoundDataIndex
	tay
	lda InstrumentPitchPointerTable,y
	sta $E4
	lda InstrumentPitchPointerTable+1,y
	sta $E5
	;Update sound instrument
	stx TempSoundDataIndex
	lda #$02
	clc
	adc TempSoundDataIndex
	tax
	jsr UpdateSoundInstrument
	;Set instrument timer
	ldx TempSoundDataIndex
	lda $E4
	lsr
	lsr
	lsr
	lsr
	sta SoundInst2Timer,x
	;Set instrument pitch
	lda $E4
	and #$0F
	sta $E4
	ldy SoundInst2Multiplier,x
	bne UpdateInstrumentPitch_DoMult
	tya
	beq UpdateInstrumentPitch_Set
UpdateInstrumentPitch_DoMult:
	lda #$08
	sta SoundJumpTableSaveY
	lda $E4
	bit SoundJumpTableSaveY
	beq UpdateInstrumentPitch_Loop
	ora #$F0
	sta $E4
UpdateInstrumentPitch_Loop:
	dey
	beq UpdateInstrumentPitch_Set
	clc
	adc $E4
	jmp UpdateInstrumentPitch_Loop
UpdateInstrumentPitch_Set:
	sta $E4
	ldy TempSoundDataIndex
	rts

GetSoundPitch:
	;Get sound frequency
	lda SoundFreqLo,x
	sta $EA
	lda SoundFreqHi,x
	sta $EB
	rts

UpdateInstrumentVolume:
	;Get instrument volume pointer
	lda SoundInst1,x
	asl
	sty TempSoundDataIndex
	tay
	lda InstrumentVolumePointerTable,y
	sta $E4
	lda InstrumentVolumePointerTable+1,y
	sta $E5
	;Update sound instrument
	jsr UpdateSoundInstrument
	;Set instrument volume and timer
	lda $E4
	and #$0F
	sta SoundVol,x
	lda $E4
	lsr
	lsr
	lsr
	lsr
	sta SoundInst1Timer,x
	ldy TempSoundDataIndex
	rts

UpdateEchoVolumeDuty:
	;Check if echo duty is different
	lda SoundEchoDuty,x
	and #$0C
	beq UpdateEchoVolumeDuty_NoDuty
	lsr
	lsr
	sta $E4
	;Check for end of note
	lda SoundTimerLo,x
	cmp SoundEchoEndLo,x
	bcc UpdateEchoVolumeDuty_NoEnd
UpdateEchoVolumeDuty_NoDuty:
	;Subtract fade volume
	lda SoundVol,x
	beq UpdateEchoVolumeDuty_VolZ
	sec
	sbc SoundFade,x
	bcc UpdateEchoVolumeDuty_VolC
	sec
	sbc SoundEchoFade,x
	bcc UpdateEchoVolumeDuty_VolC
	sec
	sbc SoundFadeoutTimer+1
	beq UpdateEchoVolumeDuty_VolC
	bcs UpdateEchoVolumeDuty_VolZ
UpdateEchoVolumeDuty_VolC:
	;If underflow, set volume to 1
	lda #$01
UpdateEchoVolumeDuty_VolZ:
	;Set volume
	sta $E4
UpdateEchoVolumeDuty_NoEnd:
	;Combine volume and duty values
	lda $E5
	ora $E4
	rts

InitEchoVolumeDuty:
	;Get duty
	lda SoundDuty,x
	sta $E5
	;Check for different echo duty
	lda #$01
	sta SoundJumpTableSaveY
	lda SoundEchoDuty,x
	bit SoundJumpTableSaveY
	beq UpdateEchoVolumeDuty_NoEnd
	;Get echo duty
	and #$F0
	sta $E5
	jmp UpdateEchoVolumeDuty_NoEnd

UpdateSoundInstrument:
	;Check for command byte $FB-$FF
	ldy SoundInst1Pointer,x
	lda ($E4),y
	cmp #$FB
	bcc UpdateSoundEnvelope_NoCmd
	;Check for command byte $FF (return)
	cmp #$FF
	beq UpdateSoundEnvelope_FF
	;Check for command byte $FE (loop end)
	cmp #$FE
	beq UpdateSoundEnvelope_FE
	bne UpdateSoundEnvelope_FB
UpdateSoundEnvelope_NoCmd:
	;Set instrument value
	sta $E4
	rts
UpdateSoundEnvelope_FB:
	;Handle command byte $FB (loop begin)
	inc SoundInst1Pointer,x
	lda SoundInst1Pointer,x
	sta SoundInst1RepeatPointer,x
	jmp UpdateSoundInstrument
UpdateSoundEnvelope_FE:
	;Handle command byte $FE (loop end)
	iny
	lda ($E4),y
	cmp SoundInst1RepeatCounter,x
	beq UpdateSoundEnvelope_NoLoop
	inc SoundInst1RepeatCounter,x
	lda SoundInst1RepeatPointer,x
	sta SoundInst1Pointer,x
	jmp UpdateSoundInstrument
UpdateSoundEnvelope_NoLoop:
	inc SoundInst1Pointer,x
	inc SoundInst1Pointer,x
	jmp UpdateSoundInstrument
UpdateSoundEnvelope_FF:
	;Handle command byte $FF (return)
	dec SoundInst1Pointer,x
	jmp UpdateSoundInstrument

PitchShiftNote:
	;Check for shifting pitch down
	lda $E5
	bmi PitchShiftNote_Down
	;Shift pitch up
	lsr
	lsr
	lsr
	lsr
	and #$07
	beq PitchShiftNote_UpOctEnd
	sta $E6
	lda $E4
PitchShiftNote_UpOctLoop:
	clc
	adc #$0C
	dec $E6
	bne PitchShiftNote_UpOctLoop
	sta $E4
PitchShiftNote_UpOctEnd:
	lda $E5
	and #$0F
	clc
	adc $E4
	sta $E4
	rts
PitchShiftNote_Down:
	;Shift pitch down
	lsr
	lsr
	lsr
	lsr
	and #$07
	beq PitchShiftNote_DnOctEnd
	sta $E6
	lda $E4
PitchShiftNote_DnOctLoop:
	sec
	sbc #$0C
	dec $E6
	bne PitchShiftNote_DnOctLoop
	sta $E4
PitchShiftNote_DnOctEnd:
	lda $E5
	and #$0F
	sta $E5
	lda $E4
	sec
	sbc $E5
	bcs PitchShiftNote_DownC
	lda #$00
PitchShiftNote_DownC:
	sta $E4
	rts

OutputSoundDummy:
	;Do nothing
	rts

GetSoundPointer:
	;Get sound data pointer
	ldy #$00
	lda SoundPointersLo,x
	sta TempSoundDataPointer
	lda SoundPointersHi,x
	sta TempSoundDataPointer+1
	rts

IncSoundPointer:
	;Increment sound data pointer
	iny
	tya
	clc
	adc TempSoundDataPointer
	sta SoundPointersLo,x
	bcc IncSoundPointer_NoC
	lda TempSoundDataPointer+1
	adc #$00
	sta SoundPointersHi,x
IncSoundPointer_NoC:
	rts

SetSoundPointer:
	;Set current sound data pointer
	iny
	lda (TempSoundDataPointer),y
	sta SoundPointersLo,x
	iny
	lda (TempSoundDataPointer),y
	sta SoundPointersHi,x
	rts

SetSoundReturnPointer:
	;Set return sound data pointer
	iny
	tya
	clc
	adc TempSoundDataPointer
	sta SoundReturnPtrLo,x
	lda TempSoundDataPointer+1
	adc #$00
	sta SoundReturnPtrHi,x
	rts

OutputSoundVol:
	;Set sound volume register
	jsr GetSoundOutIndex
	sta SQ1_VOL,x
	jmp GetSoundCurChannel

OutputSoundSweep:
	;Set sound sweep register
	jsr GetSoundOutIndex
	sta SQ1_SWEEP,x
	jmp GetSoundCurChannel

OutputSoundLo:
	;Set sound timer low register
	jsr GetSoundOutIndex
	sta SQ1_LO,x
	jmp GetSoundCurChannel

OutputSoundHi:
	;Set sound timer high register
	jsr GetSoundOutIndex
	sta SQ1_HI,x
	sta SQ1_HI,x
	jmp GetSoundCurChannel

GetSoundOutIndex:
	;Get sound register index
	sta $E4
	lda SoundOutIndexTable,x
	tax
	lda $E4
	rts
SoundOutIndexTable:
	.db $00,$04,$08,$00,$0C,$0C

GetSoundCurChannel:
	;Get current sound channel index
	jsr OutputSoundDummy
	ldx SoundCurChannel
	rts

CheckForChannel0:
	pha
	;Check for square 1 channel
	cpx #$00
	bne CheckForChannel0_No
	;Check for SFX square channel sound ID
	lda SoundID+3
	beq CheckForChannel0_No
	bne CheckForChannel0_Set
CheckForChannel0_Set:
	;Set carry flag
	sec
	pla
	rts
CheckForChannel0_No:
	;Clear carry flag
	clc
	pla
	rts

ClearSoundRegs:
	;Clear sound registers
	lda #$30
	sta SQ1_VOL
	jsr OutputSoundDummy
	sta SQ2_VOL
	jsr OutputSoundDummy
	sta NOISE_VOL
	jsr OutputSoundDummy
	lda #$00
	sta TRI_LINEAR
	jsr OutputSoundDummy
	lda #$FF
	sta SoundOutFreqHi+2
	sta TRI_HI
	jsr OutputSoundDummy
	rts

SetSoundRegs:
	;Set sound registers
	ldx #$00
	lda SoundDuty,x
	sta $E5
	lda #$00
	sta $E4
	lda #$7F
	sta SQ1_SWEEP
	jsr OutputSoundDummy
	lda SoundOutFreqLo
	sta SQ1_LO
	jsr OutputSoundDummy
	lda SoundOutFreqHi
	sta SQ1_HI
	sta SQ1_HI
	jsr OutputSoundDummy
	;Check if paused
	lda PausedFlag
	bne SetSoundRegs_NoVol
	;Check for no music
	lda SoundID
	beq SetSoundRegs_NoVol
	;Check for rest
	lda SoundControlFlags
	and #SF_REST
	bne SetSoundRegs_NoVol
	jsr UpdateEchoVolumeDuty_NoDuty
SetSoundRegs_NoVol:
	;Set sound volume register
	lda $E5
	ora $E4
	jsr OutputSoundVol
	ldx SoundCurChannel
	rts

MultiplyNoteLength:
	;Multiply $E7 by X and store in lo:$E5, hi:$E6
	lda #$00
	sta $E6
	stx $E8
	ldx #$08
MultiplyNoteLength_Loop:
	lsr $E8
	bcc MultiplyNoteLength_NoAdd
	clc
	adc $E7
MultiplyNoteLength_NoAdd:
	ror
	ror $E6
	dex
	bne MultiplyNoteLength_Loop
	sta $E5
	ldx SoundCurChannel
	rts

DoJumpTable_Sound:
	;Get jump table offset
	asl
	;Save X/Y registers
	stx SoundJumpTableSaveX
	sty SoundJumpTableSaveY
	;Get jump address
	tay
	iny
	pla
	sta TempSoundJumpPointer
	pla
	sta TempSoundJumpPointer+1
	lda (TempSoundJumpPointer),y
	tax
	iny
	lda (TempSoundJumpPointer),y
	sta TempSoundJumpPointer+1
	stx TempSoundJumpPointer
	;Restore X/Y registers
	ldy SoundJumpTableSaveY
	ldx SoundJumpTableSaveX
	;Jump to address
	jmp (TempSoundJumpPointer)

;;;;;;;;;;;;
;SOUND DATA;
;;;;;;;;;;;;
	.db $FF
;HEADERS
SndEff01Header:
	.db $01,$24
	.dw SndEff01Ch4Data
SndEff02Header:
	.db $01,$24
	.dw SndEff02Ch4Data
SndEff03Header:
	.db $01,$24
	.dw SndEff03Ch4Data
SndEff04Header:
	.db $01,$24
	.dw SndEff04Ch4Data
SndEff05Header:
	.db $10,$23
	.dw SndEff05Ch3Data
SndEff06Header:
	.db $10,$23
	.dw SndEff06Ch3Data
SndEff07Header:
	.db $20,$23
	.dw SndEff07Ch3Data
SndEff08Header:
	.db $20,$23
	.dw SndEff08Ch3Data
SndEff09Header:
	.db $20,$23
	.dw SndEff09Ch3Data
SndEff0AHeader:
	.db $2A,$63
	.dw SndEff0ACh3Data
	.db $24
	.dw SndEff0ACh4Data
SndEff0BHeader:
	.db $29,$23
	.dw SndEff0BCh3Data
SndEff0CHeader:
	.db $2A,$63
	.dw SndEff0CCh3Data
	.db $24
	.dw SndEff0CCh4Data
SndEff0DHeader:
	.db $2A,$23
	.dw SndEff0DCh3Data
SndEff0EHeader:
	.db $2A,$23
	.dw SndEff0ECh3Data
SndEff0FHeader:
	.db $2A,$23
	.dw SndEff0FCh3Data
SndEff10Header:
	.db $30,$23
	.dw SndEff10Ch3Data
SndEff11Header:
	.db $31,$23
	.dw SndEff11Ch3Data
SndEff12Header:
	.db $35,$23
	.dw SndEff12Ch3Data
SndEff13Header:
	.db $35,$23
	.dw SndEff13Ch3Data
SndEff14Header:
	.db $35,$24
	.dw SndEff14Ch4Data
SndEff15Header:
	.db $35,$24
	.dw SndEff15Ch4Data
SndEff16Header:
	.db $35,$24
	.dw SndEff16Ch4Data
SndEff17Header:
	.db $35,$23
	.dw SndEff17Ch3Data
SndEff18Header:
	.db $35,$23
	.dw SndEff18Ch3Data
SndEff19Header:
	.db $35,$23
	.dw SndEff19Ch3Data
SndEff1AHeader:
	.db $35,$63
	.dw SndEff1ACh3Data
	.db $24
	.dw SndEff1ACh4Data
SndEff1BHeader:
	.db $35,$24
	.dw SndEff1BCh4Data
SndEff1CHeader:
	.db $35,$23
	.dw SndEff1CCh3Data
SndEff1DHeader:
	.db $35,$63
	.dw SndEff1DCh3Data
	.db $24
	.dw SndEff1DCh4Data
SndEff1EHeader:
	.db $35,$23
	.dw SndEff1ECh3Data
SndEff1FHeader:
	.db $35,$63
	.dw SndEff1FCh3Data
	.db $24
	.dw SndEff1FCh4Data
SndEff20Header:
	.db $35,$23
	.dw SndEff20Ch3Data
SndEff21Header:
	.db $35,$63
	.dw SndEff21Ch3Data
	.db $24
	.dw SndEff21Ch4Data
SndEff22Header:
	.db $36,$63
	.dw SndEff22Ch3Data
	.db $24
	.dw SndEff22Ch4Data
SndEff23Header:
	.db $36,$23
	.dw SndEff23Ch3Data
SndEff24Header:
	.db $36,$63
	.dw SndEff24Ch3Data
	.db $24
	.dw SndEff24Ch4Data
SndEff25Header:
	.db $36,$63
	.dw SndEff25Ch3Data
	.db $24
	.dw SndEff25Ch4Data
SndEff26Header:
	.db $36,$24
	.dw SndEff26Ch4Data
SndEff27Header:
	.db $37,$23
	.dw SndEff27Ch3Data
SndEff28Header:
	.db $3F,$63
	.dw SndEff28Ch3Data
	.db $24
	.dw SndEff28Ch4Data
SndEff29Header:
	.db $40,$23
	.dw SndEff29Ch3Data
SndEff2AHeader:
	.db $40,$63
	.dw SndEff2ACh3Data
	.db $24
	.dw SndEff2ACh4Data
SndEff2BHeader:
	.db $40,$23
	.dw SndEff2BCh3Data
SndEff2CHeader:
	.db $41,$63
	.dw SndEff2CCh3Data
	.db $24
	.dw SndEff2CCh4Data
SndEff2DHeader:
	.db $41,$63
	.dw SndEff2DCh3Data
	.db $24
	.dw SndEff2DCh4Data
SndEff2EHeader:
	.db $44,$63
	.dw SndEff2ECh3Data
	.db $24
	.dw SndEff2ECh4Data
SndEff2FHeader:
	.db $44,$63
	.dw SndEff2FCh3Data
	.db $24
	.dw SndEff2FCh4Data
SndEff30Header:
	.db $44,$24
	.dw SndEff30Ch4Data
SndEff31Header:
	.db $44,$23
	.dw SndEff0ECh3Data
SndEff32Header:
	.db $45,$24
	.dw SndEff32Ch4Data
SndEff33Header:
	.db $45,$23
	.dw SndEff33Ch3Data
SndEff34Header:
	.db $45,$63
	.dw SndEff34Ch3Data
	.db $24
	.dw SndEff34Ch4Data
SndEff35Header:
	.db $46,$23
	.dw SndEff35Ch3Data
SndEff36Header:
	.db $46,$63
	.dw SndEff21Ch3Data
	.db $24
	.dw SndEff21Ch4Data
SndEff37Header:
	.db $4A,$23
	.dw SndEff37Ch3Data
SndEff38Header:
	.db $4A,$23
	.dw SndEff38Ch3Data
SndEff39Header:
	.db $4A,$23
	.dw SndEff39Ch3Data
SndEff3AHeader:
	.db $4A,$23
	.dw SndEff3ACh3Data
SndEff3BHeader:
	.db $50,$23
	.dw SndEff3BCh3Data
SndEff3CHeader:
	.db $60,$63
	.dw SndEff3CCh3Data
	.db $24
	.dw SndEff3CCh4Data
SndEff3DHeader:
	.db $70,$23
	.dw SndEff3DCh3Data
SndEff3EHeader:
	.db $80,$63
	.dw SndEff3ECh3Data
	.db $21
	.dw SndEff3ECh1Data
SndEff3FHeader:
	.db $80,$23
	.dw SndEff3FCh3Data
SndEff40Header:
	.db $85,$24
	.dw SndEff40Ch4Data
SndEff41Header:
	.db $91,$23
	.dw SndEff41Ch3Data
Music43Header:
	.db $FF,$C0
	.dw Music43Ch0Data
	.db $01
	.dw Music43Ch1Data
	.db $02
	.dw Music43Ch2Data
	.db $05
	.dw Music43Ch5Data
Music44Header:
	.db $FF,$C0
	.dw Music44Ch0Data
	.db $01
	.dw Music44Ch1Data
	.db $02
	.dw Music44Ch2Data
	.db $05
	.dw Music44Ch5Data
Music45Header:
	.db $FF,$C0
	.dw Music45Ch0Data
	.db $01
	.dw Music45Ch1Data
	.db $02
	.dw Music45Ch2Data
	.db $05
	.dw Music45Ch5Data
Music46Header:
	.db $FF,$C0
	.dw Music46Ch0Data
	.db $01
	.dw Music46Ch1Data
	.db $02
	.dw Music46Ch2Data
	.db $05
	.dw Music46Ch5Data
Music47Header:
	.db $FF,$C0
	.dw Music47Ch0Data
	.db $01
	.dw Music47Ch1Data
	.db $02
	.dw Music47Ch2Data
	.db $05
	.dw Music47Ch5Data
Music48Header:
	.db $FF,$C0
	.dw Music48Ch0Data
	.db $01
	.dw Music48Ch1Data
	.db $02
	.dw Music48Ch2Data
	.db $05
	.dw Music48Ch5Data
Music49Header:
	.db $FF,$C0
	.dw Music49Ch0Data
	.db $01
	.dw Music49Ch1Data
	.db $02
	.dw Music49Ch2Data
	.db $05
	.dw Music49Ch5Data
Music4AHeader:
	.db $FF,$C0
	.dw Music4ACh0Data
	.db $01
	.dw Music4ACh1Data
	.db $02
	.dw Music4ACh2Data
	.db $05
	.dw Music4ACh5Data
Music4BHeader:
	.db $FF,$C0
	.dw Music4BCh0Data
	.db $01
	.dw Music4BCh1Data
	.db $02
	.dw Music4BCh2Data
	.db $05
	.dw Music4BCh5Data
Music4CHeader:
	.db $FF,$C0
	.dw Music4CCh0Data
	.db $01
	.dw Music4CCh1Data
	.db $02
	.dw Music4CCh2Data
	.db $05
	.dw Music4CCh5Data
Music4DHeader:
	.db $FF,$C0
	.dw Music4DCh0Data
	.db $01
	.dw Music4DCh1Data
	.db $02
	.dw Music4DCh2Data
	.db $05
	.dw Music4DCh5Data
Music4EHeader:
	.db $FF,$C0
	.dw Music4ECh0Data
	.db $01
	.dw Music4ECh1Data
	.db $02
	.dw Music4ECh2Data
	.db $05
	.dw Music4ECh5Data
Music4FHeader:
	.db $FF,$C0
	.dw Music4FCh0Data
	.db $01
	.dw Music4FCh1Data
	.db $02
	.dw Music4FCh2Data
	.db $05
	.dw Music4FCh5Data
Music50Header:
	.db $FF,$C0
	.dw Music50Ch0Data
	.db $01
	.dw Music50Ch1Data
	.db $02
	.dw Music50Ch2Data
	.db $05
	.dw Music50Ch5Data
Music51Header:
	.db $FF,$C0
	.dw Music51Ch0Data
	.db $01
	.dw Music51Ch1Data
	.db $02
	.dw Music51Ch2Data
	.db $05
	.dw Music51Ch5Data
Music52Header:
	.db $FF,$C0
	.dw Music52Ch0Data
	.db $01
	.dw Music52Ch1Data
	.db $02
	.dw Music52Ch2Data
	.db $05
	.dw Music52Ch5Data
Music53Header:
	.db $FF,$C0
	.dw Music53Ch0Data
	.db $01
	.dw Music53Ch1Data
	.db $02
	.dw Music53Ch2Data
	.db $05
	.dw Music53Ch5Data
Music54Header:
	.db $FF,$C0
	.dw Music54Ch0Data
	.db $01
	.dw Music54Ch1Data
	.db $02
	.dw Music54Ch2Data
	.db $05
	.dw Music54Ch5Data
Music55Header:
	.db $FF,$C0
	.dw Music55Ch0Data
	.db $01
	.dw Music55Ch1Data
	.db $02
	.dw Music55Ch2Data
	.db $05
	.dw Music55Ch5Data
Music56Header:
	.db $FF,$C0
	.dw Music56Ch0Data
	.db $01
	.dw Music56Ch1Data
	.db $02
	.dw Music56Ch2Data
	.db $05
	.dw Music56Ch5Data
Music57Header:
	.db $FF,$C0
	.dw Music57Ch0Data
	.db $01
	.dw Music57Ch1Data
	.db $02
	.dw Music57Ch2Data
	.db $05
	.dw Music57Ch5Data
DMC5CHeader:
	.db $FF,$06
	.dw DMCInstrumentTable+$00
DMC5DHeader:
	.db $FF,$06
	.dw DMCInstrumentTable+$04
	.db $FF

SoundHeaderPointerTable:
	;SOUND EFFECTS
	.dw SndEff01Header	;$01  Noise patch (closed hi-hat)
	.dw SndEff02Header	;$02  Noise patch (open hi-hat)
	.dw SndEff03Header	;$03  Noise patch (bass noise, UNUSED)
	.dw SndEff04Header	;$04  Noise patch (snare noise, UNUSED)
	.dw SndEff05Header	;$05  Player landing
	.dw SndEff06Header	;$06  Player jumping
	.dw SndEff07Header	;$07  Player shooting (Bucky/Blinky)
	.dw SndEff08Header	;$08  Player shooting (Jenny/Willy)
	.dw SndEff09Header	;$09  Player shooting (Dead-Eye)
	.dw SndEff0AHeader	;$0A  Lightning/ceiling laser
	.dw SndEff0BHeader	;$0B  Buzzing effect
	.dw SndEff0CHeader	;$0C  Ice block landing
	.dw SndEff0DHeader	;$0D  Shoot laser
	.dw SndEff0EHeader	;$0E  Whir effect short
	.dw SndEff0FHeader	;$0F  Shoot toward front
	.dw SndEff10Header	;$10  Player charging
	.dw SndEff11Header	;$11  Player charging 2
	.dw SndEff12Header	;$12  Tree platform fall
	.dw SndEff13Header	;$13  Vine platform fall
	.dw SndEff14Header	;$14  Splash
	.dw SndEff15Header	;$15  Trooper melting ice
	.dw SndEff16Header	;$16  BG fire arch
	.dw SndEff17Header	;$17  BG fire snake
	.dw SndEff18Header	;$18  Gravity area moving up
	.dw SndEff19Header	;$19  Gravity area moving down
	.dw SndEff1AHeader	;$1A  Minecart moving
	.dw SndEff1BHeader	;$1B  BG snake
	.dw SndEff1CHeader	;$1C  BG robot from behind glass
	.dw SndEff1DHeader	;$1D  Machine gun effect
	.dw SndEff1EHeader	;$1E  BG fake block
	.dw SndEff1FHeader	;$1F  Beetle in wall
	.dw SndEff20Header	;$20  Enemy grabbing
	.dw SndEff21Header	;$21  BG chute crusher
	.dw SndEff22Header	;$22  Jenny light ball
	.dw SndEff23Header	;$23  Dead-eye grab wall
	.dw SndEff24Header	;$24  Willy power shoot
	.dw SndEff25Header	;$25  Blinky flying
	.dw SndEff26Header	;$26  Minecart slowing down
	.dw SndEff27Header	;$27  Elevator
	.dw SndEff28Header	;$28  Enemy hit invincible
	.dw SndEff29Header	;$29  Player hit
	.dw SndEff2AHeader	;$2A  Enemy kill
	.dw SndEff2BHeader	;$2B  Enemy hit
	.dw SndEff2CHeader	;$2C  Crash effect
	.dw SndEff2DHeader	;$2D  Dive bomber
	.dw SndEff2EHeader	;$2E  Whir/laser effect 1
	.dw SndEff2FHeader	;$2F  Whir/laser effect 2
	.dw SndEff30Header	;$30  Big ball rolling
	.dw SndEff31Header	;$31  Whir effect long
	.dw SndEff32Header	;$32  Blast effect
	.dw SndEff33Header	;$33  Level 6 boss fall
	.dw SndEff34Header	;$34  Break glass
	.dw SndEff35Header	;$35  Hypnotizing teammate
	.dw SndEff36Header	;$36  Level 6 boss land
	.dw SndEff37Header	;$37  Powerup
	.dw SndEff38Header	;$38  1-UP
	.dw SndEff39Header	;$39  Lifeup
	.dw SndEff3AHeader	;$3A  Bonus coin
	.dw SndEff3BHeader	;$3B  Password scene
	.dw SndEff3CHeader	;$3C  Boss kill
	.dw SndEff3DHeader	;$3D  Cursor move
	.dw SndEff3EHeader	;$3E  Cursor select
	.dw SndEff3FHeader	;$3F  Invalid password
	.dw SndEff40Header	;$40  Dialog typing
	.dw SndEff41Header	;$41  Pause
	;MUSIC
	.dw Music43Header	;$42  Unused duplicate of level 1
	.dw Music43Header	;$43  Level 1
	.dw Music44Header	;$44  Level 2
	.dw Music45Header	;$45  Level 3
	.dw Music46Header	;$46  Level 4
	.dw Music47Header	;$47  Level 5
	.dw Music48Header	;$48  Level 6
	.dw Music49Header	;$49  Level 8
	.dw Music4AHeader	;$4A  Level 7
	.dw Music4BHeader	;$4B  Boss 1
	.dw Music4CHeader	;$4C  Boss 2
	.dw Music4DHeader	;$4D  Title screen
	.dw Music4EHeader	;$4E  Scene 1
	.dw Music4FHeader	;$4F  Scene 2
	.dw Music50Header	;$50  Scene 3
	.dw Music51Header	;$51  Stage select
	.dw Music52Header	;$52  Character rescued
	.dw Music53Header	;$53  Death
	.dw Music54Header	;$54  Game over
	.dw Music55Header	;$55  Stage clear
	.dw Music56Header	;$56  Credits
	.dw Music57Header	;$57  "THE END"
	;DMC
	.dw DMC5CHeader		;$58 \Unused duplicates of DMC snare drum
	.dw DMC5CHeader		;$59 |
	.dw DMC5CHeader		;$5A |
	.dw DMC5CHeader		;$5B /
	.dw DMC5CHeader		;$5C   DMC snare drum
	.dw DMC5DHeader		;$5D   DMC bass drum

;SOUND EFFECT DATA
	.db $FF
SndEff01Ch4Data:
	.db $01,$65,$24,$21,$11
	.db $FF
SndEff02Ch4Data:
	.db $01,$A2,$A1,$71,$02,$61,$61,$50,$51,$50,$51,$50,$41,$30,$20,$20
	.db $06,$11
	.db $FF
SndEff03Ch4Data:
	.db $FF
SndEff04Ch4Data:
	.db $FF
SndEff09Ch3Data:
	.db $01,$70,$92,$50,$EC,$E0,$5F,$F0,$39,$05,$70,$92,$30,$38,$20,$37
	.db $10,$37
	.db $FF
SndEff05Ch3Data:
	.db $01,$70,$81,$C0,$63,$10,$55,$20,$5F,$80,$65,$FF,$06,$B0,$82,$91
	.db $1D,$A1,$1D,$08,$70,$83,$C0,$E2,$A0,$E1,$80,$E0,$70,$DF,$60,$DE
	.db $50,$DD,$40,$DC,$30,$DB,$20,$DA,$10,$D9,$10,$D8,$FF,$01,$9D,$4C
	.db $8E,$3D,$8D,$6E,$9C,$4D,$9C,$04,$DC,$7D,$BC,$5D,$9C,$5D,$7C,$3D
	.db $5C,$4D,$4C,$3D,$3C,$2D,$2C,$1D,$1C
	.db $FF
SndEff23Ch3Data:
	.db $02,$B0,$8B,$40,$E2,$D0,$AA
	.db $FF
SndEff39Ch3Data:
	.db $03,$70,$88,$A0,$6B,$A0,$55,$A0,$35,$90,$55,$90,$40,$90,$50,$90
	.db $32,$80,$47,$80,$39,$80,$35,$80,$2A,$80,$29,$20,$39,$20,$35,$20
	.db $2A,$20,$29
	.db $FF
SndEff37Ch3Data:
	.db $04,$70,$8C,$B0,$4E,$A0,$55,$B0,$EF,$81,$23,$70,$BB,$03,$70,$8C
	.db $B0,$BB,$B0,$AA,$B0,$88,$30,$88,$90,$77,$30,$77,$80,$66,$30,$66
	.db $70,$55,$10,$55,$A0,$44,$30,$44,$A0,$33,$10,$33,$A0,$22,$20,$11
	.db $10,$22
	.db $FF
SndEff3ACh3Data:
	.db $04,$70,$88,$C0,$2A,$C0,$35,$A0,$2A,$A0,$35,$90,$2A,$90,$35,$20
	.db $2A,$20,$35
	.db $FF
SndEff38Ch3Data:
	.db $05,$B0,$88,$C0,$2A,$C0,$35,$C0,$1A,$80,$2A,$80,$35,$80,$1A,$20
	.db $2A,$20,$35,$20,$1A
	.db $FF
SndEff06Ch3Data:
	.db $01,$B0,$88,$D0,$40,$E0,$3E,$D0,$3C,$C0,$3A,$B0,$38,$A0,$34,$90
	.db $32,$80,$30,$70,$2E,$60,$2C,$50,$2A,$40,$28,$30,$26,$20,$24,$20
	.db $22,$10,$20
	.db $FF
SndEff29Ch3Data:
	.db $02,$30,$84,$D1,$AC,$30,$87,$C0,$67,$90,$43,$20,$43,$80,$43,$08
	.db $30,$84,$10,$43
	.db $FF
SndEff0BCh3Data:
	.db $01,$30,$83,$13,$66,$23,$66,$33,$66,$FB,$72,$00,$FE,$30,$82,$00
	.db $92,$00,$A2,$00,$B2,$00,$FB,$D2,$00,$FE,$10,$A2,$00,$82,$00,$63
	.db $00,$43,$00,$33,$00,$23,$00,$13,$00
	.db $FF
SndEff10Ch3Data:
	.db $03,$30,$83,$81,$AC,$81,$7D,$81,$53,$91,$2E,$91,$1D,$90,$F0,$90
	.db $E2,$A0,$CA,$A0,$B4,$A0,$A0,$A0,$8F,$A0,$85
	.db $FF
SndEff11Ch3Data:
	.db $04,$30,$83,$A0,$85
	.db $FF
SndEff2CCh3Data:
	.db $02,$B0,$82,$D0,$FE,$A1,$E0,$93,$57
	.db $FF
SndEff2CCh4Data:
	.db $03,$DD,$4E,$04,$10,$FE,$EC,$CC,$8D,$7D,$6E,$5E,$4E,$3E,$2E,$1D
	.db $FF
SndEff2ACh3Data:
	.db $01,$30,$88,$D1,$F6,$03,$30,$8B,$C1,$16,$80,$F6,$10,$C6
	.db $FF
SndEff2ACh4Data:
	.db $01,$DE,$CD,$CA,$B4,$B5,$A6,$A7,$04,$59,$AD,$5D,$2C,$1C
	.db $FF
SndEff2BCh3Data:
	.db $03,$30,$83,$51,$39,$A0,$89,$70,$5A,$10,$5A
	.db $FF
SndEff28Ch3Data:
	.db $02,$B0,$88,$D0,$1C,$A0,$1D,$E7,$08,$E0,$12,$90,$12,$20,$12
	.db $FF
SndEff28Ch4Data:
	.db $01,$85,$13,$A3
	.db $FF
SndEff0ECh3Data:
	.db $01,$30,$89,$41,$E6,$61,$DA,$71,$AE,$FB,$81,$7F,$91,$76,$FE,$13
	.db $83,$C0
	.db $FF
SndEff3CCh3Data:
	.db $01,$B0,$83,$F2,$74,$62,$74,$00,$08,$B0,$83,$A1,$3F,$A1,$6C,$91
	.db $81,$51,$81,$41,$86,$FB,$01,$B0,$83,$F2,$74,$62,$74,$22,$74,$08
	.db $B1,$83,$A1,$3F,$A1,$6C,$91,$81,$FE,$05,$01,$B0,$83,$F2,$74,$62
	.db $74,$08,$B0,$82,$A1,$3F,$A2,$00,$82,$33,$62,$34,$52,$34,$42,$35
	.db $32,$36,$22,$37,$12,$37
	.db $FF
SndEff3CCh4Data:
	.db $01,$10,$FE,$10,$FE,$00,$08,$F9,$10,$FE,$FA,$EA,$9C,$FB,$01,$10
	.db $FE,$10,$FE,$00,$08,$F9,$10,$FE,$FA,$FE,$04,$0A,$10,$FE,$F9,$10
	.db $FA,$FC,$10,$FD,$06,$ED,$DD,$CE,$BD,$AE,$9D,$8E,$7D,$6E,$5D,$4E
	.db $3D,$2E,$1D
	.db $FF
SndEff12Ch3Data:
	.db $09,$B0,$89,$A0,$5F,$50,$4B
	.db $FF
SndEff13Ch3Data:
	.db $03,$70,$83,$73,$A7,$A3,$63,$D0,$D0,$C0,$D0,$90,$D0,$60,$CF,$40
	.db $D0,$30,$CD,$20,$D9,$10,$D8
	.db $FF
SndEff14Ch4Data:
	.db $02,$9C,$5A,$8B,$1B,$1B,$04,$DA,$D8,$D9,$D8,$C9,$C8,$99,$98,$79
	.db $78,$59,$58,$49,$48,$27,$28,$17,$17
	.db $FF
SndEff21Ch3Data:
	.db $04,$B0,$83,$D2,$77,$E2,$00,$03,$70,$82,$A1,$22,$91,$22,$71,$22
	.db $61,$22,$51,$22,$41,$22,$31,$22,$21,$22,$11,$22
	.db $FF
SndEff21Ch4Data:
	.db $04,$EE,$9D,$5D,$2E,$1D
	.db $FF
SndEff15Ch4Data:
	.db $01,$3E,$7E,$AE,$DE,$0C,$FB,$10,$FE,$FE,$04,$02,$EE,$DE,$CE,$BE
	.db $AE,$9E,$8E,$7E,$6E,$5E,$4E,$3E,$2E,$1E
	.db $FF
SndEff16Ch4Data:
	.db $01,$FB,$6E,$7D,$FE,$02,$8E,$9D,$9E,$AD,$04,$DB,$EB,$EC,$ED,$ED
	.db $DE,$CE,$BE,$AE,$9E,$8E,$7E,$6E,$5E,$4E,$3E,$2E,$1E
	.db $FF
SndEff17Ch3Data:
	.db $05,$B0,$8B,$C4,$11,$33,$11,$08,$B0,$8C,$D3,$40,$93,$40,$A2,$40
	.db $32,$40,$12,$40
	.db $FF
SndEff0CCh3Data:
	.db $05,$70,$8A,$C0,$9A,$30,$9A,$A0,$50,$20,$20,$30,$20,$20,$0F,$10
	.db $0F
	.db $FF
SndEff0CCh4Data:
	.db $01,$5A,$8B,$6D,$59,$49,$3B,$0A,$57,$17
	.db $FF
SndEff1BCh4Data:
	.db $01,$AA,$C3,$03,$FB,$C7,$96,$19,$FE,$04,$05,$E5,$C8,$13
	.db $FF
SndEff1CCh3Data:
	.db $01,$30,$89,$71,$E6,$91,$DA,$81,$AE,$FB,$A1,$7F,$91,$76,$FE,$0B
	.db $FF
SndEff2FCh3Data:
	.db $01,$30,$8A,$50,$30,$60,$2E,$70,$2C,$A0,$2A,$90,$29,$B0,$27,$C0
	.db $25,$D0,$31,$FB,$E0,$30,$FE,$1F,$05,$70,$89,$B0,$20,$60,$20,$40
	.db $20,$20,$20,$10,$20
	.db $FF
SndEff2FCh4Data:
	.db $01,$A3,$23,$C3,$61,$B3,$81,$C3,$61,$D3,$41,$FB,$E1,$81,$FE,$04
	.db $05,$C1,$A1,$81,$61,$41,$21,$11
	.db $FF
SndEff32Ch4Data:
	.db $01,$89,$9E,$AD,$DD,$EC,$3C,$2A,$19,$03,$F5,$F6,$E7,$D8,$C9,$BA
	.db $BB,$9C,$8C,$7D,$6D,$5D,$4D,$3D,$2D,$1E
	.db $FF
SndEff1DCh3Data:
	.db $01,$F0,$83,$FB,$A2,$00,$71,$1C,$51,$C5,$A0,$08,$FE,$07
	.db $FF
SndEff1DCh4Data:
	.db $01,$FB,$D9,$BE,$2A,$19,$FE,$08,$03,$5E,$3E,$2E,$1D
	.db $FF
SndEff0FCh3Data:
	.db $01,$70,$83,$30,$BE,$40,$AA,$60,$97,$80,$87,$A0,$78,$B0,$6B,$C0
	.db $5F,$FB,$A0,$71,$90,$6B,$FE,$03,$A0,$6B,$80,$78,$60,$87,$40,$97
	.db $07,$30,$85,$30,$AA,$10,$BE
	.db $FF
SndEff0DCh3Data:
	.db $01,$F0,$83,$30,$7E,$80,$6A,$10,$57,$10,$37,$E7,$09,$70,$30,$10
	.db $30
	.db $FF
SndEff3DCh3Data:
	.db $01,$B0,$88,$D0,$18,$D0,$1A,$D0,$32,$D0,$30,$03,$30,$88,$30,$18
	.db $30,$1A,$30,$32,$30,$30,$20,$18,$20,$1A,$20,$32,$20,$30,$10,$32
	.db $10,$30
	.db $FF
SndEff3ECh3Data:
	.db $04,$70,$88,$B0,$97,$B0,$8F,$B0,$71,$B0,$5F,$80,$4B,$80,$39,$20
	.db $97,$20,$8F,$20,$71,$20,$5F,$20,$4B,$10,$39
	.db $FF
SndEff3ECh1Data:
	.db $03,$30,$88,$A0,$99,$A0,$91,$A0,$73,$90,$61,$90,$4D,$90,$3B,$20
	.db $99,$20,$91,$20,$73,$20,$61,$20,$4D,$10,$3B
	.db $FF
SndEff35Ch3Data:
	.db $03,$F0,$82,$40,$6F,$40,$6E,$50,$6D,$50,$6C,$60,$6B,$60,$6A,$70
	.db $69,$70,$68,$80,$67,$80,$66,$90,$65,$90,$64,$A0,$63,$A0,$62,$B0
	.db $61,$B0,$60,$C0,$5F,$C0,$5E,$C0,$5D,$C0,$5C,$C0,$5B,$08,$70,$82
	.db $FB,$D0,$4A,$FE,$0C,$08,$30,$83,$20,$4A,$10,$4A
	.db $FF
SndEff1ECh3Data:
	.db $05,$70,$BA,$F0,$14,$30,$14,$F0,$10,$20,$10,$10,$10
	.db $FF
SndEff1FCh3Data:
	.db $02,$30,$82,$D3,$27,$13,$27,$82,$81,$12,$81,$81,$FC
	.db $FF
SndEff1FCh4Data:
	.db $02,$FB,$A6,$12,$DD,$1E,$FE,$02
	.db $FF
SndEff20Ch3Data:
	.db $04,$30,$83,$80,$4B
	.db $FF
SndEff33Ch3Data:
	.db $03,$B0,$88,$FB,$80,$3A,$FE,$08,$80,$3C,$80,$3D,$80,$3E,$80,$3F
	.db $80,$40,$80,$41,$80,$42,$80,$43,$80,$44,$80,$45,$80,$46,$80,$47
	.db $80,$48,$80,$49,$80,$4A,$80,$4B,$80,$4C,$80,$4D,$80,$4E,$80,$4F
	.db $80,$50,$80,$51,$80,$52,$80,$53,$80,$54,$80,$55,$80,$56,$80,$57
	.db $80,$58,$80,$59,$80,$5A,$80,$5B,$80,$5C,$80,$5D,$80,$5E,$80,$5F
	.db $80,$60
	.db $FF
SndEff0ACh3Data:
	.db $FB,$01,$30,$89,$80,$44,$22,$00,$71,$00,$60,$84,$22,$00,$41,$00
	.db $FE,$03,$E7,$03,$20,$40,$10,$40
	.db $FF
SndEff0ACh4Data:
	.db $01,$FB,$C2,$6A,$B2,$1A,$FE,$03,$FB,$C3,$77,$A2,$2A,$FE,$02,$04
	.db $23,$13
	.db $FF
SndEff27Ch3Data:
	.db $02,$70,$81,$50,$D6,$60,$CA,$70,$BE,$80,$B4,$90,$AA,$A0,$A0,$A0
	.db $97,$A0,$8F,$A0,$87,$FB,$80,$7F,$90,$7F,$FE,$20
	.db $FF
SndEff08Ch3Data:
	.db $01,$70,$8B,$30,$5F,$20,$5C,$06,$70,$8B,$90,$54,$40,$5D,$20,$60
	.db $FF
SndEff07Ch3Data:
	.db $03,$30,$82,$C0,$72,$A0,$17,$80,$5B,$30,$4B,$20,$4B,$10,$4B
	.db $FF
SndEff25Ch3Data:
	.db $01,$30,$82,$A0,$D6,$A0,$CA,$A0,$BE,$A0,$B4,$A0,$AA,$90,$A0,$90
	.db $97,$80,$8F,$80,$7F,$70,$78,$60,$71,$50,$6B,$40,$65,$40,$5F,$30
	.db $5A,$20,$55,$10,$50
	.db $FF
SndEff25Ch4Data:
	.db $02,$87,$79,$9A,$8B,$FB,$8C,$FE,$04,$7C,$8C,$03,$7C,$6C,$5C,$4C
	.db $2C,$1C
	.db $FF
SndEff22Ch3Data:
	.db $04,$B0,$88,$80,$20,$80,$1C,$04,$B0,$88,$80,$15,$80,$20,$80,$1C
	.db $50,$15,$50,$20,$50,$1C,$30,$15,$30,$20,$30,$1C,$10,$15,$10,$20
	.db $10,$1C
	.db $FF
SndEff22Ch4Data:
	.db $01,$52,$83,$64,$85,$15,$03,$C8,$A8,$94,$36,$25,$16
	.db $FF
SndEff30Ch4Data:
	.db $FB,$04,$DE,$4F,$EE,$AA,$C9,$1A,$89,$13,$FE,$02
	.db $FF
SndEff2ECh3Data:
	.db $02,$30,$83,$90,$44,$A0,$47,$90,$66,$80,$77,$01,$30,$89,$60,$77
	.db $60,$71,$60,$6B,$70,$65,$70,$5F,$70,$5A,$FB,$80,$55,$FE,$20,$30
	.db $55,$20,$55
	.db $FF
SndEff2ECh4Data:
	.db $02,$A4,$95,$B6,$A7,$A4,$96,$A4,$01,$FB,$95,$56,$FE,$0F,$57,$18
	.db $47,$18,$37,$17,$27,$18,$17,$18,$03,$27,$18
	.db $FF
SndEff24Ch3Data:
	.db $03,$30,$84,$B0,$BE,$30,$5F,$E7,$06,$C0,$2E,$B0,$BE,$50,$BE,$20
	.db $BE
	.db $FF
SndEff24Ch4Data:
	.db $02,$54,$05,$83,$A8,$7B,$5B,$4C,$3D,$2D,$1D
	.db $FF
SndEff3BCh3Data:
	.db $03,$70,$88,$A0,$30,$70,$45,$20,$30,$20,$45,$10,$30,$10,$45
	.db $FF
SndEff3FCh3Data:
	.db $01,$30,$88,$FB,$B1,$0D,$91,$AC,$FE,$03,$21,$0D,$21,$AC,$FB,$01
	.db $30,$88,$D1,$0D,$B1,$AC,$FE,$0B,$FB,$31,$0D,$31,$AC,$FE,$03,$FB
	.db $21,$0D,$11,$AC,$FE,$02
	.db $FF
SndEff2DCh3Data:
	.db $02,$B0,$88,$FB,$70,$39,$FE,$0A,$80,$3A,$70,$3B,$60,$3C,$50,$3D
	.db $40,$3E,$30,$3F,$20,$40,$10,$41
	.db $FF
SndEff2DCh4Data:
	.db $02,$BB,$08,$DA,$AD,$7D,$4D,$2D,$1E
	.db $FF
SndEff1ACh3Data:
	.db $01,$B0,$83,$B2,$77,$C2,$3C,$01,$70,$82,$72,$00,$62,$00,$52,$00
	.db $42,$00,$32,$00,$22,$00,$12,$00
	.db $FF
SndEff1ACh4Data:
	.db $02,$BE,$AD,$3E,$DD,$8D,$4D,$2D,$1D
	.db $FF
SndEff26Ch4Data:
	.db $03,$CD,$D8,$E3,$C2,$D2,$C2,$A2,$92,$72,$62,$52,$42,$12,$31
	.db $FF
SndEff40Ch4Data:
	.db $01,$D5,$52,$33,$14
	.db $FF
SndEff34Ch3Data:
	.db $03,$B0,$86,$E0,$12,$E0,$13,$E0,$20,$E0,$17,$02,$B0,$88,$70,$12
	.db $30,$12,$20,$12
	.db $FF
SndEff34Ch4Data:
	.db $02,$42,$E5,$B3,$C8,$88,$78,$38,$26,$13
	.db $FF
SndEff18Ch3Data:
	.db $03,$B0,$88,$B2,$3B,$A2,$2B,$B2,$1B,$A2,$16
	.db $FF
SndEff19Ch3Data:
	.db $03,$30,$88,$D3,$F9,$C3,$E0,$D3,$D0,$C3,$C0
	.db $FF
SndEff41Ch3Data:
	.db $05,$82,$88,$10,$D5,$10,$8E,$10,$A9,$02,$B0,$88,$E0,$6A,$D0,$6A
	.db $B0,$6A,$A0,$6A,$90,$6A,$70,$6A,$50,$6A,$40,$6A
	.db $FF
	.db $FF

;INSTRUMENT DATA
InstrumentVolumePointerTable:
	.dw InstrumentVol0Data
	.dw InstrumentVol1Data
	.dw InstrumentVol2Data
	.dw InstrumentVol3Data
	.dw InstrumentVol4Data
	.dw InstrumentVol5Data
	.dw InstrumentVol6Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data
	.dw InstrumentVol7Data

InstrumentVol0Data:
	.db $12,$13,$14,$15,$16,$17,$46,$15,$14,$13,$FF
InstrumentVol1Data:
	.db $15,$16,$17,$16,$FF
InstrumentVol2Data:
	.db $17,$16,$27,$26,$FF
InstrumentVol3Data:
	.db $14,$15,$16,$27,$16,$FF
InstrumentVol4Data:
	.db $34,$55,$56,$57,$58,$59,$DA,$56,$55,$54,$53,$52,$51,$FF
InstrumentVol5Data:
	.db $12,$13,$24,$13,$FF
InstrumentVol6Data:
	.db $10,$11,$12,$23,$12,$FF
InstrumentVol7Data:
	.db $1F,$FF

InstrumentPitchPointerTable:
	.dw InstrumentPitch0Data
	.dw InstrumentPitch1Data
	.dw InstrumentPitch2Data
	.dw InstrumentPitch3Data
	.dw InstrumentPitch4Data
	.dw InstrumentPitch5Data
	.dw InstrumentPitch6Data
	.dw InstrumentPitch7Data
	.dw InstrumentPitch8Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data
	.dw InstrumentPitch9Data

InstrumentPitch0Data:
	.db $16,$11,$10,$F0,$FB,$11,$12,$13,$12,$11,$10,$1F,$1E,$1D,$1E,$1F
	.db $10,$FE,$FF
InstrumentPitch1Data:
	.db $17,$11,$80,$FB,$11,$12,$13,$12,$11,$10,$1F,$1E,$1D,$1E,$1F,$10
	.db $FE,$FF
InstrumentPitch2Data:
	.db $14,$11,$F0,$FB,$11,$12,$11,$10,$1F,$1E,$1F,$10,$FE,$FF
InstrumentPitch3Data:
	.db $15,$11,$10,$FF
InstrumentPitch4Data:
	.db $FB,$11,$12,$11,$1F,$1E,$1F,$10,$FE,$FF
InstrumentPitch5Data:
	.db $18,$11,$10,$FF
InstrumentPitch6Data:
	.db $FB,$21,$22,$21,$2F,$2E,$2F,$20,$FE,$FF
InstrumentPitch7Data:
	.db $FB,$20,$21,$20,$2F,$FE,$FF
InstrumentPitch8Data:
	.db $18,$11,$80,$FB,$11,$12,$11,$1F,$1E,$1F,$FE,$FF
InstrumentPitch9Data:
	.db $FF

;MUSIC DATA
Music43Ch1Data:
	.db $E0,$04,$35,$82,$81,$FB,$E1,$A2,$A2,$C2,$A2,$A2,$E2,$22,$E1,$A2
	.db $A2,$FE,$04
Music43Ch1Data_Loop:
	.db $E0,$04,$30,$01,$41,$D1,$03,$EB,$00,$01,$E9,$3C,$E4,$D0,$20,$26
	.db $D0,$F4,$22,$F0,$32,$22,$E3,$C2,$C4,$E4,$22,$E3,$AD,$F4,$A3,$E8
	.db $21
	.db $FD
	.dw Music43Section0
	.db $E8,$41,$D0,$20,$26,$D0,$F4,$22,$F0,$E7,$04,$52,$32,$22,$24,$E3
	.db $C2,$E4,$8A,$F4,$82,$F1,$E3,$C2,$82,$32,$E4,$34,$E3,$C2,$82,$32
	.db $E0,$04,$30,$01,$41,$E4,$D0,$20,$26,$D0,$F4,$22,$F0,$E3,$C2,$E4
	.db $22,$E3,$C2,$A4,$C2,$AC,$F4,$A4
	.db $FD
	.dw Music43Section0
	.db $D0,$20,$26,$D0,$F4,$22,$F0,$E3,$C2,$E4,$22,$E3,$C2,$E4,$14,$E3
	.db $A2,$62,$82,$92,$A4,$C4,$82,$32,$82,$A2,$C2,$E4,$12,$32,$EB,$02
	.db $01,$E0,$04,$71,$01,$71,$E9,$7C,$E4,$52,$E3,$82,$E4,$12
	.db $FD
	.dw Music43Section1
	.db $E8,$51,$E4,$82,$62,$52,$1C,$F4,$12,$F0,$12,$39,$F4,$31,$E9,$30
	.db $F1,$32,$52,$62,$54,$E0,$04,$71,$01,$71,$E3,$82,$E4,$12
	.db $FD
	.dw Music43Section1
	.db $E4,$82,$62,$52,$64,$E3,$62,$A2,$E4,$12,$52,$64,$84,$E3,$82,$C2
	.db $E4,$32,$82,$A2,$C4,$E0,$04,$30,$01,$11,$EB,$00,$01,$E4,$A2,$F4
	.db $A2,$E1
	.db $FD
	.dw Music43Section2
	.db $A2,$A2,$C2,$A2,$A2,$F0,$E3,$C2,$F4,$C2,$E4,$F0,$22,$F4,$22,$E1
	.db $A2
	.db $FD
	.dw Music43Section2
	.db $F2,$E9,$70,$E4,$82,$72,$62,$58,$F4,$52
	.db $FE,$FF
	.dw Music43Ch1Data_Loop
Music43Ch0Data:
	.db $E0,$04,$35,$82,$81,$ED,$85,$FB,$E1,$A2,$A2,$C2,$A2,$A2,$E2,$22
	.db $E1,$A2,$A2,$FE,$04
Music43Ch0Data_Loop:
	.db $E0,$04,$34,$01,$31,$ED,$81,$D1,$03,$E9,$39,$E4,$D0,$20,$2A,$D0
	.db $32,$22,$E3,$C2,$C4,$E4,$22,$E3,$AE,$E8,$21,$F0,$E4,$32,$F5,$32
	.db $F0,$32,$32,$F5,$32,$F0,$52,$E8,$31,$F4,$D0,$20,$2A,$D0,$52,$32
	.db $22,$24,$E3,$C2,$E4,$8A,$F1,$82,$32,$E3,$C2,$E4,$C4,$82,$32,$E3
	.db $C2,$E0,$04,$34,$01,$31,$E4,$D0,$20,$2A,$D0,$E3,$C2,$E4,$22,$E3
	.db $C2,$A4,$C2,$AE,$F0,$E4,$32,$F5,$32,$F0,$32,$32,$F5,$32,$F0,$52
	.db $F4,$D0,$20,$2A,$D0,$E3,$C2,$E4,$22,$E3,$C2,$E4,$14,$E3,$A2,$62
	.db $82,$92,$A4,$C4,$82,$32,$82,$A2,$C2,$E4,$12,$E0,$04,$34,$82,$51
	.db $E9,$3C,$E4,$13,$E3,$82
	.db $FD
	.dw Music43Section8
	.db $51,$E0,$04,$36,$82,$41,$E4,$52,$32,$12,$E3,$AD,$F5,$A1,$F0,$A2
	.db $C9,$F5,$C1,$E9,$B0,$F0,$C2,$E4,$12,$32,$14,$E0,$04,$34,$82,$51
	.db $E3,$83
	.db $FD
	.dw Music43Section8
	.db $52,$E4,$82,$62,$52,$64,$E3,$62,$A2,$E4,$12,$52,$64,$84,$E3,$82
	.db $C2,$E4,$32,$82,$A2,$C3,$E0,$04,$30,$01,$11,$ED,$00,$E4,$52,$F5
	.db $52,$E1
	.db $FD
	.dw Music43Section3
	.db $A2,$A2,$C2,$A2,$A2,$F0,$E4,$52,$F5,$52,$F0,$A2,$F5,$A2,$E1,$A2
	.db $FD
	.dw Music43Section3
	.db $F2,$E4,$32,$22,$12,$E3,$C8,$F4,$C2
	.db $FE,$FF
	.dw Music43Ch0Data_Loop
Music43Ch2Data:
	.db $E0,$04,$08,$FB
	.db $FD
	.dw Music43Section4
	.db $FE,$04
Music43Ch2Data_Loop:
	.db $FC,$FB
	.db $FD
	.dw Music43Section4
	.db $FE,$02,$82,$82,$C2,$82,$82,$E3,$32,$E2,$82,$82,$82,$82,$C2,$82
	.db $E3,$32,$22,$E2,$C2,$E3,$22,$FE,$02,$FB
	.db $FD
	.dw Music43Section4
	.db $FE,$02,$E2,$82,$82,$C2,$82,$82,$E3,$32,$E2,$82,$82,$82,$82,$C2
	.db $82,$E3,$32,$22,$E2,$C2,$E3,$22,$FB
	.db $FD
	.dw Music43Section4
	.db $FE,$02,$62,$62,$82,$62,$62,$A2,$62,$62,$82,$82,$C2,$82,$82,$82
	.db $A2,$C2,$E3,$12
	.db $FD
	.dw Music43Section5
	.db $C2,$82,$E3,$C2,$E4,$12,$32,$12,$E3,$12,$E3
	.db $FD
	.dw Music43Section5
	.db $A2,$82,$82,$A2,$C2,$E3,$32,$FC,$FB
	.db $FD
	.dw Music43Section4
	.db $FE,$07,$E3,$82,$72,$62,$52,$52,$72,$82,$92
	.db $FE,$FF
	.dw Music43Ch2Data_Loop
Music43Ch5Data:
	.db $E0,$04,$FB,$12,$22,$FE,$0C,$B2,$A4,$A2,$B2,$B1,$B1,$A4
Music43Ch5Data_Loop:
	.db $FB
	.db $FD
	.dw Music43Section6
	.db $FE,$04,$FB
	.db $FD
	.dw Music43Section6
	.db $FD
	.db $A9,$9D,$FB
	.db $FD
	.dw Music43Section6
	.db $FD
	.dw Music43Section7
	.db $FB
	.db $FD
	.dw Music43Section6
	.db $FE,$04,$B4,$FB,$14,$FE,$05,$12,$A2,$B2,$A2,$FB,$14,$FE,$06,$12
	.db $A2,$12,$A2,$B2,$12,$A2,$12,$B2,$B2,$A2,$12,$B2,$12,$A2,$B2,$12
	.db $B2,$A2,$12,$B2,$12,$A2,$12,$B2,$B2,$A2,$12,$B2,$B2,$B2,$B2,$A2
	.db $A2,$A2,$A2
	.db $FE,$FF
	.dw Music43Ch5Data_Loop
Music43Section0:
	.db $F0,$E4,$82,$F4,$82,$F0,$72,$82,$F4,$82,$F0,$A2
	.db $FF
Music43Section1:
	.db $E3,$82,$E4,$32,$E3,$82,$E4,$52,$54,$E3,$82,$E4,$12,$E3,$82,$E4
	.db $32,$E3,$82,$E4,$52,$54,$E3,$62,$E4,$12,$E3,$62,$E4,$32,$E3,$62
	.db $E4,$52,$54,$E3,$62,$E4,$12,$E3,$62,$E4,$32,$E3,$62,$E4,$52,$54
	.db $E3,$52,$A2,$52,$C2,$52,$E4,$12,$54,$E3,$52,$A2,$52
	.db $FF
Music43Section2:
	.db $C2,$A2,$A2,$E2,$22,$E1,$A2,$A2,$A2,$A2,$C2,$A2,$A2,$F0,$E4,$32
	.db $F4,$32,$F0,$22,$F4,$22,$E1,$A2,$C2,$A2,$A2,$E2,$22,$E1,$A2,$A2
	.db $FF
Music43Section3:
	.db $C2,$A2,$A2,$E2,$22,$E1,$A2,$A2,$A2,$A2,$C2,$A2,$A2,$F0,$E4,$A2
	.db $F5,$A2,$F0,$A2,$F5,$A2,$E1,$A2,$C2,$A2,$A2,$E2,$22,$E1,$A2,$A2
	.db $FF
Music43Section4:
	.db $E2,$A2,$A2,$C2,$A2,$A2,$E3,$22,$E2,$A2,$A2
	.db $FF
Music43Section5:
	.db $12,$52,$12,$12,$82,$12,$12,$E4,$12,$E3,$12,$12,$82,$12,$12,$12
	.db $E2,$B4,$B2,$E3,$32,$E2,$B2,$B2,$E3,$B2,$E2,$B2,$B2,$E4,$12,$E2
	.db $B2,$B2,$E3,$B4,$E2,$B2,$B2,$A4,$A2,$E3,$12,$E2,$A2,$A2,$E3,$A2
	.db $E2,$A2,$A2,$E3,$C2,$E2,$A2,$A2,$E3,$A4,$E2,$A2,$A2,$A2,$62,$62
	.db $A2,$62,$62,$E3,$12,$E2,$62,$62,$82,$82
	.db $FF
Music43Section6:
	.db $B4,$A4,$B4,$A4,$B2,$B2,$A2,$B4,$B2,$A4
	.db $FF
Music43Section7:
	.db $FE,$03,$B4,$A4,$B4,$A4,$B4,$A4,$B2,$A2,$A2,$A2
	.db $FF
Music43Section8:
	.db $E4,$12,$E3,$82,$E4,$32,$E3,$82,$E4,$12,$14,$F0,$E3,$82,$E4,$12
	.db $E3,$82,$E4,$32,$E3,$82,$E4,$12,$E3,$B4,$62,$E4,$12,$E3,$62,$E4
	.db $32,$E3,$62,$E4,$12,$14,$E3,$62,$E4,$12,$E3,$62,$E4,$32,$E3,$62
	.db $E4,$12,$14,$E3,$52,$A2,$52,$C2,$52,$E4,$12,$54,$E3,$52,$A2
	.db $FF
	.db $FF
Music44Ch1Data:
	.db $FD
	.dw Music44Section0
Music44Ch1Data_Loop:
	.db $EF,$03,$E0,$04,$36,$81,$71,$ED,$82,$D1,$02,$E2,$52,$FB,$72,$FE
	.db $07,$A4,$72
	.db $FD
	.dw Music44Section1
	.db $A2,$92,$72,$94,$72,$52,$72,$ED,$00,$D1,$00,$E0,$04,$38,$81,$51
	.db $EB,$01,$01,$E9,$3C,$E3,$52,$72,$A2,$E4,$52,$F4,$54,$F0,$E3,$52
	.db $72,$A2,$E4,$42,$F4,$44,$F0,$E3,$52,$72,$A2,$E4,$32,$F4,$34,$F0
	.db $E3,$52,$72,$A2,$E4,$2A,$E3,$C2,$A2,$C2,$A2,$92,$72,$52,$72,$A2
	.db $E4,$52,$F4,$54,$F0,$E3,$52,$72,$A2,$E4,$42,$F4,$44,$F0,$E3,$52
	.db $72,$A2,$E4,$32,$F4,$34,$F0,$E3,$52,$72,$A2,$E4,$2A,$32,$22,$52
	.db $E3,$C2,$A2,$92,$E0,$04,$37,$82,$31,$E3,$54,$74,$A4,$52,$74,$A4
	.db $52,$74,$A4,$F4,$A4,$F1,$A2,$A2,$C2,$E4,$22,$F5,$22,$F1,$E3,$A4
	.db $A2,$A2,$A2,$C2,$E4,$22,$F5,$24,$F0,$E3,$54,$74,$A4,$52,$74,$C4
	.db $52,$74,$C4,$E9,$79,$E4,$22,$E3,$C4,$E4,$22,$E3,$C2,$A4,$C2,$A2
	.db $94,$A2,$92,$75,$F4,$71,$E9,$30,$F0,$E9,$3C,$E3,$54,$74,$A4,$52
	.db $74,$A4,$52,$74,$A4,$F4,$A4,$F1,$A2,$A2,$C2,$E4,$22,$F5,$22,$F1
	.db $E3,$A4,$A2,$A2,$A2,$E4,$52,$32,$22,$E3,$A2,$F0,$54,$74,$A4,$52
	.db $74,$C4,$52,$74,$C4,$E9,$75,$92,$62,$92,$C2,$92,$C2,$E4,$32,$E3
	.db $C2,$E4,$32,$62,$32,$62,$92,$A2,$C2,$F4,$C2,$EB,$01,$00,$E9,$00
	.db $FE,$FF
	.dw Music44Ch1Data_Loop
Music44Ch0Data:
	.db $FD
	.dw Music44Section0
Music44Ch0Data_Loop:
	.db $EA,$0C,$E0,$04,$35,$82,$81,$E2,$52,$FB,$72,$FE,$07,$A4,$72
	.db $FD
	.dw Music44Section1
	.db $A2,$92,$72,$94,$72,$52,$72,$EA,$00,$E0,$04,$38,$82,$41,$ED,$81
	.db $E9,$7C,$D1,$01,$F3,$E3,$54,$72,$A2,$E4,$56,$E3,$52,$72,$A2,$E4
	.db $46,$E3,$52,$72,$A2,$E4,$32,$34,$E3,$52,$72,$A2,$E4,$2A,$E3,$C2
	.db $A2,$C2,$A2,$92,$72,$52,$72,$A2,$E4,$52,$54,$E3,$52,$72,$A2,$E4
	.db $42,$44,$E3,$52,$72,$A2,$E4,$32,$34,$E3,$52,$72,$A2,$E4,$2A,$32
	.db $22,$52,$E3,$C2,$A2,$92,$E0,$04,$78,$82,$21,$F4,$E3,$54,$74,$A4
	.db $52,$74,$A4,$52,$74,$A6,$E9,$30,$F2,$52,$52,$72,$A2,$F5,$A2,$F2
	.db $54,$52,$52,$52,$72,$A2,$F5,$A4,$F4,$E3,$56,$74,$A4,$52,$74,$C4
	.db $52,$74,$C4,$E4,$22,$E3,$C4,$E4,$22,$E3,$C2,$A4,$C2,$A2,$94,$A2
	.db $92,$76,$E9,$70,$F4,$E3,$54,$74,$A4,$52,$74,$A4,$52,$74,$A6,$E9
	.db $30,$F2,$52,$52,$72,$A2,$F5,$A2,$F2,$54,$52,$52,$52,$E4,$22,$E3
	.db $C2,$A2,$52,$F4,$E9,$70,$56,$74,$A4,$52,$74,$C4,$52,$74,$C4,$F3
	.db $E9,$B5,$92,$62,$92,$C2,$92,$C2,$E4,$32,$E3,$C2,$E4,$32,$62,$32
	.db $62,$92,$A2,$C2,$ED,$00,$E9,$00
	.db $FE,$FF
	.dw Music44Ch0Data_Loop
Music44Ch2Data:
	.db $E0,$04,$0A,$E2,$00
Music44Ch2Data_Loop:
	.db $E2,$52,$FB,$72,$FE,$07,$A4,$72
	.db $FD
	.dw Music44Section1
	.db $A2,$92,$72,$94,$72,$52,$72,$E2,$52,$FB,$72,$FE,$07,$52,$72,$52
	.db $FD
	.dw Music44Section1
	.db $E3,$22,$E2,$C4,$A2,$C2,$A4,$92
	.db $FD
	.dw Music44Section2
	.db $32,$32,$22,$E2,$C4,$A2,$C2,$A4,$92
	.db $FD
	.dw Music44Section2
	.db $52,$52,$52,$24,$22,$22,$E2,$C2,$A2,$92
	.db $FE,$FF
	.dw Music44Ch2Data_Loop
Music44Ch5Data:
	.db $E4,$B2,$B2,$A2,$B4,$B2,$A1,$A1,$A1,$A1
Music44Ch5Data_Loop:
	.db $FB
	.db $B4,$A4,$B4,$A4,$B2,$B2,$A2,$B4,$B2,$A4
	.db $FE,$03
	.db $B4,$A4,$B4,$A4,$B2,$A2,$B2,$B2,$A2,$B2,$B2,$A2
	.db $FB
	.db $B4,$A4,$B4,$A2,$B4,$B2,$A4,$B4,$A4
	.db $FE,$03
	.db $B4,$A4,$B4,$A2,$B2,$B4,$A2,$B2,$A2,$A2,$A2,$A2
	.db $FD
	.dw Music44Section3
	.db $B4,$A4,$B4,$A4,$B2,$B2,$A2,$B4,$B2,$A4
	.db $FD
	.dw Music44Section3
	.db $B2,$A2,$A2,$B2,$A2,$A2,$B2,$A4,$B6,$A2,$A2,$A2,$A2
	.db $FE,$FF
	.dw Music44Ch5Data_Loop
Music44Section0:
	.db $E0,$04,$36,$81,$71,$E2,$00
	.db $FF
Music44Section1:
	.db $C4,$A2,$52,$72,$52,$FB,$72,$FE,$07,$A2,$92,$72,$54,$72,$54,$52
	.db $FB,$72,$FE,$07,$A4,$72,$C4,$A2,$52,$72,$52,$FB,$72,$FE,$07
	.db $FF
Music44Section2:
	.db $E3,$FB,$32,$FE,$0D,$E2,$52,$72,$A4,$A2,$C2,$A2,$A2,$E3,$22,$E2
	.db $A2,$A2,$E3,$32,$E2,$A2,$A2,$E3,$22,$E2,$A2,$C2,$C2,$A2,$E2,$C4
	.db $FB,$C2,$FE,$08,$E3,$22,$E2,$FB,$C2,$FE,$05,$E3,$22,$22,$22,$34
	.db $32
	.db $FF
Music44Section3:
	.db $FB,$B4,$A4,$B4,$A4,$B4,$A4,$B2,$B2,$A4,$FE,$03
	.db $FF
	.db $FF
Music45Ch1Data:
	.db $EF,$85,$EE,$05,$E0,$03,$74,$02,$61,$D2,$D1,$03,$E9,$39,$E1,$32
	.db $32
	.db $FD
	.dw Music45Section0
	.db $12,$02,$12,$34,$82,$62,$52,$F4,$52,$E1,$32
	.db $FD
	.dw Music45Section0
	.db $82,$92,$A2,$E8,$21,$E4,$14,$D2,$E7,$01,$E3,$C1,$B1,$A1,$91,$81
	.db $71,$61,$51,$41,$31,$21,$11,$E2,$C1,$B1,$A1,$91,$81,$71
Music45Ch1Data_Loop:
	.db $EF,$85,$E0,$03,$B0,$02,$61,$E9,$B9,$EB,$03,$01,$F4,$E1,$32,$32
	.db $F0
	.db $FD
	.dw Music45Section1
	.db $34,$E5,$14,$E4,$C2,$E5,$12,$D2,$32,$02,$E4,$C2,$02,$D2,$A2,$EB
	.db $03,$00,$E0,$03,$31,$01,$61,$FB,$02,$D2
	.db $FD
	.dw Music45Section4
	.db $D2,$62,$52,$FE,$02,$E0,$03,$B0,$02,$61,$EB,$03,$01,$04
	.db $FD
	.dw Music45Section1
	.db $34,$E9,$70,$E5,$14,$E4,$C2,$E5,$12,$32,$F4,$34,$32,$E0,$03,$70
	.db $03,$31
	.db $FD
	.dw Music45Section2
	.db $F0,$E9,$70,$E4,$84,$82,$74,$72,$64,$62,$84,$62,$82,$61,$E7,$01
	.db $51,$41,$31,$21,$11,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31
	.db $E7,$03,$E3,$84,$82,$74,$72,$62,$82,$92,$A4,$F1,$E9,$B0
	.db $FB,$E5,$11,$E4,$A1,$FE,$03
	.db $FE,$FF
	.dw Music45Ch1Data_Loop
Music45Ch0Data:
	.db $E0,$03,$34,$02,$61,$E9,$79,$ED,$81,$D2,$D1,$03,$E1,$32,$32
	.db $FD
	.dw Music45Section3
	.db $82,$02,$82,$A4,$E3,$32,$12,$E2,$C2,$F4,$C2,$E1,$32
	.db $FD
	.dw Music45Section3
	.db $E3,$32,$42,$52,$E8,$21,$84,$D2,$E7,$01,$71,$61,$51,$41,$31,$21
	.db $11,$E2,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21
Music45Ch0Data_Loop:
	.db $E0,$03,$B0,$05,$71,$06,$D1,$03,$E9,$35,$EB,$03,$01
	.db $FD
	.dw Music45Section1
	.db $34,$E5,$14,$E4,$C2,$D2,$E5,$12,$32,$02,$E4,$C2,$02,$D2,$A2,$ED
	.db $00,$EB,$03,$00,$E0,$03,$B4,$01,$61,$FB,$03,$D2
	.db $FD
	.dw Music45Section4
	.db $62,$52,$02
	.db $FD
	.dw Music45Section4
	.db $D2,$61,$E0,$03,$B0,$05,$61,$F3,$56,$F0,$EB,$03,$01,$D2
	.db $FD
	.dw Music45Section1
	.db $32,$E9,$30,$EC,$02,$F1,$84,$72,$82,$A2,$D2,$F4,$A4,$F5,$A2,$EA
	.db $8C,$E0,$03,$73,$03,$21
	.db $FD
	.dw Music45Section2
	.db $EA,$00,$E8,$41,$F1,$E4,$34,$32,$34,$32,$14,$12,$34,$12,$32,$11
	.db $E7,$01,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E2
	.db $C1,$B1,$A1,$E7,$03,$E3,$34,$32,$34,$32,$12,$32,$42,$54,$F2,$E9
	.db $B0,$FB,$E4,$11,$E3,$A1,$FE,$03
	.db $FE,$FF
	.dw Music45Ch0Data_Loop
Music45Ch2Data:
	.db $E0,$03,$08,$E3,$32,$32,$0C,$0A,$31,$31,$E4,$32,$E3,$32,$32,$32
	.db $0C,$0A,$82,$62,$52,$FB,$32,$32,$E4,$32,$E3,$32,$32,$E4,$32,$E3
	.db $32,$32,$FE,$03,$82,$92,$A2,$E4,$1A
Music45Ch2Data_Loop:
	.db $E0,$03,$08
	.db $FD
	.dw Music45Section5
	.db $32,$32,$32,$32,$32,$94,$84,$82,$82,$82,$82,$E4,$32,$E3,$B2,$34
	.db $32,$32,$32,$32,$94,$84,$82,$82,$82,$82,$B2,$82,$34,$32,$32,$32
	.db $32,$94,$84,$82,$82,$82,$82,$E4,$82,$32,$E3,$B2,$FC,$E3,$FB,$32
	.db $FE,$05,$E4,$32,$E3,$32,$32,$FB,$82,$FE,$05,$E4,$82,$E3,$82,$82
	.db $E3,$FB,$32,$FE,$05,$E4,$32,$E3,$32,$32,$82,$82,$82,$82,$E4,$82
	.db $62,$52,$32,$FE,$02,$FC
	.db $FD
	.dw Music45Section5
	.db $FE,$03,$FB,$32,$FE,$05,$94,$82,$82,$72,$82,$A5,$05,$E3,$32,$32
	.db $62,$32,$32,$92,$32,$32,$FB,$82,$FE,$05,$E4,$82,$E3,$82,$82,$FB
	.db $32,$FE,$05,$92,$62,$32,$FB,$82,$FE,$05,$E4,$82,$E3,$82,$82,$FB
	.db $32,$FE,$05,$E4,$32,$E3,$32,$32,$64,$62,$84,$62,$82,$62,$32,$32
	.db $E4,$32,$E3,$32,$32,$E4,$32,$E3,$32,$32,$62,$82,$92,$A2,$E0,$01
	.db $00,$E4,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E3,$C1,$B1,$A1,$91
	.db $81,$71,$61,$51,$41,$31,$21,$11,$E2,$C1,$B1,$A1
	.db $FE,$FF
	.dw Music45Ch2Data_Loop
Music45Ch5Data:
	.db $E3,$B2,$B2,$A4,$FB,$04,$A4,$FE,$03,$B2,$B2,$A8,$A8,$A8,$A2,$A2
	.db $FB,$B4,$A4,$B4,$A4,$B2,$B2,$A2,$B4,$B2,$A4,$B4,$A4,$B4,$A4,$B2
	.db $B2,$A2,$B4,$A2,$A2,$A2
Music45Ch5Data_Loop:
	.db $FB,$B4,$A4,$B4,$A4,$B4,$A4,$B2,$B2,$A4,$FE,$03,$B4,$A4,$B4,$A4
	.db $B2,$A2,$B2,$B2,$A2,$B2,$B2,$A2,$FB
	.db $FD
	.dw Music45Section6
	.db $B4,$A4,$B4,$A4,$B2,$B2,$A2,$B4,$B2,$A4,$FE,$02,$FB
	.db $FD
	.dw Music45Section6
	.db $FE,$03,$B4,$A4,$B4,$A4,$B2,$A2,$A2,$B2,$A2,$B2,$A2,$A2,$FB,$B4
	.db $A4,$B2,$B2,$A4,$B2,$B2,$A2,$B4,$B2,$A4,$FE,$03,$B2,$B2,$A4,$B4
	.db $A4,$B2,$B2,$A2,$B2,$A2,$A2,$A2,$A1,$A1
	.db $FE,$FF
	.dw Music45Ch5Data_Loop
Music45Section0:
	.db $F0,$FB,$E3,$14,$12,$32,$02,$32,$FE,$02,$F4,$34,$E1,$32,$32,$F0
	.db $E3,$14,$12,$32,$02,$32
	.db $FF
Music45Section1:
	.db $E4,$82,$92,$A2,$32,$F4,$32,$F0,$14,$32,$E3,$82,$92,$F4,$92,$F0
	.db $A2,$F4,$A2,$F0,$E4,$12,$F4,$12,$E1,$32,$F0,$E4,$82,$92,$A2,$34
	.db $E5,$14,$12,$E4,$C2,$84,$82,$92,$A2,$F4,$A2,$E1,$32,$F0,$E4,$82
	.db $92,$A2,$32,$F4,$32,$F0,$14,$32,$E3,$82,$92,$A2,$E4,$12,$F4,$12
	.db $F0,$32,$F4,$34,$F0,$82,$92,$A2
	.db $FF
Music45Section2:
	.db $E4,$32,$FB,$42,$52,$82,$FE,$06,$A2,$52,$32,$52,$12,$32,$E3,$82
	.db $A2,$E4,$12,$34,$12,$E3,$C2,$82,$F4,$84
	.db $FF
Music45Section3:
	.db $F1,$FB,$E2,$84,$82,$A2,$02,$A2,$FE,$02,$F4,$A4,$E1,$32,$32,$F1
	.db $E2,$82,$02,$82,$A2,$02,$A2
	.db $FF
Music45Section4:
	.db $E4,$62,$A2,$E5,$52,$02,$52,$02,$12,$02,$32,$02,$34,$E4,$C2,$A2
	.db $82,$02,$62,$A2,$E5,$52,$02,$52,$02,$12,$02,$82,$02,$82,$62,$82
	.db $FF
Music45Section5:
	.db $E3,$FB,$32,$FE,$05,$94,$84,$82,$82,$82,$82,$B2,$82,$32
	.db $FF
Music45Section6:
	.db $B4,$A4,$B4,$A4,$B4,$A4,$B2,$B2,$A4
	.db $FF
	.db $FF
Music46Ch1Data:
	.db $EF,$03,$EE,$0B,$FB,$E0,$04,$30,$01,$41,$E9,$38
	.db $FD
	.dw Music46Section0
	.db $FE,$02
Music46Ch1Data_Loop:
	.db $E0,$04,$30,$01,$41,$EB,$00,$01,$E2,$02,$E9,$38,$F0,$A2,$E3,$12
	.db $52,$86,$82,$72,$82,$72,$32,$F4,$32,$F0,$E4,$14,$32,$F4,$32,$F0
	.db $E2,$A2,$E3,$12,$52,$86,$82,$72,$82,$A2,$32,$F4,$32,$F0,$E4,$82
	.db $92,$A2,$F4,$A2,$F0,$E2,$A2,$E3,$12,$52,$86,$82,$72,$82,$72,$32
	.db $F4,$32,$F0,$E4,$14,$32,$F4,$32,$F0,$E2,$A2,$E3,$12,$52,$86,$82
	.db $A2,$A2,$82,$A2,$F4,$A8,$E0,$04,$B1,$03,$31,$EB,$04,$41,$E3,$A4
	.db $FD
	.dw Music46Section1
	.db $2C,$E0,$04,$70,$01,$31,$EB,$03,$01,$E9,$BD,$D1,$02
	.db $FD
	.dw Music46Section2
	.db $FE,$FF
	.dw Music46Ch1Data_Loop
Music46Ch0Data:
	.db $EA,$85,$ED,$81,$FB,$E0,$04,$71,$01,$41
	.db $FD
	.dw Music46Section0
	.db $FE,$02
Music46Ch0Data_Loop:
	.db $EA,$00,$ED,$00,$E0,$04,$34,$01,$41,$E9,$34,$E2,$05,$F4,$A2,$E3
	.db $12,$52,$86,$82,$72,$82,$72,$31,$F0,$84,$A2,$F4,$A5,$E2,$A2,$E3
	.db $12,$52,$86,$82,$72,$82,$A2,$31,$F0,$E4,$32,$42,$52,$F4,$55,$E2
	.db $A2,$E3,$12,$52,$86,$82,$72,$82,$72,$31,$F0,$84,$A2,$F4,$A5,$E2
	.db $A2,$E3,$12,$52,$86,$82,$A2,$A2,$82,$A2,$F4,$A5,$E0,$04,$B2,$05
	.db $31,$EB,$04,$21,$E3,$A8
	.db $FD
	.dw Music46Section1
	.db $28,$EB,$04,$00,$EA,$85,$E0,$04,$31,$01,$31,$D1,$02,$E9,$7D
	.db $FD
	.dw Music46Section2
	.db $FE,$FF
	.dw Music46Ch0Data_Loop
Music46Ch2Data:
	.db $E0,$04,$0A,$E2,$81,$91,$A4,$81,$91,$A2,$E3,$16,$E2,$81,$91,$A4
	.db $81,$91,$A2,$E3,$36,$E2,$81,$91,$A4,$81,$91,$A2,$E3,$16,$E2,$81
	.db $91,$A4,$81,$91,$E3,$32,$12,$E2,$A4,$E0,$04,$07,$FC,$FB,$E2,$A2
	.db $FE,$06,$E3,$12,$E2,$C2,$FB,$A2,$FE,$06,$E3,$32,$12,$FE,$02
Music46Ch2Data_Loop:
	.db $E0,$04,$08,$FB,$E2,$A2,$A2,$E3,$12,$E2,$A2,$A2,$E3,$12,$32,$42
	.db $E2,$A2,$A2,$E3,$12,$E2,$A2,$E3,$42,$32,$12,$E2,$A2,$FE,$02,$E3
	.db $32,$32,$62,$32,$32,$62,$82,$92,$32,$32,$62,$32,$92,$82,$62,$32
	.db $E2,$A2,$A2,$E3,$12,$E2,$A2,$A2,$E3,$12,$32,$42,$E2,$A2,$A2,$E3
	.db $12,$E2,$A2,$E3,$42,$32,$12,$12
	.db $FD
	.dw Music46Section3
	.db $E3,$12,$E2,$A2,$A2,$E3,$32,$32,$12,$E2,$82,$92
	.db $FD
	.dw Music46Section3
	.db $E3,$42,$52,$32,$12,$32,$12,$E2,$82,$92,$E2,$A2,$A2,$E3,$12,$E2
	.db $A2,$E3,$32,$22,$12,$E2,$A2,$FB,$82,$FE,$05,$72,$82,$A4,$A2,$E3
	.db $12,$E2,$A2,$E3,$32,$22,$12,$E2,$A2,$E3,$42,$42,$42,$42,$32,$12
	.db $E2,$A2,$82,$A2,$A2,$E3,$12,$E2,$A2,$E3,$32,$22,$12,$E2,$A2,$82
	.db $82,$C2,$82,$E3,$32,$12,$E2,$C2,$A4,$A2,$E3,$12,$E2,$A2,$E3,$32
	.db $22,$12,$E2,$A2,$FB,$82,$FE,$06,$92,$A2
	.db $FE,$FF
	.dw Music46Ch2Data_Loop
Music46Ch5Data:
	.db $E4,$BA,$A6,$BC,$A2,$A2,$BA,$A6,$BC,$A1,$A1,$A1,$A1,$FB,$B4,$A4
	.db $B4,$A2,$B2,$FE,$03,$B4,$A4,$B2,$A2,$A2,$A2
Music46Ch5Data_Loop:
	.db $E4
	.db $FD
	.dw Music46Section4
	.db $B4,$A4,$B2,$B2,$A1,$A1,$A1,$A1,$FB,$B4,$A4,$B4,$A2,$B2,$B4,$A4
	.db $B2,$B2,$A2,$B2,$FE,$03,$B4,$A4,$B4,$A2,$B2,$B2,$B2,$A2,$B2,$A2
	.db $B2,$B2,$A2
	.db $FD
	.dw Music46Section4
	.db $B4,$A4,$B2,$B2,$A1,$A1,$A1,$A1
	.db $FE,$FF
	.dw Music46Ch5Data_Loop
Music46Section0:
	.db $E2,$81,$91,$A2,$F4,$A2,$F0,$81,$91,$A2,$E3,$14,$F4,$12,$F0,$E2
	.db $81,$91,$A2,$F4,$A2,$F0,$81,$91,$A2,$F0,$E3,$33,$E7,$01,$21,$11
	.db $E2,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$E7,$04,$E2,$81,$91
	.db $A2,$F4,$A2,$F0,$81,$91,$A2,$E3,$14,$F4,$12,$F0,$E2,$81,$91,$A2
	.db $F4,$A2,$F0,$81,$91,$E3,$32,$12,$E2,$A3,$F5,$A1
	.db $FF
Music46Section1:
	.db $B2,$E4,$14,$E3,$B4,$A4,$84,$64,$84,$A8,$81,$61,$58,$F3,$E9,$70
	.db $E4,$52,$E3,$C2,$C2,$E4,$12,$E3,$C2,$C2,$E4,$54,$F1,$E9,$B0,$E3
	.db $A4,$B2,$E4,$14,$E3,$B4,$A4,$84,$A4,$B4,$AA,$E4,$36
	.db $FF
Music46Section2:
	.db $E3,$82,$92,$A6,$FB,$E4,$12,$E3,$A2,$FE,$02,$E4,$12,$34,$12,$E3
	.db $A5,$F4,$A1,$F0,$82,$92,$A6,$E4,$12,$E3,$A2,$E4,$12,$E3,$A4,$E4
	.db $44,$52,$32,$12,$32,$12,$E3,$82,$92,$E3,$A4,$FB,$E4,$12,$E3,$A2
	.db $FE,$02,$E4,$12,$34,$12,$E3,$A5,$F4,$A1,$F0,$82,$92,$A6,$E4,$12
	.db $E3,$A2,$E4,$12,$E3,$A4,$E4,$44,$52,$52,$52,$52,$82,$92,$A2,$EA
	.db $00,$D1,$00,$EB,$03,$00
	.db $FF
Music46Section3:
	.db $FB,$E2,$B2,$B2,$62,$B2,$FE,$04,$A2,$A2,$E3,$12,$E2,$A2,$A2,$E3
	.db $32,$E2,$A2,$A2
	.db $FF
Music46Section4:
	.db $FB,$B4,$A4,$B4,$A2,$B2,$B2,$B2,$A2,$B2,$B4,$A2,$A2,$FE,$03,$B4
	.db $A4,$B4,$A2,$B2
	.db $FF
	.db $FF
Music47Ch1Data:
	.db $E0,$08,$74,$82,$11,$E3,$00
Music47Ch1Data_Loop:
	.db $EF,$03,$FB,$E0,$08,$78,$83,$61,$D1,$03,$E9,$BD,$EA,$8C
	.db $FD
	.dw Music47Section0
	.db $F5,$A4,$EA,$00,$FE,$04,$FC,$E0,$08,$B0,$02,$81,$EB,$05,$01,$E9
	.db $B8,$FB,$F5,$E3,$41,$51,$41,$51,$F4,$41,$51,$F3,$41,$51,$F2,$41
	.db $51,$F1,$41,$51,$F3,$41,$51,$F4,$41,$51,$FE,$02,$E3,$E8,$21,$E9
	.db $30,$F1,$83,$81,$F5,$82,$F1,$04,$81,$F4,$82,$F1,$81,$F4,$82,$F1
	.db $83,$81,$F5,$82,$0A,$D1,$00,$FE,$02,$EB,$03,$01
	.db $FD
	.dw Music47Section1
	.db $E7,$08,$E8,$21,$AC,$EC,$02,$E4,$81,$81,$F5,$82
	.db $FD
	.dw Music47Section1
	.db $E7,$08,$A7,$E8,$31,$EC,$02,$E4,$33,$22,$11,$11,$E9,$00,$F5,$12
	.db $EB,$03,$00
	.db $FE,$FF
	.dw Music47Ch1Data_Loop
Music47Ch0Data:
	.db $E0,$08,$74,$82,$11,$E2,$00
Music47Ch0Data_Loop:
	.db $FB,$E0,$08,$B5,$83,$51,$D1,$02,$ED,$84,$E9,$7D,$EA,$8C
	.db $FD
	.dw Music47Section0
	.db $A4,$EA,$00,$FE,$04,$FC,$E0,$08,$36,$82,$51,$FB,$F1,$EA,$8C
	.db $FD
	.dw Music47Section0
	.db $F5,$A4,$EA,$00,$FE,$02,$E8,$21,$ED,$00,$D1,$00,$F1,$E3,$33,$31
	.db $E8,$81,$F5,$E2,$11,$E1,$A1,$A1,$E2,$31,$E1,$81,$81,$F1,$E8,$21
	.db $E3,$31,$F5,$32,$F1,$31,$F5,$32,$F1,$33,$31,$E8,$81,$F5,$E2,$11
	.db $E1,$A1,$A1,$E2,$31,$E1,$81,$81,$A2,$04,$FE,$02,$E0,$08,$78,$82
	.db $91,$E9,$79
	.db $FD
	.dw Music47Section2
	.db $62,$61,$62,$EC,$02,$E8,$21,$F2,$E4,$31,$31,$D1,$00,$F5,$32,$E0
	.db $08,$78,$82,$A1
	.db $FD
	.dw Music47Section2
	.db $E0,$08,$32,$02,$31,$E3,$83,$72,$61,$61,$F5,$62
	.db $FE,$FF
	.dw Music47Ch0Data_Loop
Music47Ch2Data:
	.db $E0,$08,$0F,$E3,$00
Music47Ch2Data_Loop:
	.db $E0,$08,$0F,$FB
	.db $FD
	.dw Music47Section0
	.db $04,$FE,$04,$FB
	.db $FD
	.dw Music47Section0
	.db $04,$FE,$08,$FB
	.db $FD
	.dw Music47Section0
	.db $04,$FE,$03
	.db $FD
	.dw Music47Section0
	.db $FB,$E7,$01,$E4,$81,$71,$61,$51,$41,$31,$21,$11,$FE,$02,$E3,$C1
	.db $B1,$A1,$91,$81,$71,$61,$09,$E0,$08,$0F,$FB
	.db $FD
	.dw Music47Section0
	.db $04,$FE,$03
	.db $FD
	.dw Music47Section0
	.db $FB,$E7,$01,$11,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$FE,$02,$51,$41
	.db $31,$21,$0C
	.db $FE,$FF
	.dw Music47Ch2Data_Loop
Music47Ch5Data:
	.db $E8,$B1,$B1,$B1,$B1,$A1,$B1,$B1,$A1,$B1,$B1,$A1,$B1,$A1,$A1,$A1
	.db $A1
Music47Ch5Data_Loop:
	.db $FB,$B4,$A3,$B1,$B2,$B2,$A1,$B1,$11,$11,$FE,$04,$FC,$FB,$B4,$A3
	.db $B1,$B2,$B2,$A1,$B1,$11,$11,$FE,$03,$B4,$A3,$B1,$B2,$B2,$A1,$B1
	.db $B1,$B1,$FE,$02
	.db $FD
	.dw Music47Section3
	.db $02
	.db $FD
	.dw Music47Section3
	.db $B1,$A1
	.db $FE,$FF
	.dw Music47Ch5Data_Loop
Music47Section0:
	.db $E2,$A1,$A1,$A1,$A1,$E3,$11,$E2,$A1,$A1,$E3,$31,$E2,$81,$81,$A2
	.db $FF
Music47Section1:
	.db $E0,$08,$30,$04,$01,$F4,$E1,$A1,$A1,$A1,$A1,$A2,$A1,$A1,$F0,$E2
	.db $A8,$B8,$88,$A2,$E1,$A9,$F4,$A1,$F1,$E7,$01,$B1,$C1,$E2,$11,$21
	.db $31,$41,$51,$61,$71,$81,$91,$A1,$B2,$E3,$12,$22,$32,$42,$52,$62
	.db $72,$82,$92
	.db $FF
Music47Section2:
	.db $F2,$E2,$51,$51,$51,$51,$52,$51,$52,$51,$52,$54,$61,$61,$61,$61
	.db $62,$61,$62,$61,$62,$64,$51,$51,$51,$51,$52,$51,$52,$51,$52,$54
	.db $61,$61,$61,$61,$62,$61
	.db $FF
Music47Section3:
	.db $FB,$B4,$A1,$B2,$B1,$B1,$B2,$B1,$A1,$B2,$B1,$FE,$03,$B3,$B1,$A1
	.db $B2,$B1,$B1,$B2,$B1,$A1,$A1
	.db $FF
Music52Ch1Data:
	.db $EA,$0C,$E0,$03,$B0,$01,$01
	.db $FD
	.dw Music52Section0
	.db $F5,$82,$EA,$00
Music52Ch1Data_Loop:
	.db $E0,$06,$78,$82,$41
	.db $FD
	.dw Music52Section1
	.db $FE,$FF
	.dw Music52Ch1Data_Loop
Music52Ch0Data:
	.db $EA,$0C,$E0,$03,$B3,$01,$01,$02
	.db $FD
	.dw Music52Section0
	.db $EA,$00,$E0,$06,$74,$82,$31,$03
Music52Ch0Data_Loop:
	.db $FD
	.dw Music52Section1
	.db $FE,$FF
	.dw Music52Ch0Data_Loop
Music52Ch2Data:
	.db $E0,$03,$00,$00,$06
Music52Ch2Data_Loop:
	.db $E0,$06,$00,$FB,$E2,$A6,$E3,$56,$A4,$FE,$02,$FB,$E2,$A6,$E3,$66
	.db $A4,$FE,$02
	.db $FE,$FF
	.dw Music52Ch2Data_Loop
Music52Ch5Data:
	.db $FF
Music52Section0:
	.db $E4,$A2,$E5,$22,$42,$88,$F2,$82,$F3,$82,$F4,$82
	.db $FF
Music52Section1:
	.db $E9,$7C,$FB,$E3,$52,$A2,$C2,$E4,$22,$FE,$04,$FB,$E3,$62,$A2,$C2
	.db $E4,$12,$FE,$03,$52,$32,$22,$32
	.db $FF
	.db $FF
Music48Ch1Data:
	.db $EE,$0C,$EF,$81,$E0,$07,$78,$81,$41,$E9,$7D,$EB,$05,$01,$FB
	.db $FD
	.dw Music48Section0
	.db $E3,$11,$E2,$C1,$FE,$02
Music48Ch1Data_Loop:
	.db $E0,$07,$78,$81,$41,$FB
	.db $FD
	.dw Music48Section0
	.db $E3,$11,$E2,$C1,$FE,$04,$F4,$C2,$E0,$07,$30,$01,$51,$EB,$01,$01
	.db $FD
	.dw Music48Section1
	.db $E0,$07,$B0,$03,$31,$E9,$BC,$EB,$06,$21,$E4,$88,$74,$64,$5E,$51
	.db $71,$88,$74,$64,$58,$E5,$56,$E7,$01,$41,$31,$21,$11,$E4,$C1,$B1
	.db $A1,$91,$81,$71,$61,$51,$41,$31,$E0,$07,$30,$03,$31,$E9,$7D,$E3
	.db $33,$55,$33,$55,$83,$73,$57,$F4,$51,$F0,$51,$71,$88,$78,$EB,$05
	.db $01,$81,$A1,$A1,$81,$A1,$A1,$81,$A1,$81,$A1,$B1,$C3,$E7,$01,$B1
	.db $A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E2,$C1,$B1,$A1
	.db $FE,$FF
	.dw Music48Ch1Data_Loop
Music48Ch0Data:
	.db $E0,$07,$74,$81,$41,$02,$E9,$3D,$ED,$82,$FB
	.db $FD
	.dw Music48Section0
	.db $E3,$11,$E2,$C1
	.db $FD
	.dw Music48Section0
Music48Ch0Data_Loop:
	.db $E0,$07,$74,$81,$41,$E2,$C2,$FB
	.db $FD
	.dw Music48Section0
	.db $E3,$11,$E2,$C1,$FE,$04,$ED,$00,$EA,$85,$E0,$07,$31,$01,$51,$E9
	.db $7D
	.db $FD
	.dw Music48Section1
	.db $EA,$00,$E0,$07,$77,$82,$41,$E9,$3D,$D1,$02,$E3,$81,$E2,$81,$E3
	.db $31,$82,$E2,$81,$E3,$31,$81,$71,$E2,$A1,$E3,$31,$71,$61,$E2,$A1
	.db $E3,$11,$61,$51,$FB,$E2,$A1,$C1,$E3,$52,$FE,$02,$E2,$A1,$C1,$E3
	.db $51,$81,$71,$51,$71,$81,$E2,$81,$E3,$31,$82,$E2,$81,$E3,$31,$81
	.db $71,$E2,$A1,$E3,$31,$71,$61,$E2,$A1,$E3,$11,$61,$51,$E2,$A1,$C1
	.db $E3,$52,$E8,$01,$A1,$C1,$E4,$59,$E0,$07,$78,$82,$41,$E2,$31,$F2
	.db $FB,$E2,$A1,$C1,$E3,$52,$FE,$02,$E2,$A1,$C1,$E3,$32,$E2,$A1,$C1
	.db $E3,$31,$FB,$E3,$31,$51,$51,$E2,$C1,$FE,$03,$E3,$81,$71,$51,$52
	.db $E2,$A1,$C1,$E3,$52,$E2,$A1,$E3,$81,$72,$E2,$A1,$E3,$31,$72,$81
	.db $71,$31,$E8,$31,$E9,$30,$E3,$31,$51,$51,$31,$51,$51,$31,$51,$31
	.db $51,$61,$73,$E7,$01,$61,$51,$41,$31,$21,$11,$E2,$C1,$B1,$A1,$91
	.db $81,$71,$61,$51,$D1,$00
	.db $FE,$FF
	.dw Music48Ch0Data_Loop
Music48Ch2Data:
	.db $E0,$07,$00,$E3,$51,$51,$0D,$51,$51,$51,$0B,$81,$72
Music48Ch2Data_Loop:
	.db $FD
	.dw Music48Section2
	.db $FD
	.dw Music48Section2
	.db $FD
	.dw Music48Section3
	.db $51,$51,$E4,$51,$E3,$C1
	.db $FD
	.dw Music48Section3
	.db $A1,$81,$71,$51,$E3,$11,$11,$51,$11,$C1,$E4,$11,$E3,$C1,$32,$31
	.db $71,$31,$A1,$C1,$A1,$52,$51,$81,$51,$A1,$81,$71,$52,$51,$81,$51
	.db $C1,$A1,$81,$12,$11,$81,$11,$C1,$E4,$11,$E3,$C1,$32,$31,$71,$31
	.db $31,$31,$31,$81,$A2,$A1,$A1,$A1,$A1,$A1,$A1,$A1,$C1,$C1,$A1,$C1
	.db $C3
	.db $FE,$FF
	.dw Music48Ch2Data_Loop
Music48Ch5Data:
	.db $E7,$B1,$B1,$FB,$12,$FE,$06,$11,$B1,$B1,$B1,$12,$12,$12,$B1,$B1
	.db $B1,$A1,$A1,$A1,$A1,$A1
Music48Ch5Data_Loop:
	.db $FD
	.dw Music48Section4
	.db $B2,$A1,$B2,$A1,$A1,$A1
	.db $FD
	.dw Music48Section4
	.db $B2,$A1,$B2,$A1,$A1,$A1
	.db $FD
	.dw Music48Section4
	.db $B1,$B1,$B1,$B1,$A1,$A1,$A1,$A1
	.db $FD
	.dw Music48Section4
	.db $B2,$A1,$B2,$A1,$A1,$A1
	.db $FE,$FF
	.dw Music48Ch5Data_Loop
Music48Section0:
	.db $E2,$51,$C1,$E3,$11,$E2,$51,$C1,$E3,$31,$E2,$51,$C1,$E3,$11,$E2
	.db $51,$C1,$E3,$31,$E2,$51,$C1
	.db $FF
Music48Section1:
	.db $E3,$52,$83,$54,$82,$91,$A1,$F4,$A3,$F0,$52,$83,$56,$A1,$81,$71
	.db $F4,$72,$F0,$52,$83,$F0,$54,$82,$91,$A1,$F4,$A3,$F0,$52,$83,$51
	.db $E8,$21,$B3,$C5
	.db $FF
Music48Section2:
	.db $E0,$07,$0F,$FC,$E3,$52,$FB,$51,$FE,$0B,$81,$32,$FE,$04
	.db $FF
Music48Section3:
	.db $E3,$82,$FB,$81,$FE,$06,$72,$71,$71,$61,$61,$61,$61,$52,$51,$51
	.db $51,$51,$E4,$51,$E3,$51,$52,$51,$51
	.db $FF
Music48Section4:
	.db $E7,$FB,$B2,$A1,$B2,$B1,$A2,$FE,$03,$B1,$B1,$A1,$B2,$B1,$A2,$FB
	.db $B2,$A1,$B2,$B1,$A2,$FE,$03
	.db $FF
	.db $FF
Music49Ch1Data:
	.db $EE,$08,$EF,$83,$E0,$05,$30,$01,$42,$E9,$38
	.db $FD
	.dw Music49Section0
	.db $FD
	.dw Music49Section1
	.db $FB,$E0,$05,$78,$82,$56,$E9,$39,$D1,$03,$02
	.db $FD
	.dw Music49Section2
	.db $E9,$30
	.db $FD
	.dw Music49Section3
	.db $FE,$02,$D1,$00,$E0,$05,$B0,$03,$36,$EB,$04,$31
	.db $FD
	.dw Music49Section4
	.db $CA,$E0,$05,$70,$01,$42,$E9,$78,$D1,$01,$EB,$02,$01
	.db $FD
	.dw Music49Section5
	.db $E9,$30
	.db $FD
	.dw Music49Section6
	.db $FE,$FF
	.dw Music49Ch1Data
Music49Ch0Data:
	.db $E0,$05,$33,$01,$32,$02,$E9,$38
	.db $FD
	.dw Music49Section0
	.db $F4
	.db $FD
	.dw Music49Section1
	.db $EA,$85,$E0,$05,$37,$82,$56,$D1,$02,$E9,$79
	.db $FD
	.dw Music49Section2
	.db $E9,$39
	.db $FD
	.dw Music49Section3
	.db $F4,$12,$F0
	.db $FD
	.dw Music49Section2
	.db $FD
	.dw Music49Section3
	.db $D1,$00,$EA,$00,$E0,$05,$B4,$03,$36,$03
	.db $FD
	.dw Music49Section4
	.db $C7,$EA,$85,$E0,$05,$32,$01,$42,$E9,$38,$D1,$01
	.db $FD
	.dw Music49Section5
	.db $FD
	.dw Music49Section6
	.db $EA,$00
	.db $FE,$FF
	.dw Music49Ch0Data
Music49Ch2Data:
	.db $E0,$05,$0B,$E3,$FC,$FB,$A1,$A1,$A1,$A1,$FE,$04,$FE,$08,$E0,$05
	.db $0A,$FC,$E3,$FB,$31,$31,$31,$31,$FE,$08,$FB,$A1,$A1,$A1,$A1,$FE
	.db $08,$FE,$02,$FC,$E3,$FB,$61,$61,$61,$61,$FE,$08,$FB,$81,$81,$81
	.db $81,$FE,$08,$FE,$02
	.db $FD
	.dw Music49Section7
	.db $61,$61,$61,$61,$FB,$81,$81,$81,$81,$FE,$04
	.db $FD
	.dw Music49Section7
	.db $61,$61,$E0,$05,$0C,$E4,$34,$32,$32,$08,$E7,$01,$31,$21,$11,$E3
	.db $C1,$B1,$A1,$91,$81,$71,$61
	.db $FE,$FF
	.dw Music49Ch2Data
Music49Ch5Data:
	.db $FD
	.dw Music49Section8
	.db $B1,$B1,$B1,$B1,$A1,$B1,$B1,$B1,$A1,$A2,$A2,$A1,$A1,$A1
	.db $FD
	.dw Music49Section8
	.db $B2,$B1,$B1,$A4,$A1,$A2,$A2,$A1,$A1,$A1
	.db $FD
	.dw Music49Section8
	.db $B2,$B1,$B1,$A4,$B1,$FB,$A1,$FE,$07,$FB,$B2,$B1,$B1,$A4,$FE,$07
	.db $B2,$B1,$B1,$A1,$B1,$B1,$B1,$FB,$B2,$B1,$B1,$A4,$FE,$05,$B2,$B1
	.db $B1,$A2,$A4,$A2,$A8,$A1,$A1,$A1,$A1
	.db $FE,$FF
	.dw Music49Ch5Data
Music49Section0:
	.db $FB,$E3,$A1,$C1,$E4,$11,$51,$FE,$04,$FB,$E3,$A1,$C1,$E4,$11,$31
	.db $FE,$04,$FB,$E3,$A1,$C1,$E4,$11,$61,$FE,$04,$FB,$E3,$A1,$C1,$E4
	.db $11,$51,$FE,$08,$FB,$E3,$A1,$C1,$E4,$11,$31,$FE,$04,$FB,$E3,$A1
	.db $C1,$E4,$11,$61,$FE,$04
	.db $FF
Music49Section1:
	.db $51,$31,$11,$E3,$C1,$E4,$31,$11,$E3,$C1,$A1,$E4,$31,$11,$E3,$C1
	.db $A1,$E4,$11,$E3,$C1,$81,$A1
	.db $FF
Music49Section2:
	.db $D2,$E3,$AC,$A1,$C1,$E4,$12,$E3,$C2,$A2,$82,$A2,$C4,$A4
	.db $FF
Music49Section3:
	.db $E4,$12,$12,$02,$32,$32,$02,$12,$02,$12,$12,$02,$32,$12,$E3,$C2
	.db $E4,$12,$D2
	.db $FF
Music49Section4:
	.db $E3,$51,$A1,$E4,$11,$59,$32,$12,$56,$1A,$E3,$51,$A1,$E4,$11,$E4
	.db $59,$32,$12,$A6,$8A,$E3,$51,$A1,$E4,$11,$59,$32,$12,$56,$1A,$E3
	.db $51,$A1,$E4,$11,$E4,$59,$32,$12,$A6
	.db $FF
Music49Section5:
	.db $E5,$12,$D2,$E4,$C2,$02,$A2,$02,$82,$02,$A2,$02,$C2,$02,$E5,$1A
	.db $E5,$12,$E4,$C2,$02,$A2,$02,$82,$02,$A2,$02,$C2,$02,$E5,$14,$32
	.db $12,$E4,$C2,$E5,$12,$E4,$C2,$02,$A2,$02,$82,$02,$A2,$02,$C2,$02
	.db $E5,$1A,$E5,$12,$E4,$C2,$02,$A2,$02,$82,$02
	.db $FF
Music49Section6:
	.db $E5,$34,$32,$D2,$32,$F2,$32,$F3,$32,$F4,$32,$F0,$EB,$02,$00,$E7
	.db $01,$31,$21,$11,$E4,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21
	.db $11,$E3,$C1,$B1,$A1,$91,$81,$D1,$00
	.db $FF
Music49Section7:
	.db $E3,$FB,$A1,$A1,$A1,$A1,$FE,$08,$FB,$61,$61,$61,$61,$FE,$03
	.db $FF
Music49Section8:
	.db $E5,$FB,$B2,$B1,$B1,$A4,$FE,$07,$B2,$B1,$B1,$A2,$A1,$A1,$FB,$B2
	.db $B1,$B1,$A4,$FE,$06
	.db $FF
	.db $FF
Music4ACh1Data:
	.db $EE,$06
	.db $FD
	.dw Music4ASection0
Music4ACh1Data_Loop:
	.db $E0,$03,$78,$82,$31,$D1,$03,$E9,$3D
	.db $FD
	.dw Music4ASection1
	.db $E0,$03,$30,$03,$52,$E9,$38,$D1,$00,$EB,$02,$01
	.db $FD
	.dw Music4ASection2
	.db $EB,$02,$00,$E0,$03,$B0,$03,$32
	.db $FD
	.dw Music4ASection3
	.db $72,$82,$A2,$82,$72,$A2,$E0,$03,$70,$03,$31,$EB,$04,$31,$D1,$01
	.db $E9,$BD
	.db $FD
	.dw Music4ASection4
	.db $54
	.db $FD
	.dw Music4ASection5
	.db $82,$E5,$12,$E4,$C4,$A4,$84,$73,$F3,$71,$EA,$8C,$E0
	.db $03,$30,$03,$31
	.db $FD
	.dw Music4ASection4
	.db $E8,$11,$5C,$F3,$52,$F0,$52
	.db $FD
	.dw Music4ASection6
	.db $EA,$00,$EB,$04,$00
	.db $FE,$FF
	.dw Music4ACh1Data_Loop
Music4ACh0Data:
	.db $EA,$85
	.db $FD
	.dw Music4ASection0
Music4ACh0Data_Loop:
	.db $E0,$03,$37,$82,$31,$D1,$03,$E9,$7D
	.db $FD
	.dw Music4ASection1
	.db $EA,$00,$E0,$03,$30,$06,$42,$E9,$3C,$D1,$00,$04
	.db $FD
	.dw Music4ASection2
	.db $E0,$03,$B0,$06,$22
	.db $FD
	.dw Music4ASection3
	.db $72,$82,$A2,$82,$E0,$03,$31,$03,$31,$D1,$01,$E9,$3C
	.db $FD
	.dw Music4ASection7
	.db $84,$F3,$83
	.db $FD
	.dw Music4ASection5
	.db $81,$F1,$E4,$34,$14,$E3,$C4,$A3,$F3,$A1,$EA,$8C,$E0,$03,$31,$03
	.db $31
	.db $FD
	.dw Music4ASection7
	.db $E8,$11,$8C,$F4,$82,$F0,$82,$EA,$85
	.db $FD
	.dw Music4ASection6
	.db $EA,$85
	.db $FE,$FF
	.dw Music4ACh0Data_Loop
Music4ACh2Data:
	.db $E0,$03,$00,$E2,$B2,$D0,$CE,$C4,$D0,$E7,$01,$B2,$A1,$91,$81,$71
	.db $61,$51,$41,$31,$21,$11
Music4ACh2Data_Loop:
	.db $E0,$03,$06,$E3,$FB,$52,$FE,$0B,$84,$92,$A2,$54,$FB,$52,$FE,$0A
	.db $84,$82,$82,$54,$FB,$52,$FE,$0A,$84,$92,$A2,$54,$FB,$52,$FE,$0A
	.db $84,$82,$82,$72,$E3,$FB,$52,$FE,$0D,$32,$42,$54,$FB,$52,$FE,$0C
	.db $82,$92,$A4,$FB,$A2,$FE,$0C,$82,$72,$54,$FB,$52,$FE,$0D,$32,$E2
	.db $A2,$E3
	.db $FD
	.dw Music4ASection8
	.db $82,$72,$52,$32
	.db $FD
	.dw Music4ASection8
	.db $32,$32,$52,$72
	.db $FD
	.dw Music4ASection9
	.db $34,$32,$32,$32,$32,$52,$72,$A2
	.db $FD
	.dw Music4ASection9
	.db $3A,$E0,$01,$00,$C9,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11
	.db $E2,$C1,$B1,$A1,$91
	.db $FE,$FF
	.dw Music4ACh2Data_Loop
Music4ACh5Data:
	.db $E3,$A2,$B2,$B2,$B2,$FE,$02,$FB,$A1,$FE,$08
Music4ACh5Data_Loop:
	.db $FD
	.dw Music4ASectionA
	.db $A2
	.db $FD
	.dw Music4ASectionA
	.db $A1,$A1,$FB,$B4,$A2,$B2,$B4,$A2,$B2,$B2,$B2,$B2,$A2,$B4,$A4,$FE
	.db $03,$B2,$B2,$B2,$A2,$B4,$A4,$A2,$B2,$B2,$A2,$B2,$B2,$A1,$A1,$A1
	.db $A1
	.db $FD
	.dw Music4ASectionA
	.db $A1,$A1,$FB,$B4,$A4,$B2,$B2,$A4,$FE,$06,$B4,$A4,$B4,$A2,$A2,$14
	.db $14,$14,$B1,$B1,$A2
	.db $FE,$FF
	.dw Music4ACh5Data_Loop
Music4ASection0:
	.db $E0,$03,$38,$82,$11,$D1,$03,$E2,$B2,$D0,$CE,$C4,$D0,$E7,$01,$B1
	.db $A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E1,$C1
	.db $FF
Music4ASection1:
	.db $E2,$52,$B2,$52,$52,$A2,$52,$52,$82,$32,$42,$52,$84,$92,$A2,$54
	.db $B2,$52,$52,$A2,$52,$52,$82,$32,$42,$52,$82,$F3,$82,$F0,$83,$F3
	.db $81,$F0,$54,$B2,$52,$52,$A2,$52,$52,$82,$32,$42,$52,$84,$92,$A2
	.db $54,$B2,$52,$52,$A2,$52,$52,$82,$32,$42,$52,$82,$F3,$82,$F0,$83
	.db $F3,$83
	.db $FF
Music4ASection2:
	.db $FB,$E3,$52,$82,$F4,$82,$F0,$52,$A2,$F4,$A2,$F0,$52,$B4,$52,$A2
	.db $F4,$A2,$F0,$52,$84,$32,$52,$82,$F4,$82,$F0,$52,$A2,$F4,$A2,$F0
	.db $52,$B4,$B2,$B4,$A2,$82,$52,$32,$FE,$02
	.db $FF
Music4ASection3:
	.db $E3,$14,$34,$54,$82,$74,$32,$F4,$32,$F2,$E4,$A2,$E5,$32,$E4,$A2
	.db $E5,$33,$F4,$31,$F0,$E3,$14,$34,$54,$82,$A4,$72,$F4,$74,$F2,$E5
	.db $32,$12,$E4,$C2,$A2,$F0,$E3,$14,$34,$54,$82,$74,$32,$F4,$32,$F2
	.db $E4,$A2,$E5,$32,$E4,$A2,$E5,$32,$F4,$32,$F0,$E3,$14,$34,$54,$82
	.db $74,$32
	.db $FF
Music4ASection4:
	.db $E4,$84,$82,$74,$72,$84,$82,$74,$72,$82,$74,$5C,$52,$82,$76,$54
	.db $34,$74,$84,$82,$74,$72,$84,$82,$74,$72,$82,$74
	.db $FF
Music4ASection5:
	.db $E3,$82,$E4,$12,$52,$12,$52
	.db $FF
Music4ASection6:
	.db $C6,$E7,$01,$B2,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E3,$C9
	.db $B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E2,$C1,$B1,$A1,$91
	.db $FF
Music4ASection7:
	.db $E3,$C4,$C2,$A4,$A2,$C4,$C2,$A4,$A2,$C2,$A4,$8C,$82,$C2,$A6,$84
	.db $74,$A4,$C4,$C2,$A4,$A2,$C4,$C2,$A4,$A2,$C2,$A4
	.db $FF
Music4ASection8:
	.db $FB,$12,$FE,$05,$52,$FB,$12,$FE,$0F,$52,$12,$12,$32,$32,$32,$32
	.db $FF
Music4ASection9:
	.db $E0,$03,$06,$E3,$52,$52,$52,$34,$32,$32,$54,$52,$52,$34,$32,$52
	.db $34,$FB,$12,$FE,$05,$52,$34,$32,$32,$32,$32,$52,$72,$32,$52,$52
	.db $52,$34,$32,$32,$54,$52,$52,$34,$32,$52,$34,$FB,$12,$FE,$05,$52
	.db $FF
Music4ASectionA:
	.db $E3,$FB,$B4,$A4,$B2,$B2,$A4,$FE,$07,$B4,$A4,$B2,$A2,$A2
	.db $FF
	.db $FF
Music4BCh1Data:
	.db $EE,$00,$E0,$04,$70,$00,$11,$E9,$BC,$E4,$1C,$20,$30,$E7,$08,$44
	.db $F2,$44,$F3,$44,$F4,$44,$F5,$42
Music4BCh1Data_Loop:
	.db $EA,$03,$E0,$03,$B0,$01,$61,$D1,$03,$E9,$79,$E3,$82
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection1
	.db $E3,$82
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection2
	.db $E0,$03,$78,$82,$61,$E9,$B9,$E3,$82
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection1
	.db $E3,$82
	.db $FD
	.dw Music4BSection0
	.db $B2,$E3,$82,$E0,$01,$70,$01,$71,$E4,$86,$8A,$71,$61,$51,$41,$31
	.db $21,$11,$E3,$C1
	.db $FE,$FF
	.dw Music4BCh1Data_Loop
Music4BCh0Data:
	.db $E0,$04,$70,$00,$11,$E9,$BC,$E3,$8C,$70,$A0,$E7,$08,$A4,$F2,$A4
	.db $F3,$A4,$F4,$A4,$F5,$A2
Music4BCh0Data_Loop:
	.db $EA,$03,$E0,$03,$B5,$82,$41,$E9,$B8,$ED,$82,$E3,$86
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection1
	.db $E3,$82
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection2
	.db $E0,$03,$75,$82,$41,$E3,$82
	.db $FD
	.dw Music4BSection0
	.db $FD
	.dw Music4BSection1
	.db $E3,$82
	.db $FD
	.dw Music4BSection0
	.db $E0,$01,$71,$01,$71,$E4,$36,$3A,$31,$21,$11,$E3,$C1,$B1,$A1,$91
	.db $81
	.db $FE,$FF
	.dw Music4BCh0Data_Loop
Music4BCh2Data:
	.db $E0,$04,$09,$E2,$82,$84,$82,$84,$82,$76,$74,$72,$72,$72,$66,$64
	.db $62,$62,$62,$86,$84,$82,$B2,$E3,$12,$22,$0C,$E0,$01,$00,$E4,$21
	.db $11,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E2,$C1
	.db $B1
Music4BCh2Data_Loop:
	.db $EA,$03
	.db $FD
	.dw Music4BSection3
	.db $FD
	.dw Music4BSection3
	.db $FE,$FF
	.dw Music4BCh2Data_Loop
Music4BCh5Data:
	.db $E4,$FB,$12,$14,$12,$FE,$08,$08,$FB,$A1,$FE,$08
Music4BCh5Data_Loop:
	.db $E3,$FB,$B4,$A4,$FE,$0F,$B2,$A2,$A2,$A2,$FB,$B4,$A4,$FE,$0F,$B2
	.db $A2,$A2,$A2
	.db $FE,$FF
	.dw Music4BCh5Data_Loop
Music4BSection0:
	.db $82,$B2,$82,$E4,$12,$E3,$82,$82,$B2,$82,$82,$E4,$12,$E3,$82,$82
	.db $B2,$E4,$12,$22,$E3,$82,$82,$B2,$82,$E4,$12,$E3,$82,$82,$B2,$82
	.db $82
	.db $FF
Music4BSection1:
	.db $B2,$E3,$82,$E4,$32,$22,$12,$E3,$B2
	.db $FF
Music4BSection2:
	.db $B2,$E3,$82,$F1,$E9,$70,$E4,$31,$21,$11,$E3,$B1,$E4,$11,$E3,$B1
	.db $A1,$81
	.db $FF
Music4BSection3:
	.db $E0,$03,$07,$FB,$E2,$82,$82,$E3,$82,$E2,$82,$82,$E3,$62,$E2,$82
	.db $82,$E3,$42,$E2,$82,$82,$E3,$32,$E2,$82,$82,$E3,$12,$E2,$82,$FE
	.db $02,$FB,$E2,$92,$92,$E3,$92,$E2,$92,$92,$E3,$82,$E2,$92,$92,$E3
	.db $62,$E2,$92,$92,$E3,$42,$E2,$92,$92,$E3,$22,$E2,$92,$FE,$02
	.db $FF
Music53Ch1Data:
	.db $EE,$00,$E0,$03,$30,$01,$21,$E9,$B9,$E5,$92,$32,$62,$22,$52,$12
	.db $42,$E4,$C2,$E5,$32,$E4,$B2,$E5,$22,$E4,$A2,$C2,$E5,$12,$42,$72
	.db $F4,$12,$42,$72
	.db $FF
Music53Ch0Data:
	.db $E0,$03,$74,$01,$11,$E9,$7C,$E5,$94,$32,$62,$22,$52,$12,$42,$E4
	.db $C2,$E5,$32,$E4,$B2,$E5,$22,$E4,$A2,$C2,$E5,$12,$42,$72,$F4,$12
	.db $42,$72
	.db $FF
Music53Ch2Data:
	.db $E0,$03,$06,$E4,$92,$32,$62,$22,$52,$12,$42,$E3,$C2,$E4,$32,$E3
	.db $B2,$E4,$22,$E3,$A2,$C2,$E4,$12,$42,$72
	.db $FF
Music53Ch5Data:
	.db $E3,$12,$22,$22,$22,$22,$FB,$12,$FE,$0A,$22
	.db $FF
	.db $FF
Music4CCh1Data:
	.db $E0,$01,$77,$82,$62
	.db $FD
	.dw Music4CSection0
	.db $E4,$36,$E3,$C7,$97
Music4CCh1Data_Loop:
	.db $E0,$05,$B9,$84,$33
	.db $FD
	.dw Music4CSection1
	.db $E0,$05,$70,$01,$43,$E9,$3D,$EB,$04,$21
	.db $FD
	.dw Music4CSection2
	.db $61,$F4,$61,$F0,$E4,$61,$61,$F4,$61,$F0
	.db $FD
	.dw Music4CSection3
	.db $B1,$91,$71,$61,$E9,$00,$E0,$05,$71,$01,$44
	.db $FD
	.dw Music4CSection4
	.db $EB,$04,$00
	.db $FE,$FF
	.dw Music4CCh1Data_Loop
Music4CCh0Data:
	.db $EE,$03,$E0,$01,$34,$82,$62,$07,$ED,$81
	.db $FD
	.dw Music4CSection0
	.db $EE,$0E,$E4,$36,$E3,$C7
Music4CCh0Data_Loop:
	.db $EA,$85,$E0,$05,$B8,$83,$36
	.db $FD
	.dw Music4CSection1
	.db $EA,$00,$E0,$05,$74,$01,$36,$E9,$BD,$02
	.db $FD
	.dw Music4CSection2
	.db $E4,$11,$11,$11,$F6,$12,$F4
	.db $FD
	.dw Music4CSection3
	.db $B1,$91,$E9,$00,$EA,$85,$E0,$05,$32,$01,$44
	.db $FD
	.dw Music4CSection4
	.db $FE,$FF
	.dw Music4CCh0Data_Loop
Music4CCh2Data:
	.db $E0,$05,$00,$E3,$98,$C8,$E4,$30
Music4CCh2Data_Loop:
	.db $E0,$05,$10,$FB,$E2,$A3,$A1,$02,$B4,$B2,$E3,$12,$22,$FE,$04,$E0
	.db $05,$0D,$E3,$FC,$FB,$91,$FE,$0E,$71,$71,$FE,$08,$E0,$05,$0D,$E2
	.db $FC,$FB,$B1,$FE,$10,$FB,$C1,$FE,$10,$FE,$04
	.db $FE,$FF
	.dw Music4CCh2Data_Loop
Music4CCh5Data:
	.db $E5,$14,$14,$14,$12,$12,$14,$14,$14,$A1,$A1,$A1,$A1,$E5,$FB,$A3
	.db $A3,$A4,$B2,$B2,$11,$11,$FE,$03,$A3,$A3,$A4,$B2,$A1,$A1,$A1,$A1
Music4CCh5Data_Loop:
	.db $FD
	.dw Music4CSection5
	.db $B2,$A2,$A2,$B2,$A1,$A1,$A1,$A1,$B1,$A1,$A1,$A1
	.db $FD
	.dw Music4CSection5
	.db $FB,$A1,$FE,$10,$FB,$B2,$A1,$B2,$B1,$A2,$FE,$07,$FB,$A1,$FE,$08
	.db $FE,$FF
	.dw Music4CCh5Data_Loop
Music4CSection0:
	.db $FB,$E3,$66,$97,$C7,$E4,$36,$E3,$C7,$97,$FE,$03,$E3,$66,$97,$C7
	.db $FF
Music4CSection1:
	.db $FB,$E3,$13,$11,$F4,$12,$F0,$24,$22,$32,$42,$FE,$04
	.db $FF
Music4CSection2:
	.db $FB,$E3,$91,$C1,$E4,$6A,$E3,$91,$C1,$E4,$72,$FE,$03,$61,$41,$21
	.db $E3,$C1,$E4,$41,$21,$E3,$C1,$B1,$C1,$B1,$91
	.db $FF
Music4CSection3:
	.db $FB,$E3,$91,$C1,$E4,$6A,$E3,$91,$C1,$E4,$72,$FE,$03,$62,$41,$61
	.db $72,$61,$71,$92,$71,$91
	.db $FF
Music4CSection4:
	.db $FC,$E4,$FB,$B1,$61,$31,$FE,$05,$B1,$FB,$C1,$61,$31,$FE,$05,$C1
	.db $FB,$B1,$61,$31,$FE,$05,$B1,$C1,$91,$61,$31,$91,$61,$31,$E3,$C1
	.db $E4,$61,$31,$E3,$C1,$91,$E4,$31,$E3,$C1,$91,$61,$FE,$02
	.db $FF
Music4CSection5:
	.db $E5,$FB,$B2,$A1,$B2,$B1,$A2,$FE,$07,$B2,$A1,$B2,$B1,$A1,$A1,$FB
	.db $B2,$A1,$B2,$B1,$A2,$FE,$06
	.db $FF
	.db $FF
Music51Ch1Data:
	.db $E0,$06,$30,$01,$21,$E9,$BD,$EB,$02,$01,$E3,$86
	.db $FD
	.dw Music51Section0
	.db $F0
	.db $FD
	.dw Music51Section1
	.db $E4,$38,$50,$10,$E3,$BC,$A4,$B8,$E4,$34,$64,$50,$E5,$10
	.db $FE,$FF
	.dw Music51Ch1Data
Music51Ch0Data:
	.db $E0,$06,$33,$01,$21,$E9,$3C,$D1,$03,$E3,$89
	.db $FD
	.dw Music51Section0
	.db $F3
	.db $FD
	.dw Music51Section1
	.db $E4,$35,$F3,$FB,$E5,$51,$31,$11,$E4,$81,$FE,$02,$F4,$FB,$E5,$51
	.db $31,$11,$E4,$81,$FE,$03,$F5,$FB,$E5,$51,$31,$11,$E4,$81,$FE,$03
	.db $F3,$E3,$BF,$A4,$B8,$E4,$34,$64,$50,$E5,$1D
	.db $FE,$FF
	.dw Music51Ch0Data
Music51Ch2Data:
	.db $E0,$06,$0A,$FB,$E3,$14,$E0,$01,$01,$18,$18,$18,$E0,$06,$0A,$12
	.db $12,$12,$12,$FE,$08,$FC,$FB,$E2,$B4,$E0,$01,$01,$B8,$B8,$B8,$E0
	.db $06,$0A,$B2,$B2,$B2,$B2,$FE,$02,$FB,$E3,$14,$E0,$01,$01,$18,$18
	.db $18,$E0,$06,$0A,$12,$12,$12,$12,$FE,$02,$FE,$02
	.db $FE,$FF
	.dw Music51Ch2Data
Music51Ch5Data:
	.db $E6,$A4,$E1,$A8,$A8,$A8,$E6,$A2,$A2,$A2,$A2
	.db $FE,$FF
	.dw Music51Ch5Data
Music51Section0:
	.db $E4,$16,$E3,$84,$66,$B6,$64,$83,$61,$5F,$F4,$5D
	.db $FF
Music51Section1:
	.db $86,$E4,$16,$E3,$84,$66,$B6,$E4,$34,$53,$31,$D0,$1C,$1C,$D0,$14
	.db $E3,$BC,$A4,$B8
	.db $FF
Music4DCh1Data:
	.db $EE,$07,$E0,$07,$30,$01,$22,$EB,$03,$03,$E4,$81,$81,$81,$61,$51
	.db $B4,$F4,$B1,$F0,$B1,$E5,$12,$F3,$11,$F4,$11
	.db $FF
Music4DCh0Data:
	.db $E0,$07,$30,$01,$22,$E4,$51,$51,$51,$31,$11,$64,$F4,$61,$F0,$61
	.db $82,$F3,$81,$F4,$81
	.db $FF
Music4DCh2Data:
	.db $E0,$07,$12,$E3,$81,$81,$81,$61,$51,$B5,$B1,$E4,$12
	.db $FF
Music4DCh5Data:
	.db $E7,$A1,$B1,$B1,$B1,$B1,$A5,$A1,$A1
	.db $FF
	.db $FF
Music54Ch1Data:
	.db $EA,$05,$EB,$01,$02
Music54Section0:
	.db $E0,$03,$30,$01,$21,$D1,$03,$E9,$38,$E3,$82,$82,$F4,$82,$F0,$0A
	.db $82,$62,$52,$66,$63,$F4,$61,$F0,$62,$52,$62,$E4,$12,$E3,$C2,$E4
	.db $12,$87,$F4,$81,$F0,$12,$12,$F4,$12,$F5,$11
	.db $FF
Music54Ch0Data:
	.db $EE,$05,$EB,$01,$01
	.db $FD
	.dw Music54Section0
	.db $FF
Music54Ch2Data:
	.db $E0,$03,$0A,$E3,$12,$12,$52,$12,$82,$62,$52,$12,$E2,$B2,$B2,$E3
	.db $32,$E2,$B2,$E3,$62,$52,$32,$52,$E0,$03,$00,$A6,$96,$88,$62,$62
	.db $FF
Music54Ch5Data:
	.db $E3,$B4,$A4,$B2,$B2,$A4,$B2,$B2,$A2,$B4,$B2,$A4,$B2,$A2,$A2,$B2
	.db $A2,$A2,$B8,$A2,$A2
	.db $FF
Music55Ch1Data:
	.db $EB,$01,$01,$E0,$04,$30,$01,$31,$D1,$01,$E3,$A2,$E4,$12,$52,$82
	.db $74,$72,$32,$64,$62,$54,$36,$C6,$C6,$E5,$25,$F4,$22,$F5,$21
	.db $FF
Music55Ch0Data:
	.db $E0,$04,$B0,$01,$31,$D1,$01,$E3,$52,$A2,$E4,$12,$52,$34,$32,$E3
	.db $A2,$E4,$14,$12,$E3,$C4,$A6,$E4,$86,$86,$A5,$F4,$A2,$F5,$A1
	.db $FF
Music55Ch2Data:
	.db $E0,$04,$0A,$E3,$FB,$A2,$FE,$08,$FB,$62,$FE,$08,$E0,$01,$0A,$FB
	.db $E4,$3C,$21,$11,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$FE
	.db $02,$E4,$58,$41,$31,$21,$11,$E3,$C1,$B1,$A1,$91,$81,$71,$61,$51
	.db $41,$31,$21
	.db $FF
Music55Ch5Data:
	.db $E4,$B4,$A4,$B2,$B2,$A4,$B2,$B2,$A2,$B4,$B2,$A4,$A2,$B2,$B2,$A2
	.db $B2,$B2,$A1,$A1,$B2
	.db $FF
	.db $FF
Music4ECh1Data:
	.db $FB,$E0,$05,$B1,$01,$41,$E9,$BC
	.db $FD
	.dw Music4ESection0
	.db $FE,$FF
	.dw Music4ECh1Data
Music4ECh0Data:
	.db $E0,$05,$B4,$01,$31,$E3,$03
Music4ECh0Data_Loop:
	.db $FB,$E0,$05,$B4,$01,$31
	.db $FD
	.dw Music4ESection0
	.db $FE,$FF
	.dw Music4ECh0Data_Loop
Music4ECh2Data:
	.db $E0,$05,$00,$E3,$A0,$A0,$80,$80
	.db $FE,$FF
	.dw Music4ECh2Data
Music4ECh5Data:
	.db $E5,$B2,$B2,$A4,$B4,$B4
	.db $FE,$FF
	.dw Music4ECh5Data
Music4ESection0:
	.db $E3,$C2,$A2,$E4,$52,$E3,$A2,$E3,$C2,$A2,$E4,$52,$E3,$A2
	.db $FF
Music4FCh1Data:
	.db $EF,$83,$E0,$04,$B8,$81,$23,$E4,$00,$04
Music4FCh1Data_Loop:
	.db $E0,$04,$B0,$01,$23,$D1,$01,$EB,$01,$01,$E9,$BD
	.db $FD
	.dw Music4FSection0
	.db $E9,$30,$FB
	.db $FD
	.dw Music4FSection4
	.db $FE,$05,$E3,$62,$82,$F3,$82,$F4,$82,$E0,$04,$B0,$01,$23
	.db $FD
	.dw Music4FSection0
	.db $E9,$30,$FB
	.db $FD
	.dw Music4FSection4
	.db $FE,$04,$F3,$12,$F4,$12,$F0,$E3,$B3,$F4,$B3,$F0,$B4,$E4,$10,$F3
	.db $12,$E0,$04,$30,$01,$41,$D1,$02,$EB,$04,$61,$E9,$3C
	.db $FD
	.dw Music4FSection1
	.db $FE,$FF
	.dw Music4FCh1Data_Loop
Music4FCh0Data:
	.db $E0,$04,$38,$84,$41,$E4,$00,$04
Music4FCh0Data_Loop:
	.db $EA,$85,$E0,$04,$31,$01,$23,$D1,$03,$E9,$3C
	.db $FD
	.dw Music4FSection0
	.db $F3,$43,$EA,$00,$FB
	.db $FD
	.dw Music4FSection4
	.db $FE,$05,$E3,$62,$82,$F4,$81,$EA,$85,$E0,$04,$32,$01,$23
	.db $FD
	.dw Music4FSection0
	.db $F3,$43,$EA,$00,$FB
	.db $FD
	.dw Music4FSection4
	.db $FE,$04,$F4,$11,$F1,$EA,$85,$E3,$B3,$F4,$B3,$F1,$B4,$E4,$10,$F3
	.db $12,$EA,$85,$E0,$04,$32,$01,$41,$D1,$02,$E9,$3C,$F0
	.db $FD
	.dw Music4FSection1
	.db $FE,$FF
	.dw Music4FCh0Data_Loop
Music4FCh2Data:
	.db $E0,$04,$00,$08,$E7,$02,$E4,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41
	.db $31,$21,$11,$E3,$C1,$B1,$A1,$91
Music4FCh2Data_Loop:
	.db $E0,$04,$09,$FC
	.db $FD
	.dw Music4FSection2
	.db $FB,$82,$FE,$08,$E0,$04,$09,$FC
	.db $FD
	.dw Music4FSection2
	.db $04,$E3,$B4,$02,$B4,$E4,$14,$E0,$04,$09,$FB,$E4,$12,$FE,$0F,$FB
	.db $E3,$B2,$FE,$10,$FB,$A2,$FE,$0F,$64,$FB,$62,$FE,$06,$84,$FB,$82
	.db $FE,$06,$E4,$14,$FB,$12,$FE,$0F,$FB,$E3,$B2,$FE,$0F,$E4,$12
	.db $FE,$FF
	.dw Music4FCh2Data_Loop
Music4FCh5Data:
	.db $E4,$FB,$A2,$FE,$07,$A1,$A1
Music4FCh5Data_Loop:
	.db $E4,$FC,$FB,$B4,$A4,$B2,$B2,$A4,$FE,$03,$B4,$A4,$B2,$B2,$A2,$A1
	.db $A1,$FE,$02
	.db $FD
	.dw Music4FSection3
	.db $A2,$A1,$A1,$FB,$B4,$A4,$B2,$B2,$A4,$FE,$03,$B4,$A4,$B2,$A4,$A2
	.db $FB,$B4,$A4,$B2,$B2,$A4,$FE,$07,$B4,$A4,$B2,$B2,$A2,$A1,$A1
	.db $FD
	.dw Music4FSection3
	.db $A1,$A1,$A1,$A1
	.db $FE,$FF
	.dw Music4FCh5Data_Loop
Music4FSection0:
	.db $E3,$9A,$78,$64,$72,$62,$42,$F4,$44,$F0,$9A,$78,$64,$72,$62,$42
	.db $FF
Music4FSection1:
	.db $E4,$82,$62,$52,$66,$64,$82,$8E,$82,$62,$52,$B6,$B2,$E5,$1D,$E7
	.db $01,$E4,$C1,$B1,$A1,$91,$81,$71,$61,$51,$41,$31,$21,$11,$E7,$04
	.db $E4,$1A,$12,$32,$52,$1E,$12,$34,$52,$52,$62,$62,$52,$32,$52,$82
	.db $8E,$82,$62,$52,$66,$64,$82,$8E,$82,$62,$52,$B6,$B2,$E5,$12,$F2
	.db $12,$F3,$12
	.db $FF
Music4FSection2:
	.db $FB,$E3,$92,$FE,$08,$FE,$04,$FC,$FB,$82,$FE,$08,$FE,$03
	.db $FF
Music4FSection3:
	.db $FB,$B4,$A4,$B2,$B2,$A4,$FE,$03,$B4,$A4,$B2,$B2
	.db $FF
Music4FSection4:
	.db $E3,$62,$82,$B2,$62,$82,$E4,$12
	.db $FF
Music50Ch1Data:
	.db $EF,$84,$E0,$07,$B0,$03,$31,$E9,$BC,$EB,$07,$21,$E4,$82,$8E,$82
	.db $62,$52,$66,$64,$82,$8E,$82,$62,$52,$E8,$11,$B8,$A1,$91
	.db $FE,$FF
	.dw Music50Ch1Data
Music50Ch0Data:
	.db $E0,$07,$B3,$03,$31,$02
Music50Ch0Data_Loop:
	.db $E0,$07,$B3,$03,$31,$ED,$81,$E4,$82,$8E,$82,$62,$52,$66,$64,$82
	.db $8E,$82,$62,$52,$E8,$11,$B8,$A1,$91
	.db $FE,$FF
	.dw Music50Ch0Data_Loop
Music50Ch2Data:
	.db $E0,$07,$0F,$FB,$E4,$12,$FE,$10,$FB,$E3,$B2,$FE,$10,$FB,$A2,$FE
	.db $10,$FB,$62,$FE,$08,$FB,$82,$FE,$06,$A2,$B2
	.db $FE,$FF
	.dw Music50Ch2Data
Music50Ch5Data:
	.db $E7,$B4,$A4,$B2,$B2,$A2,$11,$11
	.db $FE,$FF
	.dw Music50Ch5Data
	.db $FF
Music56Ch1Data:
	.db $E0,$06,$B1,$01,$46,$E4,$82,$E5,$12,$32,$82,$FE,$0C
Music56Ch1Data_Loop:
	.db $FD
	.dw Music56Section0
	.db $EB,$08,$01,$E3,$8C,$E4,$13,$11,$E3,$BC,$B4,$AA,$84,$62,$80,$E3
	.db $8C,$E4,$13,$11,$E3,$BC,$B4,$AA,$84,$62,$50,$FC,$E0,$06,$70,$01
	.db $16,$EB,$07,$01
	.db $FD
	.dw Music56Section1
	.db $F0
	.db $FD
	.dw Music56Section2
	.db $80,$F1,$EB,$02,$01,$C8,$E5,$14,$34,$FC,$E0,$01,$31,$01,$46,$EB
	.db $02,$01,$E5,$58,$F4,$58,$F0,$18,$E7,$06,$16,$E4,$B4,$A2,$86,$64
	.db $54,$32,$E7,$01,$58,$F4,$58,$F0,$18,$E7,$06,$16,$12,$E3,$B2,$A2
	.db $8A,$64,$52,$E7,$01,$68,$F4,$68,$F0,$18,$E7,$06,$16,$12,$62,$A2
	.db $E4,$1A,$12,$62,$A2,$E8,$26,$E5,$10,$30,$FE,$02
	.db $FE,$FF
	.dw Music56Ch1Data_Loop
Music56Ch0Data:
	.db $E0,$06,$B5,$01,$46,$03,$FB,$E4,$82,$E5,$12,$32,$82,$FE,$0B,$E4
	.db $82,$E5,$12,$31
Music56Ch0Data_Loop:
	.db $FD
	.dw Music56Section0
	.db $E3,$1C,$53,$51,$3C,$34,$1A,$54,$32,$50,$1C,$53,$51,$3C,$34,$1A
	.db $54,$32,$10,$E0,$06,$74,$01,$16,$03,$FC,$E9,$70,$E3
	.db $FD
	.dw Music56Section1
	.db $FD
	.dw Music56Section2
	.db $8D,$F2,$88,$84,$C4,$FB,$E0,$01,$31,$01,$46,$E4,$88,$F4,$88,$F1
	.db $58,$E7,$06,$56,$34,$12,$E3,$B6,$B4,$84,$62,$E7,$01,$88,$F4,$88
	.db $F1,$58,$E7,$06,$56,$52,$32,$12,$E2,$BA,$A4,$82,$E7,$01,$A8,$F4
	.db $A8,$F1,$A8,$E7,$06,$A6,$A2,$E3,$12,$62,$AA,$A2,$E4,$12,$62,$E8
	.db $26,$90,$B0,$FE,$02
	.db $FE,$FF
	.dw Music56Ch0Data_Loop
Music56Ch2Data:
	.db $E0,$06,$00,$E2,$8C,$E3,$34,$80,$8C,$E4,$34,$80,$EE,$08,$88,$EE
	.db $04,$88,$EE,$03,$88,$EE,$02,$88,$EE,$00
Music56Ch2Data_Loop:
	.db $E0,$06,$0F,$E3,$FB,$14,$02,$11,$11,$12,$12,$12,$12,$FE,$08,$E2
	.db $FC,$FB,$B4,$02,$B1,$B1,$B2,$B2,$B2,$62,$B4,$02,$B1,$B1,$B2,$B2
	.db $B2,$62,$EA,$02,$FE,$02,$EA,$00,$FE,$02,$FB,$94,$02,$91,$91,$92
	.db $92,$92,$92,$FE,$02,$84,$02,$81,$81,$82,$82,$82,$82,$84,$02,$81
	.db $81,$A4,$C4
	.db $FD
	.dw Music56Section3
	.db $FD
	.dw Music56Section3
	.db $FE,$FF
	.dw Music56Ch2Data_Loop
Music56Ch5Data:
	.db $E6,$FB,$00,$FE,$05,$0F,$E3,$A1,$A1
	.db $FD
	.dw Music56Section4
	.db $FD
	.dw Music56Section4
	.db $E6,$FB,$B2,$11,$11,$A2,$11,$11,$FE,$07,$B2,$B1,$B1,$A1,$A1,$A1
	.db $A1
Music56Ch5Data_Loop:
	.db $E6
	.db $FD
	.dw Music56Section5
	.db $11,$11,$B2,$11,$11,$A2,$A1,$A1
	.db $FD
	.dw Music56Section5
	.db $B2,$FB,$A1,$FE,$08,$FB,$B4,$A4,$B2,$B2,$A4,$B2,$B2,$A2,$B4,$B2
	.db $A2,$11,$11,$FE,$09,$FB,$B4,$A4,$FE,$03,$FB,$A1,$FE,$08
	.db $FE,$FF
	.dw Music56Ch5Data_Loop
Music56Section0:
	.db $E0,$06,$30,$01,$36,$D1,$02,$E9,$3C
	.db $FF
Music56Section1:
	.db $E3,$31,$51,$6C,$E9,$30,$E3,$FB,$31,$51,$FE,$03,$61,$81,$61,$81
	.db $A1,$B1,$A1,$B1,$E4,$11,$31,$11,$31,$E9,$70,$E3,$51,$61,$8C,$E9
	.db $30,$E3,$FB,$51,$61,$FE,$03,$81,$A1,$81,$A1,$FB,$E3,$B1,$E4,$11
	.db $FE,$02,$31,$51,$31,$51,$FE,$02,$E8,$26
	.db $FF
Music56Section2:
	.db $E4,$8A,$82,$62,$42,$8A,$82,$62,$42
	.db $FF
Music56Section3:
	.db $E0,$06,$11,$FC,$FB,$E3,$14,$02,$11,$11,$12,$12,$12,$E2,$82,$FE
	.db $02,$EA,$82,$FE,$02,$EA,$00,$FB,$E2,$A4,$02,$A1,$A1,$A2,$A2,$A2
	.db $A2,$FE,$02,$FB,$94,$02,$91,$91,$92,$92,$92,$92,$EA,$02,$FE,$02
	.db $EA,$00
	.db $FF
Music56Section4:
	.db $FC,$FB,$E6,$A6,$A1,$A1,$A2,$A2,$A2,$A2,$FE,$03,$A6,$A1,$A1,$A2
	.db $A2,$E3,$FB,$A1,$FE,$08,$FE,$02
	.db $FF
Music56Section5:
	.db $FB,$B2,$11,$11,$A2,$11,$11,$B2,$11,$11,$A2,$11,$11,$FE,$07,$B2
	.db $11,$11,$A2
	.db $FF
Music57Ch1Data:
	.db $E0,$06,$30,$01,$46,$E9,$3C,$EB,$02,$01,$E5,$16,$11,$11,$12,$12
	.db $12,$12,$E4,$B6,$B1,$B1,$B2,$B2,$E5,$32,$E4,$B2,$E5,$16,$11,$11
	.db $12,$12,$12,$12,$EE,$0D,$E4,$B6,$B1,$B1,$B2,$B2,$EE,$07,$E5,$32
	.db $62,$E8,$26,$EE,$06,$50,$54,$E3,$11,$12,$11,$17,$F3,$F4,$12,$F5
	.db $12
	.db $FF
Music57Ch0Data:
	.db $E0,$06,$30,$01,$46,$E9,$3C,$E4,$56,$F0,$51,$51,$52,$52,$52,$52
	.db $36,$31,$31,$32,$32,$62,$32,$E4,$56,$51,$51,$52,$52,$52,$52,$66
	.db $61,$61,$62,$62,$62,$B2,$E8,$26,$80,$84,$E2,$11,$12,$11,$17,$F3
	.db $12,$F4,$12,$F5,$12
	.db $FF
Music57Ch2Data:
	.db $E0,$06,$14,$E3,$16,$11,$11,$12,$12,$12,$12,$E2,$B2,$62,$B2,$E3
	.db $32,$62,$52,$32,$62,$16,$11,$11,$12,$12,$12,$12,$62,$12,$62,$82
	.db $B2,$A2,$82,$B2,$FB,$E4,$12,$E3,$82,$FE,$04,$E4,$14,$E3,$11,$12
	.db $11,$17
	.db $FF
Music57Ch5Data:
	.db $E6,$FB,$B2,$11,$11,$22,$A1,$A1,$A2,$A2,$A2,$A2,$FE,$04,$E3,$FB
	.db $A1,$FE,$20,$E6,$A4,$B1,$B2,$B1,$B6
	.db $FF
	.db $FF

;;;;;;;;;;;;;;;;;;;;;;;;;;
;INIT GAME STATE ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;
RunGameMode_InitGameStateSub:
	;Init game state
	lda #$00
	sta DemoEndFlag
	sta DisableSoundLoadFlag
	sta DialogID
	sta OnEscapePodFlag
	sta LevelsCompletedFlags
	sta ItemCollectedBits
	sta ItemCollectedBits+1
	sta EnemyTriggeredBits
	sta EnemyTriggeredBits+1
	sta IceMeltedBits
	sta CurCharacter
	sta ScoreCurrent
	sta ScoreCurrent+1
	sta ScoreTop+1
	sta CharacterPowerCur
	sta CharacterPowerCur+1
	sta CharacterPowerCur+2
	sta CharacterPowerCur+3
	sta CharacterPowerCur+4
	sta CurLevel
	sta CurArea
	lda #$05
	sta ScoreTop
	lda #$02
	sta NumLives
	lda #$8C
	sta CharacterPowerMax
	lda #$0C
	sta CharacterPowerMax+1
	sta CharacterPowerMax+2
	sta CharacterPowerMax+3
	sta CharacterPowerMax+4
	lda #$14
	sta Enemy_HP
	sta Enemy_Temp4
	rts

InitLevelStateFirst:
	;Init level state
	lda #$03
	sta CurLevel
	lda #$00
	sta ItemCollectedBits
	sta ItemCollectedBits+1
	sta EnemyTriggeredBits
	sta EnemyTriggeredBits+1
	sta IceMeltedBits
	sta TempIRQEnableFlag
	lda #$03
	sta BlackScreenTimer
	ldx #$26
	jsr LoadCHRBankSet
	lda #$55
	sta TempCHRBanks+2
	lda #$58
	sta TempCHRBanks+3
	lda #$25
	jsr WritePaletteStrip8
	ldy #$03
	lda #$01
	sta $00
InitLevelStateFirst_Loop:
	;Check if level was completed
	lda LevelsCompletedFlags
	and $00
	beq InitLevelStateFirst_Next
	;Set gray color palette for planet
	ldx VRAMBufferOffset
	txa
	sec
	sbc PlanetPaletteBufOffs,y
	tax
	lda #$00
	sta VRAMBuffer,x
	inx
	lda #$10
	sta VRAMBuffer,x
	inx
	lda #$20
	sta VRAMBuffer,x
	inx
InitLevelStateFirst_Next:
	asl $00
	dey
	bpl InitLevelStateFirst_Loop
	jmp GoToNextGameMode
PlanetPaletteBufOffs:
	.db $1C,$14,$0C,$20

;UNUSED SPACE
	;$87 bytes of free space available
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;.db $FF,$FF,$FF,$FF,$FF,$FF,$FF

	.org $C000
