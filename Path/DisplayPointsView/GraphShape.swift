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


struct GraphShape: Shape {
    @Binding var points: GraphPoints
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rectTransform: (Point) -> CGPoint = { (p: Point) in
            return CGPoint(
                x: rect.origin.x + CGFloat(p.x - points.boundingRect.x.lowerBound) * rect.size.width / CGFloat(points.boundingRect.x.length),
                y: rect.origin.y + CGFloat(p.y - points.boundingRect.y.lowerBound) * rect.size.height / CGFloat(points.boundingRect.y.length)
            )
        }
                
        if let firstPoint = points.first {
            path.move(to: rectTransform(firstPoint))
            
            for i in 1..<points.count {
                path.addLine(to: rectTransform(points[i]))
            }
        }
        
        return path
    }
}


