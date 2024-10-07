----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2024 09:47:49 PM
-- Design Name: 
-- Module Name: RX_UART - Behavioral
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RX_UART is
    Port ( RX, RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           READY : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end RX_UART;

architecture Behavioral of RX_UART is
    type state_type is (idle,start,data,stop);
    signal state_reg, state_next: state_type; -- state of the state machine --
    signal clk16_reg,clk16_next: unsigned(9 downto 0); -- counter for uart pulse --
    signal s_reg, s_next: unsigned(3 downto 0); -- s counter for each sample --
    signal n_reg,n_next: unsigned(2 downto 0); -- n counter for each bit --
    signal b_reg,b_next: std_logic_vector(7 downto 0); -- rx data register --
    signal s_pulse: STD_LOGIC; -- uart pulse --
    constant DVSR: integer := 54; -- 54 for 115200 , 651 for 9600 Baud at 100 MHz, 52 for 1200 Baud at 1 MHz (1200 Baud does not work with Basys3 and FTDI USB-UART Bridge)
begin


-- Process for the UART CLK --

process(clk,reset)
begin
    if RESET = '1' then
        clk16_reg <= (others=>'0');
    elsif(clk'event and clk='1') then
        clk16_reg <= clk16_next;
    end if;
end process;

-- Next-state/output logic
clk16_next <= (others=>'0') when clk16_reg=(DVSR-1) else
    clk16_reg + 1;
s_pulse <= '1' when clk16_reg=0 else '0';

-- FSDM state and Data Registers --
process(clk,reset)
begin
    if reset = '1' then
        state_reg <= idle;
        s_reg <= (others => '0');
        n_reg <= (others => '0');
        b_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
    end if;
end process;


-- Next-State logic and data path functional units / routing --
process(state_reg,s_reg,n_reg,b_reg,s_pulse,rx)
begin
    s_next <= s_reg;
    n_next <= n_reg;
    b_next <= b_reg;
    ready <= '0';
    case state_reg is 
        
        when idle =>
            if rx = '0' then
                state_next <= start;
            else
                state_next <= idle; -- forgot to add this --
            end if; 
            ready <= '1';
            
        when start =>
            if (s_pulse = '1') then
                if (s_reg = 7) then
                    state_next <= data;
                    s_next <= (others => '0');
                else
                    state_next <= start;
                    s_next <= s_reg + 1;
                end if;
            else
                state_next <= start;
            end if;
            
        when data =>
            if (s_pulse = '1') then
                if s_reg = 15 then
                    -- store data --
                    s_next <= (others => '0');
                    b_next <= rx & b_reg(7 downto 1);
                    if n_reg=7 then
                        state_next <= stop;
                        n_next <= (others => '0');
                    else
                        state_next <= data;
                        n_next <= n_reg + 1;
                    end if;
                else
                    state_next <= data;
                    s_next <= s_reg + 1;
                end if;
            else
                state_next <= data;
            end if;
        
        when stop =>
            if (s_pulse = '1') then
                if s_reg = 15 then
                    state_next <= idle;
                    s_next <= (others => '0');
                else
                    state_next <= stop;
                    s_next <= s_reg + 1;
                end if;
            else
                state_next <= stop;
            end if;
    end case;
    
end process;

dout <= b_reg;

end Behavioral;
