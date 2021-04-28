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
    
    private var content: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                Text("Opened drawer \(self.drawerOpens) times")
                Spacer()
                    .frame(height: 4)
                
                Text("Closed drawer \(self.drawerCloses) times")
                Spacer()
                    .frame(height: 4)
                
                Button("Open Drawer", action: self.openDrawer)
                Spacer()
            }
            
            Spacer()
        }
    }
    
    private var drawerContent: some View {
        HStack {
            Spacer()
                .frame(width: 16)
            
            VStack {
                Spacer()
                    .frame(height: 24)
                
                Text("This is time number \(self.drawerOpens) opening this Drawer")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    .frame(height: 16)
                
                Text("Tap here to close the Drawer. This could be a continue button.")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture(perform: self.shouldCloseDrawer)
                Spacer()
                    .frame(height: 32)
            }
            
            Spacer()
                .frame(width: 16)
        }
    }
    
    private var drawer: some View {
        DrawerView(isOpen: self.$drawerIsOpen) {
            self.drawerContent
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
