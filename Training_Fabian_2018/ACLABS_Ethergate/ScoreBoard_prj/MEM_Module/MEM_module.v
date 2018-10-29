module mem(
    clk_mem,
    rst_mem,

    mem_position_in,
    mem_id_in,

    enable_mem,

    red_px_mem,
    green_px_mem,
    blue_px_mem
);

input clk_mem, rst_mem, enable_mem;
input [2:0] mem_position_in;
input [3:0] mem_id_in;

output [2:0] red_px_mem, green_px_mem;
output [1:0] blue_px_mem;

reg [9:0] horizontal_x_d, horizontal_x_ff;
reg [9:0] vertical_y_d, vertical_y_ff;

reg[2:0] red_b_d, red_b_ff, green_b_d, green_b_ff;
reg[1:0] blue_b_d, blue_b_ff;

reg[3:0] color_d, color_ff;

reg mem_nr_0 [0:39] [0:29];
wire mem_nr_0_data;
reg [5:0] index_y_0_d, index_y_0_ff;
reg [4:0] index_x_0_d, index_x_0_ff;

reg mem_nr_1 [0:39] [0:29];
wire mem_nr_1_data;
reg [5:0] index_y_1_d, index_y_1_ff;
reg [4:0] index_x_1_d, index_x_1_ff;

reg mem_nr_2 [0:39] [0:29];
wire mem_nr_2_data;
reg [5:0] index_y_2_d, index_y_2_ff;
reg [4:0] index_x_2_d, index_x_2_ff;

reg mem_nr_3 [0:39] [0:29];
wire mem_nr_3_data;
reg [5:0] index_y_3_d, index_y_3_ff;
reg [4:0] index_x_3_d, index_x_3_ff;

reg mem_nr_4 [0:39] [0:29];
wire mem_nr_4_data;
reg [5:0] index_y_4_d, index_y_4_ff;
reg [4:0] index_x_4_d, index_x_4_ff;

reg mem_nr_5 [0:39] [0:29];
wire mem_nr_5_data;
reg [5:0] index_y_5_d, index_y_5_ff;
reg [4:0] index_x_5_d, index_x_5_ff;

reg mem_nr_6 [0:39] [0:29];
wire mem_nr_6_data;
reg [5:0] index_y_6_d, index_y_6_ff;
reg [4:0] index_x_6_d, index_x_6_ff;

reg mem_nr_7 [0:39] [0:29];
wire mem_nr_7_data;
reg [5:0] index_y_7_d, index_y_7_ff;
reg [4:0] index_x_7_d, index_x_7_ff;

reg mem_nr_8 [0:39] [0:29];
wire mem_nr_8_data;
reg [5:0] index_y_8_d, index_y_8_ff;
reg [4:0] index_x_8_d, index_x_8_ff;

reg mem_nr_9 [0:39] [0:29];
wire mem_nr_9_data;
reg [5:0] index_y_9_d, index_y_9_ff;
reg [4:0] index_x_9_d, index_x_9_ff;

reg [5:0] i;
reg [4:0] j;

parameter H_VIZ = 'd640;
parameter V_VIZ = 'd480;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

parameter POSITION_NULL = 'b111;
parameter POSITION_ZERO = 'b000;
parameter POSITION_ONE = 'b001;

parameter ELEMENT_ZERO = 'b0000;
parameter ELEMENT_ONE = 'b0001;
parameter ELEMENT_TWO = 'b0010;
parameter ELEMENT_THREE = 'b0011;
parameter ELEMENT_FOUR = 'b0100;
parameter ELEMENT_FIVE = 'b0101;
parameter ELEMENT_SIX = 'b0110;
parameter ELEMENT_SEVEN = 'b0111;
parameter ELEMENT_EIGHT = 'b1000;
parameter ELEMENT_NINE = 'b1001;
parameter ELEMENT_NULL = 'b1010;

parameter WHITE = 'b0111;
parameter YELLOW = 'b0110;
parameter CYAN = 'b0101;
parameter GREEN = 'b0100;
parameter MAGENTA = 'b0011;
parameter RED = 'b0010;
parameter BLUE = 'b0001;
parameter BLACK = 'b0000;
parameter COLOR_NULL = 'b1000;

always @(posedge clk_mem or posedge rst_mem) begin
    if(rst_mem) begin
        
        vertical_y_ff <= RESET;
        horizontal_x_ff <= RESET;

        index_y_0_ff <=RESET;
        index_y_1_ff <=RESET;
        index_y_2_ff <=RESET;
        index_y_3_ff <=RESET;
        index_y_4_ff <=RESET;
        index_y_5_ff <=RESET;
        index_y_6_ff <=RESET;
        index_y_7_ff <=RESET;
        index_y_8_ff <=RESET;
        index_y_9_ff <=RESET;

        index_x_0_ff <=RESET;
        index_x_1_ff <=RESET;
        index_x_2_ff <=RESET;
        index_x_3_ff <=RESET;
        index_x_4_ff <=RESET;
        index_x_5_ff <=RESET;
        index_x_6_ff <=RESET;
        index_x_7_ff <=RESET;
        index_x_8_ff <=RESET;
        index_x_9_ff <=RESET;
        
        red_b_ff <= RESET;
        green_b_ff <= RESET;
        blue_b_ff <= RESET;

        color_ff <= RESET;

