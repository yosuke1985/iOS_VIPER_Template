# iOS Todo app build with Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>

## 動機

iOSで中大規模のアプリを作成する上で、クリーンアーキテクチャの採用する上でどういった実装がベストプラクティスなのかということをメモと勉強を兼ねて残したいと思います。
自分が考えているオレオレな解釈でクリーンアーキテクチャを理解したつもりでいるので、間違っているところが多々あるかもしれないです！
複数の現場を経験してきて自分の考えうるベストプラクティスとして作ったものですが、ツッコミどころなどあればissueやプルリクを投げてもらえば議論させていただきたいです！

## プロジェクト概要

SwiftでTodoアプリをクリーンアーキテクチャであるVIPER, View Interactor Presenter Entity Routerでつくりました。
クリーンアーキテクチャと一口にいっても、細かくいろんな書き方があり、データバインディングにReactive ExtensionsのRxSwiftを採用しないパターン、データ通信周りだけRxSwiftを採用するパターン、命名がインターフェイス（Protocol）と実装が異なるパターンなど、微妙な違いがあります。

ここでは、Clean Architectureと画面遷移の責務をもつRouter(Wireframeとも読んだりする？)を組み合わせたものをVIPERと呼ばれているものをRxSwfitを使って実装していきます。命名なども、Protocol(Interface)と実装で完全に異なるパターンなどもありますが、シンプルさを心がけてあります。

## UI

<img src="/Images/ui.gif" height = 400>

### Login Page, Create User Page

<img src="/Images/LoginView.png" height = 400><img src="Images/CreateUser.png" height = 400>

### Todo List Page, Todo Detail Page, Create Todo Page

<img src="/Images/TodoListView.png" height = 400><img src="/Images/TodoDetailView.png" height = 400><img src="/Images/CreateTodoView.png" height = 400>


## Firestore Data Model

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

## Requirements

