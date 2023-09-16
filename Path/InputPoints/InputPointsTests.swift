/*
 
 MIT License

 Copyright (c) 2023 Andrey Yo

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import XCTest
@testable import Path


final class InputPointsTests: XCTestCase {
    var pointService: PointServiceMock!
    var inputPointsDelegate: InputPointsDelegateMock!

    @MainActor override func setUp() {
        pointService = PointServiceMock()
        inputPointsDelegate = InputPointsDelegateMock()
        super.setUp()
    }

    override func tearDown() {
        pointService = nil
        inputPointsDelegate = nil
        super.tearDown()
    }

    @MainActor
    func test_some_points_received() async throws {
        // Given
        let pointsReceived = [Point(x: 1, y: 2), Point(x: 3, y: 4)]
        pointService.output = pointsReceived
        
        let inputPoints = InputPoints(pointService: pointService)
        inputPoints.delegate = inputPointsDelegate
        inputPoints.isLoading = false
        inputPoints.errorMessage = nil
        inputPoints.inputPointsCount = "2"
        
        // When
        await inputPoints.inputPointsCountAction()?.value
        
        // Then
        XCTAssertEqual(inputPointsDelegate.input, pointsReceived)
        XCTAssertEqual(inputPoints.isLoading, false)
    }
    
    @MainActor
    func test_incorrect_input() async throws {
        // Given
        pointService.output = nil
        
        let inputPoints = InputPoints(pointService: pointService)
        inputPoints.delegate = inputPointsDelegate
        inputPoints.isLoading = false
        inputPoints.errorMessage = nil
        inputPoints.inputPointsCount = "0"
        
        // When
        await inputPoints.inputPointsCountAction()?.value
        
        // Then
        XCTAssertEqual(inputPointsDelegate.input, nil)
        if case .incorrectInput = inputPoints.errorMessage {
            //ok
        } else {
            XCTFail()
        }
    }

}

