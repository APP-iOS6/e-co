//
//  ECO_FB_TestApp.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct ECO_FB_TestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init () {
        KakaoSDK.initSDK(appKey: Bundle.main.infoDictionary?["AppKey"] as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .environment(UserStore.shared)
                .environment(GoodsStore.shared)
                .environment(AuthManager.shared)
        }
    }
}
