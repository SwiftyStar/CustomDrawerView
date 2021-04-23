//
//  DrawerView.swift
//  CustomDrawerView
//
//  Created by Jacob Starry on 4/22/21.
//

import SwiftUI

struct DrawerView<Content: View>: View {
    private let content: () -> Content
    @Binding private var isOpen: Bool
    
    @Binding private var shouldClose: Bool
    private let hasCloseButton: Bool
    private let onOpen: (() -> Void)?
    private let onClose: (() -> Void)?
    
    @State private var verticalOffset = UIScreen.main.bounds.height
    
    /// Drawer view modal that 'opens' from the bottom of the screen.
    /// - Parameters:
    ///   - isOpen: Binding<Bool> that determines if the drawer is open. Typically used to tell the parent view to remove the drawer entirely.
    ///   - content: () -> Content  ViewBuilder for the content in the drawer
    init(isOpen: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isOpen = isOpen
        self.content = content
        self._shouldClose = .constant(false)
        self.hasCloseButton = true
        self.onOpen = nil
        self.onClose = nil
    }
    
    private init(isOpen: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, shouldClose: Binding<Bool>, hasCloseButton: Bool, onOpen: (() -> Void)?, onClose: (() -> Void)?) {
        self._isOpen = isOpen
        self.content = content
        self._shouldClose = shouldClose
        self.hasCloseButton = hasCloseButton
        self.onOpen = onOpen
        self.onClose = onClose
    }
    
    private var closeButton: some View {
        VStack {
            Spacer()
                .frame(height: 12)
            
            HStack {
                Spacer()
                Button("close", action: self.closeDrawer)
                Spacer()
                    .frame(width: 8)
            }
        }
    }
    
    private var drawerHandle: some View {
        VStack {
            Spacer()
                .frame(height: 6)
            
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 64, height: 4)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    private var drawerHandleContainer: some View {
        ZStack {
            self.drawerHandle
                .layoutPriority(1000)
            
            if self.hasCloseButton {
                self.closeButton
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged(self.draggingChanged(_:))
                .onEnded(self.draggingEnded(_:))
        )
    }
    
    private var backgroundView: some View {
        Color.black.opacity(0.33)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: self.openDrawer)
            .onTapGesture(perform: self.closeDrawer)
    }
    
    private var drawer: some View {
        VStack {
            self.drawerHandleContainer
            self.content()
        }
        .background(Color(UIColor.systemBackground))
        .offset(y: self.verticalOffset)
    }
    
    var body: some View {
        ZStack {
            self.backgroundView
            
            VStack {
                Spacer()
                self.drawer
            }
        }
        .onChange(of: self.shouldClose, perform: self.shouldCloseChanged(_:))
    }
    
    private func closeDrawer() {
        let animationDuration = 0.33
        
        withAnimation(.linear(duration: animationDuration)) {
            self.verticalOffset = UIScreen.main.bounds.height
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.onClose?()
            self.isOpen = false
        }
    }
    
    private func openDrawer() {
        let animationDuration = 0.33
        
        withAnimation(.easeOut(duration: animationDuration)) {
            self.verticalOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.onOpen?()
        }
    }
    
    private func draggingChanged(_ value: DragGesture.Value) {
        let newOffset = self.verticalOffset + value.translation.height
        let positiveOffset = max(newOffset, 0)
        
        self.verticalOffset = positiveOffset
    }
    
    private func draggingEnded(_ value: DragGesture.Value) {
        let thresholdDistance: CGFloat = 42
        
        if self.verticalOffset > thresholdDistance {
            self.closeDrawer()
        } else {
            self.reopenDrawer()
        }
    }
    
    private func reopenDrawer() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.verticalOffset = 0
        }
    }
    
    private func shouldCloseChanged(_ shouldClose: Bool) {
        guard shouldClose else { return }
        
        self.closeDrawer()
    }
    
    /// Adds a Binding to determine if the drawer should close.
    /// This is different from isOpen. IsOpen primarily tells the parent view to remove the drawer entirely. shouldClose lets the parent tell the drawer that it should animate closed
    /// This is .constant(true) by default
    /// - Parameter shouldClose: Binding<Bool> that tells the drawer whether or not to animate closed
    /// - Returns: DrawerView that will close if the binding is changed to true
    func shouldClose(_ shouldClose: Binding<Bool>) -> DrawerView {
        DrawerView(isOpen: self.$isOpen,
                   content: self.content,
                   shouldClose: shouldClose,
                   hasCloseButton: self.hasCloseButton,
                   onOpen: self.onOpen,
                   onClose: self.onClose)
    }
    /// Determines if the drawer has a close button.
    /// This is true by default
    /// - Parameter hasButton: Bool determining if the drawer has a close button
    /// - Returns: DrawerView with or without a close button
    func hasCloseButton(_ hasButton: Bool) -> DrawerView {
        DrawerView(isOpen: self.$isOpen,
                   content: self.content,
                   shouldClose: self.$shouldClose,
                   hasCloseButton: hasButton,
                   onOpen: self.onOpen,
                   onClose: self.onClose)
    }
    
    /// Provides an action that occurs when the drawer is finished opening.
    /// This is nil by default
    /// - Parameter action: (() -> Void)? action to take when the drawer is finished opening
    /// - Returns: DrawerView with or without an on open action
    func onOpen(_ action: (() -> Void)?) -> DrawerView {
        DrawerView(isOpen: self.$isOpen,
                   content: self.content,
                   shouldClose: self.$shouldClose,
                   hasCloseButton: self.hasCloseButton,
                   onOpen: action,
                   onClose: self.onClose)
    }
    
    /// Provides an action that occurs when the drawer is finished closing.
    /// This is nil by default
    /// - Parameter action: (() -> Void)? action to take when the drawer is finished closing
    /// - Returns: DrawerView with or without an on close action
    func onClose(_ action: (() -> Void)?) -> DrawerView {
        DrawerView(isOpen: self.$isOpen,
                   content: self.content,
                   shouldClose: self.$shouldClose,
                   hasCloseButton: self.hasCloseButton,
                   onOpen: self.onOpen,
                   onClose: action)
    }
}
