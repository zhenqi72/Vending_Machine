module test();
    reg clk;
    reg rst;
    reg [1:0] coin;
    wire change;
    wire sell;
    wire[2:0] state;

    parameter    CYCLE_200MHz = 10 ; //
    always begin
        clk = 0 ; 
        #(CYCLE_200MHz/2) ;
        clk = 1 ; 
        #(CYCLE_200MHz/2) ;
    end

    reg [9:0]    buy_oper ; 
    
    initial begin
        buy_oper  = 'h0 ;
        coin      = 2'h0 ;
        rst       = 1'b1 ;
        #8 rst    = 1'b0 ;
        @(negedge clk) ;

        //case(1) 0.5 -> 0.5 -> 0.5 -> 0.5
        #16 ;
        buy_oper  = 10'b00_0101_0101 ;
        repeat(5) begin
            @(negedge clk) ;
            coin      = buy_oper[1:0] ;
            buy_oper  = buy_oper >> 2 ;
        end

        //case(2) 1 -> 0.5 -> 1, taking change
        #16 ;
        buy_oper  = 10'b00_0010_0110 ;
        repeat(5) begin
            @(negedge clk) ;
            coin      = buy_oper[1:0] ;
            buy_oper  = buy_oper >> 2 ;
        end

        //case(3) 0.5 -> 1 -> 0.5
        #16 ;
        buy_oper  = 10'b00_0001_1001 ;
        repeat(5) begin
            @(negedge clk) ;
            coin      = buy_oper[1:0] ;
            buy_oper  = buy_oper >> 2 ;
        end

        //case(4) 0.5 -> 0.5 -> 0.5 -> 1, taking change
        #16 ;
        buy_oper  = 10'b00_1001_0101 ;
        repeat(5) begin
            @(negedge clk) ;
            coin      = buy_oper[1:0] ;
            buy_oper  = buy_oper >> 2 ;
        end
    end

    Vending_Machine vd1 (
        .coins      (coin),
        .clk        (clk),
        .rst        (rst),
        .sell       (sell),
        .change     (change),
        .state      (state)
        );
    
    always begin
      #100;
      if ($time >= 10000)  $finish ;
   end
    
endmodule
