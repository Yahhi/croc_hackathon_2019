import 'package:flutter/material.dart';

import 'bloc/graph_bloc.dart';

class GraphScreen extends StatelessWidget {
  final GraphBloc bloc;

  const GraphScreen(
    this.bloc, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("График работы системы вентиляции"),
      ),
      body: Column(
        children: <Widget>[
          Text(""),
        ],
      ),
    );
  }
}
