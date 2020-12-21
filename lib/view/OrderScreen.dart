import 'package:cab_e_driver/provider/OrderProvider.dart';
import 'package:cab_e_driver/view/wallet_screen.dart';
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
    if (snapshot.docs.length != 0) {
      order = await provider.getOrderUsingOrderId(snapshot.docs[0].id);
    } else {
      order = null;
    }
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
          drawer: Drawer(
            child: Container(
              color: AppColor.primaryColor,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Hello, Waqar',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletScreen()));
                    },
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Wallet',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.home,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.help,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Help',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.info,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'About',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.settings,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Feedback',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.developer_mode,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
