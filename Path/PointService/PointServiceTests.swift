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

final class PointServiceTests: XCTestCase {
    var httpRequester: HTTPRequesterMock! = nil
    
    override func setUp() {
        httpRequester = HTTPRequesterMock()
        super.setUp()
    }

    override func tearDown() {
        httpRequester = nil
        super.tearDown()
    }

    func test_get_some_points() async throws {
        // Given
        let pointService = PointService(httpRequester)
        httpRequester.output = points100JSON.data(using: .utf8)!
        
        // When
        let resultPoints = try await pointService.points(100)
        
        // Then
        XCTAssert(httpRequester.input!.parameters[URLSubpathString.count] as! UInt == 100)
        XCTAssert(httpRequester.input!.serviceName == URLSubpathString.points)
        XCTAssert(resultPoints.count == 100)
    }
    
    func test_sorted_points() async throws {
        // Given
        let pointService = SortedPointService(PointService(httpRequester))
        httpRequester.output = points100JSON.data(using: .utf8)!
        
        // When
        let resultPoints = try await pointService.points(100)
        
        // Then
        for i in 1..<100 {
            XCTAssertTrue(resultPoints[i-1].x <= resultPoints[i].x)
        }
    }
}


 
let points100JSON: String = """
 {
   "points": [
     {
       "x": -58.88,
       "y": -3.76
     },
     {
       "x": 54.37,
       "y": 51.19
     },
     {
       "x": -18.3,
       "y": 12.54
     },
     {
       "x": -6.23,
       "y": -27.18
     },
     {
       "x": 47.91,
       "y": -5.28
     },
     {
       "x": -36.67,
       "y": 74.83
     },
     {
       "x": 43.08,
       "y": -81.64
     },
     {
       "x": -25.2,
       "y": -71.62
     },
     {
       "x": 66.46,
       "y": -50
     },
     {
       "x": 69.45,
       "y": -64.59
     },
     {
       "x": 30.38,
       "y": 9.17
     },
     {
       "x": 59.69,
       "y": -28.2
     },
     {
       "x": -15.81,
       "y": 73.01
     },
     {
       "x": 1.25,
       "y": 65.95
     },
     {
       "x": -31.74,
       "y": -42.95
     },
     {
       "x": -79.17,
       "y": 68.16
     },
     {
       "x": 10.37,
       "y": 7.28
     },
     {
       "x": -4.48,
       "y": 5.08
     },
     {
       "x": -37.34,
       "y": 81.9
     },
     {
       "x": -36.2,
       "y": 13.82
     },
     {
       "x": -20.52,
       "y": -49.05
     },
     {
       "x": -55.59,
       "y": -51.32
     },
     {
       "x": -12.04,
       "y": 15.72
     },
     {
       "x": -28.59,
       "y": -49.75
     },
     {
       "x": -68.83,
       "y": -10.77
     },
     {
       "x": 17.65,
       "y": -53
     },
     {
       "x": -39.76,
       "y": -5.77
     },
     {
       "x": -91.32,
       "y": -11.67
     },
     {
       "x": -34.26,
       "y": -79.6
     },
     {
       "x": -43.2,
       "y": 18.67
     },
     {
       "x": -6.67,
       "y": -45.35
     },
     {
       "x": -40.55,
       "y": 4.99
     },
     {
       "x": 22.35,
       "y": 37.54
     },
     {
       "x": 42.91,
       "y": 66.48
     },
     {
       "x": 52.64,
       "y": 65.17
     },
     {
       "x": 44.39,
       "y": 67.12
     },
     {
       "x": -81.06,
       "y": 9.35
     },
     {
       "x": -22.03,
       "y": -35.22
     },
     {
       "x": -54.25,
       "y": 4.51
     },
     {
       "x": -12.83,
       "y": -31.03
     },
     {
       "x": -39.45,
       "y": -27.69
     },
     {
       "x": 37.88,
       "y": 30.57
     },
     {
       "x": -16.8,
       "y": 49.27
     },
     {
       "x": 84.71,
       "y": -68.51
     },
     {
       "x": 47.59,
       "y": -57.37
     },
     {
       "x": 48.8,
       "y": 55.2
     },
     {
       "x": -63.08,
       "y": -5.93
     },
     {
       "x": -49.36,
       "y": -4.73
     },
     {
       "x": -56.77,
       "y": -27.71
     },
     {
       "x": 83.07,
       "y": 65.92
     },
     {
       "x": 76.61,
       "y": -53.2
     },
     {
       "x": 51.72,
       "y": -50.8
     },
     {
       "x": -25.39,
       "y": 72.84
     },
     {
       "x": -63.86,
       "y": -47.09
     },
     {
       "x": -75.74,
       "y": 22.69
     },
     {
       "x": 11.82,
       "y": -26.11
     },
     {
       "x": -55.99,
       "y": 48.67
     },
     {
       "x": 68.18,
       "y": -10.4
     },
     {
       "x": -71.22,
       "y": -67.22
     },
     {
       "x": 31,
       "y": 84.95
     },
     {
       "x": -82.44,
       "y": 77.61
     },
     {
       "x": 22.71,
       "y": -1.34
     },
     {
       "x": -75.85,
       "y": 48.02
     },
     {
       "x": 78.38,
       "y": 75.07
     },
     {
       "x": -48.48,
       "y": -36.32
     },
     {
       "x": -21.59,
       "y": -32.91
     },
     {
       "x": 5.36,
       "y": 79.47
     },
     {
       "x": -62.82,
       "y": -67.68
     },
     {
       "x": -29.1,
       "y": -57.78
     },
     {
       "x": 71.4,
       "y": -41.25
     },
     {
       "x": 21.6,
       "y": -60.93
     },
     {
       "x": 9.72,
       "y": 11.85
     },
     {
       "x": -46.63,
       "y": -19.11
     },
     {
       "x": -13.51,
       "y": 17.81
     },
     {
       "x": -20.85,
       "y": 14.69
     },
     {
       "x": -57.06,
       "y": -43.06
     },
     {
       "x": -22.77,
       "y": 9.62
     },
     {
       "x": -20.26,
       "y": 27.02
     },
     {
       "x": 6.54,
       "y": 5.63
     },
     {
       "x": 80.23,
       "y": -24.74
     },
     {
       "x": 25.27,
       "y": -15.78
     },
     {
       "x": -87.23,
       "y": -51.52
     },
     {
       "x": -66.97,
       "y": 68.33
     },
     {
       "x": 73.45,
       "y": -78.55
     },
     {
       "x": -60.55,
       "y": -51.61
     },
     {
       "x": -36.88,
       "y": -23.49
     },
     {
       "x": -72.01,
       "y": 84.86
     },
     {
       "x": 15.07,
       "y": -77.91
     },
     {
       "x": -62.05,
       "y": 68.97
     },
     {
       "x": -28.14,
       "y": -56.82
     },
     {
       "x": 63.07,
       "y": 16.71
     },
     {
       "x": -73.74,
       "y": -37.18
     },
     {
       "x": -8.11,
       "y": 72.72
     },
     {
       "x": 54.21,
       "y": 44.03
     },
     {
       "x": 25.73,
       "y": 64.91
     },
     {
       "x": -89.69,
       "y": 61.54
     },
     {
       "x": -4.12,
       "y": 4.97
     },
     {
       "x": 55.66,
       "y": -35.37
     },
     {
       "x": -9.76,
       "y": 64.77
     },
     {
       "x": -31.37,
       "y": -40.2
     }
   ]
 }
"""

