import 'package:flutter/material.dart';

import 'bloc/device_state_updater.dart';
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
          print("dialog update");
          StaticObject staticObject = data.data;
          if (staticObject == null)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            );
          print("people count ${staticObject.peopleCount}");
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              staticObject.gas == null
                  ? Container()
                  : Text("Gas: ${staticObject.gas}"),
              staticObject.levelCO == null
                  ? Container()
                  : Text("CO: ${staticObject.levelCO}"),
              staticObject.humidity == null
                  ? Container()
                  : Text("Влажность: ${staticObject.humidity}"),
              staticObject.peopleCount == null
                  ? Text("Людей поблизости нет")
                  : Text("Количество людей рядом: ${staticObject.peopleCount}"),
              staticObject.temperature == null
                  ? Container()
                  : Text("Температура: ${staticObject.temperature}"),
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

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
