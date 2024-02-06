package main

import (
	"C"
	"sync"
	"utils"
)

const (
	n = 4
)

//export AllWordFrom
func AllWordFrom(Grid []C.int, dico []interface{}) []string {

	ch := make(chan string)
	res := make([]string, 0)
	wg := new(sync.WaitGroup)
	wg.Add(1)
	go func(wg *sync.WaitGroup) {
		defer wg.Done()
		awig(Grid, dico, ch)
	}(wg)

	for v := range ch {
		if !utils.Contain(res, v) && v != "" {
			res = append(res, v)
		}
	}

	wg.Wait()

	return res
}

func awig(Grid []rune, dico []interface{}, ch chan string) {

	wg := new(sync.WaitGroup)
	for i := range Grid {
		for j := range Grid {
			used := []bool{}
			wg.Add(1)
			go func(wg *sync.WaitGroup, i, j int) {
				defer wg.Done()

				aawfp(
					ch,

					Grid,
					dico,
					"",
					i, j, used)
			}(wg, i, j)
		}
	}

	wg.Wait()

	close(ch)
	return
}

func aawfp(res chan string,
	G []rune,
	dico []interface{},
	word string, i, j int,
	used []bool,
) {

	if CheckWord(word, dico) {
		if len(word) != 0 {
			res <- word
		}
	}

	if !cpal(i, j, used) || !CanCreateWord(word, dico) {

		return
	}

	for _, a := range []int{-1, 0, 1} {
		for _, b := range []int{-1, 0, 1} {
			possitive := (i+a >= 0 && j+b >= 0)
			notOutOfRange := (i+a < 4 && j+b < 4)
			if possitive && notOutOfRange && !used[(i+a)*n+j+b] {
				used[(i+a)*n+j+b] = true
				word += string(G[(i+a)*n+j+b])

				aawfp(res, G, dico, word, i+a, j+b, used)
				word = word[:len(word)-1]
				used[(i+a)*n+j+b] = false
			}
		}
	}

}

func cpal(i int, j int, used []bool) bool {
	possible := false
	for _, a := range []int{-1, 0, 1} {
		for _, b := range []int{-1, 0, 1} {
			if i+a >= 0 && j+b >= 0 && i+a < n && j+b < n {
				possible = possible || !used[(i+a)*n+j+b]
			}
		}
	}
	return possible
}

func CheckWord(word string, dico []interface{}) bool {

	return true
}

func CanCreateWord(word string, dico []interface{}) bool {

	return true
}







//export enforce_binding
func enforce_binding() {}

func main() {}