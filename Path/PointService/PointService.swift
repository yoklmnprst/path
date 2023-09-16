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


enum NetworkServiceError: Error {
    case `internal`(Error)
    case timeout
    case noConnection
    case cancelled
}

struct Point: Decodable, Equatable {
    var x: Float
    var y: Float
}

protocol IPointService {
    func points(_ count: UInt) async throws -> [Point]
}

final class SortedPointService: IPointService {
    let pointService: IPointService
    let sortingStrategy: (Point, Point) -> Bool
    
    init(_ pointService: IPointService, by sortingStrategy: @escaping (Point, Point) -> Bool) {
        self.pointService = pointService
        self.sortingStrategy = sortingStrategy
    }
    
    func points(_ count: UInt) async throws -> [Point] {
        let result = try await pointService.points(count)
       
        return result.sorted(by: sortingStrategy)
    }
}

typealias URLSubpathString = String

private extension URLSubpathString {
    static let points = "points"
    static let count = "count"
}

// better to split for test purposes
final class PointService: IPointService {
    let executor: IHTTPRequester
    
    init(_ executor: IHTTPRequester) {
        self.executor = executor
    }
    
    func points(_ count: UInt) async throws -> [Point] {
        do {
            let request = Request(serviceName: .points, parameters: [URLSubpathString.count : count])
            let data = try await executor.execute(request)
           
            let decoder = JSONDecoder()

            struct PointsResponse: Decodable {
                var points: [Point]
            }
            
            let response = try decoder.decode(PointsResponse.self, from: data)
            
            return response.points
        } catch let httpStatusError as HTTPStatusError {
            throw NetworkServiceError.internal(httpStatusError)
        } catch {
            let nserror = error as NSError
            switch (nserror.domain, nserror.code) {
            case (NSURLErrorDomain, NSURLErrorTimedOut):
                throw NetworkServiceError.timeout
            case (NSURLErrorDomain, NSURLErrorNotConnectedToInternet):
                throw NetworkServiceError.noConnection
            case (NSURLErrorDomain, NSURLErrorCancelled):
                throw NetworkServiceError.cancelled
            default:
                throw NetworkServiceError.internal(nserror)
            }
        }
    }
}


private extension UInt {
    static let defaultPointCountMaxLimit: UInt = 1000
}


final class RandomPointService: IPointService {
    private let randomGenerator: RandomNumberGenerator
    private let xrange: ClosedRange<Float> = -1000.0...1000.0
    private let yrange: ClosedRange<Float> = -1000.0...1000.0
    private let countMaxLimit: UInt = .defaultPointCountMaxLimit

    init(randomGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomGenerator = randomGenerator
    }

    func points(_ count: UInt) async throws -> [Point] {
        guard 1...countMaxLimit ~= count else {
            // simulate the backend error
            throw NetworkServiceError.internal(
                HTTPStatusError(errorCode: 500, responseInfo: URLResponse(), data: Data())
            )
        }
        
        // simulate network request delay
        // random delay between 1 and 2 sec:
        let delay = Float.random(in: 1...2)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        var randomGenerator = self.randomGenerator
        var randomPoints = [Point]()

        for _ in 0..<count {
            let x = Float.random(in: xrange, using: &randomGenerator)
            let y = Float.random(in: yrange, using: &randomGenerator)
            let point = Point(x: x, y: y)
            randomPoints.append(point)
        }

        return randomPoints
    }
}
