//
//  BritaliansTVApp.swift
//  BritaliansTV
//
//  Created by miqo on 06.11.23.
//

import SwiftUI
import AVKit

@main
struct BritaliansTVApp: App {
    @StateObject var contentVM = ContentPageVM()
    @StateObject var mainPageVM = MainPageVM()
    @StateObject var appVM = ApplicationVM()
    @StateObject var playerVM = PlayerVM()
    
    @State var player: AVQueuePlayer?
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                
                BackgroundView()
                    .opacity(mainPageVM.loading ? 0 : 1)
                    .focusable(false)
                
                NavigationStack {
                    ZStack {
                        MainPage()
                            .opacity(appVM.dataLoaded ? 1 : 0)
                        
                        SplashScreen()
                            .opacity(appVM.dataLoaded ? 0 : 1)
                    }
                    .animation(.default, value: appVM.dataLoaded)
                    .ignoresSafeArea(.all)
                    .environmentObject(mainPageVM)
                    .environmentObject(playerVM)   
                }
            }
            .fullScreenCover(
                isPresented: $appVM.exitPresented,
                onDismiss: { appVM.exitPresented = false },
                content: popupContent
            )
            .environmentObject(appVM)
            .environmentObject(contentVM)
        }
    }
    
    @ViewBuilder
    func SplashScreen() -> some View {
        VStack(alignment: .center) {
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
        }
    }
    
    @ViewBuilder
    func popupContent() -> some View {
        PopupView(
            isPresented: $appVM.exitPresented,
            message: ("Are you sure you want to exit the app?"),
            onYesPlaceholder: ("yes"),
            onNoPlaceholder: ("no"),
            onYes: { exit(0) })
    }
}
