//
//  CreateUserPresenterTests.swift
//  TodoTests
//
//  Created by yosuke.nakayama on 2020/12/03.
//

import RxCocoa
import RxSwift
import RxTest
@testable import Todo
import XCTest

class CreateUserPresenterTests: XCTestCase {
    private var presenter: CreateUserPresenter!
    var scheduler: TestScheduler!

    let bag = DisposeBag()

    private let view = TestDouble.CreateUserTestViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        scheduler = TestScheduler(initialClock: 0)
        presenter = CreateUserPresenterImpl()
        var router = CreateUserRouterImpl()
        router.viewController = view
                
        presenter.router = router
        presenter.authUseCase = AuthUseCaseImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func isValidEmailPass() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

//        XCTContext.runActivity(named: "create user") { _ in
//            self.presenter.createUser(email: "test4@user.com", password: "1234OKMijn")
//        }
        
        // RxTest、RxBlockingによるテストパターン
        // https://qiita.com/takehilo/items/09f4a3077e441e5bb9de
        
        let isEnabledCreateUserObserver = scheduler.createObserver(Bool.self)

        presenter.isEnableCreateButtonRelay
            .drive(isEnabledCreateUserObserver)
            .disposed(by: bag)

        scheduler.createHotObservable([
            Recorded.next(10, ""),
            Recorded.next(20, "test@gmail.com"),
            Recorded.next(30, "")
        ])
            .bind(to: presenter.emailRelay)
            .disposed(by: bag)

        scheduler.createHotObservable([
            Recorded.next(10, ""),
            Recorded.next(20, "aasdfa"),
            Recorded.next(30, ""),
        
        ])
            .bind(to: presenter.passwordRelay)
            .disposed(by: bag)

//        scheduler.createHotObservable([
//            Recorded.next(10, ()),
//            Recorded.next(20, ()),
//            Recorded.next(30, ())
//        ])
//            .bind(to: presenter.createUserRelay)
//            .disposed(by: bag)

        scheduler.start()

        XCTAssertEqual(isEnabledCreateUserObserver.events, [
            .next(10, false),
            .next(20, true),
            .next(30, false)
        ])
    }
}

// extension CreateUserPresenterTests {
//    enum TestDouble {
//        struct CreateUserRouterTestImpl: CreateUserRouter {
//            var viewController: UIViewController?
//        }
//
//        class CreateUserTestViewController: UIViewController {}
//    }
// }
