//
//  TodoStorageTests.swift
//  WeatherCalendarTests
//
//  Created by Jaewon on 2022/06/07.
//

import XCTest
@testable import WeatherCalendar

class TodoStorageTests: XCTestCase {

    var sut: StubTodoStorage!
    
    override func setUpWithError() throws {
        sut = StubTodoStorage()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTodoStorage() {
        let item = TodoItem.mock()
        print(item)
        sut.save(item: item)
        
        let list = sut.fetchAll()
        print(list)
        XCTAssertEqual(item.id, list[0].id)
        XCTAssertEqual(item.date, list[0].date)
        XCTAssertEqual(item.content, list[0].content)
        
        sut.deleteAll()
        
        let list2 = sut.fetchAll()
        print(list2)
        XCTAssertNil(list2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
