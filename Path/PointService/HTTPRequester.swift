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


private extension Int {
    static let unknown = -1
    static let ok = 200
}

struct Request {
    enum MethodType {
        case get
    }
    
    var methodType: MethodType = .get
    var serviceName: String
    var parameters: [AnyHashable: Any] = [:]
}

@dynamicMemberLookup
struct HTTPStatusError: CustomNSError {
    static var errorDomain: String { NSURLErrorDomain }
    var errorCode: Int
    var responseInfo: URLResponse
    var data: Data

    var errorUserInfo: [String : Any] = [:]
    subscript(dynamicMember key: String) -> Any? {
        get {
            return errorUserInfo[key]
        }
        set {
            errorUserInfo[key] = newValue
        }
    }
}

private extension Int {
    static let requestMethodTypeNotSupported = 1
    static let malformedURL = 2
}

extension NSError {
    static let requestMethodTypeNotSupported =  NSError(domain: NSURLErrorDomain, code: .requestMethodTypeNotSupported)
    static let malformedURL = NSError(domain: NSURLErrorDomain, code: .malformedURL)
}

extension NSError: CustomNSError {}

protocol IHTTPRequester {
    func execute(_ request: Request) async throws -> Data
}

// throws CustomNSError (HTTPStatusError or NSError)
final class HTTPRequester: IHTTPRequester {
    var url: URL
    var session: IURLSession
    
    init(url: URL, session: IURLSession) {
        self.url = url
        self.session = session
    }
    
    func execute(_ request: Request) async throws -> Data {
        guard request.methodType == .get else {
            throw NSError.requestMethodTypeNotSupported
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NSError.malformedURL
        }
        
        urlComponents.path += "/" + request.serviceName
        if !request.parameters.isEmpty {
            urlComponents.queryItems = request.parameters.map {
                URLQueryItem(name: "\($0.key)", value: "\($0.value)")
            }
        }
        
        guard let urlComponentsURL = urlComponents.url else {
            throw NSError.malformedURL
        }
        
        let requestURL = URLRequest(url: urlComponentsURL)
        
        let (data, response) = try await session.data(for: requestURL)
        
        let statusCode: Int = (response as? HTTPURLResponse)?.statusCode ?? .unknown
        
        if statusCode == .ok {
            return data
        } else {
            throw HTTPStatusError(errorCode: statusCode, responseInfo: response, data: data)
        }
    }
}
