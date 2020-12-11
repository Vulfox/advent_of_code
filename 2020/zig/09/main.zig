const std = @import("std");
const input: []const u8 = @embedFile("input.txt");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const SliceAggError = error {
    EmptySlice,
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var series = ArrayList(u64).init(allocator);

    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        if (raw_line.len == 0) break;
        //per line logic
        try series.append(try std.fmt.parseUnsigned(u64, raw_line, 10));

    }

    // for(series.items) |n, i| {
    //     std.debug.print("{}\n", .{n});
    // }

    var invalid = getInvalidPreamble(series.items, 25);
    std.debug.print("Invalid N: {}\n", .{invalid});

    var sumn = getSumEntriesN(allocator, series.items, invalid);
    std.debug.print("Sum N: {}\n", .{sumn});
}

fn getInvalidPreamble(series: []u64, preambleCount: usize) u64 {
    for(series) |n, i| {
        if(i < preambleCount) continue;
        //std.debug.print("{}\n", .{n});
        if(!doesSumExist(series[i-preambleCount..i], n)) return n;
    }

    return 0;
}

fn doesSumExist(preamble: []u64, n: u64) bool {
    for(preamble) |pi, i| {
        for(preamble) |pj, j| {
            if(j == i) continue;
            if(pi + pj == n) return true;
        }
    }

    return false;
}

fn getSumEntriesN(allocator: *Allocator, series: []u64, n: u64) u64 {
    //var sumEntries = ArrayList(u64).init(allocator);

    //var x = recurseFind(&sumEntries, series, n);
    for(series) |x, i| {
        var sum = x;
        //std.debug.print("Start: {}\n", .{x});
        if (sum == n) return 0;
        for(series[i+1..]) |y, j| {
            //std.debug.print("  Start: {}\n", .{y});
            //std.debug.print("  i: {}, j: {}\n", .{i, j});
            sum += y;
            if(sum == n) return sliceMinMaxSum(series[i..j+i+1]);
            if(sum > n) break;
        }
    }

    
    //std.debug.print("Find Count: {}\n", .{sumEntries.items.len});
    //return std.mem.min(u64, sumEntries.items) + std.mem.max(u64, sumEntries.items);
    return 0;
}

fn sliceMinMaxSum(slice: []u64) u64 {
    //std.debug.print("minmaxsum: {}\n", .{slice.len});
    if(slice.len == 0) return 0;
    var min: u64 = slice[0];
    var max: u64 = slice[0];
    for(slice) |s| {
        if (s < min) min = s;
        if (s > max) max = s;
    }
    return min + max;
}

fn sliceMin(slice: []u64) !u64 {
    if(slice.len == 0) return SliceAggError.EmptySlice;
    var min: u64 = slice[0];
    for(slice) |s| {
        if (s < min) min = s;
    }
    return min;
}
fn sliceMax(slice: []u64) !u64 {
    if(slice.len == 0) return SliceAggError.EmptySlice;
    var max: u64 = slice[0];
    for(slice) |s| {
        if (s > max) max = s;
    }
    return max;
}

fn sliceSum(slice: []u64) u64 {
    var output: u64 = 0;
    for(slice) |n| {
        output += n;
    }
    return output;
}