# iOS Todo app build with Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>

## 残

- [ ] RxSwiftのバインディングについて
- [ ] アプリリリース
  - [ ] アイコンの準備
  - [ ] スクリーンショット
  - [ ] 説明の準備
- [ ] GIFの追加
- [ ] 記事の計画
- [ ] 英語バージョンのREADME

## 概要

### アーキテクチャ

- Clean Architecture + Router　= VIPER
- VIPERはView Interactor Presenter Entity Routerの頭文字を取ったものであるが、ここでは Interactorとは呼ばずUseCaseと呼ぶことにする。
- 双方向バインディングにはRxSwiftを使用している。
- レポジトリにはInterface Adapterは作成しない。

### 命名規則

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
- DIの部分は、protocolの\\(ModuleName)Injectableと命名する。
- 画面遷移の責務を持つものをWireframeではなく、\\(ModuleName)Routerと命名する。
- UseCaseは、Interactorではなく、\\(ModuleName)Usecase
- Interface Adapterには、ViewModelではなく、\\(ModuleName)Presenter

### DIの注入

- DIの部分は、protocolの\\(ModuleName)Injectableを作成し、protocol extensionに実体を持つ。
- Builderについて
  - 各画面に対し、1 ViewControleler, 1 storyboardで構成し、それに対応したBuilderが依存関係の注入しPresenter, UseCase, RouterにDIする。

### 画面遷移

- 画面遷移の責務を持つRouterパターン。
  - Routerは画面遷移の責務を持つ。画面遷移先のViewControllerをBuildし、遷移する。
  - 画面遷移部分を切り離す各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
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
root:
  users:
    userID: userID
      todos:
        documentID: auto
        title: String
        description: String
        isChecked: Bool
        createdAt: Date
        updatedAt: Date
```

### データバインディング

#### ViewController -> Presenter Event (Ex: button tap)

``` swift
protocol ViewPresenter {
    var loginRequest: PublishRelay<Void> { get }
}

class ViewPresenterImpl: ViewNamePresenter {
    let loginRequest = PublishRelay<Void>()
}

class ViewController {
    var presenter: ViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.presenter.loginRequest.accept(())
            }).disposed(by: self.disposeBag)

        // Abbreviation / 省略形
        loginButton.rx.tap
            .bind(to: presener.loginRequest)
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController Event (Ex: tap Event)

Signal: エラーが発生しない, main スレッドで実行, subscribe してから発生した event を受け取る。
ゆえに、画面遷移などや一度だけ実行されるものに向いている。

``` swift
protocol ViewPresenter {
    var nextSereen: Signal<Void> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let _nextSereen = PublishRelay<Void>()
    var nextSereen: Signal<Void> {
        return _nextSereen.asSignal()
    }
}

class ViewController {
    var presenter: ViewPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.nextSereen
            .emit(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.presenter.moveToNextSereen()
            })
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController One-way Bind property (Ex: String -> UILabel)

Driver: エラーが発生しない, main スレッドで実行, 一つ前の event を受け取れる.
初期表示でセットされる場合などを考慮すると、tapした瞬間しか受け取れないSignalよりもDriverが適している。

``` swift
protocol ViewPresenter {
    var labelText: Driver<String> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let _labelText = BehaviorRelay<String>(value: "")
    var labelText: Driver<String> {
        return _labelText.asDriver()
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

#### Presenter -> ViewController One-way Bind property (Ex: Button Enable/Disable)

``` swift
protocol ViewPresenter {
    var canSearch: Driver<Bool> { get }
}

class ViewPresenterImpl: ViewPresenter {
    private let inputtedText = BehaviorRelay<String>(value: "")
    private let inputtedErrorText = BehaviorRelay<String>(value: "") 

    var canSearch: Driver<Bool> {
        return Driver.combineLatest(inputtedText.asDriver(), inputtedErrorText.asDriver()) { iText, iErrorText in
            return iText && !iErrorText
        }
    }
}

class ViewController {
    var presenter: ViewPresenter!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.canSearch
            .drive(onNext: { [weak self] value in
                guard let weakSelf = self else { return }
                weakSelf.searchButton.isEnabled = value
            })
            .disposed(by: bag)

        // Abbreviation / 省略形
        presenter.labelText
            .drive(searchButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
```

#### Presenter <-> ViewController Two-way Bind property (Ex: String <-> UITextField)

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
            .disposed(by: self.disposeBag)
        testTextField.rx.text.orEmpty
            .bind(to: presenter.testText)
            .disposed(by: bag)
    }
}
```

#### Presenter -> ViewController One-way Bind property (Ex: [Struct] -> UITableView)

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

