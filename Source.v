`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2023 16:56:17
// Design Name: 
// Module Name: FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFO#(parameter N=8)(rst, d_in, r_en, clk, w_en, empty, full, d_out);
input [7:0]d_in;
input r_en, w_en, clk, rst;
output  empty, full;
output reg [7:0]d_out;

reg [7:0]fifo[0:7];
reg [3:0]counter;
reg [2:0]read_ptr,write_ptr;

assign empty = (counter ==0);
assign full = (counter ==8);



always@(posedge clk)
begin
if(rst == 1'b1)
begin
read_ptr <=0;
write_ptr <=0;
end

else
begin
write_ptr <= (w_en && !full) || (w_en && r_en)?write_ptr+1:write_ptr;
read_ptr <= (r_en && !empty) || (w_en && r_en)?read_ptr+1:read_ptr;
end

if(w_en && !full)
begin
fifo[write_ptr] <=d_in;
end
else if(w_en && r_en)
fifo[write_ptr] <=d_in;

if(r_en && !empty)
d_out <=fifo[read_ptr];
else if(r_en && w_en)
d_out <=fifo[read_ptr];
end


always@(posedge clk) //counter to check the fifo status
begin
if(rst == 1'b1)
counter <= 0;

else
begin
case({w_en,r_en})
2'b00: counter <= counter;
2'b01: counter <= (counter==0)?0:counter-1;
2'b10: counter <= (counter==8)?8:counter+1;
2'b11: counter <= counter;
default: counter <= counter;
endcase
end

end



endmodule
