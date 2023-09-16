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


struct YAxis: View {
    @Binding var range: ClosedRange<Float>
    var segments: UInt // assert(segments >= 1)
    
    var bottomHeight: CGFloat
    var format: Formatter
    var font: CTFont
    
    private var labels: [String] {
        let labelNumbers: [Float] = range.strideThrough(count:segments).reversed().map { $0 }
        var result = labelNumbers.map { format.string(for: $0) ?? "" }
        if result.count < lines {
            let emptyLabelsCount = lines-UInt(result.count)
            for _ in 0..<emptyLabelsCount {
                result.append("")
            }
        }
        
        return result
    }
    
    private var lines: UInt {
        let result = segments+1
        assert(result >= 2)
        return result
    }
    
    var body: some View {
        let labels = self.labels
        
        VGeometryReader { availableHeight  in
            // `minus font.digitHeight()` is needed
            // to avoid climbing on top of each two labels near 0 in X0Y
            // (one label near 0X and other near 0Y)
            let step = max(availableHeight - bottomHeight - font.digitHeight(), 0) / CGFloat(segments)

            VStack(alignment: .trailing, spacing: 0) {
                ForEach(0..<lines, id: \.self) { (i: UInt) in
                    Text(verbatim: labels[Int(i)])
                        .lineLimit(1)
                        .font(.init(font))
                        .frame(height: step)
                }
                // `plus font.digitHeight()/2` is needed
                // to avoid climbing on top of each two labels near 0 in X0Y
                // (one label near 0X and other near 0Y)
                Spacer().frame(width: 1, height: bottomHeight + font.digitHeight()/2)
            }
            // offset doesn't needed here, because
            // the content was already centered
            // (opposite to classic GeometryReader)
        }
    }
}






