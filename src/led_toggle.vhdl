library ieee;
use ieee.std_logic_1164.all;

entity led_toggle is
	port
	(
		i_Clk: 		in std_logic;
		i_Switch: 	in std_logic;
		o_LED:		out std_logic
	);
end entity led_toggle;

architecture RTL of led_toggle is

	signal r_LED:		std_logic := '0';
	signal r_Switch:	std_logic := '0';

begin

	process (i_Clk) is
	begin
		if rising_edge(i_Clk) then
			r_Switch <= i_Switch;

			if r_Switch = '1' and i_Switch = '0' then
				r_LED <= not r_LED;
			end if;
		end if;
	end process;

	o_LED <= r_LED;
end RTL;

