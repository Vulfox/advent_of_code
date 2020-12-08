const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

fn determine2020Expenses(expenses: []u32, n: u2) void {
    for(expenses) |expense, index| {
        for(expenses) |expense2, index2| {
            if (index == index2) continue;
            
            if (n == 2 and (expense+expense2) == 2020) {
                std.debug.print("expense product: {} * {} = {}\n", .{expense, expense2, expense*expense2});
                return;
            }
            if (n == 3) {
                for(expenses) |expense3, index3| {
                    if ((index == index3) or (index2 == index3)) continue;
                    
                    if ((expense+expense2+expense3) == 2020) {
                        std.debug.print("expense product: {} * {} * {} = {}\n", .{expense, expense2, expense3, expense*expense2*expense3});
                        return;
                    }
                }
            }
        }
    }
}

pub fn main() anyerror!void {
    const file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;
    defer file.close();

    // buffer for file line streaming
    var expenses = ArrayList(u32).init(test_allocator);
    var buffer: [64]u8 = undefined;
    while (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |raw_line| {
        if (raw_line.len == 0) break;
        var line : []u8 = raw_line;
        if (line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }

        try expenses.append(try std.fmt.parseUnsigned(u32, line, 10));
    }

    determine2020Expenses(expenses.items, 2);
    determine2020Expenses(expenses.items, 3);
}
