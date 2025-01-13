; a2-signalling.asm
; CSC 230: Fall 2022
;
; Student name: Evan Strasdin
; Student ID: V00907185
; Date of completed work: 11/02/23
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section

	; Stack init
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; LED init
	ldi r31, 0xFF
	sts DDRL, r31
	out DDRB, r31

; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16

	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000

test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:
	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end


; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************


set_leds:
	; Push to retain Z
	push ZH
	push ZL

	; Define variables
	.def mask = r17
		ldi mask, 0x01
	.def hold = r18
		ldi hold, 0x00
	.def bitsL = r19
		ldi bitsL, 0x00
	.def bitsB = r20
		ldi bitsB, 0x00
	.def c = r21
		ldi c, 0x00

	; Determine which leds to set using c= 1 to 6
	loop_set:
		mov hold, r16
		and hold, mask
		lsr r16
		inc c
		cpi c, 0x07
		breq end_leds
		cp hold, mask
		breq set_n
		rjmp loop_set

	; Sets leds 1-6 according to c
	set_n:
		cpi c, 0x01
		breq set_1
		cpi c, 0x02
		breq set_2
		cpi c, 0x03
		breq set_3
		cpi c, 0x04
		breq set_4
		cpi c, 0x05
		breq set_5
		cpi c, 0x06
		breq set_6

	; Set individual leds
	set_1:
		ori bitsL, 0x80
		rjmp loop_set
	set_2:
		ori bitsL, 0x20
		rjmp loop_set
	set_3:
		ori bitsL, 0x08
		rjmp loop_set
	set_4:
		ori bitsL, 0x02
		rjmp loop_set
	set_5:
		ori bitsB, 0x08
		rjmp loop_set
	set_6:
		ori bitsB, 0x02
		rjmp loop_set

	; Output to controller, pop
	end_leds:
		mov r31, bitsL
		sts PORTL, r31
		mov r31, bitsB
		out PORTB, r31
		pop ZL
		pop ZH
		ret

;--------------------------------------------

slow_leds:
	; Based on code from tests
	; Push all used by fn which calls slow/fast leds (For good measure)
	push mask
	push hold
	push c
	push r22
	push r23
	push r16

	; Set leds & delay
	mov r16, r17
	rcall set_leds
	rcall delay_long

	; Set leds empty & delay
	clr r16
	rcall set_leds

	; Pop ... ret
	pop r16
	pop r23
	pop r22
	pop c
	pop hold
	pop mask
	ret


fast_leds:
; Same as slow_leds but call delay_short
	push mask
	push hold
	push c
	push r22
	push r23
	push r16
	mov r16, r17
	rcall set_leds
	rcall delay_short
	clr r16
	rcall set_leds
	pop r16
	pop r23
	pop r22
	pop c
	pop hold
	pop mask
	ret

;--------------------------------------------
leds_with_speed:
	; Push Z
	push ZH
	push ZL

	; Offset 2+3+1
	.set offset = 6

	; Setup Y
	in YH, SPH
	in YL, SPL

	; Note that mask checks for top two bits
	ldi mask, 0x80 ; r17
	ldi hold, 0x00 ; r18
	ldi c, 0x00 ; r21

	; Load value from stack
	.def num = r22
		ldd num, Y+offset
	.def c2 = r23
		ldi c2, 0x00

	; Mask value, check if top two bits set
	msk:
		mov hold, num
		and hold, mask
		cp hold, mask
		breq slo
		rjmp fas
	
	; If bits set
	slo:
		mov r17, num
		rcall slow_leds
		rjmp end_2

	; If bits not set
	fas:
		mov r17, num
		rcall fast_leds
		rjmp end_2
	
	; Pop, ret
	end_2:
		pop ZL
		pop ZH
		
		ret

;--------------------------------------------

; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
	; Push Z
	push ZH
	push ZL

	ldi r25, 0x00

	; Setup Y, Z
	in YH, SPH
	in YL, SPL
	ldi ZL, LOW(2*PATTERNS)
	ldi ZH, HIGH(2*PATTERNS)

	; Offset 2+3+1
	.set offset = 6

	;Load Y to hold
	ldd hold, Y+offset

	; Load mask for decode (o's and .'s in PATTERN)
	ldi mask, 'o'

	; Load mask for set bits
	ldi num, 0x20

	; To hold final val
	.def leds = r25
		ldi leds, 0x00

	; To set top bits
	ldi c2, 0xC0

	; Move to desired letter in PATTERNS
	loop_3:
		lpm c, Z+
		cp c, hold
		breq encode_led
		rjmp loop_3

	; Set bits according to decode
	encode_led:
		lpm c, Z+
		cp c, mask
		breq set_led
		cpi c, 0x01
		breq set_time
		cpi c, 0x02
		breq end_3
		lsr num
		rjmp encode_led

	; Set individual bit
	set_led:
		eor leds, num
		lsr num
		rjmp encode_led

	; Set time according to last val in PATTERNS
	set_time:
		eor leds, c2
		rjmp end_3

	; Pop, ret
	end_3:
		pop ZL
		pop ZH
		ret

	;--------------------------------------------

display_message:
	
	; Move addy to Z
	ldi hold, 0x00
	mov ZL, r24
	mov ZH, r25

	; Based on code from tests
	; Encode each letter and output to LEDS, delay between letters
	letter_loop:
		lpm hold, Z+
		cpi hold, 0x00
		breq end_4
		push hold
		rcall encode_letter
		pop hold
		push r25
		rcall leds_with_speed
		pop r25
		rcall delay_long
		rjmp letter_loop

	end_4:
		ret


; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************




; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "W", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

