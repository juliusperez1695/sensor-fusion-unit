`timescale 1ns/1ps

// Project:  Subsea Sensor Fusion Unit (SFU)
// Module:  Sensor Timestamp FIFO, 16-word depth, 64-bit width
// Developer:  Julius Perez

module sense_fifo_16x64(
    input wire clk,
    input wire nrst,
    input wire we,
    input wire [63:0] din,
    input wire re,
    output wire [63:0] dout,
    output reg [4:0] data_count,
    output wire full,
    output wire empty
);

reg[3:0] rptr;
reg[3:0] wptr;
reg[63:0] fifo_mem[0:15];

// asynchronous logic
assign full = (data_count == 16) ? 1 : 0;
assign empty = (data_count == 0) ? 1 : 0;

wire do_write = (we && !full);
wire do_read = (re && !empty);

assign dout = fifo_mem[rptr];

// synchronous logic
always @(posedge clk or negedge nrst) begin
    if(!nrst) begin
        rptr <= 4'd0;
        wptr <= 4'd0;
        data_count <= 5'd0;
    end
    else begin
        // read/write to memory and update pointers
        if(do_write) begin
            fifo_mem[wptr] <= din;
            wptr <= wptr + 4'd1;
        end
        if(do_read) begin
            rptr <= rptr + 4'd1;
        end

        // update data_count for read/write/simultanous read & write
        case({do_write, do_read})
            2'b01 : data_count <= data_count - 5'd1;
            2'b10 : data_count <= data_count + 5'd1;
            default: data_count <= data_count;
        endcase
    end
end

endmodule