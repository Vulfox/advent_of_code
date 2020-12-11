const std = @import("std");
const input: []const u8 = @embedFile("example_input.txt");

pub fn main() anyerror!void {
    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        if (raw_line.len == 0) break;
        //per line logic
    }
}
