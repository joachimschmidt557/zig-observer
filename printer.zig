const std = @import("std");
const Allocator = std.mem.Allocator;

const Counter = @import("counter.zig").Counter;
const Observer = @import("observer.zig").Observer;

/// An observer of a counter which prints the value of the counter when a
/// notification arrives
pub const Printer = struct {
    allocator: *Allocator,
    counter: *Counter,
    observer: Observer,

    const Self = @This();

    pub fn create(ctr: *Counter, alloc: *Allocator) !*Self {
        var self = try alloc.create(Self);
        self.* = Self{
            .allocator = alloc,
            .counter = ctr,
            .observer = Observer{ .update = Self.update },
        };

        try self.counter.changed.attach(&self.observer);

        return self;
    }

    pub fn destroy(self: *Self) void {
        const alloc = self.allocator;
        self.counter.changed.detach(&self.observer);
        alloc.destroy(self);
    }

    pub fn print(self: Self) void {
        std.debug.warn("value: {}\n", .{self.counter.count});
    }

    fn update(observer: *const Observer) void {
        const self = @fieldParentPtr(Printer, "observer", observer);
        self.print();
    }
};
