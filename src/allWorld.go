package main

import (
	"C"
	"sync"
	"utils"
)

const (
	n C.int = 4
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

func awig(Grid []C.int, dico []interface{}, ch chan string) {

	wg := new(sync.WaitGroup)
	for i := range Grid {
		for j := range Grid {
			used := []bool{}
			wg.Add(1)
			go func(wg *sync.WaitGroup, i, j C.int) {
				defer wg.Done()

				aawfp(
					ch,

					Grid,
					dico,
					"",
					C.int(i), C.int(j), used)
			}(wg, C.int(i), C.int(j))
		}
	}

	wg.Wait()

	close(ch)
	return
}

func aawfp(res chan string,
	G []C.int,
	dico []interface{},
	word string, i, j C.int,
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

	for _, a := range []C.int{-1, 0, 1} {
		for _, b := range []C.int{-1, 0, 1} {
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

func cpal(i C.int, j C.int, used []bool) bool {
	possible := false
	for _, a := range []C.int{-1, 0, 1} {
		for _, b := range []C.int{-1, 0, 1} {
			if i+a >= 0 && j+b >= 0 && i+a < n && j+b < n {
				possible = possible || !used[(i+a)*n+j+b]
			}
		}
	}
	return possible
}

func CheckWord(word string, dico []interface{}) bool {
	if dico == nil {
		return false
	}
	temp := dico
	var count C.int = C.int(len(word))
	for _, l := range word {
		count--
		if len(temp) > 1 {
			children, ok := temp[1].([]interface{})
			if !ok {
				return false
			}
			// the current node has children

			update := false
			for i := range children {
				if c, ok := children[i].(int); ok {
					//is a leaf
					if int8(c) == int8(l) {
						return count == 0 && (c&1<<9 > 0)
						//check if last letter of the word & if is completing a word
					}
				} else {
					if c, ok := children[i].([]interface{}); ok {
						if val, ok := c[0].(int); ok {
							if int8(val) == int8(l) {
								temp = c
								update = true
								break
							}
						}
					}

				}
			}
			if !update {
				return false
			}
		} else {
			return false // more letter than node for this word
		}
	}

	if val, ok := temp[0].(int); ok {
		return val&1<<9 > 0
	}
	return false
}

func CanCreateWord(word string, dico []interface{}) bool {

	return true
}

//export enforce_binding
func enforce_binding() {}

func main() {}
