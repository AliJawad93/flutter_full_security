// import Foundation
// import CFNetwork

// class ProxyService {
//     private var proxyCache: [String: [String: Any]] = [:]
    
//     func getProxy(for url: String) -> [String: Any]? {
//         if let cachedProxy = proxyCache[url] {
//             return cachedProxy
//         }
        
//         let proxConfigDict = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as NSDictionary?
//         guard let proxConfig = proxConfigDict else { return nil }

//         if proxConfig[kCFNetworkProxiesProxyAutoConfigEnable] as? Int == 1 {
//             if let pacUrl = proxConfig[kCFNetworkProxiesProxyAutoConfigURLString] as? String {
//                 handlePacUrl(pacUrl: pacUrl, url: url)
//             } else if let pacContent = proxConfig[kCFNetworkProxiesProxyAutoConfigJavaScript] as? String {
//                 handlePacContent(pacContent: pacContent, url: url)
//             }
//         } else if proxConfig[kCFNetworkProxiesHTTPEnable] as? Int == 1 {
//             var dict: [String: Any] = [:]
//             dict["host"] = proxConfig[kCFNetworkProxiesHTTPProxy] as? String
//             dict["port"] = proxConfig[kCFNetworkProxiesHTTPPort] as? Int
//             proxyCache[url] = dict
//         }
        
//         return proxyCache[url]
//     }

//     private func handlePacContent(pacContent: String, url: String) {
//         let proxies = CFNetworkCopyProxiesForAutoConfigurationScript(pacContent as CFString, CFURLCreateWithString(kCFAllocatorDefault, url as CFString, nil), nil)!.takeUnretainedValue() as? [[CFString: Any]] ?? []
//         if let proxy = proxies.first(where: { $0[kCFProxyTypeKey] as! CFString == kCFProxyTypeHTTP || $0[kCFProxyTypeKey] as! CFString == kCFProxyTypeHTTPS }) {
//             let host = proxy[kCFProxyHostNameKey]
//             let port = proxy[kCFProxyPortNumberKey]
//             let dict: [String: Any] = ["host": host ?? "", "port": port ?? 0]
//             proxyCache[url] = dict
//         }
//     }

//     private func handlePacUrl(pacUrl: String, url: String) {
//         let _pacUrl = CFURLCreateWithString(kCFAllocatorDefault, pacUrl as CFString, nil)
//         let targetUrl = CFURLCreateWithString(kCFAllocatorDefault, url as CFString, nil)
        
//         var context = CFStreamClientContext(version: 0, info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), retain: nil, release: nil, copyDescription: nil)
        
//         let runLoopSource = CFNetworkExecuteProxyAutoConfigurationURL(_pacUrl!, targetUrl!, { (client, proxies, error) in
//             guard let self = Unmanaged<ProxyService>.fromOpaque(client!).takeUnretainedValue() as? ProxyService else {
//                 return
//             }

//             let _proxies = proxies as? [[CFString: Any]] ?? []
//             if let proxy = _proxies.first(where: { $0[kCFProxyTypeKey] as! CFString == kCFProxyTypeHTTP || $0[kCFProxyTypeKey] as! CFString == kCFProxyTypeHTTPS }) {
//                 let host = proxy[kCFProxyHostNameKey]
//                 let port = proxy[kCFProxyPortNumberKey]
//                 let dict: [String: Any] = ["host": host ?? "", "port": port ?? 0]
//                 // Use `url` for caching; pass `url` via context if needed
//                 self.proxyCache[url] = dict
//             }
//             CFRunLoopStop(CFRunLoopGetCurrent())
//         }, &context)
        
//         let runLoop = CFRunLoopGetCurrent()
//         CFRunLoopAddSource(runLoop, ProxyService.getRunLoopSource(runLoopSource), .defaultMode)
//         CFRunLoopRun()
//         CFRunLoopRemoveSource(runLoop, ProxyService.getRunLoopSource(runLoopSource), .defaultMode)
//     }
    
//     private static func getRunLoopSource<T>(_ runLoopSource: T) -> CFRunLoopSource {
//         if let unmanagedValue = runLoopSource as? Unmanaged<CFRunLoopSource> {
//             return unmanagedValue.takeUnretainedValue()
//         } else {
//             return runLoopSource as! CFRunLoopSource
//         }
//     }
// }
