cmake_minimum_required(VERSION 3.20)
include(CMakeDependentOption)
project(readsb)

set(LIBS "-pthread -lpthread -lm -lrt -lzst")


SET(READSB_VERSION "Apekatten")

option(ENABLE_RTLSDR "Do you want to enable RTLSDR?" OFF)
cmake_dependent_option(HAVE_BIASTEE "Would you enable BIASTEE?" ON "ENABLE_RTLSDR" OFF)
option(ENABLE_BLADERF "Do you want to enable BLADERF?" OFF)
option(ENABLE_PLUTOSDR "Do you want to enable PLUTOSDR?" OFF)
option(TRACK_UUID "Track UUID" OFF)
option(PRINT_UUID "Print UUID" OFF)

set(DIALECT "-std=c11")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${DIALECT} -W -D_GNU_SOURCE -D_DEFAULT_SOURCE \
-Wall -Werror -fno-common -O2 -Wdate-time -D_FORTIFY_SOURCE=2 -fstack-protector-strong \
-Wformat -Werror=format-security -DMODES_READSB_VERSION=\"${READSB_VERSION}\" \
${LIBS}"
)
	


set(SOURCES
	src/readsb.c
	src/argp.c
	src/anet.c
	src/interactive.c
	src/mode_ac.c
	src/mode_s.c
	src/comm_b.c
	src/json_out.c
	src/net_io.c
	src/crc.c
	src/demod_2400.c
	extras/uat2esnt/uat2esnt.c
	extras/uat2esnt/uat_decode.c
	src/stats.c
	src/cpr.c
	src/icao_filter.c
	src/track.c
	src/util.c
	src/fasthash.c
	src/convert.c
	src/sdr_ifile.c
	src/sdr_beast.c
	src/ais_charset.c
	src/globe_index.c
	src/geomag.c
	src/receiver.c
	src/aircraft.c
	src/api.c
	src/threadpool.c
)
SET(EXTRA_SOURCES
	src/cprtests.c
	src/feature_test.c
	src/hello.c
	src/sdr_bladerf.c
	src/sdr.c
	src/sdr_plutosdr.c
	src/sdr_rtlsdr.c
	src/sdr_ubladerf.c
)

add_library(minilzo STATIC extras/minilzo/minilzo.c extras/minilzo/minilzo.h)

add_executable(readsb 
				src/readsb.c
				${SOURCES}
)
target_link_libraries(readsb minilzo)
target_include_directories(readsb
	PUBLIC inc
	PUBLIC extras
)

