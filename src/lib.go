package main

import "C"
import (
	"sync"
)

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export AllWordFrom
func AllWordFrom(grid []C.int, n C.int, dico []interface{}) []string {

	ch := make(chan string)
	res := make([]string, 0)
	wg := new(sync.WaitGroup)
	wg.Add(1)

	go func(wg *sync.WaitGroup) {
		allWordFrom(grid, n, dico, ch)
		defer wg.Done()
	}(wg)

	for w := range ch {
		res = append(res, w)
	}

	wg.Wait()
	return res

}

func allWordFrom(grid []C.int, n C.int, dico []interface{}, ch chan string) {

	wg := new(sync.WaitGroup)
	wg.Add(int(n * n))
	for i := C.int(0); i < n; i++ {
		for j := C.int(0); j < n; j++ {

			go func(wg *sync.WaitGroup, ch chan string, i C.int, j C.int, n C.int, grid []C.int, dico []interface{}) {
				allWordStartingFrom("",
					[3]C.int{i, j, n}, grid, make([]bool, n*n), dico, ch)
				defer wg.Done()
			}(wg, ch, i, j, n, grid, dico)
		}
	}

	wg.Wait()
	close(ch)

}

func allWordStartingFrom(word string, vector [3]C.int, grid []C.int,
	used []bool, dico []interface{}, ch chan string) {
	i, j, n := vector[0], vector[1], vector[2]
	wordLen := len(word)
	child, ok := dico[1].([]interface{})
	wg := new(sync.WaitGroup)

	if wordLen > 16 || !ok {
		return
	}

	handleWord(wordLen, word, child, ch)

	for x := C.int(-1); x < 2; x++ {
		for y := C.int(-1); y < 2; y++ {
			target := (i+x)*n + (j + y)
			if (x == 0 && y == 0) || notUsable(target, n) || used[target] {
				continue
			}
			used[target] = true
			vector[0], vector[1] = i+x, j+y
			wg.Add(1)
			word += string(grid[target])
			go func(wg *sync.WaitGroup, used []bool, child []interface{}, vector [3]C.int, word string, ch chan string) {
				allWordStartingFrom(word, vector, grid, used, child, ch)
				defer wg.Done()
			}(wg, used, child, vector, word, ch)
			word = word[:wordLen]
			used[target] = false

		}
	}
	wg.Wait()

}

func handleWord(wordLen int, word string, child []interface{}, ch chan string) {
	if wordLen > 2 {

		lastLetter := C.int(word[wordLen-1])
		for _, el := range child {
			if l, ok := el.(C.int); ok && l&lastLetter == lastLetter && (l&1<<9) > 0 {
				ch <- word
				break
			}
			if l, ok := el.([]interface{})[0].(C.int); ok && l&lastLetter == lastLetter && (l&1<<9) > 0 {
				ch <- word
				break
			}
		}
	}
}

func notUsable(target C.int, n C.int) bool {
	return target < 0 || target > n*n-1
}

//export enforce_binding
func enforce_binding() {}

func main() {}
