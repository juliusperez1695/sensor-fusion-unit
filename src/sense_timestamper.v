`timescale 1ns / 1ps

// Project: Subsea Sensor Fusion Unit (SFU)
// Module: Edge-Detection / Timestamping Logic
// Developer: Julius Perez

module sense_timestamper(
    input wire sys_clk,
    input wire nrst,
    input wire [63:0] gbl_counter,
    input wire hw_trig,
    output reg [63:0] tstamp,
    output reg fifo_we
);

// Monitor data_rdy interrupt signal
// Pass data_rdy through 2 Flip-Flop buffers to detect a stable, rising-edge change of state
// Use a 3-bit shift register for rising-edge detection via {hw_trig_LOW, hw_trig_HIGH, hw_trig}
reg[2:0] hw_trig_buffer;
always @(posedge sys_clk or negedge nrst) begin
    if(!nrst) begin
        hw_trig_buffer <= 3'b000;
    end
    else begin
        hw_trig_buffer <= {hw_trig_buffer[1:0], hw_trig};
    end
end

// Asynchronous stable edge-detection occurs after 2 clk cycle delay following actual arrival time
// Trade-off of 20 ns delay for 100 MHz clk to eliminate metastability of interrupt signal
wire hw_trig_rising = (hw_trig_buffer[2:1] == 2'b01) ? 1 : 0;

// Upon detection of a stable interrupt edge, clk-sync a Write Enable pulse to a FIFO along with the 
// current global count latched as the data timestamp
always @(posedge sys_clk or negedge nrst) begin
    if(!nrst) begin
        fifo_we <= 1'b0;
        tstamp <= 64'd0;
    end
    else if(hw_trig_rising) begin
        fifo_we <= 1'b1;
        tstamp <= gbl_counter;
    end
    else begin
        fifo_we <= 1'b0;
    end
end

endmodule