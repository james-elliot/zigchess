const std = @import("std");
const utils = @import("utils.zig");
const board = @import("board.zig");

fn ab(
    alpha: utils.Vals,
    beta: utils.Vals,
    color: utils.Colors,
    depth: utils.Depth,
    hv: utils.Sigs,
) utils.Vals {
    if (hv == 0) return alpha + beta + color + depth else return alpha + beta + color + depth;
}
pub fn main() !void {
    var t = std.time.milliTimestamp();
    var ret = ab(1, -1, board.WHITE, 0, 0);
    t = std.time.milliTimestamp() - t;
    var t2: f64 = @intToFloat(f64, t) / 1000.0;
    try utils.stderr.print("SIZEX={} SIZEY={} ret={} time={d}s\n", .{ board.SIZE, board.PIECES, ret, t2 });
}
