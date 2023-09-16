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


private extension Int {
    // formatter constant
    static let defaultMaximumDigits: Int = 4
}

private extension EdgeInsets {
    static let axisGridPadding: EdgeInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 18)
}

private extension CGFloat {
    // list padding
    static let defaultSpace: CGFloat = 5
    static let defaultBottom: CGFloat = 15
    static let defaultTrailing: CGFloat = 18
    static let defaultLeading: CGFloat = pullButtonSafeArea
}

private extension CGFloat {
    static let pullButtonMaxWidth: CGFloat = 35
    static let pullButtonMinWidth: CGFloat = 20
    static let pullButtonDefaultHidden: CGFloat =  .pullButtonMaxWidth - .pullButtonMinWidth
   
    
    static let pullButtonFixedBottomOffset: CGFloat = 5
    static let pullButtonSafeArea: CGFloat = pullButtonMaxWidth + pullButtonFixedBottomOffset
}

private extension Animation {
    static let pullspring: Animation = .spring(response: 0.30, dampingFraction: 0.825, blendDuration: 0.0)
}

struct DisplayPointsView: View {
    var animationNamespace: Namespace.ID
    @ObservedObject var vm: DisplayPoints
    
    @EnvironmentObject @SimpleObservable
    private var isHiddenInTransitionAnimation: Bool
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass: UserInterfaceSizeClass?
    
    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
   
    var format: Formatter = {
        let x = NumberFormatter()
        x.maximumSignificantDigits = .defaultMaximumDigits
        // x.numberStyle = .scientific
        return x
    }()
    
    var body: some View {
        ZStack {
            Color.customBlue.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
               
                XYGraphGrid(animationNamespace: animationNamespace,
                              points: $vm.gpoints,
                              format: format)
                    .padding(.axisGridPadding)
                
                Spacer().frame(height: .defaultSpace)
                
                if verticalSizeClass == .regular {
                    ZStack {
                        HStack(spacing: 0) {
                            PointsList(points: $vm.gpoints,
                                       format: format)
                                .listStyle(.plain)
                                .modifier(FlatColorStyle(background: .customDarkGreen))
                                .matchedGeometryEffect(id: ID.bottomGeometry, in: animationNamespace)
                                .padding(.trailing, .defaultTrailing)
                                .padding(.leading, .defaultLeading)
                        }
                        
                        SidePullButton(hiddenBehindEdge: .pullButtonDefaultHidden,
                                       bottomEdgeOffset: 0,
                                       action: discardresult(vm.backAction)) {
                            VStack(spacing: 0) {
                                Spacer()
                            }
                            .frame(width: .pullButtonMaxWidth)
                            .modifier(FlatColorStyle(background: .customCyan))
                        }
                        .transition(.move(edge: .leading))
                        .animation(.pullspring)
                        .offset(x: isHiddenInTransitionAnimation ? -.pullButtonMaxWidth : 0)
                    }
                    .padding(.bottom, .defaultBottom)
                }
            }
        }
        .animation(.linear(duration: .hiddingInTransitionTime),
                   value: isHiddenInTransitionAnimation)
    }
}

