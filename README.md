# iOS Todo app build with Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>

## 残

- [ ] VIPERについての解説
- [ ] router部分の実装の解説
- [ ] アプリリリース
  - [ ] アイコンの準備
  - [ ] スクリーンショット
  - [ ] 説明の準備
- [ ] GIFの追加
- [ ] 記事の計画
- [ ] 英語バージョンのREADME

## 概要

##　アーキテクチャ概要

- Clean Architecture + Router　= VIPER
- VIPERはView Interactor Presenter Entity Routerの頭文字を取ったものであるが、ここでは Interactorとは呼ばずUseCaseと呼ぶことにする。
- 双方向バインディングにはRxSwiftを使用している。
- レポジトリにはInterface Adapterは作成しない。

## Class Chart

<img src="https://docs.google.com/drawings/d/e/2PACX-1vSgHoUQDGKzsEiM8oaBD5dv5hGxEjHILlpnIOmOni308qQD79W35BrA6kxwEhBwugF1GkaJ81hF8meF/pub?w=960&amp;h=720">

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

## Firestore

``` yml
root/:
  users/:
    userID/: userID
      todos/:
        documentID: auto
        title: String
        description: String
        isChecked: Bool
        createdAt: Date
        updatedAt: Date
```

### Naming conventions

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
- DIの部分は、protocolの\\(ModuleName)Injectableと命名する。
- 画面遷移の責務を持つものをWireframeではなく、\\(ModuleName)Routerと命名する。
- UseCaseは、Interactorではなく、\\(ModuleName)Usecase
- Interface Adapterには、ViewModelではなく、\\(ModuleName)Presenter


|  役割 | 抽象型 | 具象型 |
| --- | --- | --- |
|  View | | (ModuleName)View, (ModuleName)ViewController |
|  Presenter | (ModuleName)Presenter <sup>[2](#note2)</sup>| (ModuleName)PresenterImpl |
|  UseCase| (ModuleName)UseCase<sup>[3](#note3)</sup>  | (ModuleName)UseCaseImpl |
|  Entity |  | Entity |
|  Router | (ModuleName)Router<sup>[4](#note4)</sup> | (ModuleName)RouterImpl |
|  Repository | (ModuleName)Repository | (ModuleName)RepositoryImpl |

### Dependency Injection

- DIの部分は、protocolの\\(ModuleName)Injectableを作成し、protocol extensionに実体を持つ。
- Builderについて
  - 各画面に対し、1 ViewControleler, 1 storyboardで構成し、それに対応したBuilderが依存関係の注入しPresenter, UseCase, RouterにDIする。

### 画面遷移を責務を持つRouter

- 画面遷移の責務を持つRouterパターン。
  - Routerは画面遷移の責務を持つ。画面遷移先のViewControllerをBuildし、遷移する。
  - 画面遷移部分を切り離す各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
- 各Transitionableは、buildして画面遷移する責務を持つ。各Transitionableに準拠したRouter(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

### データバインディング

#### ViewController -> Presenter Event (Ex: button tap)

View入力、アクションがトリガーとなって行う処理に使用する。
例）Authentication周りのログイン処理、セッションがあるかどうかAPI経由で確認

``` swift
protocol ViewPresenter {
    var loginRequestRelay: PublishRelay<Void> { get }
}

class ViewPresenterImpl: ViewNamePresenter {
    let loginRequestRelay = PublishRelay<Void>()
}

class ViewController {
    var presenter: ViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.presenter.loginRequestRelay.accept(())
            })
            .disposed(by: bag)

        // Abbreviation / 省略形
        loginButton.rx.tap
            .bind(to: presener.loginRequestRelay)
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController Event

Presenterで処理した結果をアクションとして渡し、それが描画に関連する場合に使用する。Viewに描画する目的で一度だけ流れる。
Signal: エラーが発生しない, main スレッドで実行, subscribe してから発生した event を受け取る。

例として、タップイベント。画面遷移など。

``` swift
protocol ViewPresenter {
    var toNextViewRelay: Signal<Void> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let _toNextViewRelay = PublishRelay<Void>()
    var toNextViewRelay: Signal<Void> {
        return _toNextViewRelay.asSignal()
    }
}

class ViewController {
    var presenter: ViewPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.toNextViewRelay
            .emit(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.router.moveToNextSereen()
            })
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController One-way Bind property

Presenterで処理した結果を、描画する目的で流す。
Driver: エラーが発生しない, main スレッドで実行, 一つ前の event を受け取れる.
初期表示でセットされる場合などを考慮すると、tapした瞬間しか受け取れないSignalよりもDriverが適している。

例として、テキストの表示、画像の表示などUIの表示、UIの表示のEnable, Hiddenなど

``` swift
protocol ViewPresenter {
    var labelText: Driver<String> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let _labelTextRelay = BehaviorRelay<String>(value: "")
    var labelTextRelay: Driver<String> {
        return _labelTextRelay.asDriver()
    }
}

class ViewController {
    var presenter: ViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.labelText
            .drive(onNext: { [weak self] value in
                guard let weakSelf = self else { return }
                weakSelf.testLabel.text = value
            })
            .disposed(by: bag)

        // Abbreviation / 省略形
        presenter.labelText
            .drive(testLabel.rx.text)
            .disposed(by: bag)
    }
}
```

#### Presenter <-> ViewController Two-way Bind property (Ex: String <-> UITextField)

双方向バインディング
Viewでの入力とPresenterの処理の結果が互いに影響を及ぼす場合。

``` swift
protocol ViewPresenter {
    var testText: BehaviorRelay<String> { get }
}

class ViewPresenterImpl: ViewPresenter {
    let testText = BehaviorRelay<String>(value: "")
}

class ViewController {
    var presenter: ViewPresenter!
    @IBOutlet weak var testTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.testText.asDriver()
            .drive(onNext: { [weak self] value in
                guard let weakSelf = self else { return }
                weakSelf.testTextField.text = value
            })
            .disposed(by: bag)
        testTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] value in
                guard let weakSelf = self else { return }
                weakSelf.presenter.testText.accept(value)
            })
            .disposed(by: bag)

        // Abbreviation / 省略形
        presenter.testText.asDriver()
            .drive(testTextField.rx.text)
            .disposed(by: bag)
        testTextField.rx.text.orEmpty
            .bind(to: presenter.testText)
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController One-way Bind property (Ex: [Struct] -> UITableView)

PresenterにてUseCaseから得た結果をもとに、Viewに返す。
RxDataSourcesを使用する。

``` swift
protocol ViewPresenter {
    var items: Driver<[Struct]> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let _items = BehaviorRelay<[Struct]>(value: [])
    var items: Driver<[Struct]> {
        return _items.asDriver()
    }
}

class ViewController {
    var presenter: ViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.items
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "DummyId") as! DummyCell
                return cell
            }
            .disposed(by: bag)
    }
}
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

- infinum/iOS-VIPER-Xcode-Templates
  - <https://github.com/infinum/iOS-VIPER-Xcode-Templates>

- 本気でやりたい人のためのFirestore設計入門 - 超シンプルなTODOアプリ編
  - <https://www.youtube.com/watch?v=fHFoqJpkbJg>

- mironal/RxSwift&MVVM.md
  - <https://gist.github.com/mironal/9eead7a5d812174cec238d68615f1dd6>
