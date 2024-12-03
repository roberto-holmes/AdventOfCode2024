`timescale 1ns / 1ps

module Day2Part1 #(
    parameter ARRAY_WIDTH  = 5,
    parameter ARRAY_LENGTH = 6,
    parameter VAR_SIZE     = 32
) (
    input  wire                clk,
    input  wire                rst,
    input  wire [VAR_SIZE-1:0] data[0:ARRAY_LENGTH-1][0:ARRAY_WIDTH-1],
    output reg  [        31:0] out
);
  integer        level;
  integer        report;
  reg     [31:0] tmp;
  reg            report_done;
  reg            is_rising;
  reg            is_currently_rising;

  always_ff @(posedge clk) begin
    if (rst) begin
      out <= 32'd0;
      is_rising <= 0;
      report_done <= 0;
    end else begin
      if (level == 0) begin
        is_rising   <= 0;
        report_done <= 0;
      end else begin
        if (report < ARRAY_LENGTH) begin
          // Only accept changes in level
          if (tmp == 0) report_done <= 1'b1;
          // Check for negative values
          else if (is_currently_rising) begin
            if (level == 1) begin
              is_rising <= 1'b1;
            end else if (!is_rising) report_done <= 1'b1;
          end else if (level != 1 && is_rising) report_done <= 1'b1;

          // Check that the difference is at most 3
          if (tmp > 3) report_done <= 1'b1;
        end
      end
    end
  end

  always_ff @(negedge clk) begin
    if (rst) begin
      level  <= 0;
      report <= 0;
    end else begin
      if ((level == ARRAY_WIDTH - 1) || (data[report][level+1] == 32'b0)) begin
        if (!report_done && tmp != 0) out <= out + 1;
        level  <= 0;
        report <= report + 1;
      end else level <= level + 1;
    end
  end

  always_comb begin
    if (!report_done) begin
      if (data[report][level-1] < data[report][level]) begin
        tmp = data[report][level] - data[report][level-1];
        is_currently_rising = 1;
      end else if (data[report][level-1] > data[report][level]) begin
        tmp = data[report][level-1] - data[report][level];
        is_currently_rising = 0;
      end else tmp = 0;
    end else tmp = 0;
  end

endmodule
