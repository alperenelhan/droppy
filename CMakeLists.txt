project (droppy)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

enable_testing ()

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/droppy")
set (GETTEXT_PACKAGE "droppy")
set (RELEASE_NAME "Fast and connected.")
set (VERSION "0.1")
set (VERSION_INFO "Release")
set (CMAKE_C_FLAGS "-ggdb")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gthread-2.0 gtk+-3.0 granite vte-2.90 libnotify gdk-x11-3.0 gee-1.0 x11)

add_definitions (${DEPS_CFLAGS})

link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.16.0" MINIMUM)

include (ValaPrecompile)
vala_precompile(VALA_C
    src/Settings.vala
    src/Droppy.vala
    src/DroppyWindow.vala
    src/TerminalWidget.vala
    src/ForegroundProcessDialog.vala
    src/config.vala
    src/KeybindingManager.vala
PACKAGES
    vte-2.90
    granite
    gtk+-3.0
    libnotify
    gdk-3.0
    posix
    x11
    gdk-x11-3.0
    gee-1.0
OPTIONS
    --thread
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
)

include (GSettings)
add_schema ("org.elementary.droppy.gschema.xml")

add_subdirectory (po)

add_executable (droppy ${VALA_C})
find_library (M_LIB m)
target_link_libraries (droppy ${M_LIB})

install (TARGETS droppy RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/droppy.desktop DESTINATION share/applications)
