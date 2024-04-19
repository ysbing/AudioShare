cmake_minimum_required(VERSION 3.16)

project(AudioShare VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Multimedia Network)

qt_standard_project_setup(REQUIRES 6.5)

set(MY_SRC_DIR "${PROJECT_SOURCE_DIR}/client")

file(GLOB_RECURSE MY_CPP_LIST
    ${MY_SRC_DIR}/*.cpp
    ${MY_SRC_DIR}/*.cc
    ${MY_SRC_DIR}/*.c
    ${MY_SRC_DIR}/*.mm
    ${MY_SRC_DIR}/*.h
    )

file(GLOB_RECURSE MY_RESOURCES_LIST LIST_DIRECTORIES false
    ${MY_SRC_DIR}/*.qrc
    )

set(PROJECT_SOURCES
    ${MY_CPP_LIST}
    ${MY_RESOURCES_LIST}
    )

qt_add_executable(AudioShare
    ${PROJECT_SOURCES}
)

qt_add_qml_module(AudioShare
    URI AudioShare
    VERSION 1.0
    QML_FILES client/Main.qml
)

set_target_properties(AudioShare PROPERTIES
    OUTPUT_NAME "AudioShare"
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(AudioShare
    PRIVATE Qt6::Quick
    Qt6::Multimedia
)

install(TARGETS AudioShare
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

#QT链接库复制到构建目录
get_target_property(_qmake_executable Qt6::qmake IMPORTED_LOCATION)
get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
find_program(DEPLOYQT_EXECUTABLE NAMES windeployqt macdeployqt HINTS "${_qt_bin_dir}")
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${DEPLOYQT_EXECUTABLE} "$<TARGET_FILE:${PROJECT_NAME}>"
    --$<LOWER_CASE:$<CONFIG>> --qmldir ${CMAKE_SOURCE_DIR}
)

#复制ADB等相关文件到构建目录
add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${MY_SRC_DIR}/utils"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>)
