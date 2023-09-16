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
    static let defaultHiddenBehindEdge: CGFloat = 20
    static let defaultBottomEdgeOffset: CGFloat = 20
    static let defaultNoActionMoveBack: CGFloat = 5
}

struct SidePullButton<Label: View>: View {
    private var hiddenBehindEdge: CGFloat
    private var bottomEdgeOffset: CGFloat
    private var action: () -> Void
    private var label: Label
    @State private var offset: CGFloat = 0
    
    init(hiddenBehindEdge: CGFloat = .defaultHiddenBehindEdge,
         bottomEdgeOffset: CGFloat = .defaultBottomEdgeOffset,
         action: @escaping () -> Void,
         @ViewBuilder label: () -> Label) {
        self.label = label()
        self.hiddenBehindEdge = hiddenBehindEdge
        self.bottomEdgeOffset = bottomEdgeOffset
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            
            HStack(spacing: 0) {
                label
                    .offset(x: offset - hiddenBehindEdge, y: -1 * bottomEdgeOffset)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width > 0 {
                                let newOffset = gesture.translation.width
                                if newOffset <= hiddenBehindEdge {
                                    $offset.wrappedValue = newOffset
                                }
                            }
                        }
                        .onEnded { gesture in
                            if gesture.translation.width > .defaultNoActionMoveBack {
                                action()
                            }
                            $offset.wrappedValue = 0
                        }
                    )
                
                Spacer()
            }
        }
    }
}

