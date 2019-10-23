import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:Inventarios/pages/product_edit.dart';
import 'package:Inventarios/scoped_models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState(){
    widget.model.fetchProducts();
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
            child: Icon(Icons.library_books, color: Colors.white),
          ),
          title: Text(
            model.allProducts[index].title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway'),
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                model.allProducts[index].description,
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.white, size: 30.0),
            onPressed: () {
              model.setSelectedProduct(model.allProducts[index].id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProductEditPage();
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
        itemCount: model.allProducts.length,
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
        child: Text('No hay productos registrados!'),
      );
      if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      } else if(model.allProducts.length > 0 && !model.isLoading) {
        content = buildBody(context, model);
      }

      return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
    });
  }
}
