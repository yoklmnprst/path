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


final class HTTPRequesterTests: XCTestCase {
    var session: URLSessionMock!
    
    override func setUp() {
        session = URLSessionMock()
    }

    override func tearDown() {
        session = nil
        super.tearDown()
    }
    
    func test_request_with_no_params() async throws {
        // Given
        let backend: String = "http://test.com"
        let backendURL = URL(string: backend)!
        let service: String = "service"
        let inputRequest = Request(serviceName: service)
        
        let outputResponse: URLResponse = HTTPURLResponse(url: backendURL,
                                                          statusCode: .ok,
                                                          httpVersion: nil,
                                                          headerFields: nil)!
        let outputData = Data()
        session.output = (outputData, outputResponse)
        
        let httpRequester = HTTPRequester(url: backendURL, session: session)
        
        // When
        let _ = try await httpRequester.execute(inputRequest)
        
        // Then
        XCTAssertEqual(session.input!.url!.absoluteString, "http://test.com/service")
    }
    
    func test_request_with_1_param() async throws {
        // Given
        let backend: String = "http://test.com"
        let service: String = "service"
        let backendURL = URL(string: backend)!
        let inputRequest = Request(serviceName: service, parameters: ["one": 1])
        
        let outputResponse: URLResponse = HTTPURLResponse(url: backendURL,
                                                          statusCode: .ok,
                                                          httpVersion: nil,
                                                          headerFields: nil)!
        let outputData = Data()
        session.output = (outputData, outputResponse)
        
        let httpRequester = HTTPRequester(url: backendURL, session: session)
        
        // When
        let _ = try await httpRequester.execute(inputRequest)
        
        // Then
        XCTAssertEqual(session.input!.url!.absoluteString, "http://test.com/service?one=1")
    }
    
    func test_request_with_2_param() async throws {
        // Given
        let backend: String = "http://test.com"
        let service: String = "service"
        let backendURL = URL(string: backend)!
        let inputRequest = Request(serviceName: service,
                                   parameters: [
                                    "one": "cat",
                                    "two": "dog"
                                   ])
        
        let outputResponse: URLResponse = HTTPURLResponse(url: backendURL,
                                                          statusCode: .ok,
                                                          httpVersion: nil,
                                                          headerFields: nil)!
        let outputData = Data()
        session.output = (outputData, outputResponse)
        
        let httpRequester = HTTPRequester(url: backendURL, session: session)
        
        // When
        let _ = try await httpRequester.execute(inputRequest)
        
        // Then
        let case1: Bool = "http://test.com/service?one=cat&two=dog" == session.input!.url!.absoluteString
        let case2: Bool = "http://test.com/service?two=dog&one=cat" == session.input!.url!.absoluteString
        XCTAssertTrue(case1 || case2)
    }



}
