library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;

library work;
use work.and_gate;

entity and_gate_tb is
end entity and_gate_tb;

architecture behave of and_gate_tb is
	signal r_In1, r_In2, w_Out: std_logic;

begin
	UUT: entity and_gate
		port map
		(
			i_Switch_1 => r_In1,
			i_Switch_2 => r_In2,
			o_LED      => w_Out
		);
	
	process is
	begin
		r_In1 <= '0';
		r_In2 <= '0';
		wait for 10 ns;
		r_In1 <= '0';
		r_In2 <= '1';
		wait for 10 ns;
		r_In1 <= '1';
		r_In2 <= '0';
		wait for 10 ns;
		r_In1 <= '1';
		r_In2 <= '1';
		wait for 10 ns;
		wait for 10 ns;
		finish;
	end process;
end behave;

