const std = @import("std");

fn determineIfTreeHit(slope_x: u32, slope_y: u32, row: []const u8, row_index: u32) bool {
    return ((row_index % slope_y == 0) and row[((row_index / slope_y) * slope_x) % row.len] == '#');
}

pub fn main() anyerror!void {
    const file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;
    defer file.close();

    var treesHit_3_1: u32 = 0;
    var treesHit_1_1: u32 = 0;
    var treesHit_5_1: u32 = 0;
    var treesHit_7_1: u32 = 0;
    var treesHit_1_2: u32 = 0;

    var buffer: [64]u8 = undefined;
    var row_index: u32 = 0;
    while (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |raw_line| {
        if (raw_line.len == 0) break;
        var line : []u8 = raw_line;
        // Cause Windows
        if (line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }

        // skip first row cause we will never have 0 slope
        if (row_index != 0) {
            if (determineIfTreeHit(3, 1, line, row_index)) treesHit_3_1 += 1;
            if (determineIfTreeHit(1, 1, line, row_index)) treesHit_1_1 += 1;
            if (determineIfTreeHit(5, 1, line, row_index)) treesHit_5_1 += 1;
            if (determineIfTreeHit(7, 1, line, row_index)) treesHit_7_1 += 1;
            if (determineIfTreeHit(1, 2, line, row_index)) treesHit_1_2 += 1;
        }
        row_index += 1;
    }

    std.debug.print("Trees Hit 1-1: {}\n", .{treesHit_1_1});
    std.debug.print("Trees Hit 3-1: {}\n", .{treesHit_3_1});
    std.debug.print("Trees Hit 5-1: {}\n", .{treesHit_5_1});
    std.debug.print("Trees Hit 7-1: {}\n", .{treesHit_7_1});
    std.debug.print("Trees Hit 1-2: {}\n", .{treesHit_1_2});
    std.debug.print("Trees Hit Multiplied: {}\n", .{treesHit_1_1*treesHit_3_1*treesHit_5_1*treesHit_7_1*treesHit_1_2});
}
