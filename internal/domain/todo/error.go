package todo

type NotImplementedError struct{}

func (e *NotImplementedError) Error() string {
	return "not implemented"
}
