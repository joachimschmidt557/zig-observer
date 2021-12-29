const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const Observer = @import("observer.zig").Observer;

/// Framework for Observable structs
///
/// For observable structs: Embed this in your struct and use the init and
/// deinit functions. Call notify whenever the observers should be notified of
/// some change
///
/// For observers: Use attach to subscribe to notifications. Don't forget to
/// detach when the memory of the observer becomes invalid.
pub const Observable = struct {
    observers: ArrayList(*const Observer),

    const Self = @This();

    pub fn init(allocator: Allocator) Self {
        return Self{
            .observers = ArrayList(*const Observer).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.observers.deinit();
    }

    pub fn attach(self: *Self, obs: *const Observer) !void {
        try self.observers.append(obs);
    }

    pub fn detach(self: *Self, obs: *const Observer) void {
        if (std.mem.indexOfScalar(*const Observer, self.observers.items, obs)) |index| {
            _ = self.observers.swapRemove(index);
        }
    }

    pub fn notify(self: Self) void {
        for (self.observers.items) |obs| {
            obs.update(obs);
        }
    }
};
