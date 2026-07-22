//GAME STATE CONTROLLER FSM 
//Russell Nwokolo R12023697
//ECE 2372
//Derek Johnston
//Spring 2026

module console_cpu(clk, rst, btn_start, collision_event, game_tick, ball_y 
,game_state, score_p1, game_reset);

//clk and reset
input wire clk;
input wire rst;

//game inputs
input wire btn_start;
input wire collision_event;
input wire game_tick;
input wire[7:0] ball_y;

//game outputs
output reg[2:0] game_state;
output reg[7:0] score_p1;
output reg game_reset;
//internal registers
reg[7:0] timer_counter;
reg[2:0] current_state;  
reg[2:0] next_state; 
//state encoding
localparam IDLE = 3'b000;    
localparam ACTIVE = 3'b001;   
localparam GAME_OVER = 3'b010;
//game parameters
localparam GAME_OVER_TIMEOUT = 120;
localparam BALL_Y_THRESHOLD = 64;

//initializes registers
initial begin
    game_state = IDLE;
    score_p1 = 0;
    timer_counter = 0;
    current_state = IDLE;
    next_state = IDLE;
    game_reset = 1;
end

//combinational logic
always@(*)begin
    //stays in current state unless told to
    next_state = current_state;
    //reset has the highest priority
    if(rst == 1)begin
        next_state = IDLE;
    end
    else begin
        case(current_state)
            IDLE:begin
                if(btn_start==1)begin
                    next_state = ACTIVE; //starts game
                end
            end
            ACTIVE:begin
                if(ball_y >= BALL_Y_THRESHOLD)begin
                    next_state = GAME_OVER; //means ball missed
                end
            end
            GAME_OVER:begin
                if(timer_counter >= GAME_OVER_TIMEOUT || btn_start==1)begin
                    next_state = IDLE; //restarts game
                end
            end
        endcase
    end
end

//sequential logic, synchronous to the clock
always@(posedge clk)begin
    current_state <= next_state;
    game_state <= current_state;
    case(current_state)
        IDLE:begin
            //resets score, timer, and holds game in reset
            score_p1 <= 0;
            timer_counter <= 0;
            game_reset <= 1;
        end
        ACTIVE:begin
            game_reset <= 0; //release game reset
            //increments score if conditions met
            if(collision_event && game_tick)begin
                    score_p1 <= score_p1 + 1;
                end
            //resets timer after transition
            if(next_state == GAME_OVER)begin
                timer_counter <= 0;
            end
        end
         GAME_OVER:begin
            game_reset <= 0;  // ← Add this (or 0, depending on intended behavior)
            if(game_tick)begin
                timer_counter <= timer_counter + 1;
            end
        end
        default: game_reset <= 1;  // Safe fallback
    endcase
end

endmodule

