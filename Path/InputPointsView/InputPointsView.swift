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


private extension LocalizedString {
    static let pointsCountInput = "points_count_input"
    static let enterPointsCount = "enter_points_count"
    static let defaultErrorMessage = "default_error_message"
}

private extension CGFloat {
    static let textFieldPadding: CGFloat = 10
}


struct InputPointsView: View, EnvironmentHidableInTransitionAnimation {
    var animationNamespace: Namespace.ID
    @ObservedObject var vm: InputPoints
    
    @EnvironmentObject @SimpleObservable
    var isHiddenInTransitionAnimation: Bool
    
    var body: some View {
        
        ZStack {
            Color.customBlue.ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                TextField(
                    isHiddenInTransitionAnimation
                        ? "" : LocalizedStringKey(.enterPointsCount),
                    text: isHiddenInTransitionAnimation
                        ? .constant("") : $vm.inputPointsCount)
                    .keyboardType(.numberPad)
                    .padding()
                    .modifier(FlatColorStyle(background: .customYellow, radius: true))
                    .padding(.horizontal, .textFieldPadding)
                    .matchedGeometryEffect(id: ID.topGeometry, in: animationNamespace)
                
                Spacer()
                
                LoadingButton(isLoading: $vm.isLoading) {
                    let keyWindow = UIApplication.shared.connectedScenes
                                            .filter({$0.activationState == .foregroundActive})
                                            .compactMap({$0 as? UIWindowScene})
                                            .first?.windows
                                            .filter({$0.isKeyWindow}).first
                        keyWindow?.endEditing(true)
                    discardresult(vm.inputPointsCountAction)()
                } spinner: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .borderColor))
                        .frame(width: .progressView.width,
                               height: .progressView.height)
                        .padding()
                        .opacity((!isHiddenInTransitionAnimation).toNum())
                        .transition(.scale)
                } label: {
                    Text(LocalizedStringKey(.pointsCountInput))
                        .padding()
                        .opacity((!isHiddenInTransitionAnimation).toNum())
                        .transition(.scale)
                        .foregroundColor(.borderColor)
                }
                .matchedGeometryEffect(id: ID.bottomGeometry, in: animationNamespace)
                .modifier(FlatColorStyle(background: .customDarkGreen))
                .animation(.spring(), value: vm.isLoading)
                
                Spacer()
            }
            .alert(isPresented: $vm.isErrorMessage) {
                Alert(title:
                        Text(vm.errorMessage?.errorDescription
                             ?? NSLocalizedString(.defaultErrorMessage))
                )
            }
        }
        .animation(.linear(duration: .hiddingInTransitionTime),
                   value: isHiddenInTransitionAnimation)
    }
}



