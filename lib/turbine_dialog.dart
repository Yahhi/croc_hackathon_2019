import 'package:flutter/material.dart';
import 'package:http_client/browser.dart';
import 'package:http_client/console.dart';
import 'package:miners/model/turbine.dart';

import 'constants.dart';

class TurbineDialog extends StatefulWidget {
  final Turbine turbine;

  const TurbineDialog(
    this.turbine, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TurbineDialogState();
  }
}

class _TurbineDialogState extends State<TurbineDialog> {
  int _changedTurbineValue;

  @override
  void initState() {
    _changedTurbineValue = widget.turbine.power;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Вентилятор"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slider(
            value: _changedTurbineValue.roundToDouble(),
            onChangeEnd: _sendNewPower,
            onChanged: (value) {
              setState(() {
                _changedTurbineValue = value.round();
              });
            },
            min: 0.0,
            max: 100.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("0"), Text("100")],
            ),
          ),
          widget.turbine.levelCO == null
              ? Container()
              : Text("Уровень CO: ${widget.turbine.levelCO}"),
        ],
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
            "turbines?turbineId=${widget.turbine.id}&status=${value.round()}"));
    print(rs.body);
  }
}
