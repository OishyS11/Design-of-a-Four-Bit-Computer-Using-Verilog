module Proj(A3,A2,A1,A0,clk,A,B,BYTE,address,address_val,stack,memA,memB,IP,outA,temp,ZF,CF,SF);


input A3,A2,A1,A0;
input clk;
input [3:0]A,B,BYTE;
input [3:0] address,address_val;
output reg [3:0]stack,memA,memB,IP,outA,temp;
output reg ZF,CF,SF;
integer i,j;


always @(posedge clk)
casex ({A3,A2,A1,A0})
  0: // Implementing addition command (instruction 1)
  begin
  {CF,memA}=A+B;
  ZF=(memA==0);
  if ((memA&4'b1000)==4'b1000)
     SF=1;
  else
     SF=0;
  IP=1;
  end
  
  1: // Implementing subtraction command (instruction 2)
  begin
  {CF,memA}=A-B;
  ZF=(memA==0);
  if ((memA&4'b1000)==4'b1000)
     SF=1;
  else
     SF=0;
  IP=2;
  end
  
  2: // Implementing exchange command (instruction 3)
  begin
  memB=A;
  memA=B;
  IP=3;
  end
  
  3:
  begin // Implementing In command (instruction 4)
  memA=A;
  IP=4;
  end
  
  4: // Implementing RCR command (instruction 5)
  begin
  CF=0;
  temp=A;
  for (j=2;j>=0;j=j-1)
  begin 
  for(i=3;i>=1;i=i-1)
  begin
  memA[i-1]=temp[i];
  end
  memA[3]=CF;
  CF=temp>>1;
  temp=memA;
  end
  IP=5;
  ZF=(memA==0);
  SF=0;
  end
  
  5: // Implementing decrement command (instruction 6)
  begin
  memB=B-1;
  IP=6;
  ZF=(memB==0);
  SF=0;
  CF=0;
  end
  
  6: //Implementing JZ command (instruction 7)
  begin
  if (ZF==1)
  begin
  IP=address;
  memA=A^B;
  end
  else
  IP=7;
  end
  
  7: //Implementing JMP command (instruction 8)
  begin
  IP=address;
  memA=A^B;
  end
  
  8: //Implemention OR command (instruction 9)
  begin
  memB=B|BYTE;
  IP=8;
  ZF=(memB==0);
  SF=0;
  CF=0;
  end
  
  9: //Implementing PUSH command(instruction 10)
  begin
  stack=B;
  IP=9;
  end
  
  10: //Implementing POP command(instruction 11)
  begin
  memB=stack;
  IP=10;
  stack=0;
  end
  
  11: //Implementing OUT command (instruction 12)
  begin
  outA=memA;
  IP=11;
  end
  
  12: //Implementing call command(instruction 13)
  begin
  stack=IP+1;
  IP=address;
  memA=A^B;
  end
  
  
  13: //Implementing ret command (instruction 14)
  begin
  IP=stack;
  stack=0;
  CF=0;
  SF=0;
  ZF=0;
  end
  
  14: //Implementing AND command (instruction 15)
  begin
  memA=A & address_val;
  IP=13;
  CF=0;
  SF=0;
  ZF=(memA==0);
  end
  
  15: // Implementing HLT command (instruction 16)
  begin
  stack=4'bxxxx;
  memA=4'bxxxx;
  memB=4'bxxxx;
  IP=4'bxxxx;
  outA=4'bxxxx;
  ZF=4'bxxxx;
  CF=4'bxxxx;
  SF=4'bxxxx;
  
  end
   
  endcase
  
endmodule