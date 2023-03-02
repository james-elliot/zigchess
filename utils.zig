const std = @import("std");

pub var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa_alloc = gpa.allocator();
pub const stdout = std.io.getStdOut().writer();
pub const stderr = std.io.getStdErr().writer();

pub const Pieces = u8;
pub const Vals = i16;
pub const Vals_min: Vals = -32767;
pub const Vals_max: Vals = 32767;
pub const Depth = u8;
pub const Colors = i8;
pub const Sigs = u64;

pub const MAXDEPTH = 250;
