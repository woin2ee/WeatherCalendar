//
//  TodoTableViewControllerTests.swift
//  WeatherCalendarTests
//
//  Created by Jaewon on 2022/05/28.
//

import XCTest

class TodoTableViewControllerTests: XCTestCase {

    var sut: StubTodoTableViewController!
    
    override func setUpWithError() throws {
        sut = StubTodoTableViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_scrollToBottom() {
        for i in -1000...1000 {
            sut.scrollToBottom(numOfRows: i)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
