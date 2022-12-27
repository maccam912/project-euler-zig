const std = @import("std");
const assert = std.debug.assert;

const Fib = struct {
    a: u64,
    b: u64,
    n: u64,

    fn init() Fib {
        return Fib{
            .a = 1,
            .b = 1,
            .n = 0,
        };
    }

    fn next(self: *Fib) ?u64 {
        if (self.n < 2) {
            self.*.n += 1;
            return 1;
        } else {
            var val = self.a + self.b;
            if (self.n % 2 == 0) {
                self.a = val;
            } else {
                self.b = val;
            }
            self.*.n += 1;
            return val;
        }
    }
};

fn problem2() usize {
    var sum: usize = 0;
    var fib = Fib.init();
    while (fib.next()) |i| {
        if (i > 4_000_000) {
            break;
        }
        if (i % 2 == 0) {
            sum += i;
        }
    }
    return sum;
}

pub fn main() void {
    std.debug.print("{}\n", .{comptime problem2()});
}

test "integer overflow at compile time" {
    var fib = Fib.init();
    assert(fib.next() == 1);
    assert(fib.next() == 1);
    assert(fib.next() == 2);
    assert(fib.next() == 3);
    assert(fib.next() == 5);
    assert(fib.next() == 8);
    assert(fib.next() == 13);
}
