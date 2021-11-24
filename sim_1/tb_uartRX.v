`timescale 1ns / 1ps

module tb_uartRX;

	reg clk; 
    reg reset;
    reg rx;
    wire [7:0] r_data;
    wire rx_done;
	wire baud_tick;
	
	localparam baud_gen_divisior = 54, // # 100Mhz / (16 * Baudrate) (Baudrate = 115200)
               data_bits = 8,          // # data bits
               stop_ticks = 16,        // # ticks for stop bits (One bit=16, 1.5 bit=24 Two bit=32)   
	           bit_ticks = 16;         // # ticks for bits
			   
	localparam one_bit_time = 8680;  // One bit time = 8.68us
	
	uart_baudrate_generator #(.divisior(baud_gen_divisior)) baud_gen(clk, reset, baud_tick);
	
	uart_rx #(.DBIT(data_bits), .S_TICK_LIM(bit_ticks), .STOP_BITS_LIM(stop_ticks)) 
	uut(.clk(clk), .reset(reset), .rx(rx), .s_tick(baud_tick), .rx_done_tick(rx_done), .data_out(r_data));
	
	initial begin	
		clk    = 1'b0;       
        reset  = 1'b0;
        rx     = 1'b1;	
	end
	
	always begin clk <= ~clk; #5; end
	
	always begin
	
		#50;
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b1;
		#one_bit_time;      
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b1;
		#one_bit_time;      
		rx = 1'b1;
		#one_bit_time;      
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b0;
		#one_bit_time;      
		rx = 1'b1;
		wait(rx_done);		
		#40;
		
		rx = 1'b0;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b0;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b0;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		rx = 1'b1;
		#one_bit_time;
		wait(rx_done);
		#40;
		
		$display("Simulasyon Tamamlandi");
		$finish;

	end
	
	

endmodule
