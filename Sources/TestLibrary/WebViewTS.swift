//
//  WebView.swift
//  WebViewKit
//
//  Created by Daniel Saidi on 2022-03-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
typealias WebViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias WebViewRepresentable = NSViewRepresentable
#endif

#if os(iOS) || os(macOS)
import SwiftUI
import WebKit

/**
 This view wraps a `WKWebView` and can be used to load a URL
 that refers to both remote or local web pages.
 
 When you create this view, you can either provide it with a
 url, or an optional url and a view configuration block that
 can be used to configure the created `WKWebView`.

 You can also provide a custom `WKWebViewConfiguration` that
 can be used when initializing the `WKWebView` instance.
 */
public struct WebViewTS: WebViewRepresentable {
    
    
    // MARK: - Initializers
    
    /**
     Create a web view that loads the provided url after the
     provided configuration has been applied.
     
     If the `url` parameter is `nil`, you must manually load
     a url in the configuration block. If you don't, the web
     view will not present any content.
     
     - Parameters:
       - url: The url of the page to load into the web view, if any.
       - webConfiguration: The WKWebViewConfiguration to apply to the web view, if any.
       - webView: The custom configuration block to apply to the web view, if any.
     */
    public init(

        ideskAppData: String,
        webConfiguration: WKWebViewConfiguration? = nil,
        viewConfiguration: @escaping (WKWebView) -> Void = { _ in }) {
            
        self.ideskAppData = ideskAppData
        self.webConfiguration = webConfiguration
        self.viewConfiguration = viewConfiguration
    }
    
    
    // MARK: - Properties
    
    private let ideskAppData: String
    private let webConfiguration: WKWebViewConfiguration?
    private let viewConfiguration: (WKWebView) -> Void
    
    
    // MARK: - Functions
    
    #if os(iOS)
    public func makeUIView(context: Context) -> WKWebView {
        makeView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {}
    #endif
    
    #if os(macOS)
    public func makeNSView(context: Context) -> WKWebView {
        makeView()
    }
    
    public func updateNSView(_ view: WKWebView, context: Context) {}
    #endif
}

private extension WebViewTS {

    func makeWebView() -> WKWebView {
        guard let configuration = webConfiguration else { return WKWebView() }
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func makeView() -> WKWebView {
        let view = makeWebView()
        viewConfiguration(view)
        tryLoad(into: view)
        return view
    }
    
    func tryLoad( into view: WKWebView) {
        
        let url = URL(string: AppConstants.BASE_URL)
        view.loadHTMLString(ideskAppData, baseURL: url)
    }
        
}

#endif

