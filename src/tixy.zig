const std = @import("std");
const rl = @import("raylib");

const scale = 2;
const width = scale * 15;
const height = scale * 15;
const gap = scale * 1;

fn tixy(t: f64, i: i32, x: i32, y: i32) f64 {
    _ = x;
    _ = i;
    return @floatCast(
        std.math.sin(
            @as(f64, @floatFromInt(y)) / 8 + t,
        ),
    );
}

pub fn main() anyerror!void {
    const screen_width = 16 * width + 15 * gap;
    const screen_height = screen_width;

    rl.setConfigFlags(.{ .msaa_4x_hint = true });
    rl.initWindow(screen_width, screen_height, "tixy.zig");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        const t = rl.getTime();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        for (0..16) |y_usize| {
            for (0..16) |x_usize| {
                const y: i32 = @intCast(y_usize);
                const x: i32 = @intCast(x_usize);
                const i: i32 = y + 16 * x;

                const v = tixy(t, i, x, y);
                const r = @min(@abs(v), 1.0);
                const color: rl.Color = if (v >= 0) .white else .red;

                rl.drawCircle(
                    x * (width + gap) + (width / 2),
                    y * (width + gap) + (height / 2),
                    @floatCast(r * (width / 2)),
                    color,
                );
            }
        }
    }
}
