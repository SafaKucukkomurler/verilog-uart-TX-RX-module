`timescale 1ns / 1ps

module tb_uartTX;

	reg clk; 
    reg reset;
    wire tx;
    reg [7:0] t_data;
    wire tx_done;
	reg tx_start;
	wire baud_tick;
	
	localparam baud_gen_divisior = 54, // # 100Mhz / (16 * Baudrate) (Baudrate = 115200)
               data_bits = 8,          // # data bits
               stop_ticks = 16,        // # ticks for stop bits (One bit=16, 1.5 bit=24 Two bit=32)   
	           bit_ticks = 16;         // # ticks for bits
	
	uart_baudrate_generator #(.divisior(baud_gen_divisior)) baud_gen(.clk(clk), .reset(reset), .uart_tick(baud_tick));
	
	uart_tx #(.DBIT(data_bits), .S_TICK_LIM(bit_ticks), .STOP_BITS_LIM(stop_ticks)) 
	uut(.clk(clk), .reset(reset), .tx_start(tx_start), .tx(tx), .s_tick(baud_tick), .tx_done_tick(tx_done), .data_in(t_data));
	
	initial begin	
		clk = 1'b0;       
        reset=1'b0;
        tx_start=1'b0;
		t_data=8'b0;		
	end
	
	always begin clk <= ~clk; #5; end
	
	always begin
	
		#50;
		t_data = 8'b00110010;		
		tx_start = 1'b1;
		#50;
		tx_start = 1'b0;
		wait(tx_done);
		
		#20;
		t_data = 8'b11101101;
		#20;
		tx_start = 1'b1;
		#10;
		tx_start = 1'b0;
		wait(tx_done);
		
		$display("Simulasyon Tamamlandi");
		$finish;
		//$stop;
	end
	
	

endmodule
