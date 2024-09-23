----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2024 21:38:51
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( r2 : in STD_LOGIC_VECTOR (18 downto 0);
           r3 : in STD_LOGIC_VECTOR (18 downto 0);
           ALU_Op : in STD_LOGIC_VECTOR (2 downto 0);
           r1 : out STD_LOGIC_VECTOR (18 downto 0));
end ALU;

architecture Behavioral of ALU is
   signal r2_unsigned : unsigned(18 downto 0);
   signal r3_unsigned :unsigned(18 downto 0);
   signal mult_r1 : unsigned(37 downto 0);
   signal temp_r1 : unsigned(18 downto 0);
begin
   r2_unsigned <= unsigned(r2);
   r3_unsigned <= unsigned(r3);
   
   process(r2_unsigned,r3_unsigned,ALU_Op)
   begin 
     case ALU_Op is
      when "000" =>
       temp_r1 <=RESIZE(r2_unsigned+r3_unsigned,19);
       r1 <=std_logic_vector(temp_r1);
      when "001" =>
       temp_r1 <=resize(r2_unsigned-r3_unsigned,19);
       r1 <=std_logic_vector(temp_r1);
      when "010" =>
       mult_r1 <= r2_unsigned*r3_unsigned;
       r1<= std_logic_vector(mult_r1(18 downto 0));
       when "011" =>
         temp_r1 <=r2_unsigned and r3_unsigned;
         r1 <=std_logic_vector(temp_r1);
         
        when others =>
         r1 <=(others => '0');
         
       end case;
     end process;
    

end Behavioral;
