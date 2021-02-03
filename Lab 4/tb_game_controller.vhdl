-- Author: Aurelia HAAS & Christine RIACHI
--Description: This test bench verifies the logic of the Finite State Machine.
-----------------------------------

-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

-- Declare entity
entity tb_game_controller is
end tb_game_controller;

architecture behaviour of tb_game_controller is

-- Component declaration of Device Under Test (DUT)

	component game_controller is

		Port (

			clk             : in std_logic; -- Clock for the system

		        rst             : in std_logic; -- Resets the state machine

		

		        -- Inputs

		        shoot           : in std_logic; -- User shoot

		        move_left       : in std_logic; -- User left

		        move_right      : in std_logic; -- User right

				  

			pixel_x         : in integer; -- X position of the cursor

			pixel_y		: in integer; -- Y position of the cursor

	        

			-- Outputs

		        pixel_color		: out std_logic_vector (2 downto 0)

		);

	end component;



	-- Inputs

	signal clk_in		: std_logic;

	signal rst_in		: std_logic;

	signal shoot_in		: std_logic;

	signal move_left_in	: std_logic;

	signal move_right_in	: std_logic;

	signal pixel_x_in	: integer;

	signal pixel_y_in	: integer;



	-- Outputs

	signal pixel_color_out	: std_logic_vector (2 downto 0);



-- Helpers
constant clk_period : time := 10 ns;
type state is (init, pre_game, gameplay, game_over);
type alien_array is array(59 downto 0) of integer;

begin

game_controller_instance : game_controller
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

-- This process creates a clock signal
clk_process: process
begin
clk_in <= '0';
wait for clk_period/2;
clk_in <= '1';
wait for clk_period/2;
end process;

-- This initializes the system by holding the reset high for 2 clock periods
initialize: process
begin
wait for clk_period;
rst_in <= '1';
wait for clk_period;
rst_in <= '0';
wait for clk_period;
end process;

-- This is the actual unit test
test: process
begin

-- check init state 
rst_in <= '1';
shoot_in <= '0';
wait for 2*clk_period; 

-- check pregame state
rst_in <= '0';
wait for 2*clk_period;

-- check gameplay state
shoot_in <= '1';
wait for 3*clk_period;
-- check we are still in gameplay
shoot_in <= '0';
wait for 6*clk_period; 

-- force score = 60 and wait a few clock periods to see game_over state

wait for 3*clk_period; 


end process;
end behaviour;

