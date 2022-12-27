const std = @import("std");

fn multipleOf(n: u32, comptime m: u32) bool {
    return n % m == 0;
}

fn problemOne() u32 {
    var sum: u32 = 0;
    var i: u32 = 0;
    while (i < 1000) : (i += 1) {
        if (multipleOf(i, 3) or multipleOf(i, 5)) {
            sum += i;
        }
    }
    return sum;
}

pub fn main() !void {
    @setEvalBranchQuota(10_000);
    var p1 = comptime problemOne();
    std.debug.print("{d}\n", .{p1});
}
