----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2024 22:33:50
-- Design Name: 
-- Module Name: Register_File - Behavioral
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

entity Register_File is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           r_addr1 : in STD_LOGIC_VECTOR (2 downto 0);
           r_addr2 : in STD_LOGIC_VECTOR (2 downto 0);
           w_addr : in STD_LOGIC_VECTOR (2 downto 0);
           w_data : in STD_LOGIC_VECTOR (18 downto 0);
           w_en : in STD_LOGIC;
           r_data1 : out STD_LOGIC_VECTOR (18 downto 0);
           r_data2 : out STD_LOGIC_VECTOR (18 downto 0));
end Register_File;

architecture Behavioral of Register_File is
   type reg_array is array(0 to 7)of std_logic_vector(18 downto 0);
   signal registers : reg_array :=(others =>(others =>'0'));

begin
  process(clk,reset)
  begin
    if reset = '1' then
      registers <=(others =>(others => '0'));
    elsif rising_edge(clk) then
      if w_en = '1' then
        registers(TO_INTEGER(unsigned(w_addr)))<=w_data;
      end if;
    end if;
  end process;
  
 r_data1 <= registers(TO_INTEGER(unsigned(r_addr1)));
 r_data2 <= registers(TO_INTEGER(unsigned(r_addr2)));
 
      
end Behavioral;
