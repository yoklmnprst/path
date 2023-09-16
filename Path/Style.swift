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
import SwiftUI

extension Color {
    static let customBlue = Color(rgb: 0x317bff)
    static let customYellow = Color(rgb: 0xf8d839)
    static let borderColor = Color(rgb: 0x0f1558)
}

extension Color {
    static let customLightGreen = Color(rgb: 0x00d9b9)
    static let customDarkGreen = Color(rgb: 0x02ccaf)
    static let customCyan = Color(rgb: 0x0db1ff)
}

extension CGFloat {
    static let borderWidth: CGFloat = 3
}

struct FlatColorStyle: ViewModifier {
    let backgroundColor: Color
    let radius: Bool
    let borderColor: Color = .borderColor
    let cornerRadius: CGFloat = .borderWidth
    let borderWidth: CGFloat = .borderWidth
    
    init(background backgroundColor: Color, radius: Bool = false) {
        self.backgroundColor = backgroundColor
        self.radius = radius
    }

    func body(content: Content) -> some View {
        if (radius) {
            content
                .background(backgroundColor)
                .border(borderColor, width: .borderWidth)
                .cornerRadius(cornerRadius, antialiased: true)
        } else {
            content
                .background(backgroundColor)
                .border(borderColor, width: .borderWidth)
        }
    }
}
