import 'dart:async';
import 'dart:convert';

import 'package:http_client/browser.dart';
import 'package:miners/model/turbine.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';

class TurbineStateUpdater {
  final BehaviorSubject<Turbine> _dataController = new BehaviorSubject();
  Stream<Turbine> get turbineData => _dataController.stream;
  final int turbineId;
  Timer updater;
  BrowserClient client;

  TurbineStateUpdater(this.turbineId) {
    print("state updater created with $turbineId");
    _loadData();
  }

  Future _loadData() async {
    client = BrowserClient();
    updater = new Timer.periodic(Duration(seconds: 5), (_) async {
      //http://api.prohack.fun/TooltipTurbine?turbineId=4
      print("address: " +
          Constants.SERVER_ADDRESS +
          "TooltipTurbine?turbineId=$turbineId");
      final rs = await client.send(Request('GET',
          Constants.SERVER_ADDRESS + "TooltipTurbine?turbineId=$turbineId"));
      final textContent = await rs.readAsString();
      Map<String, dynamic> turbineData = json.decode(textContent);
      _dataController.add(Turbine.fromJson(turbineData));
    });
  }

  void dispose() {
    client?.close();
    updater?.cancel();
    updater = null;
  }
}
