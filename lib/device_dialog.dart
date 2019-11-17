import 'package:flutter/material.dart';
import 'package:http_client/browser.dart';
import 'package:http_client/console.dart';

import 'bloc/device_state_updater.dart';
import 'constants.dart';
import 'model/static_object.dart';

class DeviceDialog extends StatefulWidget {
  final int turbineId;

  const DeviceDialog(
    this.turbineId, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeviceDialogState();
  }
}

class _DeviceDialogState extends State<DeviceDialog> {
  DeviceStateUpdater bloc;

  @override
  void initState() {
    bloc = new DeviceStateUpdater(widget.turbineId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Контроллер качества воздуха"),
      content: StreamBuilder<StaticObject>(
        stream: bloc.objectData,
        builder: (BuildContext ctxt, AsyncSnapshot<StaticObject> data) {
          StaticObject turbine = data.data;
          if (turbine == null)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            );
          return Container();
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
            "turbines?turbineId=${widget.turbineId}&status=${value.round()}"));
    print(rs.body);
  }
}
