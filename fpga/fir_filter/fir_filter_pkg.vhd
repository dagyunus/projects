library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package fir_filter_pkg is

constant INPUT_WIDTH    : natural := 25;
constant OUTPUT_WIDTH   : natural := 48;
constant COEFF_WIDTH    : natural := 18;
constant NUMBER_OF_TAPS : natural := 9;

type COEFS_TYPE is array (0 to NUMBER_OF_TAPS-1) of signed(COEFF_WIDTH-1 downto 0);

constant COEFFICIENTS: COEFS_TYPE := (
    to_signed(200, COEFF_WIDTH),
    to_signed(300, COEFF_WIDTH),
    to_signed(500, COEFF_WIDTH),
    to_signed(700, COEFF_WIDTH),
    to_signed(900, COEFF_WIDTH),
	 to_signed(700, COEFF_WIDTH),
    to_signed(500, COEFF_WIDTH),
    to_signed(300, COEFF_WIDTH),
    to_signed(200, COEFF_WIDTH)
);

end package;
