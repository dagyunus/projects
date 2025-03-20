library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir_filter_tb is
end iir_filter_tb;

architecture test of iir_filter_tb is

    constant INPUT_WIDTH    : integer := 25;
    constant COEFF_WIDTH    : integer := 18;
    constant NUMBER_OF_TAP  : integer := 3;
    constant OUTPUT_WIDTH   : integer := 48;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal valid_in   : std_logic := '0';
    signal data_in    : std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');
    signal data_out   : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal valid_out  : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- Saat periyodu (100 MHz için)
    
begin

    -- **Saat Üretimi (Clock Generation)**
    process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- **Test Senaryosu**
    process
    begin
        -- **Reset Aktif**
		  wait until rising_edge(clk);
        rst <= '1';
        wait for 2 * CLK_PERIOD;
        rst <= '0';  -- Reset bırakıldı
        
        -- **İlk giriş**
        valid_in <= '1';
        data_in <= std_logic_vector(to_signed(10, 25)); 
        wait for CLK_PERIOD;
        
        -- **İkinci giriş**
        data_in <= std_logic_vector(to_signed(-5, 25));
        wait for CLK_PERIOD;
        
        -- **Üçüncü giriş**
        data_in <= std_logic_vector(to_signed(15, 25));
        wait for CLK_PERIOD;

        -- **Dördüncü giriş**
        data_in <= std_logic_vector(to_signed(7, 25));
			
			wait for CLK_PERIOD;

        -- **Dördüncü giriş**
        data_in <= std_logic_vector(to_signed(8, 25));
		  
		  wait for CLK_PERIOD;

        -- **Dördüncü giriş**
        data_in <= std_logic_vector(to_signed(4, 25));
		  wait for CLK_PERIOD;

        -- **Dördüncü giriş**
        data_in <= std_logic_vector(to_signed(21, 25));
		  wait for CLK_PERIOD;

        -- **Dördüncü giriş**
        data_in <= std_logic_vector(to_signed(17, 25));
			
		  wait for 2*CLK_PERIOD;
		  valid_in <= '0';
		  data_in <= (others => '0');
	
        
        -- **Simülasyonun Bitmesi**
        wait for 10 * CLK_PERIOD;
        wait;
    end process;

    -- **IIR Filter Bağlantısı**
    uut: entity work.iir_filter
        generic map(
            INPUT_WIDTH    => 25,
				COEFF_WIDTH => 18,
				NUMBER_OF_TAP => 3,
            OUTPUT_WIDTH   => 48
        )
        port map(
            clk        => clk,
            rst        => rst,
            valid_in   => valid_in,
            data_in    => data_in,
            data_out   => data_out,
            valid_out  => valid_out
        );

end test;
