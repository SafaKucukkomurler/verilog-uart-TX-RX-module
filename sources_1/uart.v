`timescale 1ns / 1ps

module uart(
	input clk, reset, rx, tx_start,
	output tx, rx_done, tx_done,
	input [7:0] t_data,
	output [7:0] r_data
	);

	wire baud_tick;
	
	localparam baud_gen_divisior = 54, // # 100Mhz / (16 * Baudrate) (Baudrate = 115200)
                   data_bits = 8,          // # data bits
                   stop_ticks = 16,        // # ticks for stop bits (One bit=16, 1.5 bit=24 Two bit=32)   
	           bit_ticks = 16;         // # ticks for bits
	
	uart_baudrate_generator #(.divisior(baud_gen_divisior)) baud_gen(.clk(clk), .reset(reset), .uart_tick(baud_tick));
	
	uart_tx #(.DBIT(data_bits), .S_TICK_LIM(bit_ticks), .STOP_BITS_LIM(stop_ticks)) 
	uart_transmit(.clk(clk), .reset(reset), .tx_start(tx_start), .tx(tx), .s_tick(baud_tick), .tx_done_tick(tx_done), .data_in(t_data));
	
	uart_rx #(.DBIT(data_bits), .S_TICK_LIM(bit_ticks), .STOP_BITS_LIM(stop_ticks)) 
	uart_receive(.clk(clk), .reset(reset), .rx(rx), .s_tick(baud_tick), .rx_done_tick(rx_done), .data_out(r_data));

endmodule
