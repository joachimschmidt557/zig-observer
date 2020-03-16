const std = @import("std");
const ArrayList = std.ArrayList;

const Counter = @import("counter.zig").Counter;
const Printer = @import("printer.zig").Printer;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Observable
    var ctr = Counter.init(allocator);
    defer ctr.deinit();

    // Observers
    var printers = ArrayList(*Printer).init(allocator);
    defer {
        for (printers.toSlice()) |x| x.deinit();
        printers.deinit();
    }

    const stdin = std.io.getStdIn();
    var stdin_stream = stdin.inStream();

    while (stdin_stream.readUntilDelimiterAlloc(allocator, '\n', 1024)) |line| {
        defer allocator.free(line);

        if (std.mem.eql(u8, "i", line)) {
            // Trigger an increment
            ctr.incr();
        } else if (std.mem.eql(u8, "a", line)) {
            // Add another observer
            try printers.append(try Printer.init(&ctr, allocator));
        } else if (std.mem.eql(u8, "d", line)) {
            // Remove an observer
            if (printers.len > 0) {
                printers.orderedRemove(0).deinit();
            }
        }
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
}
