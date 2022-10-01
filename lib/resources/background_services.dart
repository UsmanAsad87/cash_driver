class BackgroundServices {
  // Future<void> initializeService() async {
  //   final service = FlutterBackgroundService();
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will be executed when app is in foreground or background in separated isolate
  //       onStart: onStart,
  //
  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //       // auto start service
  //       autoStart: true,
  //
  //       // this will be executed when app is in foreground in separated isolate
  //       onForeground: onStart,
  //
  //       // you have to enable background fetch capability on xcode project
  //       onBackground: onIosBackground,
  //     ),
  //   );
  //   service.startService();
  // }
  //
  // bool onIosBackground(ServiceInstance service) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   print('FLUTTER BACKGROUND FETCH');
  //
  //   return true;
  // }
  //
  // void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();
  //
  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.setAsForegroundService();
  //     });
  //
  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //   }
  //   service.on('stopService').listen((event) {
  //     service.stopSelf();
  //   });
  // }
}
