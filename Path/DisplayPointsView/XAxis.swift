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


struct XAxisEmpty: View {
    var font: CTFont
    
    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 0) {
                Text(verbatim: "")
                    .lineLimit(1)
                    .font(.init(font))
                    .fixedSize()
                    .opacity(0)
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
}


struct XAxis: View {
    @Binding var data: ZoomOffset
   
    var range: ClosedRange<Float>
    var segments: UInt // assert(lines >= 1)
    var format: Formatter
    var font: CTFont
    
    
    private var lines: UInt {
        let result = segments+1
        assert(result >= 2)
        return result
    }
    
    private var labels: [String] {
        let labelNumbers: [Float] = range.strideThrough(count: segments).map { $0 }
        var result = labelNumbers.map { format.string(for: $0) ?? "" }
        if result.count < lines {
            let emptyLabelsCount = lines-UInt(result.count)
            for _ in 0..<emptyLabelsCount {
                result.append("")
            }
        }
        
        return result
    }
    
    var body: some View {
        let labels = self.labels
       
        GeometryReader { geometry in
            let step: CGFloat = data.activeZoom * (geometry.size.width) / CGFloat(segments)
            let invisibleLeftCount: UInt = UInt((abs(min(data.offset, 0)) / step).rounded(.towardZero))
            let firstVisible: UInt = invisibleLeftCount
            let offsetWithoutInvisible: CGFloat = data.offset + CGFloat(invisibleLeftCount) * step
            
            let lastVisible: UInt = firstVisible + UInt((abs(geometry.size.width) / step).rounded(.towardZero)) + 1
            
            // Should be LazyHStack, but SwiftUI shows bug here with random layout calculating sometimes.
            // So we will do lazy manually with firstVisible and lastVisible indicies:
            HStack(spacing: 0) {
                let lastVisible_safe = min(lastVisible+1, lines)
                let firstVisible_safe = min(firstVisible, lastVisible_safe)
                ForEach(firstVisible_safe..<lastVisible_safe, id: \.self) { i in
                    Text(verbatim: labels[Int(i)])
                        .lineLimit(1)
                        .font(.init(font))
                        .fixedSize()
                        .frame(width: step)
                }
            }
            .offset(x: -step/2)
            .offset(x: offsetWithoutInvisible)
        }.fixedSize(horizontal: false, vertical: true)

    }
}
