package configenv

import (
	"context"
	"fmt"
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config[BindConfigT any] struct {
	BindConfig BindConfigT
}

func Load[BindConfigT any](ctx context.Context, path string) (*Config[BindConfigT], error) {
	env := "local"
	if e := os.Getenv("APP_ENV"); e != "" {
		env = e
	}

	return loadWithEnv[BindConfigT](ctx, env, path)
}

func loadWithEnv[BindConfigT any](ctx context.Context, env, path string) (*Config[BindConfigT], error) {
	var cfg Config[BindConfigT]

	if err := cleanenv.ReadConfig(path+"/base.yaml", &cfg); err != nil {
		return nil, fmt.Errorf("read base config failed: %w", &LoadConfigError{Err: err})
	}

	if err := cleanenv.ReadConfig(fmt.Sprintf("%s/%s.yaml", path, env), &cfg); err != nil {
		return nil, fmt.Errorf("read %s config failed: %w", env, &LoadConfigError{Err: err})
	}

	return &cfg, nil
}
