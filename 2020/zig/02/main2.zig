const std = @import("std");
const input: []const u8 = @embedFile("input.txt");

fn charCount(string: []const u8, character: u8) u32 {
    var count: u32 = 0;
    for (string) |string_char| {
        if(character == string_char) count+=1;
    }
    return count;
}

fn isValidPassword(inputLine: []const u8) anyerror!bool {
    var line_bits = std.mem.split(inputLine, " ");
    var char_min_max = std.mem.split(line_bits.next().?, "-");

    var char_min = try std.fmt.parseUnsigned(u32, char_min_max.next().?, 10);
    var char_max = try std.fmt.parseUnsigned(u32, char_min_max.next().?, 10);
    var req_char = line_bits.next().?[0];
    var password = line_bits.next().?;

    var char_count = charCount(password, req_char);

    return (char_count >= char_min and char_count <= char_max);
}

fn isValidPasswordV2(inputLine: []const u8) anyerror!bool {
    var line_bits = std.mem.split(inputLine, " ");
    var char_indices = std.mem.split(line_bits.next().?, "-");

    var index1 = try std.fmt.parseUnsigned(u32, char_indices.next().?, 10);
    var index2 = try std.fmt.parseUnsigned(u32, char_indices.next().?, 10);
    var req_char = line_bits.next().?[0];
    var password = line_bits.next().?;

    var char_index1 = password[index1-1];
    var char_index2 = password[index2-1];

    return ((char_index1 == req_char) != (char_index2 == req_char));
}


pub fn main() anyerror!void {
    const file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;
    defer file.close();

    var validPasswords: u32 = 0;
    var validPasswordsV2: u32 = 0;
    var input_iter = std.mem.split(input, "\n");
    var raw_line = input_iter.next();
    while(raw_line != null) {
        var line = raw_line.?[0..];
        if (line[line.len-1] == '\r') {
            line = line[0..line.len-1];
        }

        if (try isValidPassword(line)) validPasswords+=1;
        if (try isValidPasswordV2(line)) validPasswordsV2+=1;

        raw_line = input_iter.next();
    }

    std.debug.print("Valid Passwords: {}\n", .{validPasswords});
    std.debug.print("Valid Passwords V2: {}\n", .{validPasswordsV2});
}
