---------------------------------------------------------------------------------------------------
-- Author : Yunus Dag	
-- Description : Transposed FIR filter testbench
--   
--   
--   
-- More information (optional) :
--    
--    
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.fir_filter_pkg.all;
library osvvm;
use osvvm.randompkg.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

constant clock_period : time := 10 ns;
constant max_rand 	: integer := 1000;

type input_array is array (0 to 1000) of signed(OUTPUT_WIDTH-1 downto 0);

signal clk       	: std_logic := '0';
signal rst       	: std_logic := '1'; -- Start with reset active
signal data_out  	: std_logic_vector(OUTPUT_WIDTH -1 downto 0);
signal valid_in  	: std_logic := '0';
signal valid_out 	: std_logic;
signal data_in    : std_logic_vector(INPUT_WIDTH-1 downto 0);

begin
clk_process: process
begin
	clk <= '0';
	wait for clock_period / 2;
	clk <= '1';
	wait for clock_period / 2;
end process;

process 
variable RandGen : RandomPType;
variable input_num : integer;
variable rand_input_value : integer;
begin

	rst <= '1';
	wait for 2 * clock_period;
	rst <= '0';
	wait for 2 * clock_period;
	
	randgen.initseed(12345);
	input_num := randgen.randint(60, 70);
	
	valid_in <= '1';
	for i in 0 to input_num-1 loop
		rand_input_value := randgen.randint(-2**(INPUT_WIDTH-2), 2**(INPUT_WIDTH-2)-1);		
		data_in <= std_logic_vector(to_signed(rand_input_value, INPUT_WIDTH));

		wait for clock_period;
		if valid_out = '1' then
			
		end if;
	end loop;
	valid_in <= '0';
	wait for clock_period;
	
	
	wait for 5 * clock_period;
	report "Simulation Successful!" severity failure;
	
end process;

-- Instantiate the FIR filter
uut: entity work.fir_filter_wrapper
   generic map (
      INPUT_WIDTH    => INPUT_WIDTH,
      OUTPUT_WIDTH   => OUTPUT_WIDTH,
      COEFF_WIDTH    => COEFF_WIDTH,
      NUMBER_OF_TAPS => NUMBER_OF_TAPS
   )
port map (
	clk         => clk,
	rst         => rst,
	valid_in    => valid_in,
	data_in     => data_in,
	data_out    => data_out,
	valid_out   => valid_out
);

end behavioral;