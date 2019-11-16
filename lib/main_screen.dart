import 'package:flutter/material.dart';
import 'package:miners/bloc/graph_bloc.dart';
import 'package:miners/bloc/mine_loader_bloc.dart';
import 'package:miners/graph_screen.dart';
import 'package:miners/model/mine.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MineLoaderBloc bloc = new MineLoaderBloc();

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
              Mine mine = mineData.data;
              if (mine == null) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      mine.imageAddress,
                    ),
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
}