/*----------------------------------------------------------zero*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_0 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------one*/
        for(i = 0; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_1 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_1 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------two*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_2 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

       for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b0;
            end
       end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------three*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_3 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

         for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_3 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
       end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------four*/
        for(i = 0; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
             for(j = 5; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
        end

        for(i = 20 ; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_4 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------five*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end

         for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_5 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------six*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end

         for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_6 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------seven*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_7 [i][j] = 'b1;
            end
        end

        for(i = 5; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_7 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_7 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------eight*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_8 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_8 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------nine*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_9 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_9 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------*/

    end
    else if(enable_mem) begin

        vertical_y_ff <= vertical_y_d;
        horizontal_x_ff <= horizontal_x_d;

        index_y_0_ff <= index_y_0_d;
        index_y_1_ff <= index_y_1_d;
        index_y_2_ff <= index_y_2_d;
        index_y_3_ff <= index_y_3_d;
        index_y_4_ff <= index_y_4_d;
        index_y_5_ff <= index_y_5_d;
        index_y_6_ff <= index_y_6_d;
        index_y_7_ff <= index_y_7_d;
        index_y_8_ff <= index_y_8_d;
        index_y_9_ff <= index_y_9_d;

        index_x_0_ff <= index_x_0_d;
        index_x_1_ff <= index_x_1_d;
        index_x_2_ff <= index_x_2_d;
        index_x_3_ff <= index_x_3_d;
        index_x_4_ff <= index_x_4_d;
        index_x_5_ff <= index_x_5_d;
        index_x_6_ff <= index_x_6_d;
        index_x_7_ff <= index_x_7_d;
        index_x_8_ff <= index_x_8_d;
        index_x_9_ff <= index_x_9_d;

        red_b_ff <= red_b_d;
        green_b_ff <= green_b_d;
        blue_b_ff <= blue_b_d;

        color_ff <= color_d;
    end
    else begin
        vertical_y_ff <= DISABLE;
        horizontal_x_ff <= DISABLE;

        index_y_0_ff <= DISABLE;
        index_y_1_ff <= DISABLE;
        index_y_2_ff <= DISABLE;
        index_y_3_ff <= DISABLE;
        index_y_4_ff <= DISABLE;
        index_y_5_ff <= DISABLE;
        index_y_6_ff <= DISABLE;
        index_y_7_ff <= DISABLE;
        index_y_8_ff <= DISABLE;
        index_y_9_ff <= DISABLE;

        index_x_0_ff <= DISABLE;
        index_x_1_ff <= DISABLE;
        index_x_2_ff <= DISABLE;
        index_x_3_ff <= DISABLE;
        index_x_4_ff <= DISABLE;
        index_x_5_ff <= DISABLE;
        index_x_6_ff <= DISABLE;
        index_x_7_ff <= DISABLE;
        index_x_8_ff <= DISABLE;
        index_x_9_ff <= DISABLE;

        red_b_ff <= DISABLE;
        green_b_ff <= DISABLE;
        blue_b_ff <= DISABLE;

        color_ff <= DISABLE;
    end
end

always @(*) begin
    
    vertical_y_d = vertical_y_ff;
    horizontal_x_d = horizontal_x_ff;

    index_y_0_d = index_y_0_ff;
    index_y_1_d = index_y_1_ff;
    index_y_2_d = index_y_2_ff;
    index_y_3_d = index_y_3_ff;
    index_y_4_d = index_y_4_ff;
    index_y_5_d = index_y_5_ff;
    index_y_6_d = index_y_6_ff;
    index_y_7_d = index_y_7_ff;
    index_y_8_d = index_y_8_ff;
    index_y_9_d = index_y_9_ff;

    index_x_0_d = index_x_0_ff;
    index_x_1_d = index_x_1_ff;
    index_x_2_d = index_x_2_ff;
    index_x_3_d = index_x_3_ff;
    index_x_4_d = index_x_4_ff;
    index_x_5_d = index_x_5_ff;
    index_x_6_d = index_x_6_ff;
    index_x_7_d = index_x_7_ff;
    index_x_8_d = index_x_8_ff;
    index_x_9_d = index_x_9_ff;

    color_d = color_ff;

    red_b_d = red_b_ff;
    green_b_d = green_b_ff;
    blue_b_d = blue_b_ff;

    if(vertical_y_ff == V_VIZ - 1 && horizontal_x_ff == H_VIZ - 1) begin
        horizontal_x_d = DISABLE;
        vertical_y_d = DISABLE;
    end
    else if(horizontal_x_ff == H_VIZ - 1) begin
        horizontal_x_d = RESET;
        vertical_y_d = vertical_y_d + 1;
    end
    else begin
        horizontal_x_d = horizontal_x_d + 1;
    end

    case (mem_position_in)

    POSITION_NULL: begin
        /*nothing to display*/
        index_y_0_d = RESET;
        index_x_0_d = RESET;

        index_y_1_d = RESET;
        index_x_1_d = RESET;

        index_y_2_d = RESET;
        index_x_2_d = RESET;

        index_y_3_d = RESET;
        index_x_3_d = RESET;

        index_y_4_d = RESET;
        index_x_4_d = RESET;

        index_y_5_d = RESET;
        index_x_5_d = RESET;

        index_y_6_d = RESET;
        index_x_6_d = RESET;

        index_y_7_d = RESET;
        index_x_7_d = RESET;

        index_y_8_d = RESET;
        index_x_8_d = RESET;

        index_y_9_d = RESET;
        index_x_9_d = RESET;
    end

    POSITION_ZERO: begin
        index_y_0_d = vertical_y_d;
        index_x_0_d = horizontal_x_d;

        index_y_1_d = vertical_y_d;
        index_x_1_d = horizontal_x_d;

        index_y_2_d = vertical_y_d;
        index_x_2_d = horizontal_x_d;

        index_y_3_d = vertical_y_d;
        index_x_3_d = horizontal_x_d;

        index_y_4_d = vertical_y_d;
        index_x_4_d = horizontal_x_d;

        index_y_5_d = vertical_y_d;
        index_x_5_d = horizontal_x_d;

        index_y_6_d = vertical_y_d;
        index_x_6_d = horizontal_x_d;

        index_y_7_d = vertical_y_d;
        index_x_7_d = horizontal_x_d;

        index_y_8_d = vertical_y_d;
        index_x_8_d = horizontal_x_d;

        index_y_9_d = vertical_y_d;
        index_x_9_d = horizontal_x_d;
    end

    POSITION_ONE: begin
        /*loading*/
    end
        
    default: begin
        /*nothing*/
    end
    endcase

    case (mem_id_in)
    ELEMENT_ZERO: begin
        if(mem_nr_0_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end
        
    ELEMENT_ONE:  begin
        if(mem_nr_1_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_TWO: begin
        if(mem_nr_2_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
     end

    ELEMENT_THREE: begin
        if(mem_nr_3_data == 1) begin
            color_d = WHITE;
        end
        else begin
             color_d = COLOR_NULL;
        end
    end

    ELEMENT_FOUR: begin
        if(mem_nr_4_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_FIVE: begin
        if(mem_nr_5_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_SIX: begin
        if(mem_nr_6_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_SEVEN: begin
        if(mem_nr_7_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_EIGHT: begin
        if(mem_nr_8_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_NINE: begin
        if(mem_nr_9_data == 1) begin
            color_d = WHITE;
        end
        else begin
            color_d = COLOR_NULL;
        end
    end

    ELEMENT_NULL: begin
        color_d = COLOR_NULL;
    end
    
    endcase

    case (color_d)
    WHITE: begin
        red_b_d = 'b111;
        green_b_d = 'b111;
        blue_b_d = 'b11;
    end

    YELLOW:begin
        red_b_d = 'b111;
        green_b_d = 'b111;
        blue_b_d = 'b0;
    end

    CYAN: begin
        red_b_d = 'b111;
        green_b_d = 'b0;
         blue_b_d = 'b11;
    end

    GREEN: begin
        red_b_d = 'b0;
        green_b_d = 'b111;
        blue_b_d = 'b0;
    end

    MAGENTA: begin
        red_b_d = 'b0;
        green_b_d = 'b111;
        blue_b_d = 'b11;
    end

    RED: begin
        red_b_d = 'b111;
        green_b_d = 'b0;
        blue_b_d = 'b0;
    end

    BLUE: begin
        red_b_d = 'b0;
        green_b_d = 'b0;
        blue_b_d = 'b11;
    end

    BLACK: begin
        red_b_d = 'b0;
        green_b_d = 'b0;
        blue_b_d = 'b0;
    end

    COLOR_NULL: begin
        red_b_d = DISABLE;
        green_b_d = DISABLE;
        blue_b_d = DISABLE;
    end

    endcase
end

assign red_px_mem = red_b_ff;
assign green_px_mem = green_b_ff;
assign blue_px_mem = blue_b_ff;

assign mem_nr_0_data = mem_nr_0[index_y_0_ff][index_x_0_ff];
assign mem_nr_1_data = mem_nr_1[index_y_1_ff][index_x_1_ff];
assign mem_nr_2_data = mem_nr_2[index_y_2_ff][index_x_2_ff];
assign mem_nr_3_data = mem_nr_3[index_y_3_ff][index_x_3_ff];
assign mem_nr_4_data = mem_nr_4[index_y_4_ff][index_x_4_ff];
assign mem_nr_5_data = mem_nr_5[index_y_5_ff][index_x_5_ff];
assign mem_nr_6_data = mem_nr_6[index_y_6_ff][index_x_6_ff];
assign mem_nr_7_data = mem_nr_7[index_y_7_ff][index_x_7_ff];
assign mem_nr_8_data = mem_nr_8[index_y_8_ff][index_x_8_ff];
assign mem_nr_9_data = mem_nr_9[index_y_9_ff][index_x_8_ff];

endmodule