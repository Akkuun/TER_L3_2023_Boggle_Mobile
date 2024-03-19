package main

//#include <string.h>
//#include <stdlib.h>
//#include <stdio.h>
import "C"
import (
	"errors"
	"sync"
	"unsafe"
)

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export GetAllWord
func GetAllWord(cgrid *C.char, cdico *C.void) **C.char {
	grid := C.GoString(cgrid)
	idico := interface{}(unsafe.Pointer(cdico))
	dico, ok := idico.([]interface{})
	if !ok {
		return nil
	}

	buf := make(chan string, 1024) //buffered channel to avoid deadlock

	resMap := make(map[string]bool)

	wg := new(sync.WaitGroup)

	wg.Add(1)
	go startAtAllPoint(buf, grid, dico, wg)

	var res **C.char = (**C.char)(C.malloc(C.size_t(len(resMap) * int(unsafe.Sizeof(uintptr(0))))))
	i := 0
	for k := range resMap {

		cstr := C.CString(k)
		**(**uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(res)) +
			uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(unsafe.Pointer(cstr))
		i++
	}

	wg.Wait()

	return res
}

//export FreeCStringArray
func FreeCStringArray(cstr **C.char, size C.int) {
	for i := 0; i < int(size); i++ {
		C.free(unsafe.Pointer(unsafe.Pointer(uintptr(unsafe.Pointer(cstr)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))))
	}
	C.free(unsafe.Pointer(cstr))
}

func startAtAllPoint(buf chan string, grid string, dico []interface{}, wg *sync.WaitGroup) {
	iwg := new(sync.WaitGroup)
	iwg.Add(16)

	for _, i := range [4]int{0, 1, 2, 3} {
		for _, j := range [4]int{0, 1, 2, 3} {

			go initPoint(buf, grid, iwg, i, j, dico,
				grid[i*4+j])
		}
	}

	iwg.Wait()
	close(buf)
	defer wg.Done()

}

func initPoint(buf chan string, grid string, iwg *sync.WaitGroup, i, j int, dico []interface{}, point byte) {
	defer iwg.Done()
	var used [4][4]bool
	used[i][j] = true
	children := dico[1].([]interface{})
	n, err := getChild(children, point)
	if err != nil { //if no children for this letter
		return
	}
	child := n.([]interface{})

	appendFromPoint(buf, grid, string(point), i, j, used, child)

}

var MOVE = [3]int{-1, 0, 1}

func appendFromPoint(res chan string, grid string, word string, i, j int, used [4][4]bool, node []interface{}) {

	if (node[0].(int32) & 0b100000000) > 0 {
		res <- word
	}
	if len(node) != 2 { //if no children -> leaf
		return
	}
	var ix, jy, index int

	children := node[1].([]interface{})

	for _, a := range MOVE {
		for _, b := range MOVE {
			ix = a + i
			jy = b + j
			index = ix*4 + jy
			if ix < 0 || jy < 0 || ix > 3 || jy > 3 { //out of range
				continue
			}
			if used[ix][jy] { // can't use the same letter twice
				continue
			}

			newLetter := grid[index]

			n, err := getChild(children, newLetter)
			if err != nil { //if no children for this letter
				continue
			}
			used[ix][jy] = true
			if child, ok := n.([]interface{}); !ok {
				appendFromPoint(res, grid, word+string(newLetter), ix, jy, used, []interface{}{n})
			} else {
				appendFromPoint(res, grid, word+string(newLetter), ix, jy, used, child)
			}
			used[ix][jy] = false

		}
	}
}

func getChild(children []interface{}, newLetter byte) (interface{}, error) {
	for _, n := range children {
		child, ok := n.([]interface{})

		if !ok && byte(n.(int32)) == newLetter { // if no children -> leaf
			return n, nil
		}

		if !ok {
			continue
		}

		if byte(child[0].(int32)) == newLetter { //with children
			return child, nil
		}

	}
	return nil, errors.New("not found")
}

//export enforce_binding
func enforce_binding() {}

func main() {}
