//
//  AddressSearchView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/22/24.
//

import SwiftUI
import WebKit

struct AddressSearchView: UIViewRepresentable {
    @Binding var postalCode: String
    @Binding var address: String
    @Environment(\.presentationMode) var presentationMode

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator

        // 카카오 우편검색 서비스 URL삽입 예쩡
        let url = URL(string: "https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js")!
        webView.load(URLRequest(url: url))

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: AddressSearchView

        init(_ parent: AddressSearchView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.configuration.userContentController.add(self, name: "addressSelected")
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "addressSelected",
               let body = message.body as? [String: String] {
                parent.postalCode = body["zonecode"] ?? ""
                parent.address = body["address"] ?? ""
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
