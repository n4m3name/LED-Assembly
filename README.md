# LED-Assembly

Assignment 2 of CSC230 - Intro to Computer Architecture at UVic, written in AVR Assembly

This assembly program implements an LED pattern display system for the AVR ATmega2560 microcontroller. The program controls LED patterns to display encoded letters and messages using various timing patterns.

## Features

**LED Control Functions**
- Single LED manipulation with precise control over individual LEDs
- Pattern display with adjustable speeds (fast/slow)
- Letter encoding system for displaying text messages
- Support for uppercase letters A-Z with unique LED patterns

**Timing Control**
- Multiple delay functions for different display speeds
- Long delay (approximately 1 second)
- Short delay (approximately 0.25 seconds)

## Implementation Details

**LED Configuration**
- Uses PORTL and PORTB for LED output
- Supports 6 LEDs in total
- LED patterns defined in the PATTERNS table

**Message Display**
```assembly
; Example message display
ldi r25, HIGH(WORD02 << 1)
ldi r24, LOW(WORD02 << 1)
rcall display_message
```

**Pattern Encoding**
- Each letter has a unique LED pattern
- Patterns use "o" for ON and "." for OFF
- Speed control: 1 for slow/long, 2 for fast/short

## Core Functions

**Main Functions**
- `set_leds`: Controls individual LED states
- `slow_leds`: Displays patterns with long delays
- `fast_leds`: Displays patterns with short delays
- `encode_letter`: Converts letters to LED patterns
- `display_message`: Shows complete text messages

**Helper Functions**
- `delay_long`: ~1 second delay
- `delay_short`: ~0.25 second delay
- `delay`: Standard delay function
- `delay_busywait`: Precise timing control

## Usage

1. Initialize the stack and LED ports
2. Load desired message into registers
3. Call display_message to show text
4. Program will display each letter with appropriate timing

## Hardware Requirements

- AVR ATmega2560 microcontroller
- 6 LEDs connected to PORTL and PORTB
- Appropriate power supply and connections

## Notes

- Only uppercase letters are supported
- Special character "-" included for error handling
- Pre-defined words available (WORD00 through WORD09)
