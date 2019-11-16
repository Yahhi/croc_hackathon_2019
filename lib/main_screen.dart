import 'package:flutter/material.dart';
import 'package:miners/bloc/graph_bloc.dart';
import 'package:miners/bloc/mine_loader_bloc.dart';
import 'package:miners/graph_screen.dart';
import 'package:miners/model/mine.dart';
import 'package:miners/model/turbine.dart';
import 'package:miners/turbine_dialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MineLoaderBloc bloc = new MineLoaderBloc();
  final GlobalKey imageKey = new GlobalKey();
  Widget turbineLayer = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Вентиляция шахты"),
      ),
      body: Center(
        child: SafeArea(
          child: FutureBuilder<Mine>(
            future: bloc.mine,
            builder: (BuildContext ctxt, AsyncSnapshot<Mine> mineData) {
              double screenWidth = MediaQuery.of(context).size.width;
              double screenHeight = MediaQuery.of(context).size.height;
              Mine mine = mineData.data;
              if (mine == null) {
                return CircularProgressIndicator();
              } else {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Image.network(
                      mine.imageAddress,
                      key: imageKey,
                    )),
                    _loadOtherLayers(mine.width / screenWidth,
                        mine.height.roundToDouble(), screenHeight),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openGraph,
        tooltip: 'Открыть графики',
        child: Icon(Icons.graphic_eq),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _openGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      GraphBloc graphBloc = new GraphBloc();
      return new GraphScreen(graphBloc);
    }));
  }

  List<Widget> _formTurbinesList(List<Turbine> data, double k, double topY) {
    print("topY $topY");
    List<Widget> turbines = new List();
    for (Turbine turbine in data) {
      print((turbine.positionY * k).toString());
      turbines.add(Positioned(
        top: topY + turbine.positionY * k,
        left: turbine.positionX * k,
        child: IconButton(
          onPressed: () {
            _showTurbineData(turbine);
          },
          icon: Image.asset(
            "assets/turbine.png",
            height: 24.0,
          ),
        ),
      ));
    }
    return turbines;
  }

  void _showTurbineData(Turbine turbine) {
    showDialog(
        context: context,
        builder: (BuildContext ctxt) {
          return TurbineDialog(turbine);
        });
  }

  Widget _loadOtherLayers(double k, double mapHeight, double screenHeight) {
    print("loading other layers");
    double blankSpaceBeforeMap = (screenHeight - mapHeight / k) / 2;
    return StreamBuilder<List<Turbine>>(
      stream: bloc.coolers,
      initialData: List(),
      builder: (BuildContext ctxt, AsyncSnapshot<List<Turbine>> data) {
        List<Widget> turbines =
            _formTurbinesList(data.data, k, blankSpaceBeforeMap);
        return Stack(
          children: turbines,
        );
      },
    );
  }
}
