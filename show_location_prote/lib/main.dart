import 'package:flutter/material.dart';
import 'location_permission.dart';

void main() {
  runApp(const MainLayout());
}

// メインレイアウト
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Location App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Get Location App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetLocationButton(),
          ],
        ),
      ),
    );
  }
}

// 基底クラス
class GetLocationButton extends StatefulWidget {
  const GetLocationButton({super.key});

  @override
  State<GetLocationButton> createState() => _GetLocationButtonState();
}

// ボタン管理クラス
class _GetLocationButtonState extends State<GetLocationButton> {
  String location = '';
  String errMsg = 'Please Press Button.';
  bool isEnabledButton = true;

  void _buttonStateChange() async {
    // ボタン無効化
    setState(() {
      isEnabledButton = false;
    });
    // 位置情報取得
    await _getLocation();
    // ボタン有効化
    setState(() {
      isEnabledButton = true;
    });
  }

  // 緯度経度を返す
  Future _getLocation() async {
    LocationPermission locationPermission = LocationPermission();
    await locationPermission.getLocationMessage();
    errMsg = locationPermission.errMsg;
    location = locationPermission.currntLocation;

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
            onPressed: isEnabledButton ? _buttonStateChange : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: isEnabledButton ? Colors.blue : Colors.grey),
            child: isEnabledButton
                ? Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Processing',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: errMsg != '' ? Text(errMsg) : Text(location),
        ),
      ],
    ));
  }
}
