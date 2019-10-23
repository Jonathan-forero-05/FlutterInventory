import 'package:Inventarios/scoped_models/main.dart';
import 'package:flutter/material.dart';

import 'package:Inventarios/pages/product_edit.dart';
import 'package:Inventarios/pages/product_list.dart';
import 'package:Inventarios/widgets/side_menu.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;

  ProductAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      title: Text('Productos'),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideMenu(),
        appBar: topAppBar,
        body: TabBarView(
          children: <Widget>[
            ProductListPage(model),
            ProductEditPage(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.list),
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
