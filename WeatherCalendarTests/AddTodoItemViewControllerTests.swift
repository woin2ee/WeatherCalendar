//
//  AddTodoItemViewControllerTests.swift
//  AddTodoItemViewControllerTests
//
//  Created by Jaewon on 2022/05/21.
//

import XCTest
@testable import WeatherCalendar

class AddTodoItemViewControllerTests: XCTestCase {

    func makeSUT() -> AddTodoItemViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "AddTodoItemViewController") as! AddTodoItemViewController

        sut.loadViewIfNeeded()
        return sut
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoad() throws {
        // Arrange
        let sut = makeSUT()
        
        // Action
        sut.viewDidLoad()
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    func testDismissButton() {
        let sut = makeSUT()
        
        sut.dismissModal(sut)
    }
    
    func testAddTodoItemButton() {
        let sut = makeSUT()
        
        sut.addTodoItem(sut)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
