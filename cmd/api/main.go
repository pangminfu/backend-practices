package main

import (
	"context"
	"os"

	"backend-practices/internal/api"
	"backend-practices/internal/api/config"
	"backend-practices/pkg/configenv"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	mainCtx, mainCancel := context.WithCancel(context.Background())

	// Load config
	cfg, err := configenv.Load[config.Config](mainCtx, "config/api")
	if err != nil {
		log.Fatal().Err(err).Msg("load config failed")
	}

	logger := zerolog.New(os.Stdout).With().Timestamp().Logger()

	api.New(cfg, &logger)

	mainCancel()
}
