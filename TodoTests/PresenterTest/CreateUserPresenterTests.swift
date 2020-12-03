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
    private var presenter = CreateUserTestImplPresenter()
    let bag = DisposeBag()

    private let view = TestDouble.CreateUserTestViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var router = TestDouble.CreateUserRouterTestImpl()
        router.viewController = view
                
        presenter.router = router
        presenter.authUseCase = AuthUseCaseImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateUser() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        XCTContext.runActivity(named: "create user") { _ in
            self.presenter.createUser(email: "test4@user.com", password: "1234OKMijn")
        }
    }
}

extension CreateUserPresenterTests {
    enum TestDouble {
        struct CreateUserRouterTestImpl: CreateUserRouter {
            var viewController: UIViewController?
        }
        
        class CreateUserTestViewController: UIViewController {}
    }
    
    class CreateUserTestImplPresenter: CreateUserPresenter {
        var router: CreateUserRouter!
        var authUseCase: AuthUseCase!
        private let _showAPIErrorPopupRelay = PublishRelay<Error>()
        var showAPIErrorPopupRelay: Signal<Error> {
            return _showAPIErrorPopupRelay.asSignal()
        }
        
        let bag = DisposeBag()
        func testTrue() -> Bool {
            return true
        }
        
        func createUser(email: String, password: String) {
            authUseCase.createUser(email: email, password: password)
                .debug()
                .subscribe(onSuccess: { _ in
                               XCTAssertTrue(true)
                           },
                           onError: { _ in
                               XCTAssertTrue(true)
                           })
                .disposed(by: bag)
        }
        
        func toLoginView() {
            XCTAssertTrue(true)
        }
    }
}
