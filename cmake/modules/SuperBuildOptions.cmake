option(SB_GITHUB_RW_ACCESS "Use read/write address for github repository. Requires a registered user with a valid SSH Key" FALSE)
if(SB_GITHUB_RW_ACCESS)
    set(SB_GITHUB_GIT_URL "ssh://git@github.com/")
else()
   set(SB_GITHUB_GIT_URL "git://github.com/")
endif()
mark_as_advanced(SB_GITHUB_RW_ACCESS)

set(SB_YARP_GIT_URL "${SB_GITHUB_GIT_URL}robotology/yarp.git")
set(SB_YARP_GIT_TAG "yarp-2.4" CACHE STRING "YARP git branch/tag/commit to use.")
mark_as_advanced(SB_YARP_GIT_TAG)

set(SB_ICUB_SVN_BASE_URL "svn://svn.code.sf.net/p/robotcub/code/" CACHE INTERNAL "Base SVN url for iCub project.")
set(SB_ICUB_SVN_TAG "trunk" CACHE STRING "iCub SVN branch/tag to use.")
set(SB_ICUB_SVN_URL "${SB_ICUB_SVN_BASE_URL}${SB_ICUB_SVN_TAG}" CACHE INTERNAL "SVN url for iCub project.")
mark_as_advanced(SB_ICUB_SVN_TAG)

set(SB_GIT_URL ${GITHUB_GIT_URL} CACHE STRING "The default git url to use for cloning git subprojects.")
set(SB_SVN_URL ${SB_ICUB_SVN_URL} CACHE STRING "The default svn url to use for cloning svn subprojects.")
mark_as_advanced(SB_GIT_URL SB_SVN_URL)
mark_as_advanced(SB_GIT_TAG)


set(SB_SRC_CLONE_DIR "${CMAKE_SOURCE_DIR}/src")
