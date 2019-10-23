import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:Inventarios/scoped_models/main.dart';
import 'package:Inventarios/pages/place_edit.dart';

class PlaceListPage extends StatefulWidget {
  final MainModel model;

  PlaceListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PlaceListPageState();
  }
}
class _PlaceListPageState extends State<PlaceListPage> {
  @override
  initState() {
    widget.model.fetchPlaces();
    super.initState();
  }

  Widget buildCard(BuildContext context, int index, MainModel model) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24),
              ),
            ),
            child: Icon(Icons.home, color: Colors.white),
          ),
          title: Text(
            model.allPlaces[index].title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway'),
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.map, color: Colors.white),
              Text(
                model.allPlaces[index].address,
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              )
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.white, size: 30.0),
            onPressed: () {
              model.setSelectedPlace(model.allPlaces[index].id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PlaceEditPage();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, MainModel model) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: model.allPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          return buildCard(context, index, model);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
          child: Text('No hay lugares registrados!'),
        );
        if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        } else if (model.allPlaces.length > 0 && !model.isLoading) {
          content = buildBody(context, model);
        }
        return RefreshIndicator(onRefresh: model.fetchPlaces, child: content);
      },
    );
  }
}
