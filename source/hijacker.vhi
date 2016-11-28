
-- VHDL Instantiation Created from source file hijacker.vhd -- 17:45:33 09/09/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT hijacker
	PORT(
		clk : IN std_logic;
		DI1 : IN std_logic_vector(7 downto 0);
		DI2 : IN std_logic_vector(7 downto 0);          
		DO1 : OUT std_logic_vector(7 downto 0);
		DO2 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_hijacker: hijacker PORT MAP(
		clk => ,
		DI1 => ,
		DI2 => ,
		DO1 => ,
		DO2 => 
	);


