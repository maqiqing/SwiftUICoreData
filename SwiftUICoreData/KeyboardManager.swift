//
//  KeyboardManager.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/23.
//

import UIKit
import Combine

class KeyboardManager: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible = false
    
    var keyboardCancellable: Cancellable?
    
    init() {
        
        keyboardCancellable = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .sink(receiveValue: { [weak self] noti in
                guard let self = self else { return }
                guard let userInfo = noti.userInfo else { return }
                guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                self.isVisible = keyboardFrame.minY < UIScreen.main.bounds.height
                self.keyboardHeight = self.isVisible ? keyboardFrame.height : 0
            })
        
    }
    
}
