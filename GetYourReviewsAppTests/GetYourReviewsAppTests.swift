//
//  GetYourReviewsAppTests.swift
//  GetYourReviewsAppTests
//
//  Created by Smriti on 01.12.20.
//

import XCTest
@testable import GetYourReviewsApp

class GetYourReviewsAppTests: XCTestCase {
    var offset = 0
    var limit = 0
    let pagination = true
    let sortOption = "rating"


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReviewViewModel()  {
        let review = Review(id: 1, author: Author(fullName: "Sam", country: "UnitedStates"), title: "My first Review", message: "Good", rating: 5, created: "2020-02-17T15:52:22+01:00", language: "en")
        let reviewViewModel = ReviewViewModel(review: review)
        XCTAssertEqual(review.author?.fullName, reviewViewModel.author?.fullName)
    }

    func testDateFormatter(){
        let validDate = "2020-02-17T15:52:22+01:00"
        let inValidDate = "XYZ"
        XCTAssertNoThrow(validDate.dateFromStr)
        XCTAssertEqual(validDate.dateFromStr, "17-2-2020")
        XCTAssertEqual(inValidDate.dateFromStr,"")
    }
    
    fileprivate func callApiwithInputs(_ pagination: Bool,_ sortOption:String, _ limit: Int, _ offset: Int, _ expectation: XCTestExpectation) {
        ReviewService().fetchReviewsFor(pagination: pagination,sortOption:sortOption ,limit: limit, offset: offset, completion: { result in
            
            switch result{
            case .success(let reviewObj):
                XCTAssertNotNil(reviewObj)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
            
        })
    }
    
    func testReviewServiceAPIwithInValidInput(){
        let expectation = self.expectation(description: "TestAPIWithValidParam")
        callApiwithInputs(pagination,sortOption, limit, offset, expectation)
        waitForExpectations(timeout: 10)
        
    }

    func testReviewServiceAPIwithValidInput(){
        let expectation = self.expectation(description: "TestAPIWithValidParam")
        offset = 10
        limit = 10
        callApiwithInputs(pagination,sortOption, limit, offset, expectation)
        waitForExpectations(timeout: 10)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
