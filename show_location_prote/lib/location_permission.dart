import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

class LocationPermission {
  String errMsg = '';
  String currntLocation = '';

  Future getLocationMessage() async {
    final locationInstance = Location();
    PermissionStatus status = await request(locationInstance);
    // 位置情報が使えないとき
    if (status != PermissionStatus.granted) {
      if (status == PermissionStatus.denied) {
        errMsg = 'Location services are disabled.';
      } else if (status == PermissionStatus.permanentlyDenied) {
        // ここで位置情報設定を促すモーダルを表示
        errMsg = 'Please allow access to your location.';
        // アプリの設定画面に移動させる
        // openAppSettings();
      } else {
        errMsg = 'Unknown Error.';
      }

      return;
    }

    try {
      LocationData data = await locationInstance.getLocation();
      if (data.latitude == null || data.altitude == null) {
        errMsg = 'Failed Get Current Location.';
      }
      errMsg = '';
      currntLocation = '${data.latitude}, ${data.longitude}';
    } catch (e) {
      errMsg = 'Failed Get Current Location.';
    }

    return;
  }

  // Futureは非同期処理を表す
  ///
  /// 位置情報サービス使用可否確認
  ///
  static Future<PermissionStatus> request(Location location) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 位置情報サービスのステータス確認
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // 位置情報を有効にするようユーザに要求
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return PermissionStatus.denied;
      }
    }

    // アプリに対しての位置情報権限の利用ステータスを確認
    permissionGranted = await Permission.locationWhenInUse.status;

    if (permissionGranted != PermissionStatus.granted) {
      // 位置情報の使用許可をユーザに確認
      await Permission.location.request();
      permissionGranted = await Permission.locationWhenInUse.status;
    }

    return permissionGranted;
  }

  ///
  /// 現在位置取得
  ///
  static Future<LocationData> getPosition(Location location) async {
    final currentLocation = await location.getLocation();
    return currentLocation;
  }
}
