module Vending_Machine
 (
    input[1:0]  coins,
    input       clk,
    input       rst,

    output      sell,
    output      change,
    output[2:0] state
    
);
    parameter IDLE  = 3'd0;
    parameter GET05 = 3'd1;
    parameter GET10 = 3'd2;
    parameter GET15 = 3'd3;

    reg[2:0] s_cur;
    reg[2:0] s_next;
    // state transfer
    always @( posedge clk or posedge rst) begin
        if (rst) begin
            s_cur <= 'b0;
        end
        else begin
            s_cur <= s_next;
        end

    end
    // choose next state
    always @(*)begin
        case(s_cur)
            IDLE:
                case(coins)
                    2'b01:    s_next = GET05;
                    2'b10:    s_next = GET10;
                    default:  s_next = IDLE;
                endcase 
            GET05:
                case(coins)
                    2'b01:    s_next = GET10;
                    2'b10:    s_next = GET15;
                    default:  s_next = GET05;
                endcase
            GET10:
                case(coins)
                    2'b01:    s_next = GET15;
                    2'b10:    s_next = IDLE;
                    default:  s_next = GET10;
                endcase
            GET15:
                case(coins)
                    2'b01:    s_next = IDLE;
                    2'b10:    s_next = IDLE;
                    default: s_next = GET15;
                endcase
            default:    s_next = IDLE ;
        endcase
    end
    //output result
    reg       sell_r;
    reg       change_r;
    always@(posedge clk or posedge rst)begin
        if (rst) begin
            sell_r   <= 1'b0;
            change_r <= 1'b0;
        end
        
        else if ((s_cur == GET10 && coins == 2'b10)||(s_cur == GET15 &&coins == 2'b01))begin
            sell_r   <= 1'b1;
            change_r <= 1'b0;             
        end

        else if (s_cur == GET15 && coins == 2'b10)begin
            sell_r   <= 1'b1; 
            change_r <= 1'b1;             
        end

        else begin
            sell_r   <= 1'b0;
            change_r <= 1'b0;             
        end
    end
    assign sell     = sell_r;
    assign change   = change_r;
    assign state    = s_cur;

endmodule
