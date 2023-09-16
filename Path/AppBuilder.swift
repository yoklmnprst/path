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

import Foundation

private extension TimeInterval {
    static let defaultNetworkTimeout: TimeInterval = 20
}

private extension String {
    static let mainBackend: String = "https://__backend_is_here__"
}


// small number costructs in the container, so it will be only one
final class DisplayPointsBuilder: ObservableObject {

    @MainActor
    func build() -> DisplayPoints {
        return DisplayPoints()
    }
}


// small number costructs in the container, so it will be only one
final class InputPointsBuilder: ObservableObject {
    
    lazy var backendURL: URL = {
        URL(string: .mainBackend) ?? NSURL() as URL
    }()
    
    lazy var testURL: URL = {
        URL(string: .mainBackend) ?? NSURL() as URL
    }()
    
    lazy var urlSessionConfiguration: URLSessionConfiguration = {
        let timeoutInterval: TimeInterval = .defaultNetworkTimeout
        var urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForResource = timeoutInterval
        return urlSessionConfiguration
    }()
    
    lazy var urlSession: IURLSession = {
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    lazy var httpRequester: IHTTPRequester = {
        let httpRequester = HTTPRequester(url: backendURL, session: urlSession)
        
        return httpRequester
    }()
    
    lazy var pointService: IPointService = {
        return SortedPointService(RandomPointService()) {
            $0.x <= $1.x
        }

        // To demonstrate the app without a configured backend, the lines below are commented out. Uncomment them to work with a configured backend.
        // let pointService = PointService(httpRequester)
        // return SortedPointService(pointService)
    }()

    @MainActor
    func build() -> InputPoints {
        return InputPoints(pointService: pointService)
    }
}


final class ProcessPointBuilder: ObservableObject {
    
    lazy var inputPointsBuilder: InputPointsBuilder = InputPointsBuilder()
    lazy var displayPointsBuilder: DisplayPointsBuilder = DisplayPointsBuilder()
    
    @MainActor
    func build() -> ProcessPoints {
        return ProcessPoints(inputPoints: inputPointsBuilder.build(),
                             displayPoints: displayPointsBuilder.build())
    }
}
