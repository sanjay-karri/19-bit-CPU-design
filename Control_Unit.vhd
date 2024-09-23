----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2024 22:02:26
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (18 downto 0);
           r1_data : in STD_LOGIC_VECTOR (18 downto 0);
           r2_data : in STD_LOGIC_VECTOR (18 downto 0);
           memory_data : in STD_LOGIC_VECTOR (18 downto 0);
           memory_addr : out STD_LOGIC_VECTOR (18 downto 0);
           memory_write : out STD_LOGIC;
           memory_write_data : out STD_LOGIC_VECTOR (18 downto 0);
           PC : out STD_LOGIC_VECTOR (18 downto 0);
           SP : out STD_LOGIC_VECTOR (18 downto 0);
           stack : inout STD_LOGIC_VECTOR (18 downto 0));
end Control_Unit;

architecture Behavioral of Control_Unit is
    signal pc_reg : unsigned(18 downto 0) :=(others =>'0');
    signal SP_reg : unsigned(18 downto 0) :=(others =>'1');
    signal opcode : std_logic_vector(4 downto 0);
    signal addr : unsigned(18 downto 0);
    signal stack_mem : std_logic_vector(18 downto 0);
    
begin
  opcode <=instruction(18 downto 14);
  addr <=unsigned(instruction(18 downto 0));
  
  process(clk,reset)
  begin
    if reset = '1' then
      pc_reg <= (others =>'0');
      sp_reg <=(others =>'1');
    elsif rising_edge(clk) then
      case opcode is
        when "10000" =>
           pc_reg <=addr;
        when "10001" =>
          if r1_data = r2_data then  
            pc_reg <=addr;
          else
            pc_reg <= pc_reg+1;
          end if;
        when "10010" =>
         if r1_data/=r2_data then
           pc_reg <=addr;
         else 
           pc_reg <= pc_reg+1;
         end if;
         when "10100" =>
           sp_reg <=sp_reg+1;
           pc_reg <=unsigned(stack_mem);
         when "10101" =>
           memory_addr <= std_logic_vector(addr);
           pc_reg<=pc_reg+1;
         when "10110" => 
           memory_addr <=std_logic_vector(addr);
           memory_write <='1';
           memory_write_data <= r1_data;
           pc_reg <= pc_reg+1;
           
         when others =>
           pc_reg <=pc_reg+1;
         end case;
       end if;
     end process;
     
   PC <= std_logic_vector(pc_reg);
   SP <= std_logic_vector(sp_reg);
   
   stack <= stack_mem;

end Behavioral;
