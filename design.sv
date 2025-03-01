

module d_ff(input logic d, clk, rst,
            output reg q, qbar);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      q <= 0;
      qbar <= 1;
    end else begin
      q <= ~d;       //q <= d;
      qbar <= d;    //qbar <= ~d;
    end
  end
endmodule
