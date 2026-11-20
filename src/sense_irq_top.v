`timescale 1ns/1ps

// Project:  Subsea Sensor Fusion Unit (SFU)
// Module:  IRQ Generator - Top-level for Timestamper & FIFO
// Developer:  Julius Perez

module sense_irq_top(
    input wire sys_clk,
    input wire nrst,
    input wire imu_fifo_re,
    input wire imu_drdy,
    output wire[63:0] imu_fifo_dout,
    output wire[4:0] imu_fifo_dcount,
    output wire imu_fifo_full,
    output wire imu_fifo_empty,
    output wire imu_irq
);

// Generate global counter
reg[63:0] gbl_counter;
always @(posedge sys_clk or negedge nrst) begin
    if(!nrst) begin
        gbl_counter <= 0;
    end
    else begin
        gbl_counter <= gbl_counter + 1'b1;
    end
end

// Instantiate IMU Timestamper
wire[63:0] imu_tstamp;
wire imu_fifo_we;
sense_timestamper imu_timestamper(
    .sys_clk(sys_clk),
    .nrst(nrst),
    .gbl_counter(gbl_counter),
    .hw_trig(imu_drdy),
    .tstamp(imu_tstamp),
    .fifo_we(imu_fifo_we)
);

// Instantiate IMU FIFO
sense_fifo_16x64 imu_fifo(
    .clk(sys_clk),
    .nrst(nrst),
    .we(imu_fifo_we),
    .din(imu_tstamp),
    .re(imu_fifo_re),
    .dout(imu_fifo_dout),
    .data_count(imu_fifo_dcount),
    .full(imu_fifo_full),
    .empty(imu_fifo_empty)
);

// Assert level-sensitive IMU IRQ while unread timestamps remain in the FIFO
assign imu_irq = !imu_fifo_empty;

endmodule