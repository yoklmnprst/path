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


struct Rect<T: Comparable> {
    var x: ClosedRange<T>
    var y: ClosedRange<T>
}

struct GraphPoints: RandomAccessCollection {
    
    var content: [Point]
    
    var boundingRect: Rect<Float>
    
    init(_ points: [Point]) {
        self.content = points
        self.boundingRect = points.displayBoundingRect
    }
    
    // MARK: RandomAccessCollection:
    
    var startIndex: Int {
        content.startIndex
    }
    
    var endIndex: Int {
        content.endIndex
    }
    
    // Array subscripting
    
    subscript(index: Int) -> Point {
        get { content[index] }
        set { content[index] = newValue }
    }
    
}

// MARK: bounding rect

extension Array where Element == Point {
    
    var boundingRect: Rect<Float> {
        let points = self
        if let firstPoint = points.first {
            var minX = firstPoint.x
            var maxX = firstPoint.x
            var minY = firstPoint.y
            var maxY = firstPoint.y
            
            for i in 1..<points.count {
                if points[i].x > maxX {
                    maxX = points[i].x
                }
                if points[i].x < minX {
                    minX = points[i].x
                }
                if points[i].y > maxY {
                    maxY = points[i].y
                }
                if points[i].y < minY {
                    minY = points[i].y
                }
            }
            
            return Rect(x: minX...maxX, y: minY...maxY)
        }
        
        return Rect(x: 0...0, y: 0...0)
    }
    
    var displayBoundingRect: Rect<Float> {
        let points = self
        var boundingRect: Rect<Float>
        if points.count == 0 {
            boundingRect = Rect(x: 0...1, y: 0...1)
        } else if points.count == 1 {
            let eps: Float = 1
            let xo = points.first!.x
            let yo = points.first!.y
            boundingRect = Rect(x: xo-eps...xo+eps, y: yo-eps...yo+eps)
        } else {
            boundingRect = points.boundingRect
        }
        return boundingRect
    }

}
