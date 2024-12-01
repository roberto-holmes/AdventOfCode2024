`timescale 1ns / 1ps

module Sort #(
    parameter NUM_VALS = 5,
    parameter SIZE     = 16
) (
    input wire clk,
    input reg [SIZE-1:0] in[0:NUM_VALS-1],
    output reg [SIZE-1:0] out[0:NUM_VALS-1]
);
  // Clock out result on every posedge
  reg [SIZE-1:0] sorted_bus[0:NUM_VALS-1];
  always_ff @(posedge clk) begin
    out <= sorted_bus;
  end

  integer i, j;
  reg [SIZE-1:0] temp;
  reg [SIZE-1:0] array[1:NUM_VALS];
  always_comb begin
    for (i = 0; i < NUM_VALS; i = i + 1) begin
      array[i+1] = in[i];
    end

    for (i = NUM_VALS; i > 0; i = i - 1) begin
      for (j = 1; j < i; j = j + 1) begin
        if (array[j] < array[j+1]) begin
          temp       = array[j];
          array[j]   = array[j+1];
          array[j+1] = temp;
        end
      end
    end

    for (i = 0; i < NUM_VALS; i = i + 1) begin
      sorted_bus[i] = array[i+1];
    end
  end
endmodule

module Day1 #(
    parameter LENGTH = 6,
    parameter SIZE   = 8
) (
    input  wire            clk,
    input  wire [SIZE-1:0] data[0:1][0:LENGTH-1],
    output reg  [    31:0] out
);
  wire [SIZE-1:0] data_left [0:LENGTH-1];
  wire [SIZE-1:0] data_right[0:LENGTH-1];
  Sort #(LENGTH, SIZE) sort_left (
      clk,
      data[0],
      data_left
  );
  Sort #(LENGTH, SIZE) sort_right (
      clk,
      data[1],
      data_right
  );

  integer        i;
  reg     [31:0] tmp;
  always_comb begin
    for (i = 0; i < LENGTH; i = i + 1) begin
      // Add difference between the values in each list
      if (i == 0) begin
        tmp = data_left[i] - data_right[i];
        // Convert negative numbers to positive
        if (tmp[31] == 1'b1) begin
          tmp = -tmp;
        end
        out = tmp;
      end else begin
        tmp = data_left[i] - data_right[i];
        // Convert negative numbers to positive
        if (tmp[31] == 1'b1) begin
          tmp = -tmp;
        end
        out = out + tmp;
      end
    end
  end
endmodule
