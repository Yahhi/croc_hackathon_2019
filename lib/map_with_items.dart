import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miners/model/InMapObject.dart';
import 'package:miners/model/static_object.dart';
import 'package:miners/turbine_dialog.dart';

import 'bloc/mine_loader_bloc.dart';
import 'model/mine.dart';
import 'model/turbine.dart';

class MapWithItems extends StatefulWidget {
  final MineLoaderBloc bloc;
  final Mine mine;

  const MapWithItems(
    this.bloc,
    this.mine, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapWithItemsState();
  }
}

class _MapWithItemsState extends State<MapWithItems> {
  final GlobalKey imageKey = new GlobalKey();
  Future<ui.Image> turbineImage;
  ui.Image deviceImage, manImage;
  ObjectsRenderer renderer;

  @override
  void initState() {
    super.initState();
    turbineImage = initImage();
  }

  Future<ui.Image> initImage() async {
    deviceImage = await loadImage(
        new Uint8List.view((await rootBundle.load('assets/modem.png')).buffer));
    manImage = await loadImage(
        new Uint8List.view((await rootBundle.load('assets/man.png')).buffer));
    final ByteData data = await rootBundle.load('assets/turbine.png');
    return await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: turbineImage,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> imageData) {
        if (imageData.data == null)
          return CircularProgressIndicator();
        else
          return StreamBuilder<List<InMapObject>>(
            stream: widget.bloc.inMapObjects,
            initialData: List(),
            builder:
                (BuildContext ctxt, AsyncSnapshot<List<InMapObject>> snapshot) {
              renderer = ObjectsRenderer(
                snapshot.data,
                imageData.data,
                deviceImage,
                manImage,
                Size(widget.mine.width.roundToDouble(),
                    widget.mine.height.roundToDouble()),
              );
              return GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    onTapDown(context, details),
                child: CustomPaint(
                  child: Image.network(
                    widget.mine.imageAddress,
                    key: imageKey,
                  ),
                  foregroundPainter: renderer,
                ),
              );
            },
          );
      },
    );
  }

  void _showTurbineData(int id) {
    showDialog(
        context: context,
        builder: (BuildContext ctxt) {
          return TurbineDialog(id);
        });
  }

  void _showDeviceData(int id) {
    showDialog(
        context: context,
        builder: (BuildContext ctxt) {
          return TurbineDialog(id);
        });
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    int clickedId = renderer.findTurbineNearby(localOffset);
    if (clickedId == null) {
      clickedId = renderer.findTurbineNearby(localOffset);
      if (clickedId != null) {
        _showDeviceData(clickedId);
      }
    } else {
      _showTurbineData(clickedId);
    }
  }
}

class ObjectsRenderer extends CustomPainter {
  static const _ICON_SIZE = 30.0;
  final List<InMapObject> objects;
  final ui.Image turbineImage;
  final ui.Image deviceImage;
  final ui.Image personImage;
  final Size originalImageSize;
  Map<int, Offset> turbineOffsets = new Map();

  ObjectsRenderer(
    this.objects,
    this.turbineImage,
    this.deviceImage,
    this.personImage,
    this.originalImageSize,
  );

  @override
  void paint(Canvas canvas, Size size) async {
    for (InMapObject inMapObject in objects) {
      if (inMapObject.positionX != null && inMapObject.positionY != null) {
        double xPosition =
            inMapObject.positionX * (size.width / originalImageSize.width);
        double yPosition =
            inMapObject.positionY * (size.height / originalImageSize.height);
        final Offset offset = Offset(xPosition, yPosition);
        paintImage(
            canvas: canvas,
            rect: Rect.fromCenter(
                center: offset, width: _ICON_SIZE, height: _ICON_SIZE),
            image: inMapObject is Turbine ? turbineImage : deviceImage);
        turbineOffsets[inMapObject.id] = offset;
        if (inMapObject is StaticObject &&
            inMapObject.peopleCount != null &&
            inMapObject.peopleCount > 0) {
          print("there are people ${inMapObject.peopleCount}");
          final Offset personOffset = Offset(offset.dx, offset.dy + _ICON_SIZE);
          paintImage(
              canvas: canvas,
              rect: Rect.fromCenter(
                  center: personOffset, width: _ICON_SIZE, height: _ICON_SIZE),
              image: personImage);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  int findTurbineNearby(Offset localOffset) {
    print("checking ${localOffset.dx}, ${localOffset.dy}");
    for (MapEntry<int, Offset> mapItem in turbineOffsets.entries) {
      if ((mapItem.value.dx - localOffset.dx).abs() < _ICON_SIZE &&
          (mapItem.value.dy - localOffset.dy).abs() < _ICON_SIZE) {
        return mapItem.key;
      }
    }
    return null;
  }
}
