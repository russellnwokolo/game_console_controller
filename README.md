# Game State Controller FSM – Basys 3 FPGA

## Project Summary

A synthesized **finite state machine game controller** on a Basys 3 FPGA that manages game flow, collision detection, and real-time score display. Demonstrates core digital design: FSM implementation, clock domain management, and hardware I/O control.

**Key Features:**
- 3-state FSM (IDLE → ACTIVE → GAME_OVER) with hardware buttons and switches
- Real-time score tracking (0–99) with 7-segment display multiplexing
- Collision-based score increment synchronized to 50 Hz game tick
- Behavioral testbench covering all state transitions and edge cases

---

## Architecture

| Module | Function |
|--------|----------|
| `console_cpu` | Core FSM; manages state transitions, score, reset logic |
| `display_driver` | 7-segment multiplexer with leading-zero suppression |
| `clk_div` | 100 MHz → 50 Hz game tick generator |
| `top` | Top-level instantiation and I/O routing |

**Testbench:** 6 test cases covering reset, state transitions, score increment, and timeout recovery.

---

## Highlights

✓ **FSM Design:** Clean separation of combinational (next-state logic) and sequential (state register) blocks  
✓ **Display Driver:** Efficient BCD-based 7-segment decoder with ~1 kHz multiplexing (flicker-free)  
✓ **Synchronous Design:** All state changes synchronized to clock edge; collision/tick gated appropriately  
✓ **Verification:** Comprehensive testbench with behavioral simulation (iverilog/Vivado compatible)

---

## Getting Started

### Simulation
```bash
iverilog -o sim console_cpu.v console_cpu_tb.v
vvp sim
# Or open in Vivado and run behavioral simulation
```

### Hardware (Basys 3)
1. Synthesize and implement in Vivado
2. Program bitstream
3. Press **BTNU** to start, flip **SW[0]** for collision, monitor **LED[2:0]** for state, watch 7-segment score display

---

## State Machine

```
IDLE (000) ──btn_start──→ ACTIVE (001)
  ↑                           │
  └─── btn_start/timeout ─ GAME_OVER (010)
            (120 ticks)
```

- **ACTIVE:** Score increments when `collision` AND `game_tick` both HIGH
- **GAME_OVER:** Triggered by `ball_y ≥ 64` (miss condition)

---

## Files

- `console_cpu.v` – FSM + display driver + clock dividers
- `console_cpu_tb.v` – 6-test behavioral testbench
- `Basys3_Master.xdc` – Pin constraints (clock, buttons, switches, LEDs, 7-seg)

