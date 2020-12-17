import 'dart:math';

import 'package:background_location/background_location.dart';
import 'package:cab_e_driver/model/order.dart';
import 'package:cab_e_driver/view/OrderScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum OrderAcceptanceStatus {
  success,
  unknownError,
  noInternet,
  alreadyAccepted,
  locationProblem,
}

class OrderProvider {
  final firestore = FirebaseFirestore.instance;
  ValueNotifier<Order> currentOrder = ValueNotifier(null);

  OrderProvider() {
    // add a listener for current order
    currentOrder.addListener(() {
      final order = currentOrder.value;
      if (order == null) return;
      BackgroundLocation.getLocationUpdates((location) {
        order.driverLat = location.latitude;
        order.driverLng = location.longitude;
        print("${location.latitude},${location.longitude}");

        firestore.collection("order").doc(order.orderId).update(order.toMap());
      });
    });
    // check for ongoing order
    // checkForOngoingOrder();
  }

  Future<Order> getOrderUsingOrderId(String orderId) async {
    final orderDoc = await firestore.collection("order").doc(orderId).get();
    if (!orderDoc.exists) {
      return null;
    }
    return Order.fromMap(orderDoc.data());
  }

  Future<OrderAcceptanceStatus> acceptOrder(String orderId) async {
    try {
      //   await Get.defaultDialog(
      //     title: "Loading",
      //     content: CircularProgressIndicator(),
      //   );

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      final PermissionStatus status =
          await BackgroundLocation.checkPermissions();
      if (status != PermissionStatus.granted) {
        return OrderAcceptanceStatus.locationProblem;
      }

      if (position == null) return OrderAcceptanceStatus.locationProblem;
      BackgroundLocation.startLocationService();

      return FirebaseFirestore.instance
          .runTransaction<OrderAcceptanceStatus>((t) async {
        final orderDoc =
            await FirebaseFirestore.instance.collection("order").get();

        // await t.get(firestore.collection("order").doc(orderId));

        final order = await getOrderUsingOrderId(orderDoc.docs[0].id);
        // Order.fromMap(orderDoc.data());
        // print("ORDERRRRR");
        // print(orderDoc.data()[0]);
        if (order.status != OrderStatus.findingDriver) {
          return OrderAcceptanceStatus.alreadyAccepted;
        }
        order.driverId = "2";
        order.status = OrderStatus.driverOnWay;
        order.driverLat = position.latitude;
        order.driverLng = position.longitude;
        final messageDocId = Uuid().generateV4();
        order.messageDocId = messageDocId;
        t.set(firestore.collection("message").doc(messageDocId),
            {"orderId": order.orderId});

        t.update(orderDoc.docs[0].reference, order.toMap());
        // t.update(orderDoc.reference, order.toMap());

        currentOrder.value = order;
        currentOrder.notifyListeners();
        return OrderAcceptanceStatus.success;
      });
    } catch (e) {
      print("ERRORRRRRRR");
      print(e);
      return OrderAcceptanceStatus.unknownError;
    }
  }

  Future<void> completeCurrentOrder() async {
    // Get.defaultDialog(
    //   title: "Loading",
    //   content: CircularProgressIndicator(),
    // );
    final order = currentOrder.value;
    if (order != null) {
      currentOrder.value = null;
      currentOrder.notifyListeners();

      order.status = OrderStatus.orderCompleted;
      order.isCatered = true;
      await firestore
          .collection("order")
          .doc(order.orderId)
          .update(order.toMap());
      Get.offAll(OrderScreen("123"));
      Get.defaultDialog(
        title: "Order Completed",
        content: Icon(
          Icons.check,
          size: 48,
        ),
      );
      return true;
    }
    return false;
  }

  Future<void> cancelCurrentOrder() async {
    // Get.defaultDialog(
    //   title: "Loading",
    //   content: CircularProgressIndicator(),
    // );
    final order = currentOrder.value;
    if (order != null) {
      currentOrder.value = null;
      currentOrder.notifyListeners();
      order.status = OrderStatus.orderCancelled;
      order.isCatered = true;
      await firestore
          .collection("order")
          .doc(order.orderId)
          .update(order.toMap());
      Get.offAll(OrderScreen("123"));
      Get.defaultDialog(
        title: "Order Cancelled",
        content: Icon(
          Icons.cancel,
          size: 48,
        ),
      );
      return true;
    }
    return false;
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
