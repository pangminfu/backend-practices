package configenv

type LoadConfigError struct {
	Err error
}

func (e *LoadConfigError) Error() string {
	return e.Err.Error()
}
