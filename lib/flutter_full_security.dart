import 'dart:io';

import 'package:flutter/services.dart';

class FlutterFullSecurity {
  final MethodChannel _channel = const MethodChannel('flutter_full_security');

  Future<bool> get isAppFullSecurity async {
    var results = await Future.wait(
      [
        isProxyApply,
        isRootedDevice,
        isEmulatorDevice,
        isVpnActive,
      ],
    );
    return !results.contains(true);
  }

  Future<ProxySetting> get proxySetting async {
    return _channel
        .invokeMapMethod<String, dynamic>('getProxySetting')
        .then((e) => ProxySetting._fromMap(e ?? {}));
  }

  Future<bool> get isEmulatorDevice async {
    bool? isEmulator;
    if (Platform.isAndroid) {
      isEmulator = await _channel.invokeMethod('isEmulatorDevice');
    } else if (Platform.isIOS) {
      isEmulator = await _channel.invokeMethod('isSimulatorDevice');
    }
    return isEmulator ?? false;
  }

  Future<bool> get isRootedDevice async {
    final bool? isRooted = await _channel.invokeMethod('isRootedDevice');
    return isRooted ?? false;
  }

  Future<bool> get isProxyApply async {
    return _channel
        .invokeMapMethod<String, dynamic>('getProxySetting')
        .then((e) => ProxySetting._fromMap(e ?? {}).isProxyApply);
  }

  Future<bool> get isVpnActive async {
    final isActive = await _channel.invokeMethod('isVpnActive');
    return isActive ?? false;
  }
}

class ProxySetting {
  String? host;

  int? port;

  ProxySetting._({
    this.host,
    this.port,
  });

  factory ProxySetting._fromMap(Map<String, dynamic> map) {
    return ProxySetting._(
      host: map['host'],
      port: map['port'] != null ? int.parse(map['port'].toString()) : null,
    );
  }

  bool get isProxyApply => (host?.isNotEmpty ?? false) && ((port ?? 0) > 0);
}
