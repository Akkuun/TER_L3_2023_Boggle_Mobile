package utils

func Contain[T comparable](slice []T, target T) bool {

	for _, e := range slice {
		if e == target {
			return true
		}
	}

	return false
}
