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
import UIKit


struct ZoomOffset {
    var offset: CGFloat
    var latestFixedZoom: CGFloat
    var activeZoom: CGFloat
}

extension CGSize {
    func zoomed(width widthZoom: CGFloat = 1.0,
                height heightZoom: CGFloat = 1.0) -> CGSize {
        CGSize(width: width * widthZoom, height: height * heightZoom)
    }
}

extension ZoomOffset {
    func zoomedSegments(_ segments: UInt) -> UInt {
        return segments * n2nearest(Float(latestFixedZoom))
    }
}

// use as .modifier(HorizontalPanPinchRecognizer(...))
struct HorizontalPanPinchRecognizer: ViewModifier {
    @Binding var zoomOffset: ZoomOffset
    let activeZoomRange: ClosedRange<CGFloat>
    // is not really range, but it is used in a similar manner
    let activeOffsetRange: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    func body(content contentView: Content) -> some View {
        GeometryReader { geometry in
            let contentSize = geometry.size.zoomed(width: zoomOffset.activeZoom)
            let gridWidth = geometry.size.width
            let gridHeight = geometry.size.height
            
            ZStack(alignment: .topLeading) {
                HorizontalPanPinch(zoomOffset: $zoomOffset,
                                   activeZoomRange: activeZoomRange,
                                   activeOffsetRange: activeOffsetRange,
                                   contentSize: contentSize)
                .frame(width: gridWidth, height: gridHeight)
                
                contentView
                    .frame(width: contentSize.width, height: contentSize.height)
                    .offset(x: zoomOffset.offset)
                    .animation(.default, value: zoomOffset.activeZoom)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - implementation details

struct HorizontalPanPinch: UIViewRepresentable {
    @Binding var zoomOffset: ZoomOffset
    let activeZoomRange: ClosedRange<CGFloat>
    let activeOffsetRange: UIEdgeInsets
    let contentSize: CGSize
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = activeZoomRange.lowerBound
        scrollView.maximumZoomScale = activeZoomRange.upperBound
        scrollView.contentInset = activeOffsetRange
        
        let contentView = context.coordinator.contentView
        contentView.backgroundColor = UIColor.clear
        scrollView.addSubview(contentView)
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        scrollView.contentSize = contentSize
        context.coordinator.contentView.frame = CGRect(origin: .zero, size: contentSize)
    }
    
    func makeCoordinator() -> ScrollViewDelegate {
        return ScrollViewDelegate(self)
    }
}

extension CGFloat {
    // bugaround with animation, look below
    static let invisibleChange: CGFloat = 0.00000001
}

final class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var parent: HorizontalPanPinch
    var contentView = UIView()

    init(_ parent: HorizontalPanPinch) {
        self.parent = parent
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let newFixedScale = scale + .invisibleChange // bugaround with animation at the end of zooming
        var newData: ZoomOffset = parent.zoomOffset
        newData.activeZoom = newFixedScale
        newData.latestFixedZoom = newFixedScale
        
        // like is in scrollViewDidScroll case? should be?
        //DispatchQueue.main.async { [parent, newData] in
            parent.zoomOffset = newData
        //}
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var newData = parent.zoomOffset
        newData.offset = -scrollView.contentOffset.x
        newData.activeZoom = scrollView.zoomScale
        newData.latestFixedZoom = scrollView.zoomScale
        
        DispatchQueue.main.async { [parent, newData] in
            // Modifing state during view update, this will cause undefined behaviour
            parent.zoomOffset = newData
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var newData = parent.zoomOffset
        newData.activeZoom = scrollView.zoomScale
        newData.offset = -scrollView.contentOffset.x
       
        // like is in scrollViewDidScroll case? should be?
        //DispatchQueue.main.async { [parent, newData] in
            parent.zoomOffset = newData
        //}
    }
    
}
