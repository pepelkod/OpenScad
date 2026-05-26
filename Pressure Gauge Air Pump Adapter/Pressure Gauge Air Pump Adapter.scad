include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// ── BSP Thread Parameters ──────────────────────────────
// Whitworth thread form: 55° included angle (27.5° half-angle)

// 1/8" BSPT
BSP_18_OD    = 9.73;
BSP_18_PITCH = 25.4 / 28;  // 28 TPI → 0.907mm

// 1/4" BSPT
BSP_14_OD    = 13.16;
BSP_14_PITCH = 25.4 / 19;  // 19 TPI → 1.337mm

// ── Modules ───────────────────────────────────────────

module bspt_1_8(length = 15) {
    threaded_rod(
        d            = BSP_18_OD,
        l            = length,
        pitch        = BSP_18_PITCH,
        $fn          = 64
    );
}

module bspt_1_4(length = 15) {
    threaded_rod(
        d            = BSP_14_OD,
        l            = length,
        pitch        = BSP_14_PITCH,
        $fn          = 64
    );
}

module trap_bspt_1_8(length = 15) {
    trapezoidal_threaded_rod(
        d            = BSP_18_OD,
        l            = length,
        pitch        = BSP_18_PITCH,
        thread_angle = 27.5,   // half of 55° Whitworth
        $fn          = 64
    );
}

module trap_bspt_1_4(length = 15) {
    trapezoidal_threaded_rod(
        d            = BSP_14_OD,
        l            = length,
        pitch        = BSP_14_PITCH,
        thread_angle = 27.5,   // half of 55° Whitworth
        $fn          = 64
    );
}

module trap_55_bspt_1_8(length = 15) {
    trapezoidal_threaded_rod(
        d            = BSP_18_OD,
        l            = length,
        pitch        = BSP_18_PITCH,
        thread_angle = 55,   // half of 55° Whitworth
        $fn          = 64
    );
}

module trap_55_bspt_1_4(length = 15) {
    trapezoidal_threaded_rod(
        d            = BSP_14_OD,
        l            = length,
        pitch        = BSP_14_PITCH,
        thread_angle = 55,   // half of 55° Whitworth
        $fn          = 64
    );
}

$fn=128;

// ── Preview both side by side ─────────────────────────
difference(){
    bspt_1_4();
    bspt_1_8(16);
}

translate([16,0,0]){
    difference(){
        trap_bspt_1_4();
        trap_bspt_1_8(16);
    }
}

translate([-16,0,0]){
    difference(){
        trap_55_bspt_1_4();
        trap_55_bspt_1_8(16);
    }
}

