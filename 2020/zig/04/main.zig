const std = @import("std");
const input: []const u8 = @embedFile("input.txt");

fn isValidBYR(value: []const u8) bool {
    if (value.len != 4) return false;
    var com_value = std.fmt.parseUnsigned(u32, value, 10) catch { return false;};
    return (com_value >= 1920 and com_value <= 2002);
}

fn isValidIYR(value: []const u8) bool {
    if (value.len != 4) return false;
    var com_value = std.fmt.parseUnsigned(u32, value, 10) catch { return false;};
    return(com_value >= 2010 and com_value <= 2020);

}

fn isValidEYR(value: []const u8) bool {
    if (value.len != 4) return false;
    var com_value = std.fmt.parseUnsigned(u32, value, 10) catch { return false;};
    return (com_value >= 2020 and com_value <= 2030);
}

fn isValidHGT(value: []const u8) bool {
    if (value.len < 4 or value.len > 5) return false;
    var height = std.fmt.parseUnsigned(u32, value[0..value.len-2], 10) catch { return false;};
    var system = value[value.len-2..];
    if(std.mem.eql(u8, "cm", system) and height >= 150 and height <= 193) return true;
    if(std.mem.eql(u8, "in", system) and height >= 59 and height <= 76) return true;

    return false;
}

fn isValidHCL(value: []const u8) bool {
    if (value.len != 7 or value[0] != '#') return false;
    for(value[1..]) |c| {
        if(!std.ascii.isXDigit(c)) return false;
    }
    return true;
}

fn isValidECL(value: []const u8) bool {
    if(std.mem.eql(u8, "amb", value)) return true;
    if(std.mem.eql(u8, "blu", value)) return true;
    if(std.mem.eql(u8, "brn", value)) return true;
    if(std.mem.eql(u8, "gry", value)) return true;
    if(std.mem.eql(u8, "grn", value)) return true;
    if(std.mem.eql(u8, "hzl", value)) return true;
    if(std.mem.eql(u8, "oth", value)) return true;
    return false;
}

fn isValidPID(value: []const u8) bool {
    if (value.len != 9) return false;

    for(value) |c| {
        if (!std.ascii.isDigit(c)) return false;
    }
    return true;
}

pub fn main() anyerror!void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = &arena.allocator;

    var timer = std.time.Timer.start() catch return;
    const start = timer.lap();

    //var lines = ArrayList(*Passport).init(allocator);

    var passport: u8 = 0;
    var passport2: u8 = 0;
    var validPassports: u32 = 0;
    var validPassports2: u32 = 0;
    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        var line = raw_line[0..];

        if (line.len != 0 and line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }

        //per line logic
        if (line.len == 0){
            // std.debug.print("Passport: {b}\n", .{passport});
            // std.debug.print("Passport2: {b}\n", .{passport2});
            if (passport & 0b11111110 == 0b11111110) validPassports += 1; //bits of the passport
            if (passport2 & 0b11111110 == 0b11111110) validPassports2 += 1;
            passport = 0;
            passport2 = 0;
        }
        else {
            var line_iter = std.mem.split(line, " ");
            while (line_iter.next()) |field_value| {
                var field_value_split = std.mem.split(field_value, ":");
                var field = field_value_split.next().?;
                var value = field_value_split.next().?;
                if(std.mem.eql(u8, "byr", field)) {
                    passport |= 0b10000000;
                    if(isValidBYR(value)) passport2 |= 0b10000000;
                }
                else if(std.mem.eql(u8, "iyr", field)) {
                    passport |= 0b01000000;
                    if(isValidIYR(value)) passport2 |= 0b01000000;
                }
                else if(std.mem.eql(u8, "eyr", field)) {
                    passport |= 0b00100000;
                    if(isValidEYR(value)) passport2 |= 0b00100000;
                }
                else if(std.mem.eql(u8, "hgt", field)) {
                    passport |= 0b00010000;
                    if(isValidHGT(value)) passport2 |= 0b00010000;
                }
                else if(std.mem.eql(u8, "hcl", field)) {
                    passport |= 0b00001000;
                    if(isValidHCL(value)) passport2 |= 0b00001000;
                }
                else if(std.mem.eql(u8, "ecl", field)) {
                    passport |= 0b00000100;
                    if(isValidECL(value)) passport2 |= 0b00000100;
                }
                else if(std.mem.eql(u8, "pid", field)) {
                    passport |= 0b00000010;
                    if(isValidPID(value)) passport2 |= 0b00000010;
                }
                // else if(std.mem.eql(u8, "cid", field)) {
                //     passport |= 0b00000001;
                //     passport2 |= 0b00000001;
                // }
            }
        }
    }

    const end = timer.read();
    const elapsed_s = @intToFloat(f64, end - start) / std.time.ns_per_us;

    std.debug.print("info: December {d}us\n", .{elapsed_s});
    std.debug.print("Valid Passports: {}\n", .{validPassports});
    std.debug.print("Valid PassportsV2: {}\n", .{validPassports2});
}
