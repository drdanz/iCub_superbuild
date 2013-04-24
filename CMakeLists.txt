cmake_minimum_required(VERSION 2.8.4)
project(iCub)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

#include(iCubHelpers)
include(iCubSuperBuild)


# TinyXML
sb_add_project(TinyXML
               URL https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz/download
#               GIT_REPOSITORY git://tinyxml.git.sourceforge.net/gitroot/tinyxml/tinyxml
               PATCH_COMMAND #patch -p1 -N -t -l < ${CMAKE_SOURCE_DIR}/patches/TinyXML/0001-Add-CMake-stuff.patch &&
                             cp -v ${CMAKE_SOURCE_DIR}/patches/TinyXML/CMakeLists.txt ${SB_SRC_CLONE_DIR}/TinyXML/ &&
                             cp -v ${CMAKE_SOURCE_DIR}/patches/TinyXML/TinyXMLConfig.cmake.in ${SB_SRC_CLONE_DIR}/TinyXML/ &&
                             patch -p1 -N -t -l < ${CMAKE_SOURCE_DIR}/patches/TinyXML/0001-Return-TIXML_WRONG_TYPE-for-negative-values-in-Query.patch &&
                             patch -p1 -N -t -l < ${CMAKE_SOURCE_DIR}/patches/TinyXML/enforce-use-stl.patch &&
                             patch -p1 -N -t -l < ${CMAKE_SOURCE_DIR}/patches/TinyXML/entity-encoding.patch)


# GtkDatabox
set(SB_GIT_TAG_GtkDatabox GTK2)
sb_add_project(GtkDatabox
               GIT_REPOSITORY git://gtkdatabox.git.sourceforge.net/gitroot/gtkdatabox/gtkdatabox
               CONFIGURE_COMMAND ${SB_SRC_CLONE_DIR}/GtkDatabox/configure --prefix=${CMAKE_INSTALL_PREFIX}
               STEP_TARGETS prepare)

if(TARGET GtkDatabox)
    ExternalProject_Add_Step(GtkDatabox prepare
                             COMMAND autoreconf --install --verbose
                             WORKING_DIRECTORY ${SB_SRC_CLONE_DIR}/GtkDatabox
                             COMMENT "Performing prepare step (autoreconf) for 'GtkDatabox'"
                             DEPENDEES update
                             DEPENDERS configure)
endif(TARGET GtkDatabox)


# GtkDataboxMM
sb_add_project(GtkDataboxMM
               GIT_REPOSITORY git://git.code.sf.net/p/gtkdataboxmm/code
               CONFIGURE_COMMAND ${SB_SRC_CLONE_DIR}/GtkDataboxMM/configure --enable-maintainer-mode --prefix=${CMAKE_INSTALL_PREFIX}
               STEP_TARGETS prepare
               DEPENDS GtkDatabox)

if(TARGET GtkDataboxMM)
    ExternalProject_Add_Step(GtkDataboxMM prepare
                             COMMAND NOCONFIGURE=1 ${SB_SRC_CLONE_DIR}/GtkDataboxMM/autogen.sh
                             WORKING_DIRECTORY ${SB_SRC_CLONE_DIR}/GtkDataboxMM
                             COMMENT "Performing prepare step (autogen.sh) for 'GtkDataboxMM'"
                             DEPENDEES update
                             DEPENDERS configure)
endif(TARGET GtkDataboxMM)


# GooCanvas
set(SB_GIT_TAG_GooCanvas goocanvas-1.0)
sb_add_project(GooCanvas
               GIT_REPOSITORY git://git.gnome.org/goocanvas
               CONFIGURE_COMMAND ${SB_SRC_CLONE_DIR}/GooCanvas/configure --enable-maintainer-mode --prefix=${CMAKE_INSTALL_PREFIX}
               STEP_TARGETS prepare)

if(TARGET GooCanvas)
    ExternalProject_Add_Step(GooCanvas prepare
                             COMMAND NOCONFIGURE=1 ${SB_SRC_CLONE_DIR}/GooCanvas/autogen.sh
                             WORKING_DIRECTORY ${SB_SRC_CLONE_DIR}/GooCanvas
                             COMMENT "Performing prepare step (autogen.sh) for 'GooCanvas'"
                             DEPENDEES update
                             DEPENDERS configure)
