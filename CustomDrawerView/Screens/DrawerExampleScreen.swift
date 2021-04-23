//
//  ContentView.swift
//  CustomDrawerView
//
//  Created by Jacob Starry on 4/22/21.
//

import SwiftUI

struct DrawerExampleScreen: View {
    @State private var drawerIsOpen = false
    @State private var drawerShouldClose = false
    @State private var drawerOpens = 0
    @State private var drawerCloses = 0
    
    private var drawerOpenText: some View {
        HStack {
            Spacer()
            Text("Opened drawer \(self.drawerOpens) times")
            Spacer()
        }
    }
    
    private var drawerCloseText: some View {
        HStack {
            Spacer()
            Text("Closed drawer \(self.drawerCloses) times")
            Spacer()
        }
    }
    
    private var openDrawerButton: some View {
        HStack {
            Spacer()
            Button("Open Drawer", action: self.openDrawer)
            Spacer()
        }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            
            self.drawerOpenText
            Spacer()
                .frame(height: 4)
            
            self.drawerCloseText
            Spacer()
                .frame(height: 4)
            
            self.openDrawerButton
            Spacer()
        }
    }
    
    private var drawer: some View {
        DrawerView(isOpen: self.$drawerIsOpen) {
            HStack {
                Spacer()
                    .frame(width: 16)
                
                VStack {
                    Spacer()
                        .frame(height: 24)
                    
                    Text("This is time number \(self.drawerOpens) opening this Drawer")
                    Spacer()
                        .frame(height: 16)
                    
                    Text("Tap here to close the drawer. This could be a continue button.")
                        .onTapGesture(perform: self.shouldCloseDrawer)
                    Spacer()
                        .frame(height: 16)
                }
                
                Spacer()
                    .frame(width: 16)
            }
            
            
        }
        .shouldClose(self.$drawerShouldClose)
        .hasCloseButton(true)
        .onOpen(self.openedDrawer)
        .onClose(self.closedDrawer)
    }
    
    
    var body: some View {
        ZStack {
            self.content
            
            if self.drawerIsOpen {
                self.drawer
            }
        }
    }
    
    private func shouldCloseDrawer() {
        self.drawerShouldClose = true
    }
    
    private func openDrawer() {
        self.drawerShouldClose = false
        self.drawerIsOpen = true
    }
    
    private func openedDrawer() {
        self.drawerOpens += 1
    }
    
    private func closedDrawer() {
        self.drawerCloses += 1
    }
}

struct DrawerExampleScreen_previews: PreviewProvider {
    static var previews: some View {
        DrawerExampleScreen()
    }
}
