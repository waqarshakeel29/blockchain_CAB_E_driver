import 'package:cab_e_driver/provider/OrderProvider.dart';
import 'package:cab_e_driver/view/OrderScreen.dart';
import 'package:cab_e_driver/view/qr_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'provider/network_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.I.registerSingleton(OrderProvider());
  GetIt.I.registerSingleton(NetworkProvider());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final networkProvider = GetIt.I<NetworkProvider>();

  @override
  Widget build(BuildContext context) {
    // init network provider
    networkProvider.init();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: QrScreen(),
      home: OrderScreen("123"),
    );
  }
}
