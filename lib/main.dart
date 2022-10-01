import 'package:cash_driver/firebase_options.dart';
import 'package:cash_driver/provider/user_provider.dart';
import 'package:cash_driver/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final currentUser = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cash Driver',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: child,
          );
        },
        child: currentUser != null ? const MainMenu() : const LoginScreen(),
      ),
    );

//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: InkWell(
//             onTap: () async {
//               debugPrint("button click");
//               // Define a session storage
//               final sessionStorage = WalletConnectSecureStorage();
//               final session = await sessionStorage.getSession();
//
// // Create a connector
//               final connector = WalletConnect(
//                 bridge: 'https://bridge.walletconnect.org',
//                 session: session,
//                 sessionStorage: sessionStorage,
//                 clientMeta: const PeerMeta(
//                   name: 'WalletConnect',
//                   description: 'WalletConnect Developer App',
//                   url: 'https://walletconnect.org',
//                   icons: [
//                     'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
//                   ],
//                 ),
//               );
//             },
//             child: Text('Pay '),
//           ),
//         ),
//       ),
//     );
  }
}
