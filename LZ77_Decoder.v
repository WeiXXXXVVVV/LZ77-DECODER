module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output  reg			encode;
output reg 			finish;
output 	 reg 	[7:0] 	char_nxt;

reg [7:0] data [8:0];
reg [2:0] count;
integer i;
reg  cstat,nstat;
parameter a0=0, a1=1;
always @ (posedge clk or posedge reset)begin
    if(reset)begin  
      for(i=0;i<8;i=i+1)
      begin
          data[i]<=0;
      end
      count<=0;
      cstat<=a0;
      //finish <=0;
    end
    else begin
      cstat <= nstat;
         if(cstat==a0)begin
          data[1]<=data[0];
          data[2]<=data[1];
          data[3]<=data[2];
          data[4]<=data[3];
          data[5]<=data[4];
          data[6]<=data[5];
          data[7]<=data[6];
          data[8]<=data[7]; 
          if(code_len==0 || count==code_len)begin
              char_nxt<=chardata;
              data[0]<=chardata;
              count<=0;
          end
          else begin
           char_nxt<=data[code_pos];
           data[0]<=data[code_pos];
           count<=count+1;
          end
         end         
     end      
end
always @(*)begin
  case(cstat)  
    a0:begin
      if(char_nxt == 8'h24)begin
       nstat=a1;
      end
      else 
      nstat=a0;
    end
    a1:begin
      nstat=a1;
    end
  endcase
end
always @(*)begin
  case(cstat)  
    a0:begin
     {encode,finish}=2'b00;
   end
    a1:begin
      {encode,finish}=2'b01;
      end
      endcase
end
endmodule