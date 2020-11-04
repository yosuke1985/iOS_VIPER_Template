# Todo

## UI

## Requirements

- Clean Architecture + Wireframe(Router)
- Swift 5
- iOS14
- RxSwift
- Firebase
- Firestore

## UML

## Clean Architecture

- Entity
  - Todo.swift

- Domain
  - Usecase
    - LoginUsecase.swift
    - TodoUsecase.swift
    - TodoUseCaseImpl.swift
  - DataInterface
    - TodoRepository.swift
    - LoginRepository.swift
  - PresenterInterface
    - LoginPresenter.swift
    - TodoListPresenter.swift
    - TodoDetailPresenter.swift

- RepositoryImpl
  - TodoRepositoryImpl.swift
  - LoginRepositoryImpl.swift

- InterfaceAdopterImpl
  - LoginPresenterImpl.swift
  - TodoListPresenterImpl.swift
  - TodoDetailPresenterImpl.swift

- Presentation
  - LoginView
    - View
      - LoginViewController.swift
    - Wireframe
      - LoginWireframe.swift
  - TodoListView
    - View
      - TodoListViewController.swift
    - Wireframe
      - TodoListWireframe.swift
  - TodoDetailView
    - View
      - TodoDetailViewController.swift
    - Wireframe
      - TodoListWireframe.swift

## File構成

- Entity
  - Todo.swift

- Usecase
  - LoginUsecase.swift
  - TodoUsecase.swift
  - TodoUseCaseImpl.swift
  
- Data
  - LoginRepository.swift
  - LoginRepositoryImpl.swift
  - TodoRepository.swift
  - TodoRepositoryImpl.swift

- InterfaceAdapter
  - LoginPresenter.swift
  - LoginPresenterImpl.swift
  - TodoListPresenter.swift
  - TodoListPresenterImpl.swift
  - TodoDetailPresenter.swift
  - TodoDetailPresenterImpl.swift

- Presentation
  - LoginView
    - View
      - LoginViewController.swift
    - Wireframe
      - LoginWireframe.swift
  - TodoListView
    - View
      - TodoListViewController.swift
    - Wireframe
      - TodoListWireframe.swift
  - TodoDetail
    - View
      - TodoDetailViewController.swift
    - Wireframe
      - TodoListWireframe.swift

- Builder
  - LoginBuilder.swift
  - TodoListBuilder.swift
  - TodoDetailBuilder.swift

## Reference

実装クリーンアーキテクチャ
https://qiita.com/nrslib/items/a5f902c4defc83bd46b8
