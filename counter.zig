const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Observable = @import("observable.zig").Observable;

/// A simple incrementable counter which notifies observers whenever the count
/// is incremented
pub const Counter = struct {
    count: i64,
    changed: Observable,

    const Self = @This();

    pub fn init(allocator: *Allocator) Self {
        return Self{
            .count = 0,
            .changed = Observable.init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.changed.deinit();
    }

    pub fn incr(self: *Self) void {
        self.count += 1;
        self.changed.notify();
    }
};
