package com.flutter_full_security.flutter_full_security
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import com.scottyab.rootbeer.RootBeer
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.NetworkInfo
import androidx.annotation.RequiresApi
 
class FlutterFullSecurityPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_full_security")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "getProxySetting" -> result.success(getProxySetting())
            "isEmulatorDevice" -> result.success(isEmulatorDevice())
            "isRootedDevice" -> result.success(isRootedDevice())
            "isVpnActive" -> result.success(isVpnActive())
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getProxySetting(): Map<String, Any?> {
        return mapOf(
            "host" to System.getProperty("http.proxyHost"),
            "port" to System.getProperty("http.proxyPort")
        )
    }

    private fun isRootedDevice(): Boolean {
        return RootBeer(context).isRooted
    }

    private fun isEmulatorDevice(): Boolean {
        return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
                Build.FINGERPRINT.startsWith("generic") ||
                Build.FINGERPRINT.startsWith("unknown") ||
                Build.HARDWARE.contains("goldfish") ||
                Build.HARDWARE.contains("ranchu") ||
                Build.MODEL.contains("google_sdk") ||
                Build.MODEL.contains("Emulator") ||
                Build.MODEL.contains("Android SDK built for x86") ||
                Build.MANUFACTURER.contains("Genymotion") ||
                Build.PRODUCT.contains("sdk_google") ||
                Build.PRODUCT.contains("google_sdk") ||
                Build.PRODUCT.contains("sdk") ||
                Build.PRODUCT.contains("sdk_x86") ||
                Build.PRODUCT.contains("vbox86p") ||
                Build.PRODUCT.contains("emulator") ||
                Build.PRODUCT.contains("simulator")
    }

 @RequiresApi(Build.VERSION_CODES.M)
 private fun isVpnActive(): Boolean {
    val manager = context?.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
    val activeNetwork = manager?.activeNetwork
    val networkCapabilities = manager?.getNetworkCapabilities(activeNetwork)

    return networkCapabilities?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) ?: false
  }
}
