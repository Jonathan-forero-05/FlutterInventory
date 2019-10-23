import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menú'),
          ),
          ListTile(
            leading: Icon(Icons.gps_fixed),
            title: Text('Lugares'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/places');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Productos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }
}
