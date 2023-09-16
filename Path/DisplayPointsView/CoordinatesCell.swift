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


private extension CGFloat {
    static let rightSpaceXY: CGFloat = 80
    static let rightShiftY: CGFloat = 50
    static let rightShiftX: CGFloat = .rightSpaceXY + .rightShiftY
}

struct CoordinatesCell: View {
    var index: Int
    var x: String
    var y: String
    
    var isHeader: Bool {
        index == 0
    }
    
    func baseColor(inverted: Bool = false) -> Color {
        return (index + (inverted ? 1 : 0)).isMultiple(of: 2)
            ? Color.customDarkGreen
            : Color.customLightGreen
    }
    
    var body: some View {
        ZStack {
            if !isHeader {
                HStack(spacing: 0) {
                    Text(String(index))
                        .foregroundColor(baseColor(inverted: true))
                    Spacer()
                }
            }
            HStack(spacing: 0) {
                Spacer()
                Text(x)
                    .fontWeight(isHeader ? .bold : .regular)
                Spacer()
                    .frame(width: .rightShiftX)
            }
            HStack(spacing: 0) {
                Spacer()
                Text(y)
                    .fontWeight(isHeader ? .bold : .regular)
                Spacer()
                    .frame(width: .rightShiftY)
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(baseColor())
    }
}


