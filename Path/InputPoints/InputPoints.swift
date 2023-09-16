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


typealias LocalizedString = String

private extension LocalizedString {
    static let incorrectPointsCountInput = "incorrect_points_count_input"
    static let timeoutErrorMessage = "timeout_error_message"
    static let noConnectionErrorMessage = "no_connection_error_message"
    static let cancelledResponseErrorMessage = "cancelled_response_error_message"
    static let internalErrorMessage = "internal_error_message"
}

private extension Int {
    static let maxAlertMessageLength = 200
}

@MainActor
protocol InputPointsDelegate: AnyObject {
    func inputPoints(_ inputPoints: InputPoints, displayPoints points: [Point])
}

@MainActor
final class InputPoints: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: ErrorMessage? = nil {
        didSet {
            isErrorMessage = (errorMessage != nil)
        }
    }
    @Published var isErrorMessage: Bool = false
    @Published var inputPointsCount: String = ""
    
    let pointService: IPointService
    weak var delegate: InputPointsDelegate?
    
    init(pointService: IPointService) {
        self.pointService = pointService
    }

    private func inLoading(_ block: () async -> Void) async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        await block()
    }
   
    func inputPointsCountAction_() async {
        await inLoading {
            guard let pointsCount = UInt(inputPointsCount),
                  pointsCount > 0
            else {
                errorMessage = .incorrectInput
                return
            }
            do {
                let points = try await pointService.points(pointsCount)
                delegate?.inputPoints(self, displayPoints: points)
            } catch {
                if let serviceError = error as? NetworkServiceError {
                    errorMessage = .networkServiceError(serviceError)
                } else {
                    // unreachable case
                    print("unreachable branch: \(type(of: error))")
                    errorMessage = .incorrectInput
                }
            }
        }
    }
    
    // result Task is needed for testing purposes
    @discardableResult
    func inputPointsCountAction() -> Task<(), Never>? {
        return Task { @MainActor in
            await self.inputPointsCountAction_()
        }
    }
    
    enum ErrorMessage: LocalizedError {
        case incorrectInput
        case networkServiceError(NetworkServiceError)

        var errorDescription: String? {
            switch self {
                
            case .incorrectInput:
                return NSLocalizedString(.incorrectPointsCountInput)
                
            case .networkServiceError(.timeout):
                return NSLocalizedString(.timeoutErrorMessage)
                
            case .networkServiceError(.noConnection):
                return NSLocalizedString(.noConnectionErrorMessage)
                
            case .networkServiceError(.cancelled):
                return NSLocalizedString(.cancelledResponseErrorMessage)
                
            case .networkServiceError(.internal(let httpStatusError as HTTPStatusError)):
                var internalErrorMessage = NSLocalizedString(.internalErrorMessage)
                if let responseMessage = String(data: httpStatusError.data, encoding: .utf8),
                   responseMessage.count < .maxAlertMessageLength
                {
                    internalErrorMessage += " " + responseMessage.parenthesized
                }
                return internalErrorMessage
                
            case .networkServiceError(.internal(let underlyingNSError as NSError)):
                var internalErrorMessage = NSLocalizedString(.internalErrorMessage)
                if underlyingNSError.localizedDescription.count < .maxAlertMessageLength {
                    internalErrorMessage += " " + underlyingNSError.localizedDescription.parenthesized
                }
                return internalErrorMessage
            }
        }


    }
}

