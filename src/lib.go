package main

/*
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
*/
import "C"
import (
	"embed"
	"encoding/json"
	"errors"
	"log"
	"runtime"
	"sync"

	"unsafe"
)

//go:embed dictionary/*
var dico embed.FS

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export get_utf8_char
func get_utf8_char(v C.int ) C.char {
	return C.char(v);
}

//export end_of_word
func end_of_word(v C.int ) C.int {
	return (v&0b10000000) != 0
}



//export enforce_binding
func enforce_binding() {}

func main() {}
