package main

/*
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
*/
import "C"

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export GetChar
func GetChar(v C.int) C.char {
	return C.char(v)
}

//export IsSameKey
func IsSameKey(ps *C.char, key C.int) bool {
	s := C.GoString(ps)
	return s[0] == byte(key)
}

//export EndOfWord
func EndOfWord(v C.int) bool {
	return (v & 0b100000000) != 0
}

//export enforce_binding
func enforce_binding() {}

func main() {}
