const std = @import("std");
const input: []const u8 = @embedFile("input.txt");

pub fn main() anyerror!void {
    var timer = std.time.Timer.start() catch return;
    const start = timer.lap();

    var count: u32 = 0;
    var count2: u32 = 0;
    var groupAnswer: u26 = 0;
    var groupAnswer2: u26 = 0;
    var individualAnswer: u26 = 0;
    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        var line = raw_line[0..];

        if (line.len != 0 and line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }

        //per line logic
        if (line.len == 0){
            // std.debug.print("GroupAnswer:  {b}\n", .{groupAnswer});
            // std.debug.print("GroupAnswer2: {b}\n", .{groupAnswer2});
            var i: usize = 0;
            while(i <std.meta.bitCount(@TypeOf(groupAnswer))) : (i += 1) {
                count += groupAnswer&1;
                groupAnswer >>= 1;
            }
            groupAnswer = 0;

            i = 0;
            while(i <std.meta.bitCount(@TypeOf(groupAnswer2))) : (i += 1) {
                count2 += groupAnswer2&1;
                groupAnswer2 >>= 1;
            }
            groupAnswer2 = 0;
        }
        else {
            for (line) |c| {
                // normalize input. assumes lower case
                var location = c - 'a';
                var alphaBit: u26 = 1;
                individualAnswer |= (alphaBit << @intCast(u5, location));
                //std.debug.print("Bit: {b}\n", .{groupAnswer});
            }
            // std.debug.print("IndividualAnswer:  {b}\n", .{individualAnswer});
            
            if(groupAnswer == 0) {
                groupAnswer2 |= individualAnswer;
            }
            else {
                groupAnswer2 &= individualAnswer;
            }
            groupAnswer |= individualAnswer;
            individualAnswer = 0;
        }
    }

    const end = timer.read();
    const elapsed_s = @intToFloat(f64, end - start) / std.time.ns_per_us;

    std.debug.print("info: December {d}us\n", .{elapsed_s});

    std.debug.print("Count: {}\n", .{count});
    std.debug.print("Count2: {}\n", .{count2});
}
