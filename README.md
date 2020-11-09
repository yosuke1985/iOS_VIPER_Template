# Todo

## UI

## Requirements

- Clean Architecture + Wireframe(Router) a.k.a Viper
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
|  Interactor | (ModuleName)UseCase | (ModuleName)Interactor |
|  Presenter | (ModuleName)Presentaiton | (ModuleName)Presenter |
|  Entity |  | Entity |
|  Router | (ModuleName)Wireframe | (ModuleName)Router |

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
    - Wireframe
      - LoginWireframe.swift
        - \<P>LoginTransitionble
        - \<P>LoginWireframeInjectable
        - \<P>LoginWireframe
        - LoginWireframeImpl
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
    - Wireframe
      - TodoListWireframe.swift
      - \<P>TodoListTransitionable
      - \<P>TodoListWireframeInjectable
      - \<P>TodoListWireframe
      - TodoListWireframeImpl
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
    - Wireframe
      - TodoDetailWireframe.swift
        - \<P>TodoDetailTransitionable
        - \<P>TodoDetailWireframeInjectable
        - \<P>TodoDetailWireframe
        - TodoDetailWireframeImpl
    - Builder
      - TodoDetailBuilder.swift

## Memo

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。

- DIの部分は、protocolの**Injectable.protocolを作成し、protocol extensionに実体を配置する
- Wireframeについて
  - 画面遷移にはWireframe(Router)パターンを採用。画面遷移部分を切り離す。
  - 各Wireframeに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
  - BuilderはPresenter, UseCase, WireframeをDIさせる。
  - 各Transitionableは、buildして画面遷移する責務を持つ
  - 各Transitionableに準拠したWireframe(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

## Reference

- 実装クリーンアーキテクチャ
<https://qiita.com/nrslib/items/a5f902c4defc83bd46b8>

- Viper研究読本 VIPER研究読本1 クリーンアーキテクチャ解説編
  <https://swift.booth.pm/items/1758609>