module display_driver(
    input        clk,
    input        rst,
    input  [7:0] score,          // 0-99
    output reg [6:0] seg,
    output reg [3:0] an
);

    // -------------------------------------------------------------------------
    // Clock divider: 100MHz / 100,000 = 1kHz mux toggle (~500Hz per digit)
    // -------------------------------------------------------------------------
    localparam DIV_MAX = 17'd99_999;
    reg [16:0] div      = 17'd0;
    reg        digit_sel = 1'b0;  // 0 = units (AN0), 1 = tens (AN1)
    
    always @(posedge clk) begin
        if (rst) begin
            div       <= 17'd0;
            digit_sel <= 1'b0;
        end else if (div == DIV_MAX) begin
            div       <= 17'd0;
            digit_sel <= ~digit_sel;
        end else begin
            div <= div + 1'b1;
        end
    end

    // -------------------------------------------------------------------------
    // BCD split: extract tens and units digits from score (0-99)
    // -------------------------------------------------------------------------
    wire [3:0] units = score % 10;
    wire [3:0] tens  = score / 10;

    // -------------------------------------------------------------------------
    // 7-segment decoder (common-anode, active-low segments)
    //   Segments: gfedcba
    // -------------------------------------------------------------------------
    function [6:0] decode;
        input [3:0] digit;
        case (digit)
            4'd0:    decode = 7'b100_0000;
            4'd1:    decode = 7'b111_1001;
            4'd2:    decode = 7'b010_0100;
            4'd3:    decode = 7'b011_0000;
            4'd4:    decode = 7'b001_1001;
            4'd5:    decode = 7'b001_0010;
            4'd6:    decode = 7'b000_0010;
            4'd7:    decode = 7'b111_1000;
            4'd8:    decode = 7'b000_0000;
            4'd9:    decode = 7'b001_0000;
            default: decode = 7'b111_1111;  // blank
        endcase
    endfunction

    // -------------------------------------------------------------------------
    // Anode + segment mux (combined to avoid multi-driver warnings)
    // Leading zero suppression: tens digit blanked when score < 10
    // -------------------------------------------------------------------------
    always @(*) begin
        case (digit_sel)
            1'b0: begin
                an  = 4'b1110;          // AN0 active (units)
                seg = decode(units);
            end
            1'b1: begin
                an  = 4'b1101;          // AN1 active (tens)
                seg = (tens == 4'd0) ? 7'b111_1111 : decode(tens);  // suppress leading zero
            end
            default: begin
                an  = 4'b1111;
                seg = 7'b111_1111;
            end
        endcase
    end

endmodule

module clk_div_slow(
    input  wire clk_in,
    output reg  clk_out
);
    // Divide 100 MHz down to ~1 Hz (observable state changes)
    // 100MHz / 100,000,000 = 1 Hz
    reg [26:0] cnt = 27'd0;
    
    always @(posedge clk_in) begin
        if (cnt == 27'd49_999_999) begin
            cnt     <= 27'd0;
            clk_out <= ~clk_out;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule

module clk_div(
    input  wire clk_in,
    output reg  clk_out
);

    // Generate ~50 Hz clock divider from 100 MHz
    // 100MHz / 2,000,000 = 50 Hz
    reg [20:0] cnt = 21'd0;
    
    always @(posedge clk_in) begin
        if (cnt == 21'd999_999) begin
            cnt     <= 21'd0;
            clk_out <= ~clk_out;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule

module top(
    // Physical inputs from Basys 3
    input  wire        clk,           // W5 (100 MHz)
    input  wire        rst,           // U18 (BTNC)
    input  wire        btn_start,     // T18 (BTNU)
    input  wire [15:8] ball_y,        // SW[15:8]
    input  wire        collision,     // V17 (SW[0])
    input  wire        pause_game_tick,
    // Physical outputs to Basys 3
    output wire [2:0]  game_state_led,  // LED[2:0]
    output wire        game_reset_led,  // LED[15]
    output wire [6:0]  seg,             // 7-segment segments (CA-CG)
    output wire [3:0]  an                // 7-segment anodes (AN[3:0])
);

    // -----------------------------------------------------------------------
    // Internal signals
    // -----------------------------------------------------------------------
    wire [7:0] score;
    wire game_tick;
    wire game_reset_signal;
    
    // -----------------------------------------------------------------------
    // Game tick generator (1 Hz clock divider for testing)
    // If your game engine provides game_tick, remove this and wire it instead
    // -----------------------------------------------------------------------
    clk_div tick_gen(
        .clk_in(clk),
        .clk_out(game_tick)
    );
    
    // -----------------------------------------------------------------------
    // FSM Game Controller
    // -----------------------------------------------------------------------
    wire clk_slow;  // ~10 Hz or ~1 Hz for observable state changes

clk_div_slow fsm_clk_gen(
    .clk_in(clk),
    .clk_out(clk_slow)
);

console_cpu game(
    .clk(clk_slow),  // ← Use slow clock instead of clk
    .rst(rst),
    .btn_start(btn_start),
    .collision_event(collision),
    .game_tick(game_tick),
    .ball_y(ball_y),
    .game_state(game_state_led),
    .score_p1(score),
    .game_reset(game_reset_signal)
);
    
    // -----------------------------------------------------------------------
    // 7-Segment Display Driver
    // -----------------------------------------------------------------------
    display_driver display(
        .clk(clk),
        .rst(rst),
        .score(score),
        .seg(seg),
        .an(an)
    );
    
    // -----------------------------------------------------------------------
    // Output assignments
    // -----------------------------------------------------------------------
    assign game_reset_led = game_reset_signal;

endmodule
