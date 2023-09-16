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


extension Double {
    static let hiddingInTransitionTime: Double = 0.45
    static let sceneTransitionTime: Double = 0.3
    static let animationAntiClearance: Double = 0.20
    static let hiddingInTransitionWithAntiClearance = .hiddingInTransitionTime - .animationAntiClearance
}

typealias ID = String

extension ID {
    static let topGeometry: String = "topGeometry"
    static let bottomGeometry: String = "bottomGeometry"
}

// this is a mark for those who use @EnvironmentObject passed value
protocol EnvironmentHidableInTransitionAnimation {
    var isHiddenInTransitionAnimation: Bool { get }
}

// this is mark for those who pass environmentObject
protocol _Environment_Declare_isHiddenInTransitionAnimation {}

struct TwoSceneNavigation<StartView: View, FinalView: View>: View, _Environment_Declare_isHiddenInTransitionAnimation {
    
    @ObservedObject
    var vm: ProcessPoints
    
    @StateObject @SimpleObservable
    private var isHiddenInTransitionForActiveView = false

    var startView: StartView
    var finalView: FinalView
    
    
    // possible to configure outside or as a part of the finalView
    var backButton: AnyView? = nil
    
    var body: some View {
        ZStack {
            if vm.isFinal {
                finalView
                    .environmentObject(_isHiddenInTransitionForActiveView.wrappedValue)

                if let backButton {
                    backButton
                }
            } else {
                startView
                    .environmentObject(_isHiddenInTransitionForActiveView.wrappedValue)
            }
            
        }
        .animation(.linear(duration: .sceneTransitionTime)
                   .delay(.hiddingInTransitionWithAntiClearance),
                          value: vm.isFinal)
        .onChange(of: vm.isFinal) { newValue in
            isHiddenInTransitionForActiveView = true
            DispatchQueue.main.asyncAfter(deadline: .now()
                                          + .sceneTransitionTime
                                          + .hiddingInTransitionWithAntiClearance
                                          + .hiddingInTransitionWithAntiClearance)
            {
                isHiddenInTransitionForActiveView = false
            }
        }
    }
}
