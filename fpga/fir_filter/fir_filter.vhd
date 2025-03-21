---------------------------------------------------------------------------------------------------
-- Author : Yunus Dag	
-- Description : Transposed FIR filter
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

entity fir_filter is
generic(
   INPUT_WIDTH    : natural := 25;
   COEFF_WIDTH    : natural := 18;
   OUTPUT_WIDTH   : natural := 48;
   NUMBER_OF_TAPS : natural := NUMBER_OF_TAPS
);
Port(
	clk      : in std_logic;
	rst      : in std_logic;
	valid_in : in std_logic;
	data_in  : in std_logic_vector(INPUT_WIDTH-1 downto 0);
	data_out : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
	valid_out: out std_logic
);
end fir_filter;

architecture Behavioral of fir_filter is

type sum_array is array (0 to NUMBER_OF_TAPS -1) of signed(OUTPUT_WIDTH-1 downto 0);
signal sums     : sum_array := (others=>(others=>'0'));
signal o_valid  : std_logic := '0';
signal counter  : natural range 0 to NUMBER_OF_TAPS := 0;

begin

data_out <= std_logic_vector(sums(0));
valid_out <= o_valid;

process (clk) 
begin 
   if rising_edge(clk) then
      if rst = '1' then
         sums    <= (others => (others => '0'));
      else
         if( valid_in = '1') then
            for i in 0 to NUMBER_OF_TAPS -1 loop 
               if i = NUMBER_OF_TAPS -1 then -- At last add block another input is 0
                  sums(i) <= resize(COEFFICIENTS(i)*signed(data_in),OUTPUT_WIDTH);  
               else
                  sums(i) <= resize(COEFFICIENTS(i)*signed(data_in),OUTPUT_WIDTH) + sums(i+1);
               end if;
            end loop;
         end if;
      end if;
   end if;
end process;


process(clk) 
begin 
   if rising_edge(clk) then
      if rst = '1' then
         counter <= 0;
         o_valid <= '0';
      else
         if( valid_in = '1') then
            if( counter = NUMBER_OF_TAPS-1) then
               o_valid <= '1';
            else
               counter <= counter + 1;
            end if;
         else
            o_valid <= '0';
            counter <= 0;
         end if;
      end if;
   end if;
end process;
end behavioral;