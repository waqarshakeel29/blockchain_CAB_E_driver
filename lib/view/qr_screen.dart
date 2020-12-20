import 'package:cab_e_driver/provider/OrderProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/order.dart';
import '../shared/color.dart';
import 'OngoingOrderScreen.dart';
import 'OrderCard.dart';

//import '../HomePage.dart';

class QrScreen extends StatefulWidget {
  final Order order;
  QrScreen(this.order);
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              backgroundColor: AppColor.primaryColor,
              title: Text(
                'QR Screen',
              ),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text(
                    'Let the Rider Scan QR',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                        fontSize: 22),
                  ),
                ),
                Center(
                  child: QrImage(
                    data: widget.order.fare.toString(),
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
