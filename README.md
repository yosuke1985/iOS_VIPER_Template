# iOS Todo app build with Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>

## 残

- [ ] ロジック部分
- [ ] テストコード
- [ ] 概要のブラッシュアップ　Routerについて
- [ ] RxSwiftのバインディングについて（別枠？Gist?）
- [ ] 英語バージョン、日本語バージョンの切り分け

## 概要

### アーキテクチャ

- Clean Architecture + Router　= VIPER
- VIPERはView Interactor Presenter Entity Routerの頭文字を取ったものであるが、ここでは Interactorとは呼ばずUseCaseと呼ぶことにする。
- 双方向バインディングにはRxSwiftを使用している。
- レポジトリにはInterface Adapterは作成しない。

### DIの注入

- DIの部分は、protocolの\\(ModuleName)Injectableを作成し、protocol extensionに実体を持つ。
- BuilderはRouterの中で依存関係の注入しPresenter, UseCase, RouterにDIする。RouterでもprotocolのInjectableと同様の方法で依存性注入を行おうかと思ったが、明示的にしたいのでBuilderを作成することにした。

### 命名規則

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
- DIの部分は、protocolの\\(ModuleName)Injectableと命名する。
- 画面遷移の責務を持つものをWireframeではなく、\\(ModuleName)Routerと命名する。
- UseCaseは、Interactorではなく、\\(ModuleName)Usecase
- Interface Adapterには、ViewModelではなく、\\(ModuleName)Presenter

### 画面遷移

- 画面遷移の責務を持つRouterパターンを採用。画面遷移部分を切り離す各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
- 各Transitionableは、buildして画面遷移する責務を持つ。各Transitionableに準拠したRouter(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

## UI

### Login Page, Create User Page

<img src="/Screenshots/LoginView.png" height = 400px><img src="/Screenshots/CreateUser.png" height = 400px>

### Todo List Page, Todo Detail Page, Create Todo Page

<img src="/Screenshots/TodoListView.png" height = 400px><img src="/Screenshots/TodoDetailView.png" height = 400px><img src="/Screenshots/CreateTodoView.png" height = 400px>

## Requirements

- Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>
- Xcode 12.x
- Swift 5.x
- iOS14
- RxSwift
- Firebase
- Firestore

## Class Chart

<img src="https://docs.google.com/drawings/d/e/2PACX-1vSgHoUQDGKzsEiM8oaBD5dv5hGxEjHILlpnIOmOni308qQD79W35BrA6kxwEhBwugF1GkaJ81hF8meF/pub?w=960&amp;h=720">

## Naming conventions

|  役割 | 抽象型 | 具象型 |
| --- | --- | --- |
|  View | | (ModuleName)View, (ModuleName)ViewController |
|  Presenter | (ModuleName)Presenter <sup>[2](#note2)</sup>| (ModuleName)PresenterImpl |
|  UseCase| (ModuleName)UseCase<sup>[3](#note3)</sup>  | (ModuleName)UseCaseImpl |
|  Entity |  | Entity |
|  Router | (ModuleName)Router<sup>[4](#note4)</sup> | (ModuleName)RouterImpl |
|  Repository | (ModuleName)Repository | (ModuleName)RepositoryImpl |

## Firestore

``` yml
users:
  documentID: userID
  
  todos:
    documentID: auto
    title: String
    description: String?
    isChecked: Bool
    createdAt: Date
    updatedAt: Date
```

## 注釈

1. <p id="note1">Clean Architecture + Routerのアーキテクチャ　＝　VIPERであり、VIPERはView Interactor Presenter Entity Routerの頭文字を取ったもの。</p>
2. <p id="note2">Presenterは、MVVMでいうところのViewModel</p>
3. <p id="note3">VIPERでは UseCaseのことをInteractorと名付けている。</p>
4. <p id="note4">Routerは、Wireframeと名付けることもある</p>

## Reference

- 実装クリーンアーキテクチャ
  - nrslib氏
  - <https://qiita.com/nrslib/items/a5f902c4defc83bd46b8>

- Viper研究読本 VIPER研究読本1 クリーンアーキテクチャ解説編
  - 今城 善矩氏
  - <https://swift.booth.pm/items/1758609>

- iOSアプリ設計入門
  - 関 義隆氏, 史 翔新氏, 田中 賢治氏, 松館 大輝氏, 鈴木 大貴氏, 杉上 洋平氏, 加藤 寛人氏
  - <https://peaks.cc/books/iOS_architecture>
