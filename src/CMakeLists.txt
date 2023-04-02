
add_library(readsb_base STATIC
  argp.c
  anet.c
  interactive.c
  mode_ac.c
  mode_s.c
  comm_b.c
  json_out.c
  net_io.c
  crc.c
  demod_2400.c
  stats.c
  cpr.c
  icao_filter.c
  track.c
  util.c
  fasthash.c
  convert.c
  sdr_ifile.c
  sdr_beast.c
  sdr.c
  ais_charset.c
  globe_index.c
  geomag.c
  receiver.c
  aircraft.c
  api.c
  threadpool.c
)
SET(EXTRA_SOURCES
  cprtests.c
  feature_test.c
  hello.c
  sdr_bladerf.c
  sdr_plutosdr.c
  sdr_ubladerf.c
)

if(RTLSDR)
  add_compile_definitions(ENABLE_RTLSDR)
  add_library(rtlsdr sdr_rtlsdr.c)
  if(HAVE_BIASTEE STREQUAL "yes")
    add_compile_definitions(ENABLE_RTLSDR_BIASTEE)
  endif()
  if(RTLSDR_PREFIX)
    include_directories(${RTLSDR_PREFIX}/include)
    link_directories(${RTLSDR_PREFIX/lib})
  else()
    include_directories(PUBLIC ${LibRTLSDR_INCLUDE_DIRS})
    target_link_libraries(readsb_base ${LibRTLSDR_LIBRARY})
  endif()
  if(RTLSDR_STATIC STREQUAL "yes")
    target_compile_definitions(rtlsdr
      -Wl,-Bstatic -lrtlsdr
      -Wl,-Bdynamic -lusb-1.0
    )
  endif()

  target_link_libraries(readsb_base
    rtlsdr
    usb-1.0
  )
endif()

if(BLADERF STREQUAL "yes")
  add_compile_definitions(ENABLE_BLADERF)
  add_library(bladerf sdr_bladerf.c sdr_ubladerf.c)
  target_link_libraries(readsb_base libbladeRF bladerf)
endif()

if(PLUTOSDR STREQUAL "yes")
  add_compile_definitions(ENABLE_PLUTOSDR)
  add_library(plutosdr sdr_plutosdr.c)
  target_link_libraries(readsb_base libiio libad9361 plutosdr)
endif()

if(UNIX)
target_link_libraries(readsb m)
endif()

# target_compile_definitions was only added with CMake 2.8.11
if(THREADS_HAVE_PTHREAD_ARG)
    set_target_properties(readsb_base PROPERTIES COMPILE_OPTIONS "-pthread")
    set_target_properties(readsb_base PROPERTIES INTERFACE_COMPILE_OPTIONS "-pthread")
endif()
if(CMAKE_THREAD_LIBS_INIT)
    target_link_libraries(readsb_base "${CMAKE_THREAD_LIBS_INIT}")
endif()

