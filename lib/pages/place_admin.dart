import 'package:flutter/material.dart';

import 'package:Inventarios/scoped_models/main.dart';
import 'package:Inventarios/widgets/side_menu.dart';
import 'package:Inventarios/pages/place_edit.dart';
import 'package:Inventarios/pages/place_list.dart';

class PlaceAdminPage extends StatelessWidget {
  final MainModel model;

  PlaceAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      title: Text('Lugares'),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideMenu(),
        appBar: topAppBar,
        body: TabBarView(
          children: <Widget>[
            PlaceListPage(model),
            PlaceEditPage(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.gps_fixed),
                  text: 'Todos',
                ),
                Tab(
                  icon: Icon(Icons.add),
                  text: 'Agregar nuevo',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
