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


/*
 0.5 -> ?
*1   -> 1
 1.5 -> 1
*2   -> 2
 2.5 -> 2
 3   -> 4
*4   -> 4
 5   -> 4
 6   -> 8
*8   -> 8
 */

func n2nearest(_ f: Float) -> UInt {
    let n = Int(log2(f).rounded())
    if n < 0 {
        return 1
    } else {
        return UInt(pow(2, Double(n)))
    }
}

extension Color {
    static let customLightYellow = Color(rgb: 0x0bd1ff)
    static let customDarkYellow = Color(rgb: 0xe8b829)
    static let customPink = Color(rgb: 0x9931dd)
}

struct XYGrid<ContentView: View>: View, EnvironmentHidableInTransitionAnimation {
    @Binding var yrange: ClosedRange<Float>
    @Binding var xrange: ClosedRange<Float>
    var format: Formatter
    
    var namespace: Namespace.ID
    var contentView: ContentView
    
    @EnvironmentObject @SimpleObservable
    var isHiddenInTransitionAnimation: Bool
    
    var defaultFont: CTFont {
        return CTFontCreateWithName("Helvetica" as CFString, 12, nil)
    }
    let spaceXAxe: CGFloat = 4
    let spaceYAxe: CGFloat = 4
    let rows:UInt = 4

    init(yrange: Binding<ClosedRange<Float>>,
         xrange: Binding<ClosedRange<Float>>,
         format: Formatter, namespace: Namespace.ID,
         @ViewBuilder contentView: @escaping () -> ContentView) {
        self._yrange = yrange
        self._xrange = xrange
        self.format = format
        self.namespace = namespace
        self.contentView = contentView()
    }

    var body: some View {
        HStack(spacing: spaceXAxe) {
            
            YAxis(range: $yrange,
                  segments: rows,
                  bottomHeight: spaceYAxe + defaultFont.digitHeight(),
                  format: format,
                  font: defaultFont)
            .opacity((!isHiddenInTransitionAnimation).toNum())
            
            XGrid(xrange: $xrange,
                  format: format,
                  namespace: namespace,
                  font: defaultFont) {
                contentView
            }
        }
    }
}