endif(TARGET GooCanvas)

# GooCanvasMM
set(SB_GIT_TAG_GooCanvasMM goocanvasmm-1.0)
sb_add_project(GooCanvasMM
               GIT_REPOSITORY git://git.gnome.org/goocanvasmm
               CONFIGURE_COMMAND ${SB_SRC_CLONE_DIR}/GooCanvasMM/configure --enable-maintainer-mode --prefix=${CMAKE_INSTALL_PREFIX}
               STEP_TARGETS prepare
               DEPENDS GooCanvas)

if(TARGET GooCanvasMM)
    ExternalProject_Add_Step(GooCanvasMM prepare
                             COMMAND NOCONFIGURE=1 ${SB_SRC_CLONE_DIR}/GooCanvasMM/autogen.sh
                             WORKING_DIRECTORY ${SB_SRC_CLONE_DIR}/GooCanvasMM
                             COMMENT "Performing prepare step (autogen.sh) for 'GooCanvasMM'"
                             DEPENDEES update
                             DEPENDERS configure)
endif(TARGET GooCanvasMM)


# YARP
set(SB_GIT_TAG_YARP ${SB_YARP_GIT_TAG})
set(SB_CMAKE_ARGS_YARP -DCREATE_IDLS:BOOL=ON
                       -DCREATE_GUIS:BOOL=ON
                       -DCREATE_SHARED_LIBRARY:BOOL=ON
                       -DYARP_USE_SYSTEM_SQLITE:BOOL=ON
                       -DCREATE_LIB_MATH:BOOL=ON
                       -DYARP_USE_ATLAS:BOOL=ON
                       -DDOX_GENERATE_XML:BOOL=ON
                       -DCREATE_OPTIONAL_CARRIERS:BOOL=ON
                       -DENABLE_yarpcar_bayer_carrier:BOOL=ON
                       -DUSE_LIBDC1394:BOOL=OFF
                       -DENABLE_yarpcar_tcpros_carrier:BOOL=ON
                       -DENABLE_yarpcar_xmlrpc_carrier:BOOL=ON
                       -DENABLE_yarpcar_priority_carrier:BOOL=ON
                       -DENABLE_yarpidl_thrift:BOOL=ON
                       -DCREATE_DEVICE_LIBRARY_MODULES:BOOL=ON
                       -DENABLE_yarpcar_human_carrier:BOOL=ON
                       -DENABLE_yarpcar_mjpeg_carrier:BOOL=ON
                       -DENABLE_yarpcar_rossrv_carrier:BOOL=ON
                       -DENABLE_yarpmod_fakebot:BOOL=ON
                       -DENABLE_yarpmod_opencv_grabber:BOOL=ON
                       -DUSE_PORT_AUTHENTICATION:BOOL=ON
                       -DYARP_CLEAN_API:BOOL=ON
                       -DYARP_COMPILE_TESTS:BOOL=OFF
                       -DCREATE_GYARPBUILDER:BOOL=ON)
sb_add_project(YARP GIT_REPOSITORY ${SB_YARP_GIT_URL} DEPENDS GtkDataboxMM GooCanvasMM TinyXML)

# iCub/main
set(SB_CMAKE_ARGS_iCub -DENABLE_icubmod_icubheadcalibratorV2:BOOL=ON
                       -DENABLE_icubmod_fakecan:BOOL=ON)

sb_add_project(iCub SVN_REPOSITORY ${SB_ICUB_SVN_URL}/iCub/main DEPENDS YARP)
sb_add_project(robotInterface SVN_REPOSITORY ${SB_ICUB_SVN_URL}/iCub/main/src/core/robotInterface DEPENDS iCub TinyXML)

sb_add_project(lib0 SVN_REPOSITORY ${SB_ICUB_SVN_URL}/iCub/main/src/examples/lib0 DEPENDS iCub)
sb_add_project(lib1 SVN_REPOSITORY ${SB_ICUB_SVN_URL}/iCub/main/src/examples/lib1 DEPENDS lib1)


set(CPACK_PACKAGE_VERSION ${SB_PACKAGE_VERSION_NUMBER} )
set(CPACK_PACKAGE_NAME ${PROJECT_NAME} )
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)

include(CPack)
