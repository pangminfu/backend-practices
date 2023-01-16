package repository

import (
	"backend-practices/internal/domain/todo"
	"context"
)

type TodoRepo interface {
	Create(ctx context.Context, todo *todo.Todo) error
	CreteItems(ctx context.Context, item []*todo.Item) error
}
