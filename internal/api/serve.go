package api

import (
	"backend-practices/internal/api/config"
	"backend-practices/pkg/configenv"

	"github.com/rs/zerolog"
)

type API struct {
	cfg    *configenv.Config[config.Config]
	logger *zerolog.Logger
}

func New(cfg *configenv.Config[config.Config], logger *zerolog.Logger) *API {
	return &API{
		cfg:    cfg,
		logger: logger,
	}
}
