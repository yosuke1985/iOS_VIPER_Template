//
//  AuthUseCaseTests.swift
//  TodoTests
//
//  Created by yosuke.nakayama on 2020/12/03.
//

import RxCocoa
import RxSwift
import RxTest
@testable import Todo
import XCTest

class AuthUseCaseTests: XCTestCase {
    let authUseCase = AuthUseCaseImpl()
    let bag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateUser() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        authUseCase.createUser(email: "test5@user.com", password: "1234OKMijn")
            .debug()
            .subscribe(onSuccess: { _ in
                           XCTAssertTrue(true)
                       },
                       onError: { _ in
                           XCTAssertTrue(true)
                       })
            .disposed(by: bag)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
