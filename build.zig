const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const fs = std.fs;

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const problem = b.option(u16, "problem", "Which PE problem to run");
    var buf: [16]u8 = mem.zeroes([16]u8);

    if (problem == null) {
        std.debug.print("Please include e.g. `-Dproblem=1` to run code for PE problem 1.\n", .{});
        std.process.exit(1);
    }

    const filename: []const u8 = fmt.bufPrint(&buf, "{}.zig", .{problem.?}) catch unreachable;

    const problem_path = fs.path.join(
        b.allocator,
        &[_][]const u8{ "src", filename },
    ) catch unreachable;

    const exe = b.addExecutable("project-euler-zig", problem_path);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest(problem_path);
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
