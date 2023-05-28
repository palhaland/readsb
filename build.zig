const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const flags = [_][]const u8{
        "-Wall",
        "-Wextra",
        "-Werror=return-type",
        "-Wno-implicit-function-declaration",
        "-fno-common",
        "-O2",
        "-fstack-protector-strong",
    };
    const cflags = flags ++ [_][]const u8{
        "-std=c11",
        "-D_GNU_SOURCE",
        "-D_DEFAULT_SOURCE",
        "-DENABLE_RTLSDR",
    };
    const exe = b.addExecutable("readsb", null);
    exe.linkSystemLibrary("pthread");
    exe.linkSystemLibrary("curses");
    exe.linkSystemLibrary("zlib");
    exe.linkSystemLibrary("zstd");
    exe.linkSystemLibrary("rtlsdr");
    exe.addCSourceFile("aircraft.c", &cflags);
    exe.addCSourceFile("ais_charset.c", &cflags);
    exe.addCSourceFile("anet.c", &cflags);
    exe.addCSourceFile("api.c", &cflags);
    exe.addCSourceFile("argp.c", &cflags);
    exe.addCSourceFile("comm_b.c", &cflags);
    exe.addCSourceFile("convert.c", &cflags);
    exe.addCSourceFile("cpr.c", &cflags);
    exe.addCSourceFile("crc.c", &cflags);
    exe.addCSourceFile("demod_2400.c", &cflags);
    exe.addCSourceFile("fasthash.c", &cflags);
    exe.addCSourceFile("feature_test.c", &cflags);
    exe.addCSourceFile("geomag.c", &cflags);
    exe.addCSourceFile("globe_index.c", &cflags);
    exe.addCSourceFile("icao_filter.c", &cflags);
    exe.addCSourceFile("interactive.c", &cflags);
    exe.addCSourceFile("json_out.c", &cflags);
    exe.addCSourceFile("mode_ac.c", &cflags);
    exe.addCSourceFile("mode_s.c", &cflags);
    exe.addCSourceFile("net_io.c", &cflags);
    exe.addCSourceFile("receiver.c", &cflags);
    exe.addCSourceFile("sdr.c", &cflags);
    exe.addCSourceFile("sdr_ifile.c", &cflags);
    exe.addCSourceFile("uat2esnt/uat2esnt.c", &cflags);
    exe.addCSourceFile("uat2esnt/uat_decode.c", &cflags);
    exe.addCSourceFile("minilzo/minilzo.c", &cflags);
    exe.addCSourceFile("sdr_beast.c", &cflags);
    //    exe.addCSourceFile("sdr_plutosdr.c", &cflags);
    //    exe.addCSourceFile("sdr_bladerf.c", &cflags);
    //    exe.addCSourceFile("sdr_ubladerf.c", &cflags);
    exe.addCSourceFile("sdr_rtlsdr.c", &cflags);
    exe.addCSourceFile("stats.c", &cflags);
    exe.addCSourceFile("threadpool.c", &cflags);
    exe.addCSourceFile("track.c", &cflags);
    exe.addCSourceFile("util.c", &cflags);
    exe.addCSourceFile("readsb.c", &cflags);
    //exe.addCSourceFile("hello.c", &cflags);
    //exe.addCSourceFile("cprtests.c", &cflags);
    exe.addIncludePath("./minilzo");
    exe.addIncludePath("./uat2esnt");
    exe.linkLibC();
    exe.install();
}
