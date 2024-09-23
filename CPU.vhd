----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2024 22:46:19
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (18 downto 0);
           data_out : out STD_LOGIC_VECTOR (18 downto 0);
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           mem_r : out STD_LOGIC;
           mem_w : out STD_LOGIC);
end CPU;

architecture Behavioral of CPU is
    component ALU
     Port ( r2 : in STD_LOGIC_VECTOR (18 downto 0);
           r3 : in STD_LOGIC_VECTOR (18 downto 0);
           ALU_Op : in STD_LOGIC_VECTOR (2 downto 0);
           r1 : out STD_LOGIC_VECTOR (18 downto 0)
           );
       END component;
     component Register_File
      Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           r_addr1 : in STD_LOGIC_VECTOR (2 downto 0);
           r_addr2 : in STD_LOGIC_VECTOR (2 downto 0);
           w_addr : in STD_LOGIC_VECTOR (2 downto 0);
           w_data : in STD_LOGIC_VECTOR (18 downto 0);
           w_en : in STD_LOGIC;
           r_data1 : out STD_LOGIC_VECTOR (18 downto 0);
           r_data2 : out STD_LOGIC_VECTOR (18 downto 0)
        );
       end component;
      component Control_Unit
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
           stack : inout STD_LOGIC_VECTOR (18 downto 0)
         );
      end component;
      
      --signals
      signal pc : std_logic_vector(18 downto 0);
      signal ir : std_logic_vector(18 downto 0);
      signal alu_result : std_logic_vector(18 downto 0);
      signal regfile_out1 : std_logic_vector(18 downto 0);
      signal regfile_out2 : std_logic_vector(18 downto 0);
      signal alu_op : std_logic_vector(2 downto 0);
      signal w_en : std_logic;
      signal w_addr : std_logic_vector(2 downto 0);
      signal stack_sp : std_logic_vector(18 downto 0);
      signal stack_mem : std_logic_vector(18 downto 0);
      signal mem_addr_sig : std_logic_vector(18 downto 0);
      signal mem_write_sig : std_logic;
      signal mem_write_data_sig : std_logic_vector(18 downto 0);
            
begin
Fetch_Process : process(clk,reset)
begin 
  if reset = '1' then  
    pc <= (others =>'0');
  elsif rising_edge(clk) then
    pc <=std_logic_vector(unsigned(pc)+1);
    ir <= data_in;
  end if;
 end process Fetch_Process;
 
  --instantiate ALU
  ALU_Inst: ALU
   port map(
     r2 =>regfile_out1,
     r3 =>regfile_out2,
     ALU_Op =>alu_op,
     r1 =>alu_result
   
   );
   
  --instantiate register file
  RegFile_Inst : Register_File
   port map(
    clk => clk,
    reset =>reset,
    r_addr1 =>"000",
    r_addr2 => "001",
    w_addr =>w_addr,
    w_data => alu_result,
    w_en =>w_en,
    r_data1 =>regfile_out1,
    r_data2 => regfile_out2
   
   );
   
  --instantiate control unit
  CntrlUnit_Inst : Control_Unit
    port map(
      clk =>clk,
      reset => reset,
      instruction => ir,
      r1_data => regfile_out1,
      r2_data => regfile_out2,
      memory_data =>data_in,
      memory_addr =>mem_addr_sig,
      memory_write => mem_write_sig,
      memory_write_data =>mem_write_data_sig,
      PC =>pc,
      SP =>stack_mem    
    );
   
  data_out <= mem_write_data_sig;
  
  mem_r <= '1'
  when  mem_write_sig = '0' else '0';  
 
end Behavioral;
