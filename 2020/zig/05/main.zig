const std = @import("std");
const input: []const u8 = @embedFile("input.txt");

fn getRow(rowStr: []const u8) u32{
    var row: u7 = undefined;
    for(rowStr) |c|{
        row <<= 1;
        if(c == 'B') {
            row |= 1;
        }
    }

    return row;
}

fn getCol(colStr: []const u8) u32{
    var col: u3 = undefined;
    for(colStr) |c|{
        col <<= 1;
        if(c == 'R') {
            col |= 1;
        }
    }

    return col;
}

pub fn main() anyerror!void {
    var maxSeatID: u32 = 0;

    var rowSum: u32 = 0;
    var colSum: u32 = 0;
    var maxRowSum: u32 = 0;
    var maxColSum: u32 = 0;

    var maxRow: u32 = 0;
    var minRow: u32 = undefined;

    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        var line = raw_line[0..];

        if (line.len != 0 and line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }
        if (line.len == 0) continue;

        //per line logic
        var row = getRow(line[0..7]);
        var col = getCol(line[7..10]);

        //if (row > 0 and row < 127) {
        rowSum += row+1;
        colSum += col+1;
        //}
        //std.debug.print("Row: {}; Col: {}\n", .{});
        // std.debug.print("Col: {};\n", .{col});

        var seatID = row * 8 + col;
        if (seatID > maxSeatID) maxSeatID = seatID;
        if (row+1 > maxRow) {maxRow = row+1; maxRowSum = 0;maxColSum = 0;}
        if (row+1 < minRow) minRow = row+1;

        if (maxRow == row+1) {
            maxRowSum += row+1;
            maxColSum += col+1;
        }
        //std.debug.print("Row: {}; Col: {}; SeatID: {};\n", .{row+1, col+1, seatID});
    }
    std.debug.print("Max SeatID: {};\n", .{maxSeatID});
    
    std.debug.print("row sum: {};\n", .{rowSum});
    std.debug.print("max row sum: {};\n", .{maxRowSum});
    std.debug.print("row min: {};\n", .{minRow});
    std.debug.print("row max: {};\n", .{maxRow});
    var height = maxRow - minRow;
    var width: u32 = 8;
    std.debug.print("col sum: {};\n", .{colSum});
    std.debug.print("max col sum: {};\n", .{maxColSum});

    std.debug.print("height: {};\n", .{height});
    std.debug.print("width: {};\n", .{width});

    var theoryColSum: u32 = (width+1) * width / 2;
    var theoryRowSum: u32 = ((maxRow+1) * maxRow / 2) - ((minRow-1) * minRow / 2);
    var theoryMaxColSum: u32 = theoryColSum * height;
    var theoryMaxRowSum: u32 = theoryRowSum * width;
    std.debug.print("theory col sum: {};\n", .{theoryColSum});
    std.debug.print("theory row sum: {};\n", .{theoryRowSum});
    std.debug.print("theory col max sum: {};\n", .{theoryMaxColSum});
    std.debug.print("theory row max sum: {};\n", .{theoryMaxRowSum});

    var col2 = theoryMaxColSum - (colSum - maxColSum);
    var row2 = theoryMaxRowSum - (rowSum + 515);
    std.debug.print("Col2: {};\n", .{col2});
    std.debug.print("Row2: {};\n", .{row2});

    std.debug.print("Santa SeatID: {};\n", .{(row2-1) * 8 + (col2-1)});
}
