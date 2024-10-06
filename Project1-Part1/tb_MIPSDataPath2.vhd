-------------------------------------------------------------------------
-- Caleb Hemmestad
-- Iowa State University
-------------------------------------------------------------------------
-- tb_register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the structural mux2t_N 
-- unit with an N value of 32.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

-- Create a test entity
entity tb_MIPSDataPath2 is
    generic (gCLK_HPER : time := 10 ns); -- Generic for half of the clock cycle period
end tb_MIPSDataPath2;

architecture mixed of tb_MIPSDataPath2 is 

    constant cCLK_PER : time := gCLK_HPER * 2;

    component MIPSDataPath2 is 
        port (
	i_Clk			:in std_logic;
	i_En			:in std_logic;
	i_MemEn			:in std_logic;
	i_MemRd			:in std_logic;
	i_Rst			:in std_logic;
	i_Rs			:in std_logic_vector(4 downto 0);
	i_Rt			:in std_logic_vector(4 downto 0);
	i_Rd			:in std_logic_vector(4 downto 0);
	i_Imm			:in std_logic_vector(15 downto 0);
	i_ALUSrc		:in std_logic;
	i_nAdd_Sub		:in std_logic
	);
    end component;

    signal CLK		:std_logic := '0';
    signal s_En		:std_logic;
    signal s_EN_MEM	:std_logic;
    signal s_RD_MEM	:std_logic;
    signal s_RST 	:std_logic;
    signal s_ALU 	:std_logic;
    signal s_ADD_SUB 	:std_logic;
    signal s_IMM 	:std_logic_vector(15 downto 0);
    signal s_RS		:std_logic_vector(4 downto 0);
    signal s_RT 	:std_logic_vector(4 downto 0);
    signal s_RD 	:std_logic_vector(4 downto 0);



begin

    DUT0 : MIPSDataPath2
    port map(
        i_Clk 		=> CLK,
	i_En		=> s_EN,
	i_MemEn		=> s_EN_MEM,
	i_MemRd		=> s_RD_MEM,
        i_Rst 		=> s_RST,
        i_Rd 		=> s_RD,
        i_Rs 		=> s_RS,
        i_Rt 		=> s_RT,
	i_Imm		=> s_IMM,
	i_ALUSrc	=> s_ALU,
	i_nAdd_Sub	=> s_ADD_SUB
	);

    P_CLK : process
    begin
        CLK <= '1';
        wait for gCLK_HPER;
        CLK <= '0';
        wait for gCLK_HPER;
    end process;

    P_TEST_CASES : process
    begin
        wait for gCLK_HPER/2;
        -- Reset  the register
        s_RST <= '1';
        wait for gCLK_HPER;
        s_RST <= '0';
        wait for gCLK_HPER;

/* Examples
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00001";
	s_RS		<= B"00000";
	s_IMM		<= X"0001";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"01011";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;
*/
	-- ADD_SUB 0 for add 1 for sub
	-- ALU 0 for reg 1 for immediate
    	-- EN_MEM 0 to read from memory 1 to write to memory
	-- s_RD_MEM 0 to load memory data in reg 1 to load input data into reg
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
	--addi
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"11001";
	s_RS		<= B"00000";
	s_IMM		<= X"0000";
        wait for gCLK_HPER * 2;
	
	--addi
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"11010";
	s_RS		<= B"00000";
	s_IMM		<= X"0100";
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00001";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0000"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0004"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11010";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"0000"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0008"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11010";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"0004"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"000C"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11010";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"0008"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0010"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11010";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"000C"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0014"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11010";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"0010"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--lw
	s_EN		<= '1';      --write to the register or not
	s_RD		<= B"00010";--register to load into
	s_RS		<= B"11001";--memory address
	s_ALU		<= '1';	    --lw is an immediate type
	s_IMM		<= X"0018"; --shift
	s_ADD_SUB	<= '0';     --add or sub from memory address
	s_EN_MEM	<= '0';     --reading or writing from memory
	s_RD_MEM	<= '0';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

	--add
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"00001";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;
	
	--addi
	s_EN		<= '1';
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"11011";
	s_RS		<= B"00000";
	s_IMM		<= X"0200";
        wait for gCLK_HPER * 2;

	--sw
	s_EN		<= '0';      --write to the register or not
	s_RD		<= B"00000";--register to load into (Doesnt matter cause en is 0)
	s_RS		<= B"11011";--memory address
	s_RT		<= B"00001";--register reading from
	s_ALU		<= '1';	    --sw is an immediate type
	s_IMM		<= X"0004"; --shift
	s_ADD_SUB	<= '1';     --add or sub from memory address
	s_EN_MEM	<= '1';     --reading or writing from memory
	s_RD_MEM	<= '1';     --putting mem or value in reg
        wait for gCLK_HPER * 2;

    end process;

end mixed;
























































