----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2024 12:18:34 PM
-- Design Name: 
-- Module Name: sim_UART_RX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_UART_RX is
--  Port ( );
end sim_UART_RX;

architecture Behavioral of sim_UART_RX is

    component RX_UART is
        Port ( RX, RESET : in STD_LOGIC;
               CLK : in STD_LOGIC;
               READY : out STD_LOGIC;
               DOUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal rx : std_logic := '1';
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal rx_vector : std_logic_vector(7 downto 0) := "10100101";
    
    signal ready : std_logic;
    signal dout : std_logic_vector(7 downto 0);
    constant clk_period : time := 10 ns;

begin
    -- Instantiate a component --
    dut : rx_uart PORT MAP(
        rx => rx,
        reset => reset,
        clk => clk,
        ready => ready,
        dout => dout
    );
    
    clock_process :process 
    begin
        clk <= not(clk);
        wait for clk_period/2;
    end process;
    
    main_process :process
    begin
        reset <= '1';
        wait for 2000 ns;
        reset <= '0';
        wait for 2000 ns;
        rx <= '0';
        wait for 8.68 us;
        for i in 0 to 7 loop            
            rx <= rx_vector(i);
            wait for 8.68 us; 
        end loop;
        rx <= '1';
        wait;
    end process;
    
    
end Behavioral;
