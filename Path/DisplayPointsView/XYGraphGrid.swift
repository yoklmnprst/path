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


struct XYGraphGrid: View {
    var animationNamespace: Namespace.ID
    @Binding var points: GraphPoints
    var format: Formatter
    
    init(animationNamespace: Namespace.ID,
         points: Binding<GraphPoints>,
         format: Formatter) {
        self.animationNamespace = animationNamespace
        self._points = points
        self.format = format
    }
    
    var body: some View {
        XYGrid(yrange: $points.boundingRect.y,
               xrange: $points.boundingRect.x,
               format: format,
               namespace: animationNamespace) {
            if points.count == 0 {
                // nothing
                EmptyView()
            } else if points.count == 1 {
                Circle()
                    .stroke(Color.customPink)
                    .background(Color.customPink)
                    .frame(width: 3, height: 3)
            } else {
                GraphShape(points: $points)
                    .stroke(Color.customPink, lineWidth: 1)
                    .scaleEffect(x: 1, y: -1)
            }
        }
    }
}
