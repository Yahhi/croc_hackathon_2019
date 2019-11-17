import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isImageloaded = false;
  ObjectsRenderer renderer;

  @override
  void initState() {
    super.initState();
    turbineImage = initImage();
  }

  Future<ui.Image> initImage() async {
    final ByteData data = await rootBundle.load('assets/turbine.png');
    return await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
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
          return StreamBuilder<List<Turbine>>(
            stream: widget.bloc.coolers,
            initialData: List(),
            builder:
                (BuildContext ctxt, AsyncSnapshot<List<Turbine>> snapshot) {
              renderer = ObjectsRenderer(
                snapshot.data,
                imageData.data,
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

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    int clickedId = renderer.findTurbineNearby(localOffset);
    if (clickedId != null) {
      _showTurbineData(clickedId);
    }
  }
}

class ObjectsRenderer extends CustomPainter {
  static const _ICON_SIZE = 30.0;
  final List<Turbine> turbines;
  final ui.Image turbineImage;
  final Size originalImageSize;
  Map<int, Offset> turbineOffsets = new Map();

  ObjectsRenderer(
    this.turbines,
    this.turbineImage,
    this.originalImageSize,
  );

  @override
  void paint(Canvas canvas, Size size) async {
    for (Turbine turbine in turbines) {
      double xPosition =
          turbine.positionX * (size.width / originalImageSize.width);
      double yPosition =
          turbine.positionY * (size.height / originalImageSize.height);
      Offset offset = Offset(xPosition, yPosition);
      paintImage(
          canvas: canvas,
          rect: Rect.fromCenter(
              center: offset, width: _ICON_SIZE, height: _ICON_SIZE),
          image: turbineImage);
      turbineOffsets[turbine.id] = offset;
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
