//
//  KeyboardResponsiveModifier.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    var onKeyboardVisibilityChanged: (Bool) -> Void

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear { self.beginListeningForKeyboardEvents() }
    }

    private func beginListeningForKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            self.adjustForKeyboard(notification: notification, isVisible: true)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            self.adjustForKeyboard(notification: notification, isVisible: false)
        }
    }

    private func adjustForKeyboard(notification: Notification, isVisible: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        withAnimation {
            self.offset = isVisible ? keyboardSize.height : 0
        }
        onKeyboardVisibilityChanged(isVisible)
    }
}

extension View {
    func keyboardResponsive(onKeyboardVisibilityChanged: @escaping (Bool) -> Void = { _ in }) -> some View {
        self.modifier(KeyboardResponsiveModifier(onKeyboardVisibilityChanged: onKeyboardVisibilityChanged))
    }
}

