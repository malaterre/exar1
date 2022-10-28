cmake_minimum_required(VERSION 3.14)
project(pro C)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(MyParser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
FLEX_TARGET(MyScanner lexer.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(pro2json
    pro2json.c
    ${BISON_MyParser_OUTPUTS}
    ${FLEX_MyScanner_OUTPUTS}
)

BISON_TARGET(MyParser2 parser2.y ${CMAKE_CURRENT_BINARY_DIR}/parser2.c)
FLEX_TARGET(MyScanner2 lexer2.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer2.c)
ADD_FLEX_BISON_DEPENDENCY(MyScanner2 MyParser2)

add_executable(asc2json
    asc2json.c
    ${BISON_MyParser2_OUTPUTS}
    ${FLEX_MyScanner2_OUTPUTS}
)

# https://begriffs.com/posts/2021-11-28-practical-parsing.html
BISON_TARGET(MyParser3 lisp.y ${CMAKE_CURRENT_BINARY_DIR}/lisp.tab.c)
FLEX_TARGET(MyScanner3 lisp.l  ${CMAKE_CURRENT_BINARY_DIR}/lisp.lex.c)
ADD_FLEX_BISON_DEPENDENCY(MyScanner3 MyParser3)

add_executable(driver_lisp
    driver_lisp.c
    ${BISON_MyParser3_OUTPUTS}
    ${FLEX_MyScanner3_OUTPUTS}
)
