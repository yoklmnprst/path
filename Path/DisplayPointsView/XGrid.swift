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


struct XGrid<ContentView: View>: View, EnvironmentHidableInTransitionAnimation {
    @Binding var xrange: ClosedRange<Float>
    var format: Formatter
    var namespace: Namespace.ID
    
    @EnvironmentObject @SimpleObservable
    var isHiddenInTransitionAnimation: Bool
    
    let font: CTFont
    let contentView: ContentView
    
    @State var zoomOffset: ZoomOffset =
        .init(offset: 0.0,
              latestFixedZoom: 1.0,
              activeZoom: 1.0)
        
    let columns:UInt = 4
    let rows:UInt = 4
    let spaceYAxe: CGFloat = 4
    
    let activeZoomRange: ClosedRange<CGFloat> = 1.0...100.0
    
    init(xrange: Binding<ClosedRange<Float>>,
        format: Formatter,
         namespace: Namespace.ID,
         font: CTFont,
         contentView: @escaping () -> ContentView) {
        self._xrange = xrange
        self.format = format
        self.namespace = namespace
        self.font = font
        self.contentView = contentView()
    }

    
    @State var scale: CGFloat = 1.0
    @State var offset: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            let changedColumns = zoomOffset.zoomedSegments(columns)
            
            ZStack {
                Grid(columns: changedColumns, rows: rows)
                    .stroke(Color.customDarkYellow, lineWidth: 1)
                if !isHiddenInTransitionAnimation {
                    contentView
                }
            }
            .modifier(HorizontalPanPinchRecognizer(zoomOffset: $zoomOffset, activeZoomRange: activeZoomRange))
            .clipped()
            .modifier(FlatColorStyle(background: .customYellow, radius: true))
            .matchedGeometryEffect(id: ID.topGeometry, in: namespace)
            
            Spacer().frame(height: spaceYAxe)
            
            XAxis(data: $zoomOffset,
                          range: xrange,
                          segments: changedColumns,
                          format: format,
                          font: font)
            .opacity((!isHiddenInTransitionAnimation).toNum())
                
            Spacer().layoutPriority(-.greatestFiniteMagnitude) // GeometryReader bugaround
            
        }
    }
}


