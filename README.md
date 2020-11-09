# Todo

## UI

## Requirements

- Clean Architecture + Router a.k.a Viper
- Swift 5
- iOS14
- RxSwift
- Firebase
- Firestore

## UML

## 命名規則

|  役割 | 抽象型 | 具象型 |
| --- | --- | --- |
|  View | (ModuleName)View | (ModuleName)ViewController |
|  Interactor | (ModuleName)UseCase | (ModuleName)UseCaseImpl |
|  Presenter | (ModuleName)Presenter | (ModuleName)PresenterImpl |
|  Entity |  | Entity |
|  Router | (ModuleName)Router | (ModuleName)RouterImpl |

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
    - Router
      - LoginRouter.swift
  - TodoListView
    - View
      - TodoListViewController.swift
    - Router
      - TodoListRouter.swift
  - TodoDetailView
    - View
      - TodoDetailViewController.swift
    - Router
      - TodoListRouter.swift

## File Structure of the Program

\<P> = Protocol

- Entity
  - Todo.swift

- Usecase
  - LoginUsecase.swift
    - \<P>LoginUsecaseInjectable
    - \<P>LoginUsecase
    - LoginUsecaseImpl
  - TodoUsecase.swift
    - \<P>TodoUsecaseInjectable
    - \<P>TodoUseCase
    - TodoUseCaseImpl
  
- Data
  - Repository
    - LoginRepository.swift
      - \<P>LoginRepositoryInjectable
      - LoginRepository
      - LoginRepositoryImpl
    - TodoRepository.swift
      - \<P>TodoRepositoryInjectable
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
    - Presenter
      - LoginPresenter.swift
        - \<P>LoginPresenterInjectable
        - \<P>LoginPresenter
        - LoginPresenterImpl
    - Router
      - LoginRouter.swift
        - \<P>LoginTransitionble
        - \<P>LoginRouterInjectable
        - \<P>LoginRouter
        - LoginRouterImpl
      - Builder
        - LoginBuilder.swift

  - TodoListView
    - View
      - TodoListViewController.swift
    - Presenter
      - TodoListPresenter.swift
        - \<P>TodoListPresenterInjectable
        - \<P>TodoListPresenter
        - TodoListPresenterImpl
    - Router
      - TodoListRouter.swift
      - \<P>TodoListTransitionable
      - \<P>TodoListRouterInjectable
      - \<P>TodoListRouter
      - TodoListRouterImpl
    - Builder
      - TodoListBuilder.swift

  - TodoDetail
    - View
      - TodoDetailViewController.swift
    - Presenter
      - TodoDetailPresenter.swift
        - \<P>TodoDetailInjectable
        - \<P>TodoDetailPresenter
        - TodoDetailPresenterImpl
    - Router
      - TodoDetailRouter.swift
        - \<P>TodoDetailTransitionable
        - \<P>TodoDetailRouterInjectable
        - \<P>TodoDetailRouter
        - TodoDetailRouterImpl
    - Builder
      - TodoDetailBuilder.swift

## Memo

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。

- DIの部分は、protocolの**Injectable.protocolを作成し、protocol extensionに実体を配置する
- Routerについて
  - 画面遷移にはRouterパターンを採用。画面遷移部分を切り離す。
  - 各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
  - BuilderはPresenter, UseCase, RouterをDIさせる。
  - 各Transitionableは、buildして画面遷移する責務を持つ
  - 各Transitionableに準拠したRouter(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

## Reference

- 実装クリーンアーキテクチャ
<https://qiita.com/nrslib/items/a5f902c4defc83bd46b8>

- Viper研究読本 VIPER研究読本1 クリーンアーキテクチャ解説編
  <https://swift.booth.pm/items/1758609>
