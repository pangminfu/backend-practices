package repository

import (
	"context"

	"backend-practices/internal/domain/todo"
)

type TodoRepo interface {
	Create(ctx context.Context, todo *todo.Todo) error
	CreteItems(ctx context.Context, item []*todo.Item) error
}
