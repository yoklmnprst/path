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

import SwiftUI


private extension String {
    static let titleX: String = "X"
    static let titleY: String = "Y"
}

struct PointsList: View, EnvironmentHidableInTransitionAnimation {
    @Binding var points: GraphPoints
    var format: Formatter
    
    @EnvironmentObject @SimpleObservable
    var isHiddenInTransitionAnimation: Bool
    
    var body: some View {
        List {
            CoordinatesCell(index: 0, x: .titleX, y: .titleY)
                .opacity((!isHiddenInTransitionAnimation).toNum())
        
            ForEach(0..<points.count, id: \.self) { i in
                CoordinatesCell(
                    index: i+1,
                    x: format.string(for: points[i].x) ?? "",
                    y: format.string(for: points[i].y) ?? ""
                )
                .opacity((!isHiddenInTransitionAnimation).toNum())
            }
        }
    }
}