- Clean Architecture + Router a.k.a VIPER<sup>[1](#note1)</sup>
- Xcode 12.x
- Swift 5.x
- iOS14.x
- RxSwift 5
- Firebase
- Firestore

## クリーンアーキテクチャの解説

### VIPERアーキテクチャ概要

- Clean Architecture + Router　= VIPER
- VIPERはView Interactor Presenter Entity Routerの頭文字を取ったものであるが、ここでは Interactorとは呼ばずUseCaseと呼ぶことにする。
- 双方向バインディングにはRxSwiftを使用する。
- レポジトリにはInterface Adapterは作成しない。

### クリーンアーキテクチャの図

<img src="https://raw.githubusercontent.com/yosuke1985/iOS_VIPER_Template/main/Images/CleanArchitecture.jpg" width = 90% >

クリーンアーキテクチャの有名な図についてオレオレで解釈して解説したいとおもいます。

この図にさりげなく円の縁にある影があると思うんですが、見えますか？
この円形は私は立体にするとピラミッド状になっていると思っています。
この一番上に君臨するのがEntity, その次にUseCase, その次にControllers, Presenters, Gateways,　その下に、 DB, UI, Web, Device, External Interfaceがあります。
これは各レイヤーとの上下関係を示しております。

まず、Entityを頂点として捉えます。Entityはアプリに依存しないビジネスロジックを表現し、UseCaseはEntityを用いて、アプリに依存するロジックを作り、View, DB, Web、Deviceに指示を送っています。

### iOSアプリとの対応

iOSアプリだと、ユーザーの入力やiOSの本体に関わるのが図でいうところのFramework & Driverで、Firebase, SQliteなどデータの永続化に関わるところも青色のFramework & Driverに該当します。

例えば、Viewにてユーザーがログインボタンを押すと、PresenterからUseCaseを介し、FirebaseのAuthenticationにアクセスする流れでUseCase,Entityを中心に考えると、
ViewからログインのアクションをPresenterを介して受け取り、FirebaseのログインのAPIをたたいている。という流れになります。

### 依存関係逆転の法則とは何か？

クリーンアーキテクチャを語る上で文脈上必ずてくるのが、この依存関係逆転の法則で、これを理解しないとクリーンアーキテクチャが作れません。そもそもなにが何に依存が逆転しているのかが分かりにくいです。
ここでは事例を用いて解説します。例えば、ログインするUseCaseがあります。そのログインするUseCaseから、ログイン・ログアウト・ユーザー作成の責務を持つAuthRepositoryを使ってログインを行います。

#### プロトコルと実装の分離させて依存性を分離させる具体例

UseCaseはそのAuthRepositoryを使ってログインするわけですが、ここでの役割分担は、UseCaseは文字通り使用するユースケースと、実際にログインする処理をAuthRepositoryとに責務を分けています。

ログインUseCaseは、EmailPass情報を持ってログインする関数のみを知っている状態で、UseCaseは具体的処理は知らず、ここでいうところのFirebase Authenticationのクラスのことなどは一切知らないというのはどういうことかというと、

``` swift
struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        return authRepository.login(email: email, password: password)
    }
}

protocol AuthRepository {
    func logout() -> Single<Result<Void, APIError>>
}
```

そのAuthRepositoryに準拠したクラスが以下のような具体的な実装になります。

``` swift
struct AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(.failure(apiError)))
                } else if let uid = result?.user.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}
```

##### 依存性の分離させずに書くと、

依存関係の逆転をさせずに書くと以下のように, AuthUseCaseはログインの具体的な実装を知っている状態になります。

``` swift
struct AuthUseCaseImpl:
{
    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(.failure(apiError)))
                } else if let uid = result?.user.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}
```

以上のように、プロトコルに依存することによって疎結合な状態を保つことによって、柔軟に変更が可能な状態を保つことができます。

#### クリーンアーキテクチャが必要ない場合は？

以上のログインする処理では、LoginPresenter -> LoginUseCase -> AuthRepository.login(email:pass:)　と経由しているので、ただただ助長になっているように見えます。

この例ではシンプルなのでただ助長になっているだけですが、中大規模のアプリ開発においては、一つのUseCaseの中で複数のRepositoryを参照するというようなことがよくあります。
この例ではFirestoreを採用しており、Firestoreのデータモデルの作成する特性上、複数のRepositoryを参照するということが発生しにくいかもしれないですが、通常バックエンド開発者がいる場合では、顧客情報を取得した上でさらに購入履歴を取得し、さらにその商品の詳細を取得しなどというケースがあるかと思います。

要件がある程度シンプルだとClean Architectureなどではなく、MVVMなどの他のアーキテクチャを検討して良いのかもしれません。

### 当該アプリとクリーンアーキテクチャとの対応

各層へはプロトコル（インターフェイス）を介して、通信しています。
Todoをリスト表示させるTodoListViewを例にとると、
- TodoListViewControllerはTodoListPresenterプロトコルを介して、TodoListPresenterImplと通信している。
- TodoListPresenterImplは TodoUseCaseプロトコルを介して、TodoUseCaseImplと通信している。
- TodoUseCaseImplはTodoRepositoryプロトコルを介して、TodoRepositoryImplと通信している。

例えば、Todoのリストを表示させる場合、
1. TodoListViewControllerが、TodoListPresenterプロトコルを介してTodoListPresenterImplに[Todo]を要求。　TodoListViewControllerはTodoListPresenterプロトコルしかしらない。
2. TodoListPresenterImplはTodoListViewControllerからのInputを受けて、TodoUseCaseプロトコルを介したTodoUseCaseImplはTodoRepositoryを介してTodoRepositoryImplにアクセスする。
3. TodoRepositoryImplはAPIにアクセスしTodoのリストを取得する。

取得したデータは、RxSwiftのデータバインディングによって渡します。（図の点線部分）
この例では一つのAPIしか使用していないので助長なコードになっているとは思いますが、開発が進むにつれて責務を分けることによって変更に対応しやすい設計になってきます。

<img src="https://docs.google.com/drawings/d/e/2PACX-1vSxELUJhD45EOTJUcPS-B8EAOUwfaA6txalQD_VrtfQJsSRO2HfZxKdQPUX8NamVL-3tvMZFwFOkigd/pub?w=1121&amp;h=379">

これをよく見るクリーンアーキテクチャの図に置き換えると以下のようなピラミッド型になっている。
<img src="https://docs.google.com/drawings/d/e/2PACX-1vSgHoUQDGKzsEiM8oaBD5dv5hGxEjHILlpnIOmOni308qQD79W35BrA6kxwEhBwugF1GkaJ81hF8meF/pub?w=960&amp;h=720">

### 命名規則 Naming conventions

Clean Archtectureにわかりにくいところで、MVC, MVP, MVVMなど今まではその責務をもつモジュールの名称が名付けられていましたが、
Clean Architectureを作る人によって命名がまちまちです。
本家のVIPERにおいても、プロトコル（インターフェイス）と実装の名前が違っていたり、とてもややこしいです。ですので、できるだけシンプルさを心がけた名称を採用しました。

- protocolとそれを準拠したクラスないしは構造体は、protocolの名称 + Implと命名する。
- DIの部分は、protocolの\\(ModuleName)Injectableと命名する。
- 画面遷移の責務を持つものをWireframeではなく、\\(ModuleName)Routerと命名する。
- UseCaseは、Interactorではなく、\\(ModuleName)Usecase
- Interface Adapterには、ViewModelではなく、\\(ModuleName)Presenter

|  役割 | 抽象型 | 具象型 |
| --- | --- | --- |
|  View | | \\(ModuleName)View, \\(ModuleName)ViewController |
|  Presenter | \\(ModuleName)Presenter <sup>[2](#note2)</sup>| \\(ModuleName)PresenterImpl |
|  UseCase| \\(ModuleName)UseCase<sup>[3](#note3)</sup>  | \\(ModuleName)UseCaseImpl |
|  Entity |  | Entity |
|  Router | \\(ModuleName)Router<sup>[4](#note4)</sup> | \\(ModuleName)RouterImpl |
|  Repository | \\(ModuleName)Repository | \\(ModuleName)RepositoryImpl |

#### View, ViewController命名

``` swift
class ModuleName: UIView {
}

class ModuleNameViewController: UIViewController {
}
```

#### Presenter命名

``` swift
protocol ModuleNamePresenter {
}

struct ModuleNamePresenterImpl: ModuleNamePresenter {
}
```

#### UseCase命名

``` swift
protocol ModuleNameUseCase {
}

struct ModuleNameUseCaseImpl: ModuleNameUseCase {
}
```

#### Router命名

``` swift
protocol ModuleNameRouter {
}

struct ModuleNameRouterImpl: ModuleNameRouter {
}
```

#### Repository命名

``` swift
protocol ModuleNameRepository {
}

struct ModuleNameRepositoryImpl: ModuleNameRepository {
}
```

## VIPER各コンポーネント(= View Interactor Presenter Entity Router)<sup>[3](#note3)</sup>

### Dependency Injection

#### Protocol extensionでのDI

DIの部分は、protocolの\\(ModuleName)Injectableを作成し、protocol extensionに実体を持つ。

```swift
protocol TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase { get }
}

extension TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase {
        return TodoUseCaseImpl()
    }
}
```

##### SingletonパターンでのDI

```swift
protocol TodoRepositoryInjectable {
    var todoRepository: TodoRepository { get }
}

extension TodoRepositoryInjectable {
    var todoRepository: TodoRepository {
        return TodoRepositoryImpl.shared
    }
}

protocol TodoRepository {
}

class TodoRepositoryImpl: TodoRepository {
    static var shared = TodoRepositoryImpl() // Singleton
}

```

#### BuilderパターンでのDI

- Builderについて
  - 各画面に対し、1 ViewControleler, 1 storyboardで構成し、それに対応したBuilderが依存関係の注入しPresenter, UseCase, RouterにDIする。

``` swift
struct TodoListBuilder: 
    TodoUseCaseInjectable,
    AuthUseCaseInjectable {
    func build() -> UIViewController {
        let vc = TodoListViewController.instantiate()
        let router = TodoListRouterImpl()
        let presenter = TodoListPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        presenter.authUseCase = authUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
```

## View, ViewControllerの役割

ViewはPresenterのことのみを知っています。
つまりViewControllerはPresenterを持ち、イベントをpresenterへ渡す
ないしは、Presenterからの入力を受けて、それをViewに反映させる。
UIViewControllerの持つUIViewやUITableViewは直接参照してデータの受け渡しをするようにしています。

<b>Input: PresenterからのアクションをViewに反映させる。</b>

<b>Output: ユーザーからのアクションをPresenterにわたす。</b>

``` swift
class LoginViewController: UIViewController {
    var presenter: LoginPresenter!
    @IBOutlet weak var loginButton: UIButton!
}
```

## Presenterの役割

<b>Input: Viewからのアクションをもらう</b>

<b>Output: UseCaseにアクションを起こす</b>

PresenterはUseCaseのことのみを知っています。
Viewから得た入力をもとに、PresenterではどうするかをUseCaseに出力します。
以下では、UseCaseから帰ってきた結果をもとにViewに流し込むという処理をしています。

``` swift

protocol LoginPresenter {
    var router: TodoListRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }

}

final class LoginPresenterImpl: LoginPresenter {
    let bag = DisposeBag()
    var router: TodoListRouter!
    var authUseCase: AuthUseCase!

       func setBind() {
        loginRelay
            .flatMap { [weak self] (_) -> Single<Result<Void, APIError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                guard let email = weakSelf.emailRelay.value,
                      let password = weakSelf.passwordRelay.value
                else {
                    return .never()
                }
                return weakSelf.authUseCase.login(email: email, password: password)
            }
            .subscribe(onNext: { [weak self] result in
                           guard let weakSelf = self else { return }
                           switch result {
                           case .success:
                               weakSelf.router.toTodoListView()
                           case let .failure(error):
                               weakSelf._showAPIErrorPopupRelay.accept(error)
                           }
                
                       },
                       onError: { error in
                           fatalError(error.localizedDescription)
                       })
            .disposed(by: bag)
    }
}
```

## UseCaseの役割

<b>Input: Presenterからのアクションをもらう</b>

<b>Output: Repositoryからデータを取り出したり、ビジネスロジックであるEntityを使用し処理した結果を返す</b>

クリーンアーキテクチャの中心的役割ともいえるUseCaseで、UseCaseはEntityのことのみを知っています。
UseCaseが


``` swift
protocol AuthUseCase {
    func login(email: String, password: String) -> Single<Result<Void, APIError>>
}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        return authRepository.login(email: email, password: password)
    }
}
```

## Repostiroyの役割

<b>Input: UseCaseからのアクションをもらう</b>

<b>Output: UseCaseのアクションに基づいて、APIを叩いたり、ローカルDBを操作したりする。</b>

以下の実装の例ではAPIを叩いた結果はResult型で返すようにしています。

Presenterで受けたResult型でsubscribeの中でAPIの結果をsuccess, failureで分岐させています。

### 戻り値の型をSingle\<Result\<Void, APIError>>

まずRxSwiftのSingleはSuccessとErrorしか流れないObservableです。
このSuccessが流れるときは、必ずAPIとの通信に成功した場合に流れます。ここではVoidですので、APIを叩くのは成功したが何も流れてこないという状態です。
そのAPIから帰ってきた結果に対し、Relult型の.success, .failureで分岐させています。
つまり、ここで考えうる返却されるパターンは、３パターンで、

- observer(.success(.failure(apiError)))
APIを叩くのは成功したが、パラメータとして渡した値に問題があったかなどの、なんらかの原因でエラーがAPIから返された。

- observer(.success(.success(())))
APIを叩くのは成功し、処理としても成功した。APIから返却されたものもないのでVoid ()を返却しています。

- observer(.error(CustomError.unknown))
APIから返却されていない、何らかのエラーが発生しています。


``` swift
protocol AuthRepository {
    func login(email: String, password: String) -> Single<Result<Void, APIError>>
}

struct AuthRepositoryImpl: AuthRepository {
    static var shared = AuthRepositoryImpl()
    private init() {}

    let userRelay = BehaviorRelay<User?>(value: nil)

    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(.failure(apiError)))
                } else if let uid = result?.user.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}

```

### Routerの役割

<b>Input: Presenterからのアクションをもらう</b>

<b>Output: Presenterからのアクションをうけて、RouterはViewControllerの参照を持っているので、アクションに基づいて別のViewControllerへ画面遷移を行う。</b>

- 画面遷移の責務を持つRouterパターン。
  - Routerは画面遷移の責務を持つ。画面遷移先のViewControllerをBuildし、遷移する。
  - 画面遷移部分を切り離す各Routerに対応したUIViewControllerの参照を持ち、Presenterから受けた入力によって画面遷移させる。
- 各Transitionableは、buildして画面遷移する責務を持つ。各Transitionableに準拠したRouter(UIViewControllerの実体を持つ)は、その準拠した画面へ遷移することができるようになる。（遷移するための実装がそのTransitionableにあるので）

#### 例）TodoListViewの画面遷移

- TodoListViewからTodoDetailViewへの画面遷移

<img src="https://raw.githubusercontent.com/yosuke1985/iOS_VIPER_Template/main/Images/TodoListView.png" height = 200px><font size="+6">➔</font><img src="https://raw.githubusercontent.com/yosuke1985/iOS_VIPER_Template/main/Images/TodoDetailView.png" height = 200px>

``` swift

protocol TodoListPresenter {
    var router: TodoListRouter! { get set }
}

final class TodoListPresenterImpl: TodoListPresenter {
    var router: TodoListRouter!
}

protocol TodoListRouter:
    LoginViewTransitionable,
    TodoDetailViewTransitionable,
    CreateTodoViewTransitionable
{
    var viewController: UIViewController? { get set }
}

final class TodoListRouterImpl: TodoListRouter {
    weak var viewController: UIViewController?
}


protocol TodoDetailViewTransitionable {
    var viewController: UIViewController? { get set }
    func toTodoDetailView(todo: Todo)
}

extension TodoDetailViewTransitionable {
    func toTodoDetailView(todo: Todo) {
        let vc = TodoDetailBuilder().build(todo: todo)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

```

## データバインディング View <-> Presenter <-> UseCase <-> Repository

これらの通信にデータをどう渡すかのデータバインディングについて

### ViewController -> Presenter Event

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

### Presenter -> ViewController Event

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

### Presenter -> ViewController One-way Bind property

Presenterで処理した結果を、描画する目的で流す。
Driver: エラーが発生しない, main スレッドで実行, 一つ前の event を受け取れる.
初期表示でセットされる場合などを考慮すると、tapした瞬間しか受け取れないSignalよりもDriverが適しています。

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

### Presenter <-> ViewController Two-way Bind property

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

### Presenter -> ViewController One-way Bind property (Ex: [Struct] -> UITableView)

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

## アプリリリースしました！

面白かったという方は購入してくれたらうれしいです。
NOTTODOというアプリ名にしようかとおもいましたが、
名称がかぶっていたのでNOTTOD0（最後がゼロ）でリリースしました。
<https://apps.apple.com/jp/app/line/id1544030890>

## お仕事依頼も募集中です

お仕事も募集中です。
ihatenonoildressing@gmail.comにご連絡ください！

## 注釈

1. <p id="note1">Clean Architecture + Routerのアーキテクチャ　＝　VIPERであり、VIPERはView Interactor Presenter Entity Routerの頭文字を取ったもの。</p>
2. <p id="note2">Presenterは、MVVMでいうところのViewModel</p>
3. <p id="note3">VIPERでは UseCaseのことをInteractorと名付けています。</p>
4. <p id="note4">Routerは、Wireframeと名付けることもある</p>

## Reference

- The Clean Architecture
   - <https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html>

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

- mironal/RxSwift&MVVM.md
  - <https://gist.github.com/mironal/9eead7a5d812174cec238d68615f1dd6>

- Firestore Security Rules の書き方と守るべき原則
  - <https://qiita.com/KosukeSaigusa/items/18217958c581eac9b245>

- 本気でやりたい人のためのFirestore設計入門 - 超シンプルなTODOアプリ編
  - <https://www.youtube.com/watch?v=fHFoqJpkbJg>
