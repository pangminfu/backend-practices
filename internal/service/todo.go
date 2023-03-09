package service

import (
	"context"
	"fmt"

	"backend-practices/internal/domain/todo"
	"backend-practices/internal/repository"
)

var _ TodoServicer = (*todoService)(nil)

type todoService struct {
	repo repository.TodoRepo
}

func NewTodo(repo repository.TodoRepo) *todoService {
	return &todoService{
		repo: repo,
	}
}

func (s *todoService) Create(ctx context.Context, req todo.CreateReq) error {
	td := &todo.Todo{
		User:        req.User,
		Title:       req.Title,
		Description: req.Description,
		Items:       req.Items,
	}

	if err := s.repo.Create(ctx, td); err != nil {
		return fmt.Errorf("todo Create(): %w", err)
	}

	if err := s.repo.CreteItems(ctx, td.Items); err != nil {
		return fmt.Errorf("todo CreateItems(): %w", err)
	}

	return nil
}

func (s *todoService) List(ctx context.Context, req todo.ListReq) ([]*todo.Todo, error) {
	return nil, fmt.Errorf("%w", &todo.NotImplementedError{})
}

func (s *todoService) Get(ctx context.Context, req todo.GetReq) (*todo.Todo, error) {
	return nil, fmt.Errorf("%w", &todo.NotImplementedError{})
}
