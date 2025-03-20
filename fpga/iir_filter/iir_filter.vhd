library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir_filter is
generic(
    INPUT_WIDTH    : natural := 25;
    COEFF_WIDTH    : natural := 18;
    NUMBER_OF_TAP  : integer := 3;
    OUTPUT_WIDTH   : natural := 48
);
Port(
    clk        : in std_logic;
    rst        : in std_logic;
    valid_in   : in std_logic;
    data_in    : in std_logic_vector(INPUT_WIDTH-1 downto 0);
    data_out   : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    valid_out  : out std_logic
);
end iir_filter;

architecture Behavioral of iir_filter is

attribute USE_DSP : string;
attribute USE_DSP of Behavioral: architecture is "YES";

type data_array_t is array (0 to NUMBER_OF_TAP-1) of signed(INPUT_WIDTH-1 downto 0);
type out_array_t is array (0 to NUMBER_OF_TAP-1) of signed(OUTPUT_WIDTH-1 downto 0);
type a_coefs is array (0 to NUMBER_OF_TAP-2) of signed(COEFF_WIDTH-1 downto 0);
type b_coefs is array (0 to NUMBER_OF_TAP-1) of signed(COEFF_WIDTH-1 downto 0);

signal x : data_array_t := (others => (others => '0'));
signal y,prod_b : out_array_t := (others => (others => '0'));
signal valid_pipeline : std_logic_vector(3 downto 0)  := (others => '0');
signal sum_b : signed(OUTPUT_WIDTH-1 downto 0) := (others => '0');


signal a    : a_coefs := (
    to_signed(2, COEFF_WIDTH),
    to_signed(4, COEFF_WIDTH)
);
signal b    : b_coefs := (
    to_signed(3, COEFF_WIDTH),
    to_signed(5, COEFF_WIDTH),
    to_signed(7, COEFF_WIDTH)
);

begin

-- Pipeline Stage 1: Update shift registers and compute multiplication for b coefficients
process(clk)
   variable mult_result : signed(OUTPUT_WIDTH-1 downto 0);
begin
   if rising_edge(clk) then
      if rst = '1' then
         x <= (others => (others => '0'));
         prod_b <= (others => (others => '0')); -- new signal for products
      else
			if(valid_in = '1') then
         -- Shift the x register
				for i in NUMBER_OF_TAP-2 downto 0 loop
					x(i+1) <= x(i);
				end loop;
				x(0) <= signed(data_in);

				-- Compute products for b coefficients and register them
				for i in 0 to NUMBER_OF_TAP-1 loop
					mult_result := resize(b(i) * x(i), OUTPUT_WIDTH);
					prod_b(i) <= mult_result;
				end loop;
			end if;
      end if;
   end if;
end process;

-- Pipeline Stage 2: Accumulate the b products
process(clk)
   variable acc_b : signed(OUTPUT_WIDTH-1 downto 0);
begin
   if rising_edge(clk) then
      if rst = '1' then
         sum_b <= (others => '0');
      else
			acc_b := (others => '0');
			for i in 0 to NUMBER_OF_TAP-1 loop
				acc_b := acc_b + prod_b(i);
			end loop;
			sum_b <= acc_b;
      end if;
   end if;
end process;

-- Pipeline Stage 3: Compute feedback and final output
process(clk)
   variable acc_final : signed(OUTPUT_WIDTH-1 downto 0);
   variable mult_result_a : signed(OUTPUT_WIDTH-1 downto 0);
begin
   if rising_edge(clk) then
      if rst = '1' then
         y <= (others => (others => '0'));
         valid_pipeline <= (others => '0'); -- pipeline control signal
      else
         -- Feedback path: compute a(j)*y(j) and subtract
			acc_final := sum_b;
			for j in 0 to NUMBER_OF_TAP-2 loop
				mult_result_a := resize(a(j) * y(j), OUTPUT_WIDTH);
				acc_final := acc_final - mult_result_a;
			end loop;
			y(0) <= acc_final;
			-- Shift the y register
			for i in NUMBER_OF_TAP-2 downto 0 loop
				y(i+1) <= y(i);
			end loop;
			-- Shift valid signal accordingly
			valid_pipeline <= valid_pipeline(2 downto 0) & valid_in;
			
      end if;
   end if;
end process;

data_out <= std_logic_vector(y(0));
valid_out <= valid_pipeline(3);


end Behavioral;