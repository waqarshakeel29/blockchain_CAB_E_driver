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
                'Order Request',
              ),
              centerTitle: true,
            ),
            body: QrImage(
              data: 'This is a simple QR code',
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            )),
      ),
    );
  }
}
