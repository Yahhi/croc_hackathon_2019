import 'package:flutter/material.dart';
import 'package:http_client/browser.dart';
import 'package:http_client/console.dart';
import 'package:miners/bloc/turbine_state_updater.dart';

import 'constants.dart';
import 'model/turbine.dart';

class TurbineDialog extends StatefulWidget {
  final int turbineId;

  const TurbineDialog(
    this.turbineId, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TurbineDialogState();
  }
}

class _TurbineDialogState extends State<TurbineDialog> {
  TurbineStateUpdater bloc;
  int turbinePower;
  bool isManualUpdateEnabled = false;

  @override
  void initState() {
    bloc = new TurbineStateUpdater(widget.turbineId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Вентилятор"),
      content: StreamBuilder<Turbine>(
        stream: bloc.turbineData,
        builder: (BuildContext ctxt, AsyncSnapshot<Turbine> data) {
          Turbine turbine = data.data;
          if (turbine == null)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            );
          turbinePower = turbine.power;
          isManualUpdateEnabled = turbine.isUpdatedManually;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Slider(
                value: turbinePower.roundToDouble(),
                onChangeEnd: isManualUpdateEnabled ? _sendNewPower : null,
                onChanged: isManualUpdateEnabled
                    ? (value) {
                        setState(() {
                          turbinePower = value.round();
                        });
                      }
                    : null,
                label: turbinePower.toString(),
                min: 0.0,
                max: 100.0,
                inactiveColor: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text("0"), Text("100")],
                ),
              ),
              SwitchListTile(
                title: Text("Ручная настройка"),
                value: isManualUpdateEnabled,
                onChanged: (value) {
                  _sendNewManualSetting(value);
                  setState(() {
                    isManualUpdateEnabled = value;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _sendNewPower(double value) async {
    //http://api.prohack.fun/turbines?turbineId=1&status=10
    print("sending value ${value.round()}");
    final client = BrowserClient();
    final rs = await client.send(Request(
        'POST',
        Constants.SERVER_ADDRESS +
            "turbines?turbineId=${widget.turbineId}&status=${value.round()}&useManual=true"));
    print(rs.body);
  }

  void _sendNewManualSetting(bool value) async {
    final client = BrowserClient();
    final rs = await client.send(Request(
        'POST',
        Constants.SERVER_ADDRESS +
            "turbines?turbineId=${widget.turbineId}&status=100&useManual=$value"));
  }
}
