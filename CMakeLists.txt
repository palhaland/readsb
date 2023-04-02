cmake_minimum_required(VERSION 3.20)
project(readsb C)
set(THREADS_PREFER_PTHREAD_FLAG ON)
include(CMakeDependentOption)
include(FindThreads)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMake/Modules)

include(FindLibRTLSDR)

########################################################################
# Get version info from Git
########################################################################
include(GetGitRevisionDescription)
get_git_head_revision(GIT_REFSPEC GIT_COMMIT)
if(GIT_COMMIT) # is a git repo
    # shorten branch spec
    string(REGEX REPLACE ".*/" "" GIT_BRANCH "${GIT_REFSPEC}")
    # use lightweight (non-annotated) tags
    git_describe(GIT_VERSION "--tags")
    git_timestamp(GIT_TIMESTAMP)
    message(STATUS "Found Git version: ${GIT_REFSPEC} commit ${GIT_COMMIT} from ${GIT_TIMESTAMP_ISO}")
    message(STATUS "Using Git version tag: ${GIT_VERSION} on ${GIT_BRANCH} at ${GIT_TIMESTAMP}")
    ADD_COMPILE_DEFINITIONS(MODES_READSB_VERSION="${GIT_VERSION}")
#    ADD_DEFINITIONS(-DGIT_BRANCH=${GIT_BRANCH})
#    ADD_DEFINITIONS(-DGIT_TIMESTAMP=${GIT_TIMESTAMP})
#    SET(READSB_VERSION )
endif()

option(RTLSDR "Do you want to enable RTLSDR?" OFF)
cmake_dependent_option(HAVE_BIASTEE "Would you enable BIASTEE?" ON "RTLSDR" OFF)
option(BLADERF "Do you want to enable BLADERF?" OFF)
option(PLUTOSDR "Do you want to enable PLUTOSDR?" OFF)
option(TRACK_UUID "Track UUID" OFF)
option(PRINT_UUID "Print UUID" OFF)

set(CMAKE_C_STANDARD 11)
add_definitions(-W)
add_definitions(-Wall)
add_definitions(-Werror)
add_definitions(-fno-common)
add_definitions(-O2)
add_definitions(-Wdate-time)
add_definitions(-fstack-protector-strong)
add_definitions(-Wformat)
add_definitions(-Werror=format-security)
add_definitions(-Wno-format-truncation)

add_compile_definitions(
  _GNU_SOURCE
  _DEFAULT_SOURCE
  _FORTIFY_SOURCE=2
)

include_directories(
  BEFORE ${PROJECT_SOURCE_DIR}/inc
  PUBLIC ${PROJECT_SOURCE_DIR}/extras
)

add_executable(readsb 
  src/readsb.c
)

add_subdirectory(inc)
add_subdirectory(src)
add_subdirectory(extras/minilzo)
add_subdirectory(extras/uat2esnt)

target_link_libraries(readsb
        readsb_base
        minilzo
        uat2esnt
        zstd
)

if(ZLIB_STATIC STREQUAL "yes")
  target_link_libraries(readsb :libz.a)
else()
  target_link_libraries(readsb z)
endif()

if(DISABLE_INTERACTIVE STREQUAL "yes")
  target_compile_definitions(readsb DISABLE_INTERACTIVE)
else()
  include(FindCurses)
  include_directories( PUBLIC ${CURSES_INCLUDE_DIRS} )
  target_link_libraries(readsb ${CURSES_LIBRARIES})
endif()

if(HISTORY STREQUAL "yes")
  target_compile_definitions(readsb ALL_JSON=1)
endif()

if(PREAMBLE_THRESHOLD_DEFAULT)
  target_compile_definitions(readsb PREAMBLE_THRESHOLD_DEFAULT=${PREAMBLE_THRESHOLD_DEFAULT})
endif()

if(GLOBE_PERM_IVAL)
  target_compile_definitions(readsb GLOBE_PERM_IVAL=${GLOBE_PERM_IVAL})
endif()

if(TRACE_THREADS)
  target_compile_definitions(readsb TRACE_THREADS=${TRACE_THREADS})
endif()

if(TRACE_RECENT_POINTS)
  target_compile_definitions(readsb TRACE_RECENT_POINTS=${TRACE_RECENT_POINTS})
endif()

if(AIRCRAFT_HASH_BITS)
  target_compile_definitions(readsb AIRCRAFT_HASH_BITS=${AIRCRAFT_HASH_BITS})
endif()

if(STATS_PHASE STREQUAL "yes")
  target_compile_definitions(readsb STATS_PHASE)
endif()

if(TRACKS_UUID STREQUAL "yes")
  target_compile_definitions(readsb TRACKS_UUID)
endif()

