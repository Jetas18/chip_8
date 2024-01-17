const std = @import("std");
const ray = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub fn init() !void {
    ray.InitWindow(800, 800, "Chip-8");
}

pub fn deinit() void {}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = allocator;

    init();
    defer deinit();
}
