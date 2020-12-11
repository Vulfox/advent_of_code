const std = @import("std");
const input: []const u8 = @embedFile("example_input.txt");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const InstructionSet = enum(u2) { nop, acc, jmp };

const Instruction = struct {
    set: InstructionSet,
    value: i32,
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var instructions = ArrayList(Instruction).init(allocator);
    defer instructions.deinit();

    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        if (raw_line.len == 0) break;
        //per line logic
        var line_iter = std.mem.split(raw_line, " ");
        
        var ins = line_iter.next().?;
        var set = switch (ins[0]) {
            'a' => InstructionSet.acc,
            'j' => InstructionSet.jmp,
            else => InstructionSet.nop,
        };
        var ins_val_str = line_iter.next().?;
        //std.debug.print("ins: {}; value: {}\n", .{ins, ins_val_str});
        var ins_val = try std.fmt.parseInt(i32, ins_val_str, 10);
        try instructions.append(Instruction{.set = set, .value = ins_val});
    }

    var t = try isInfiniteLoop(allocator, instructions.items);
    try fixInvalidIndex(allocator, instructions.items);
}

fn isInfiniteLoop(allocator: *Allocator, instructions: []Instruction) !bool {
    var acc: i32 = 0;
    var i: i32 = 0;

    var executed_ids = ArrayList(i32).init(allocator);
    defer executed_ids.deinit();

    while(i < instructions.len) : (i+=1) {
        if(contains(executed_ids.items, i)){
            std.debug.print("acc: {}\n", .{acc});
            return true;
        }

        var instruction = instructions[@intCast(u32,i)];


        switch (instruction.set) {
            InstructionSet.nop => {},
            InstructionSet.acc => {
                acc += instruction.value;
            },
            InstructionSet.jmp => {
                i += instruction.value - 1;
            }
        }
        try executed_ids.append(i);
        std.debug.print("{}, acc: {}\n", .{instruction, acc});
    }

    return false;
}

fn fixInvalidIndex(allocator: *Allocator, instructions: []Instruction) !void {//, instructions: *ArrayList(Instruction)) !void {
    var potential_swaps = ArrayList(u32).init(allocator);
    defer potential_swaps.deinit();

    for(instructions) |instruction, index| {
        std.debug.print("{}, i: {}\n", .{instruction, index});
        var valid_swap = false;
        var causes_underover = false;
        var resulting_index: i32 = instruction.value + @intCast(i32,index);
        if (resulting_index < 0 or resulting_index > instructions.len-1) causes_underover = true;
        switch (instruction.set) {
            InstructionSet.nop => {
                if(instruction.value != 0 and !causes_underover) valid_swap = true;
            },
            InstructionSet.acc => {},
            InstructionSet.jmp => {
                if(instruction.value != 0 and instruction.value != 1) valid_swap = true;
            }
        }

        if (valid_swap) try potential_swaps.append(@intCast(u32,index));
    }

    for(potential_swaps.items) |potential_swap| {
        //std.debug.print("{}\n", .{potential_swap});
        flipOp(&instructions[potential_swap]);
        var isInfinite: bool = try isInfiniteLoop(allocator, instructions);
        std.debug.print("i_swap: {}, isInf: {}\n", .{potential_swap, isInfinite});
        if (!isInfinite) break;
        flipOp(&instructions[potential_swap]);
    }

}

fn flipOp(op: *Instruction) void {
    switch (op.set) {
        InstructionSet.nop => {
            op.set = InstructionSet.jmp;
        },
        InstructionSet.jmp => {
            op.set = InstructionSet.nop;
        },
        else => {},
    }
}

fn contains(list: []i32, item: i32) bool {
    for(list) |element| {
        if(element == item) return true;
    }

    return false;
}