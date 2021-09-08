module LEDWheel_pll(PACKAGEPIN,
                    PLLOUTCORE,
                    PLLOUTGLOBAL,
                    RESET);

inout PACKAGEPIN;
input RESET;    /* To initialize the simulation properly, the RESET signal (Active Low) must be asserted at the beginning of the simulation */ 
output PLLOUTCORE;
output PLLOUTGLOBAL;

SB_PLL40_PAD LEDWheel_pll_inst(.PACKAGEPIN(PACKAGEPIN),
                               .PLLOUTCORE(PLLOUTCORE),
                               .PLLOUTGLOBAL(PLLOUTGLOBAL),
                               .EXTFEEDBACK(),
                               .DYNAMICDELAY(),
                               .RESETB(RESET),
                               .BYPASS(1'b0),
                               .LATCHINPUTVALUE(),
                               .LOCK(),
                               .SDI(),
                               .SDO(),
                               .SCLK());

//\\ Fin=80, Fout=25;
defparam LEDWheel_pll_inst.DIVR = 4'b0000;
defparam LEDWheel_pll_inst.DIVF = 7'b0001001;
defparam LEDWheel_pll_inst.DIVQ = 3'b101;
defparam LEDWheel_pll_inst.FILTER_RANGE = 3'b101;
defparam LEDWheel_pll_inst.FEEDBACK_PATH = "SIMPLE";
defparam LEDWheel_pll_inst.DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
defparam LEDWheel_pll_inst.FDA_FEEDBACK = 4'b0000;
defparam LEDWheel_pll_inst.DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
defparam LEDWheel_pll_inst.FDA_RELATIVE = 4'b0000;
defparam LEDWheel_pll_inst.SHIFTREG_DIV_MODE = 2'b00;
defparam LEDWheel_pll_inst.PLLOUT_SELECT = "GENCLK";
defparam LEDWheel_pll_inst.ENABLE_ICEGATE = 1'b0;

endmodule
