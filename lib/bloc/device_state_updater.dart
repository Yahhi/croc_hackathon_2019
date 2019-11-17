import 'dart:async';
import 'dart:convert';

import 'package:http_client/browser.dart';
import 'package:miners/model/static_object.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';

class DeviceStateUpdater {
  final BehaviorSubject<StaticObject> _dataController = new BehaviorSubject();
  Stream<StaticObject> get objectData => _dataController.stream;
  final int id;
  Timer updater;
  BrowserClient client;

  DeviceStateUpdater(this.id) {
    _loadData();
  }

  Future _loadData() async {
    client = BrowserClient();
    updater = new Timer.periodic(Duration(seconds: 5), (_) async {
      final rs = await client
          .send(Request('GET', Constants.SERVER_ADDRESS + "turbine?id=$id"));
      print("address: " + Constants.SERVER_ADDRESS + "turbine?id=$id");
      final textContent = await rs.readAsString();
      Map<String, dynamic> turbineData = json.decode(textContent);
      _dataController.add(StaticObject.fromJson(turbineData));
    });
  }

  void dispose() {
    client?.close();
    updater?.cancel();
    updater = null;
  }
}
