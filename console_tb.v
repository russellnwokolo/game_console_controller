`timescale 1ns/1ps
`include "console_cpu.v"

module console_cpu_tb();

    // Testbench signals
    reg clk_tb;
    reg rst_tb;
    reg btn_start_tb;
    reg collision_event_tb;
    reg game_tick_tb;
    reg [7:0] ball_y_tb;
    wire [2:0] game_state_tb;
    wire [7:0] score_p1_tb;
    wire game_reset_tb;
    integer i; // loop variable

    // Instantiate the UUT
    console_cpu uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .btn_start(btn_start_tb),
        .collision_event(collision_event_tb),
        .game_tick(game_tick_tb),
        .ball_y(ball_y_tb),
        .game_state(game_state_tb),
        .score_p1(score_p1_tb),
        .game_reset(game_reset_tb)
    );

    // Clock generation

    always begin
        #1 clk_tb = ~clk_tb;
    end

    // Test stimulus
    initial begin
        clk_tb = 0;
        //waveform dump
        $dumpfile("console_cpu_tb.vcd");
        $dumpvars(0, console_cpu_tb);

        $display("Starting Console CPU Testbench");

        // Initialize all inputs
        rst_tb = 0;
        btn_start_tb = 0;
        collision_event_tb = 0;
        game_tick_tb = 0;
        ball_y_tb = 0;
        #4;

        // Test 1
        $display("Test 1");
        rst_tb = 1;
        #2; //wait 1 clock cycle
        rst_tb = 0;
        #2; //wait for ouptuts
        
        if (game_state_tb == 0 && score_p1_tb == 0 && game_reset_tb == 1) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $display("");

        // Test 2: Start game for 2 clock cycles
        $display("Test 2");
        btn_start_tb = 1;
        #2; // wait 1 clock cycle
        btn_start_tb = 0;
        #2; // wait for outputs
        
        if (game_state_tb == 1 && game_reset_tb == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $display("");

        // Test 3: Score Increment
        $display("Test 3");
        collision_event_tb = 1;
        game_tick_tb = 1;
        #8; // wait 1 clock cycle
        collision_event_tb = 0;
        game_tick_tb = 0;
        #2; // wait for outputs, 4 clock cycles
        
        if (score_p1_tb == 4) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $display("");

        // Test 4: Score Increment Requires Both Signals
        $display("Test 4");
        collision_event_tb = 1;
        game_tick_tb = 0;
        #2; // wait 1 clock cycle
        collision_event_tb = 0;
        #2; // wait for outputs
        
        if (score_p1_tb == 4) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $display("");

        // Test 5: ACTIVE to GAME_OVER
        $display("Test 5");
        ball_y_tb = 65;
        #2; // wait 1 clock cycle
        #2; // wait for outputs
        
        if (game_state_tb == 2) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        ball_y_tb = 0;
        $display("");

        // Test 6: GAME_OVER Timeout
        $display("Test 6");
        
        for (i = 0; i < 125; i = i + 1) begin
            game_tick_tb = 1;
            #2;
            game_tick_tb = 0;
            #2;
        end
        
        #4; // wait for outputs
        
        if (game_state_tb == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $display("");

        #10;
        $finish;
    end

endmodule
