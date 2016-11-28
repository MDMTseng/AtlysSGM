-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity grayscale is
    Port ( 
			CLK: in STD_LOGIC;
			R1 : in  STD_LOGIC_VECTOR (4 downto 0);
         G1 : in  STD_LOGIC_VECTOR (5 downto 0);
         B1 : in  STD_LOGIC_VECTOR (4 downto 0);
         Y : out STD_LOGIC_VECTOR (7 downto 0)
			);
end grayscale;

architecture Behavioral of grayscale is
signal R1_9, G1_9, B1_9: STD_LOGIC_VECTOR(8 downto 0);
signal Y1: STD_LOGIC_VECTOR(9 downto 0);
signal R1_9n, G1_9na, G1_9nb: STD_LOGIC_VECTOR(8 downto 0);


begin
	R1_9 <= ('0' & '0' & '0' & '0' & R1);
	G1_9 <= ('0' & '0' & '0' & G1);
	B1_9 <= ('0' & '0' & '0' & '0' & B1);
	Y <= Y1(9 downto 2);
	R1_9n <= (R1_9(6 downto 0) & '0' & '0');
	G1_9na <= (G1_9(7 downto 0) & '0');
	G1_9nb <= (G1_9(6 downto 0) & '0' & '0');
	--Y <= abs(conv_integer (Y2));
process (CLK)
begin
		if (CLK'event and CLK = '1') then
			Y1 <= ('0' & R1_9n) + ('0' & G1_9na) + ('0' & G1_9nb) + ('0' & B1_9);
		end if;
end process;

end Behavioral;
