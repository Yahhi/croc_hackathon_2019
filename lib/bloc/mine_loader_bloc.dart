import 'dart:async';
import 'dart:convert';

import 'package:http_client/browser.dart';
import 'package:miners/constants.dart';
import 'package:miners/model/InMapObject.dart';
import 'package:miners/model/mine.dart';
import 'package:miners/model/static_object.dart';
import 'package:miners/model/turbine.dart';
import 'package:rxdart/rxdart.dart';

class MineLoaderBloc {
  Future<Mine> mine;
  int mineId;

  final BehaviorSubject<List<InMapObject>> _mapItemsController =
      new BehaviorSubject();
  Stream<List<InMapObject>> get inMapObjects => _mapItemsController.stream;

  Timer _objectUpdater;

  MineLoaderBloc() {
    mine = _loadMine();
  }

  Future<Mine> _loadMine() async {
    print("loading");
    final client = BrowserClient();
    final rs =
        await client.send(Request('GET', Constants.SERVER_ADDRESS + "mines/"));
    print("address: " + Constants.SERVER_ADDRESS + "mines/");
    final textContent = await rs.readAsString();
    client.close();
    List<dynamic> datas = json.decode(textContent);

    Map<String, dynamic> jsonData = datas[0];
    Mine mine = Mine.fromMap(jsonData);
    mineId = mine.id;

    updateMapObjects(null);
    _objectUpdater = Timer.periodic(Duration(seconds: 10), updateMapObjects);

    return mine;
  }

  Future updateMapObjects(_) async {
    print("updating map objects");
    final client = BrowserClient();
    List<InMapObject> objects = new List();

    final turbinesText = await client.send(
        Request('GET', Constants.SERVER_ADDRESS + "turbines?mineId=$mineId"));
    final textContent = await turbinesText.readAsString();
    print("turbines result $textContent");
    List<dynamic> turbinesJson = json.decode(textContent);
    for (var json in turbinesJson) {
      objects.add(Turbine.fromJson(json));
    }

    final devicesText = await client.send(
        Request('GET', Constants.SERVER_ADDRESS + "devices?mineId=$mineId"));
    //[{"id":2,"mineId":1,"deviceId":"crockdev3","x":1,"y":1,"data":{"co":0,"t":null,"h":null,"gas":null,"persons":null,"date":"2019-11-17T07:58:11.5834941"}},
    // {"id":3,"mineId":1,"deviceId":"crockdev2","x":null,"y":null,"data":null},
    // {"id":4,"mineId":1,"deviceId":"testhack","x":null,"y":null,"data":null}]
    final deviceContent = await devicesText.readAsString();
    print("devices result $deviceContent");
    List<dynamic> devicesJson = json.decode(deviceContent);
    for (var json in devicesJson) {
      StaticObject staticObject = StaticObject.fromJson(json);
      objects.add(staticObject);
    }

    _mapItemsController.add(objects);
    client.close();
  }

  void dispose() {
    _objectUpdater?.cancel();
    _objectUpdater = null;
  }
}
