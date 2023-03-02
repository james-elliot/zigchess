const std = @import("std");
const utils = @import("utils.zig");

pub const NB_BITS: u8 = 30;
const HASH_SIZE: usize = 1 << NB_BITS;
const HASH_MASK: utils.Sigs = HASH_SIZE - 1;
const HashElem = packed struct { sig: utils.Sigs, v_inf: utils.Vals, v_sup: utils.Vals, d: utils.Depth };
const ZHASH = HashElem{ .sig = 0, .v_inf = Vals_min, .v_sup = Vals_max, .d = 0 };
var first_hash: Sigs = undefined;
var hashesw: [PIECES][SIZE]Sigs = undefined;
var hashesb: [PIECES][SIZE]Sigs = undefined;
var hashes: []HashElem = undefined;

pub fn retrieve(hv: Sigs, v_inf: *Vals, v_sup: *Vals) bool {
    const ind: usize = hv & HASH_MASK;
    if (hashes[ind].sig == hv) {
        v_inf.* = hashes[ind].v_inf;
        v_sup.* = hashes[ind].v_sup;
        return true;
    } else {
        return false;
    }
}

pub fn store(hv: Sigs, alpha: Vals, beta: Vals, g: Vals, depth: Depth) void {
    const ind = hv & HASH_MASK;
    const d = utils.MAXDEPTH + 2 - depth;
    if (hashes[ind].d <= d) {
        if (hashes[ind].sig != hv) {
            hashes[ind].d = d;
            hashes[ind].v_inf = Vals_min;
            hashes[ind].v_sup = Vals_max;
            hashes[ind].sig = hv;
        }
        if ((g > alpha) and (g < beta)) {
            hashes[ind].v_inf = g;
            hashes[ind].v_sup = g;
        } else if (g <= alpha) {
            hashes[ind].v_sup = @min(g, hashes[ind].v_sup);
        } else if (g >= beta) {
            hashes[ind].v_inf = @max(g, hashes[ind].v_inf);
        }
    }
}

pub fn init_hash()  {
    const heap_alloc = std.heap.page_allocator;
    const RndGen = std.rand.DefaultPrng;
    hashes = try heap_alloc.alloc(HashElem, HASH_SIZE);
    for (hashes) |*a| a.* = ZHASH;
    var rnd = RndGen.init(0);
    for (&hashesw) |*b| {
        for (b) |*a| a.* = rnd.random().int(Sigs);
    }
    for (&hashesb) |*b| {
        for (b) |*a| a.* = rnd.random().int(Sigs);
    }
    first_hash = rnd.random().int(Sigs);
}
