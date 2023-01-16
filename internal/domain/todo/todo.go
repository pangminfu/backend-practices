package todo

import (
	"time"

	"github.com/google/uuid"
)

type Todo struct {
	ID          int64
	User        uuid.UUID
	Title       string
	Description string
	Items       []*Item

	CompletedAt *time.Time

	CreatedAt time.Time
	UpdatedAt *time.Time
	DeletedAt *time.Time
}

type Item struct {
	ID          int64
	Description string

	CompletedAt *time.Time

	CreatedAt time.Time
	UpdatedAt *time.Time
}

type CreateReq struct {
	User        uuid.UUID
	Title       string
	Description string
	Items       []*Item
}

type ListReq struct {
	User uuid.UUID
}

type GetReq struct {
	User   uuid.UUID
	TodoID int64
}
