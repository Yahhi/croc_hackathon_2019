import 'dart:convert';

import 'package:http_client/console.dart';
import 'package:miners/constants.dart';
import 'package:miners/model/mine.dart';
import 'package:miners/model/turbine.dart';
import 'package:rxdart/rxdart.dart';

class MineLoaderBloc {
  Future<Mine> mine;
  int mineId;

  final BehaviorSubject<List<Turbine>> _coolersController =
      new BehaviorSubject();
  Stream<List<Turbine>> get coolers => _coolersController.stream;

  MineLoaderBloc() {
    mine = _loadMine();
  }

  Future<Mine> _loadMine() async {
    print("loading");
    final client = ConsoleClient();
    final rs =
        await client.send(Request('GET', Constants.SERVER_ADDRESS + "mines/"));
    print("address: " + Constants.SERVER_ADDRESS + "mines/");
    final textContent = await rs.readAsString();
    print("mines result");
    client.close();
    List<dynamic> datas = json.decode(textContent);

    Map<String, dynamic> jsonData = datas[0];
    Mine mine = Mine.fromMap(jsonData);
    mineId = mine.id;

    updateMapObjects();

    return mine;
  }

  Future updateMapObjects() async {
    print("updating map objects");
    final client = ConsoleClient();
    final turbinesText = await client.send(
        Request('GET', Constants.SERVER_ADDRESS + "turbines?mineId=$mineId"));
    final textContent = await turbinesText.readAsString();
    print("turbines result $textContent");
    List<dynamic> turbinesJson = json.decode(textContent);
    List<Turbine> turbines = new List();
    for (var json in turbinesJson) {
      turbines.add(Turbine.fromJson(json));
    }
    _coolersController.add(turbines);
  }

  void sendNewPower(double value) {}
}
