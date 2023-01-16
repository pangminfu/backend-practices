package service

import (
	"backend-practices/internal/domain/todo"
	"context"
)

type TodoServicer interface {
	Create(ctx context.Context, req todo.CreateReq) error
	List(ctx context.Context, req todo.ListReq) ([]*todo.Todo, error)
	Get(ctx context.Context, req todo.GetReq) (*todo.Todo, error)
}
