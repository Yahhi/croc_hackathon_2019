import 'dart:convert';

import 'package:http_client/console.dart';
import 'package:miners/model/mine.dart';
import 'package:miners/model/turbine.dart';
import 'package:rxdart/rxdart.dart';

class MineLoaderBloc {
  static const _SERVER_ADDRESS = "http://api.prohack.fun/";

  Future<Mine> mine;

  final BehaviorSubject<List<Turbine>> _coolersController =
      new BehaviorSubject();
  Stream<List<Turbine>> get coolers => _coolersController.stream;

  MineLoaderBloc() {
    mine = _loadMine();
  }

  Future<Mine> _loadMine() async {
    print("loading");
    final client = ConsoleClient();
    final rs = await client.send(Request('GET', _SERVER_ADDRESS + "mines/"));
    final textContent = await rs.readAsString();
    print(textContent);
    List<dynamic> datas = json.decode(textContent);

    Map<String, dynamic> jsonData = datas[0];
    print("jsonData: $jsonData");
    return Mine.fromMap(jsonData);
  }

  Future updateMapObjects() {}
}
