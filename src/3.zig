const std = @import("std");
const pow = std.math.pow;

fn swap(a: *i128, b: *i128) void {
    var tmp: i128 = a.*;
    a.* = b.*;
    b.* = tmp;
}

test "Make sure swap works" {
    var a: i128 = 1;
    var b: i128 = 10;
    std.debug.assert(a == 1);
    std.debug.assert(b == 10);
    swap(&a, &b);
    std.debug.assert(a == 10);
    std.debug.assert(b == 1);
}

fn gcd(original_u: i128, original_v: i128) i128 {
    var u = original_u;
    var v = original_v;
    if (u == 0) {
        return v;
    }
    if (v == 0) {
        return u;
    }

    var i = @intCast(u6, @ctz(u));
    var j = @intCast(u6, @ctz(v));
    u >>= i;
    v >>= j;

    var k = @min(i, j);

    while (true) {
        if (u > v) {
            swap(&u, &v);
        }

        v -= u;

        if (v == 0) {
            return u << k;
        }

        v >>= @intCast(u6, @ctz(v));
    }
    return 1;
}

test "gcd" {
    std.debug.assert(gcd(5, 10) == 5);
    std.debug.assert(gcd(6, 9) == 3);
}

const Factor = struct {
    n: i128,
    done: bool,

    fn next(self: *Factor) ?i128 {
        if (self.done) {
            return null;
        }

        var x: i128 = 2;
        var y: i128 = 2;
        var d: i128 = 1;

        while (d == 1) {
            x = @mod((pow(i128, x, 2) + 1), self.n);
            y = @mod((pow(i128, y, 2) + 1), self.n);
            y = @mod((pow(i128, y, 2) + 1), self.n);

            d = gcd(std.math.absInt(x - y) catch unreachable, self.n);
        }
        if (d == self.n) {
            self.done = true;
            return d;
        } else {
            self.*.n = @divExact(self.n, d);
            return d;
        }
    }
};

test "Factor" {
    var f = Factor{ .n = 15, .done = false };
    var a = f.next();
    var b = f.next();
    std.debug.assert(a != null and a.? == 3);
    std.debug.assert(b != null and b.? == 5);
    std.debug.assert(f.next() == null);
}

pub fn main() void {
    var f = Factor{ .n = 600851475143, .done = false };
    var largest: i128 = 0;
    while (f.next()) |i| {
        largest = i;
    }
    std.debug.print("{d}\n", .{largest});
}
