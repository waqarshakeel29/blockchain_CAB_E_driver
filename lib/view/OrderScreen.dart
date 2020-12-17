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

class OrderScreen extends StatefulWidget {
  OrderScreen(this.orderId);
  final String orderId;

  @override
  _OrderScreenState createState() => _OrderScreenState(orderId);
}

class _OrderScreenState extends State<OrderScreen> {
  _OrderScreenState(this.orderId);

  final String orderId;
  final provider = GetIt.I<OrderProvider>();
  Order order;
  bool showQR = false;

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  fetchOrder() async {
    print("DATAAAAAA - -----------------------");
    var snapshot = await FirebaseFirestore.instance.collection("order").get();
    order = await provider.getOrderUsingOrderId(snapshot.docs[0].id);
    setState(() {});
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
          body: Builder(
            builder: (context) {
              if (order == null) {
                return Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      OrderCard(order: order),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: ButtonTheme(
                                height: 40,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                  elevation: 10,
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    final status =
                                        await provider.acceptOrder(orderId);
                                    // if (Get.isDialogOpen) Get.back();
                                    if (status ==
                                        OrderAcceptanceStatus.success) {
                                      print("Order accepted");
                                      showQR = true;
                                      setState(() {});
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OngoingOrderScreen(
                                                      order: order)));
                                    } else if (status ==
                                        OrderAcceptanceStatus.unknownError) {
                                      print("Check your internet connection");
                                    } else if (status ==
                                        OrderAcceptanceStatus.locationProblem) {
                                      print(
                                          "Unable to retrieve your location. Check your location settings");
                                    } else if (status ==
                                        OrderAcceptanceStatus.alreadyAccepted) {
                                      print(
                                          "Order accepted by another Messenger.");
                                      // Get.offAll(HomePage());
                                    }
                                  },
                                  color: AppColor.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color: AppColor.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: ButtonTheme(
                                height: 40,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                  elevation: 10,
                                  child: Text(
                                    "Reject",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryColor,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {
                                    // Get.offAll(HomePage());
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color: AppColor.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
