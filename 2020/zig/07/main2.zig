const std = @import("std");
const input: []const u8 = @embedFile("input.txt");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

const BagCount = struct {
    //bag: *Bag,
    name: []const u8,
    count: u32,
};

const Bag = struct {
    const Self = @This();

    name: []const u8,
    isTopLevel: bool = false,
    contents: ArrayList(BagCount),
    //contentsOf: ArrayList([]const u8),

    pub fn init(allocator: *Allocator, name: []const u8) Self {
        return Self{
            .name = name,
            .isTopLevel = false,
            .contents = ArrayList(BagCount).init(allocator),
            //.contentsOf = ArrayList([]const u8).init(allocator),
        };
    }
};

fn getKnownBag(knownBags: *ArrayList(Bag), bagName: []const u8) ?*Bag {
    for(knownBags.items) |bag, index| {
        if (std.mem.eql(u8, bagName, bag.name)) return &knownBags.items[index];
    }

    return null;
}

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // var allocator = &arena.allocator;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer gpa.deinit();
    var allocator = &gpa.allocator;

    var known_bags = ArrayList(Bag).init(allocator);
    defer known_bags.deinit();

    //var bag_name: u8 = ;

    //var abag = try test_allocator.alloc(Bag, @sizeOf(Bag));
    // try known_bags.append(Bag{.name = "test bag"});

    var input_iter = std.mem.split(input, "\n");
    while(input_iter.next()) |raw_line| {
        if (raw_line.len == 0) continue;
        //per line logic
        // remove '.' last char
        var line = raw_line[0..raw_line.len-1];
        //std.debug.print("line: {}\n", .{line});

        var line_iter = std.mem.split(line, " bags contain ");
        var parent_bag: []const u8 = line_iter.next().?;
        //std.debug.print("parent_bag: {}\n", .{parent_bag});
        var bag_contents_iter = std.mem.split(line_iter.next().?, ", ");

        var current_bag: *Bag = undefined;
        var bag_check: ?*Bag = getKnownBag(&known_bags, parent_bag);
        //var bag_counts: ArrayList(BagCount) = undefined;

        if(bag_check == null) {
            var new_bag = Bag.init(allocator, parent_bag);//{ .name = parent_bag, .contents = ArrayList(BagCount).init(allocator)};
            try known_bags.append(new_bag);
            bag_check = getKnownBag(&known_bags, parent_bag);//new_bag;//known_bags.items[known_bags.items.len];
            std.debug.print("new_bag: {*};\n", .{&new_bag});
        }
        
        current_bag = bag_check.?;
        std.debug.print("current_bag: {*};\n", .{current_bag});

        current_bag.isTopLevel = true;

        while(bag_contents_iter.next()) |bag_content| {
            if(std.mem.eql(u8, "no ", bag_content[0..3])) break;

            var endOfNum: usize = 0;
            var endOfBagName: usize = 0;
            var hitBagSpace: bool = false;
            for(bag_content) |c, index| {
                if(c == ' ') {
                    if(endOfNum == 0) {
                        endOfNum = index;
                    }
                    else if(!hitBagSpace) {
                        hitBagSpace = true;
                    }
                    else{
                        endOfBagName = index;
                        break;
                    }
                }
            }
            var count = try std.fmt.parseUnsigned(u32, bag_content[0..endOfNum], 10);
            var bag_name = bag_content[endOfNum+1..endOfBagName];

            std.debug.print("parent_bag: {}; count: {}; bag_name: '{}';\n", .{parent_bag, count, bag_name});
            // // var bag_content_iter = std.mem.split(bag_content, " ");
            // //std.fmt.parseUnsigned(u32, value[0..value.len-2], 10)
            // var current_content_bag: *Bag = undefined;
            // var content_bag_check = getKnownBag(&known_bags, bag_name);
            // if(content_bag_check == null) {
            //     std.debug.print("append unknown bag: {}\n", .{bag_name});
            //     try known_bags.append(Bag.init(allocator, bag_name));
            //     content_bag_check = getKnownBag(&known_bags, bag_name);//new_content_bag;//known_bags.items[known_bags.items.len];
            //     // = &new_content_bag;
            // }

            // current_content_bag = content_bag_check.?;
            // std.debug.print("current_bag: {};\n", .{current_bag});
            // std.debug.print("current_content_bag: {*};\n", .{current_content_bag});


            //try current_content_bag.contentsOf.append(current_bag.name);
            std.debug.print("append countents; parent: {}; child: {};\n", .{current_bag.name, bag_name});
            try current_bag.contents.append(BagCount{.name = bag_name, .count = count});
            std.debug.print("test: {}\n", .{current_bag.contents.items[current_bag.contents.items.len-1].name});
        }

        std.debug.print("LOOP LOOK\n\n{}\n\n", .{current_bag.name});
        // std.debug.print("count: {}\n", .{current_bag.contents.items.len});
        // std.debug.print("test: {}\n", .{current_bag.contents.items[0].name});
        // std.debug.print("test: {}\n", .{current_bag.contents.items[current_bag.contents.items.len-1].name});
        // //printBags(&known_bags);
        // for(known_bags.items) |bag| {
        //     std.debug.print("bag: {{ name: '{}', isTopLevel: {} }}\n", .{bag.name, bag.isTopLevel});
        //     for(bag.contents.items) |content_bags| {
        //         std.debug.print("  - count: {}, content_bag_name: '{}'\n", .{content_bags.count, content_bags.name});
        //     }
        // }
    }

    std.debug.print("\n\nFINAL LOOP LOOK\n\n", .{});
    printBags(&known_bags);

    var shiny_gold_bag = getKnownBag(&known_bags, "shiny gold").?;
    var valid_parents = ArrayList([]const u8).init(allocator);
    //getValidParents(shiny_gold_bag, &valid_parents, &known_bags, 0);
    // for(valid_parents.items) |parent| {
    //     std.debug.print("Valid Parent: {}\n", .{parent.name});
    // }
    std.debug.print("Valid Parents Count: {}\n", .{valid_parents.items.len});

    
    var childCount = getChildCount(shiny_gold_bag, &known_bags, 1) - 1;
    std.debug.print("Bag Count: {}\n", .{childCount});
}

