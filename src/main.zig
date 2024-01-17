const std = @import("std");

const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
});

const process = std.process;

const chip8 = @import("chip8.zig");

var window: ?*sdl.SDL_Window = null;
var renderer: ?*sdl.SDL_Renderer = null;
var texture: ?*sdl.SDL_Texture = null;

pub fn init() !void {
    if (sdl.SDL_Init() < 0) {
        @panic("Sdl init failed");
    }

    window = sdl.SDL_CreateWindow("Chip-8", sdl.SDL_WINDOWPOS_CENTERED, sdl.SDL_WINDOWPOS_CENTERED, 1024, 512, 0);

    if (window == null) {
        @panic("Window creation failed");
    }

    renderer = sdl.SDL_CreateRenderer(window, -1, 0);

    if (renderer == null) {
        @panic("renderer creation failed");
    }

    texture = sdl.SDL_CreateTexture(renderer, sdl.SDL_PIXELFORMAT_RGBA8888, sdl.SDL_TEXTUREACCESS_STREAMING, 64, 32);

    if (texture == null) {
        @panic("Texture creation failed");
    }
}

pub fn deinit() void {
    sdl.SDL_DestroyWindow(window);
    sdl.SDL_Quit();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = allocator;

    init();
    defer deinit();

    var keep_open = true;

    while (keep_open) {
        var e: sdl.SDL_Event = undefined;

        while (sdl.SDL_PollEvent(&e) > 0) {
            switch (e.type) {
                sdl.SDL_Quit => keep_open = false,

                else => {},
            }
        }

        _ = sdl.SDL_RenderClear(renderer);
        _ = sdl.SDL_RenderCopy(renderer, texture, null, null);
        _ = sdl.SDL_RenderPresent(renderer);

        std.time.sleep(16 * std.math.pow(u64, 10, 6));
    }
}
