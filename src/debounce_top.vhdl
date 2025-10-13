library ieee;
use ieee.std_logic_1164.all;

entity debounce_top is
	port
	(
		i_Clk;      in  std_logic
		i_Switch_1: in  std_logic,
		o_LED:      out std_logic
	);
end entity debounce_top;

architecture RTL of debounce_top is
	signal w_Debounce_Switch: std_logic;
begin
	Debounce_Inst: entity work.Debounce_Filter
		generic map
		(
			
		)
