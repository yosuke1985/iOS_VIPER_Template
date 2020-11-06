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
<!-- TODO: delete this section and create UML -->

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
  - ViewModelInterface
    - LoginViewModel.swift
    - TodoListViewModel.swift
    - TodoDetailViewModel.swift

- RepositoryImpl
  - TodoRepositoryImpl.swift
  - LoginRepositoryImpl.swift

- InterfaceAdopterImpl
  - LoginViewModelImpl.swift
  - TodoListViewModelImpl.swift
  - TodoDetailViewModelImpl.swift

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

## File Structure of the Program

<P> = Protocol

- Entity
  - Todo.swift

- Usecase
  - LoginUsecase.swift
    - <P>LoginUsecaseInjectable
    - <P>LoginUsecase
    - LoginUsecaseImpl
  - TodoUsecase.swift
    - <P>TodoUsecaseInjectable
    - <P>TodoUseCase
    - TodoUseCaseImpl
  
- Data
  - Repository
    - LoginRepository.swift
      - <P>LoginRepositoryInjectable
      - LoginRepository
      - LoginRepositoryImpl
    - TodoRepository.swift
      - <P>TodoRepositoryInjectable
      - TodoRepository
      - TodoRepositoryImpl
  - RequestResponse
    - Login
      - LoginRequest.swift
      - LoginResponse.swift
    - Todo
      - TodoRequest.swift
      - TodoResponse.swift

- Presentation
  - LoginView
    - View
      - LoginViewController.swift
    - ViewModel
      - LoginViewModel.swift
        - <P>LoginViewModelInjectable
        - <P>LoginViewModel
        - LoginViewModelImpl
    - Wireframe
      - LoginWireframe.swift
        - <P>LoginTransitionble
        - <P>LoginWireframeInjectable
        - <P>LoginWireframe
        - LoginWireframeImpl
      - Builder
        - LoginBuilder.swift

  - TodoListView
    - View
      - TodoListViewController.swift
    - ViewModel
      - TodoListViewModel.swift
        - <P>TodoListViewModelInjectable
        - <P>TodoListViewModel
        - TodoListViewModelImpl
    - Wireframe
      - TodoListWireframe.swift
      - <P>TodoListTransitionable
      - <P>TodoListWireframeInjectable
      - <P>TodoListWireframe
      - TodoListWireframeImpl
    - Builder
      - TodoListBuilder.swift

  - TodoDetail
    - View
      - TodoDetailViewController.swift
    - ViewModel
      - TodoDetailViewModel.swift
        - <P>TodoDetailInjectable
        - <P>TodoDetailViewModel
        - TodoDetailViewModelImpl
    - Wireframe
      - TodoDetailWireframe.swift
        - <P>TodoDetailTransitionable
        - <P>TodoDetailWireframeInjectable
        - <P>TodoDetailWireframe
        - TodoDetailWireframeImpl
    - Builder
      - TodoDetailBuilder.swift

## Memo

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
- Presenterとせず、ViewModelと命名したのは、ViewModelに双方向のデータバインディングの場合よく使用されるため
- DIの部分は、protocolの**Injectable.protocolを作成し、protocol extensionに実体を配置する
- Wireframeについて
  - 画面遷移にはWireframe(Router)パターンを採用。画面遷移部分を切り離す。
  - 各Wireframeに対応したUIViewControllerの参照を持ち、ViewModelから受けた入力によって画面遷移させる。
  - BuilderはViewModel, UseCase, WireframeをDIさせる。
  - 各Transitionableは、buildして画面遷移する責務を持つ
  - 各Transitionableに準拠したWireframe(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

## Reference

実装クリーンアーキテクチャ
<https://qiita.com/nrslib/items/a5f902c4defc83bd46b8>
