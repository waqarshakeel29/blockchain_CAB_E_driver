import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../provider/wallet_provider.dart';
import '../provider/network_provider.dart';
import '../shared/color.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WalletScreenState();
  }
}

class WalletScreenState extends State<WalletScreen> {
  final walletProvider = GetIt.I<WalletProvider>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        decoration: new BoxDecoration(
            color: AppColor.buttonColor,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0),
            )),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: walletProvider
                  .getBalance(), //networkProvider.getBalance(BigInt.parse("2")),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        'REMAING BALANCE',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${snapshot.data[0]}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  );
                } else
                  return Text('Loading...');
              },
            ),
          ],
        ),
      ),
    ));
  }
}
