`timescale 1ns / 1ps

// Project: Subsea Sensor Fusion Unit (SFU)
// Module: Edge-Detection / Timestamping Logic
// Developer: Julius Perez

module imu_timestamper(
    input wire sys_clk,
    input wire nrst,
    input wire [63:0] gbl_counter,
    input wire data_rdy,
    output reg [63:0] imu_tstamp,
    output reg imu_fifo_we
);

// Monitor data_rdy interrupt signal
// Pass data_rdy through 2 Flip-Flop buffers to detect a stable, rising-edge change of state
// Use a 3-bit shift register for rising-edge detection via {data_rdy_LOW, data_rdy_HIGH, data_rdy}
reg[2:0] data_rdy_buffer;
always @(posedge sys_clk or negedge nrst) begin
    if(!nrst) begin
        data_rdy_buffer <= 3'b000;
    end
    else begin
        data_rdy_buffer <= {data_rdy_buffer[1:0], data_rdy};
    end
end

// Asynchronous stable edge-detection occurs after 2 clk cycle delay following actual arrival time
// Trade-off of 20 ns delay for 100 MHz clk to eliminate metastability of interrupt signal
wire data_rdy_rising = (data_rdy_buffer[2:1] == 2'b01) ? 1 : 0;

// Upon detection of a stable interrupt edge, clk-sync a Write Enable pulse to a FIFO along with the 
// current global count latched as the data timestamp
always @(posedge sys_clk or negedge nrst) begin
    if(!nrst) begin
        imu_fifo_we <= 1'b0;
        imu_tstamp <= 64'd0;
    end
    else if(data_rdy_rising) begin
        imu_fifo_we <= 1'b1;
        imu_tstamp <= curr_time;
    end
    else begin
        imu_fifo_we <= 1'b0;
    end
end

endmodule