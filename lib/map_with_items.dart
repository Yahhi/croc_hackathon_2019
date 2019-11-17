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
              return CustomPaint(
                child: Image.network(
                  widget.mine.imageAddress,
                  key: imageKey,
                ),
                foregroundPainter: ObjectsRenderer(
                  snapshot.data,
                  imageData.data,
                  Size(widget.mine.width.roundToDouble(),
                      widget.mine.height.roundToDouble()),
                ),
              );
            },
          );
      },
    );
  }

  void _showTurbineData(Turbine turbine) {
    showDialog(
        context: context,
        builder: (BuildContext ctxt) {
          return TurbineDialog(turbine);
        });
  }
}

class ObjectsRenderer extends CustomPainter {
  final List<Turbine> turbines;
  final ui.Image turbineImage;
  final Size originalImageSize;

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
      paintImage(
          canvas: canvas,
          rect: Rect.fromCenter(
              center: Offset(xPosition, yPosition), width: 30.0, height: 30.0),
          image: turbineImage);
      /*canvas.drawImage(
          turbineImage,
          new Offset(turbine.positionX.roundToDouble(),
              turbine.positionY.roundToDouble()),
          new Paint());*/
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
