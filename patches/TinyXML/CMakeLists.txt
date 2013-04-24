# Copyright (C) 2012, 2013  iCub Facility, Istituto Italiano di Tecnologia
# Author: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

cmake_minimum_required(VERSION 2.8.8)
project(tinyxml CXX)

set(TINYXML_MAJOR_VERSION 2)
set(TINYXML_MINOR_VERSION 6)
set(TINYXML_PATCH_VERSION 2)
set(TINYXML_VERSION ${TINYXML_MAJOR_VERSION}.${TINYXML_MINOR_VERSION}.${TINYXML_PATCH_VERSION})

# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR CMake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/cmake/TinyXML)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH "Installation directory for CMake files")

# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()




set(tinyxml_SRCS
    tinystr.cpp
    tinyxml.cpp
    tinyxmlerror.cpp
    tinyxmlparser.cpp
)

set(tinyxml_HDRS
    tinystr.h
    tinyxml.h
)




add_definitions("-DTIXML_USE_STL")

add_library(tinyxml SHARED ${tinyxml_SRCS})

set_target_properties(tinyxml PROPERTIES VERSION ${TINYXML_VERSION}
                                         SOVERSION ${TINYXML_VERSION}
                                         PUBLIC_HEADER "${tinyxml_HDRS}")

target_include_directories(tinyxml PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
                                          "$<INSTALL_INTERFACE:${INSTALL_INCLUDE_DIR}>")

install(TARGETS tinyxml
        EXPORT TinyXMLTargets
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
        PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}" COMPONENT dev)

include(CMakePackageConfigHelpers)

configure_package_config_file(TinyXMLConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/TinyXMLConfig.cmake
                              INSTALL_DESTINATION ${INSTALL_CMAKE_DIR}
                              PATH_VARS INSTALL_LIB_DIR
                                        INSTALL_BIN_DIR
                                        INSTALL_INCLUDE_DIR
                                        INSTALL_CMAKE_DIR)

write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/TinyXMLConfigVersion.cmake
                                 VERSION ${TINYXML_VERSION}
                                 COMPATIBILITY AnyNewerVersion)

install(EXPORT TinyXMLTargets
        NAMESPACE "TinyXML::"
        DESTINATION ${INSTALL_CMAKE_DIR})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/TinyXMLConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/TinyXMLConfigVersion.cmake
        DESTINATION ${INSTALL_CMAKE_DIR})