fn printBags(bags: *ArrayList(Bag)) void {
    for(bags.items) |bag| {
        std.debug.print("bag:\n  name: '{}'\n", .{bag.name});
        std.debug.print("  contents:\n", .{});
        // for(bag.contents.items) |content_bags| {
        //     std.debug.print("    - count: {}\n      name: '{}'\n", .{content_bags.count, content_bags.name});
        // }
        var i: u8 = 0;
        while (i < bag.contents.items.len) : (i += 1) {
            std.debug.print("    - count: {}\n      name: '{}'\n", .{bag.contents.items[i].count, bag.contents.items[i].name});
        }
        // std.debug.print("  parents:\n", .{});
        // for(bag.contentsOf.items) |content_of_bags| {
        //     std.debug.print("    - name: {}\n", .{content_of_bags});
        // }
    }
}

// fn getValidParents(bag: *Bag, valid_parents: *ArrayList([]const u8), known_bags: *ArrayList(Bag), n: u32) void {
//     //std.debug.print("n: {}; valid_count: {}; bag: {}; parent_count: {};\n", .{n, valid_parents.items.len, bag.name, bag.contentsOf.items.len});
//     for(bag.contentsOf.items) |parent| {
//         //std.debug.print("loop {}\n", .{parent.isTopLevel});
//         //if(parent.isTopLevel) {
//             //std.debug.print("TOP\n", .{});
//         if (!doesBagExist(valid_parents, parent)) {
//             //std.debug.print("APPEND", .{});
//             valid_parents.append(parent) catch{
//                 std.debug.print("ERROR\n", .{});
//             };

//             var ptr_parent = getKnownBag(known_bags, parent).?;
//             getValidParents(ptr_parent, valid_parents, known_bags, n+1);
//         }
//         //}
//     }
// }

fn getChildCount(bag: *Bag, known_bags: *ArrayList(Bag), multiplier: u32) u32 {
    var count: u32 = 1;
    //if (bag.contents.items.len == 0) count = 1;
    std.debug.print("parent: {}; children: {};\n", .{bag.name, bag.contents.items.len});
    for(bag.contents.items) |child| {
        std.debug.print("parent: {}; count: {}; child: {}\n", .{bag.name, child.count, child.name});
        //if(parent.isTopLevel) {
            //std.debug.print("TOP\n", .{});
        //if (!doesBagExist(valid_parents, parent)) {
            //std.debug.print("APPEND", .{});
            // valid_parents.append(parent) catch{
            //     std.debug.print("ERROR\n", .{});
            // };

            var ptr_child = getKnownBag(known_bags, child.name).?;
            count += child.count * getChildCount(ptr_child, known_bags, 1);
        //}
        //}
    }

    return count;
}

fn doesBagExist(valid_parents: *ArrayList([]const u8), bag: []const u8) bool {
    for(valid_parents.items) |parent_bag, _| {
        //if (parent_bag == bag) return true;
        if(std.mem.eql(u8, parent_bag, bag)) return true;
    }

    return false;
}
