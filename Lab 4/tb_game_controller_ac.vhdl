library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_game_controller_ac is
end tb_game_controller_ac;

architecture behavior of tb_game_controller_ac is
	component game_controller_ac is
		port (
			clk             : in std_logic; -- Clock for the system
			rst             : in std_logic; -- Resets the state machine
			move_left       : in std_logic; -- User left
			move_right      : in std_logic; -- User right
			pixel_x         : in integer; -- X position of the cursor
			pixel_y		: in integer; -- Y position of the cursor
			shoot           : in std_logic; -- User shoot
			pixel_color		: out std_logic_vector (2 downto 0)
			);
			
	end component;
			
		signal clk_in : std_logic;
		signal rst_in : std_logic;
		signal move_left_in	: std_logic;
		signal move_right_in	: std_logic;
		signal pixel_x_in	: integer;
		signal pixel_y_in	: integer;
		signal shoot_in : std_logic;
		
		-- output
		signal pixel_color_out	: std_logic_vector (2 downto 0);
		-- helper
		constant clk_period : time := 10 ns;
begin

	game_controller_ac_instance : game_controller_ac
	port map (
		clk => clk_in,
		rst => rst_in,
		shoot => shoot_in,
		move_left => move_left_in,
		move_right => move_right_in,
		pixel_x => pixel_x_in,
		pixel_y => pixel_y_in,
		pixel_color => pixel_color_out
		);


	clk_process : process
	
	begin
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
	end process;


	test : process
	begin
		-- init check
		rst_in <= '1';
		wait for (clk_period * 3);

		-- pregame check
		rst_in <= '0';
		wait for (clk_period * 3);
		
		-- check gameplay
		shoot_in <= '1';
		wait for clk_period;
		
		-- check that it is still in gameplay after releasing shoot button
		shoot_in <= '0';
		wait for clk_period;

		-- we should still be in gameplay
		wait for (2 * clk_period);
		
		-- check transition back to init
		rst_in <= '1';
		wait for (clk_period * 3);

		-- check pregame
		rst_in <= '0';
		wait for (clk_period / 2);

		-- check gameplay
		shoot_in <= '1';
		wait for clk_period;
	
		assert false report "Game Controller test Sucess!" severity failure;
	end process;	

end behavior;