/// Framework for observer structs
///
/// Embed this struct in your struct of choice to provide it with observer
/// capabilites. update gets called whenever observers are notified. Use a
/// suitable function for update which accesses the parent struct through
/// @fieldParentPtr. Always make sure that the parent struct exists in memory,
/// otherwise a notification will try to access invalid memory regions. This
/// implementation ensures this by placing all Observer structs in heap memory
/// only.
pub const Observer = struct {
    update: fn (self: *const Self) void,

    const Self = @This();
};
