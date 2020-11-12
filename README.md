# iOS Todo app build with Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>

## README残

- [ ] Referenceの作者の記述
- [ ] 注釈の作成
- [ ] アーキテクチャの概要
- [ ] UIのスクリーンショットの貼り付け
- [ ] RxSwiftのバインディングについて（別枠？Gist?）
- [ ] 英語バージョン、日本語バージョンの切り分け

## UI

TODO: スクリーンショット貼り付け

## Requirements

- Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>
- Swift 5
- iOS14
- RxSwift
- Firebase
- Firestore

## アーキテクチャの概要

TODO:
- Clean Architectureの概要
- 双方向バインディング、RxSwiftの話
- DIのInjectableの話
- レポジトリにはInterface adapterがない
- 命名規則について
- VIPERとの関係

## Class Chart

<img src="https://docs.google.com/drawings/d/e/2PACX-1vSgHoUQDGKzsEiM8oaBD5dv5hGxEjHILlpnIOmOni308qQD79W35BrA6kxwEhBwugF1GkaJ81hF8meF/pub?w=960&amp;h=720">

## Naming conventions

|  役割 | 抽象型 | 具象型 |
| --- | --- | --- |
|  View | | (ModuleName)View, (ModuleName)ViewController |
|  Presenter | (ModuleName)Presenter | (ModuleName)PresenterImpl |
|  UseCase<sup>[2](#note2)</sup> | (ModuleName)UseCase | (ModuleName)UseCaseImpl |
|  Entity |  | Entity |
|  Router | (ModuleName)Router | (ModuleName)RouterImpl |
|  Repository | (ModuleName)Repository | (ModuleName)RepositoryImpl |

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
      - \<P>LoginRepository
      - LoginRepositoryImpl
    - TodoRepository.swift
      - \<P>TodoRepositoryInjectable
      - \<P>TodoRepository
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

## 注釈

1. <p id="note1">Clean Architecture + Routerのアーキテクチャ　＝　VIPERであり、VIPERはView Interactor Presenter Entity Routerの頭文字を取ったもの。</p>
2. <p id="note2">VIPERでは UseCaseのことをInteractorと名付けている。</p>
3. protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
4. DIの部分は、protocolの**Injectable.protocolを作成し、protocol extensionに実体を配置する
5. 画面遷移にはRouterパターンを採用。画面遷移部分を切り離す。各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
6. BuilderはPresenter, UseCase, RouterをDIさせる。
7. 各Transitionableは、buildして画面遷移する責務を持つ。各Transitionableに準拠したRouter(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

## Reference

- 実装クリーンアーキテクチャ
<https://qiita.com/nrslib/items/a5f902c4defc83bd46b8>

- Viper研究読本 VIPER研究読本1 クリーンアーキテクチャ解説編
  <https://swift.booth.pm/items/1758609>

- iOSアプリ設計入門　<https://peaks.cc/books/iOS_architecture>
