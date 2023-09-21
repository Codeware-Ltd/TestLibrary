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
public struct WebView: WebViewRepresentable {
    
    
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
        url: URL? = nil,
        webConfiguration: WKWebViewConfiguration? = nil,
        viewConfiguration: @escaping (WKWebView) -> Void = { _ in }) {
        self.url = url
        self.webConfiguration = webConfiguration
        self.viewConfiguration = viewConfiguration
    }
    
    
    // MARK: - Properties
    
    private let url: URL?
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

private extension WebView {

    func makeWebView() -> WKWebView {
        guard let configuration = webConfiguration else { return WKWebView() }
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func makeView() -> WKWebView {
        let view = makeWebView()
        viewConfiguration(view)
        tryLoad(url, into: view)
        return view
    }
    
    func tryLoad(_ url: URL?, into view: WKWebView) {
        guard let url = url else { return }
        //view.load(URLRequest(url: url))
        
        
        let url2 = URL(string: "https://app.idesk360.com/init-iDesk-live-chat")
        
        let parameters: [String: Any] = ["resource_uri":"toolstatic.idesk360.com",
                                   "app_uri":"tool.idesk360.com",
                                   "page_id":"1694592792000",
                                   "customerInfo":[
                                     "name": "kamal",
                                     "rmn": "019667653443"
                                   ],
                                   "miscellaneous":[
                                     "float": 0,
                                   ]]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
       // let postData = parameters.data(using: .utf8)
        
        

        
//           var parameters = Parameters()
//           parameters["name"] = "Example"
//           parameters["surname"] = "ExmpleExample"
//           parameters["timeZone"] = "MiddleEast/MENA"
//           parameters["test"] = "YES"
//
//        let parameters = [
//                                   "username":   SessionManager.shared.username!,
//                                   "password":  SessionManager.shared.password!,
//                                   "vhost": "standard"
//             ]
                   
           var urlRequest = URLRequest(url: url2!)
           urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
           urlRequest.allowsCellularAccess = true
           urlRequest.httpMethod = "POST"
         //  let postString = parameters.getPostString()
//           urlRequest.httpBody = postString.data(using: .utf8)
        urlRequest.httpBody = jsonData
        
        view.load(urlRequest)
    }
}

//struct Previews_WebView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        if let url = URL(string: "https://danielsaidi.com") {
//            WebView(url: url)
//        } else {
//            Color.orange
//        }
//    }
//}
#endif

//struct WebView2: UIViewRepresentable {
//
//    var url: URL
//
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//}
public extension Dictionary where Key == String, Value == Any {

   func getPostString() -> String {
      var data = [String]()
      for(key, value) in self {
          data.append(key + "=\(value)")
      }
      return data.map { String($0) }.joined(separator: "&")
   }
}
