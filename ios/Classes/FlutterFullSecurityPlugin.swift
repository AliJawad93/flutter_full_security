import Flutter
import UIKit
import DTTJailbreakDetection
public class FlutterFullSecurityPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_full_security", binaryMessenger: registrar.messenger())
        let instance = FlutterFullSecurityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getProxySetting":
             result(getProxySettings3())
        case "isRootedDevice":
            result(NSNumber(value: isRootedDevice()))
        case "isSimulatorDevice":
            result(NSNumber(value: TARGET_OS_SIMULATOR != 0))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func getProxySetting() -> NSDictionary? {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue(),
            let url = URL(string: "https://www.bing.com/") else {
                return nil
        }
        let proxies = CFNetworkCopyProxiesForURL((url as CFURL), proxySettings).takeUnretainedValue() as NSArray
        guard let settings = proxies.firstObject as? NSDictionary,
            let _ = settings.object(forKey: (kCFProxyTypeKey as String)) as? String else {
                return nil
        }

        if let hostName = settings.object(forKey: (kCFProxyHostNameKey as String)), let port = settings.object(forKey: (kCFProxyPortNumberKey as String)) {
            return ["host":hostName, "port":port]
        }
        return nil;
    }
     private func getProxySettings3() -> NSDictionary? {
        let proxyDict = CFNetworkCopySystemProxySettings()!.takeUnretainedValue() as! [String: Any]
        if let proxy = proxyDict["HTTPEnable"] as? Bool, proxy {
            let host = proxyDict["HTTPProxy"] as? String ?? ""
            let port = proxyDict["HTTPPort"] as? Int ?? 0
            return ["host":host, "port":port] 
        }
        return nil
    }
     private func isRootedDevice() -> Bool {
        return DTTJailbreakDetection.isJailbroken()
    }
}
