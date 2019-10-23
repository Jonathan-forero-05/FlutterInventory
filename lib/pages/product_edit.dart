import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Inventarios/widgets/helpers/ensure_visible.dart';

import 'package:Inventarios/scoped_models/main.dart';
import 'package:Inventarios/models/product.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductEditPage();
}

class _ProductEditPage extends State<ProductEditPage> {
  Product _productFormData = new Product();
  final GlobalKey<FormState> _productFormKey = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  Widget _buildNameTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Nombre',
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 3) {
            return 'Debe tener al menos 3 letras';
          }
        },
        initialValue: product == null ? '' : product.title,
        onSaved: (String value) {
          _productFormData.title = value;
        },
      ),
    );
  }

  Widget _buildDescripionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Descripción',
        ),
        initialValue: product == null ? '' : product.description,
        onSaved: (String value) {
          _productFormData.description = value;
        },
      ),
    );
  }

  Widget _buildCategoryField() {
    List<String> _categories = <String>[
      'Licores',
      'Alimentos Empacados',
      'Gaseosas',
      'Alimentos No Empacados',
      'Cigarrillos',
      'Bebidas Lácteas'
    ];

    return DropdownButton<String>(
      hint: Text('Seleccione una categoría'),
      value: _productFormData.category,
      items: _categories.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: changedDropDownItem,
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Guardar'),
          textColor: Colors.white,
          color: Theme.of(context).accentColor,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,
              model.setSelectedProduct, model.selectedProductIndex),
        );
      },
    );
  }

  void changedDropDownItem(String selectedCategory) {
    setState(() {
      _productFormData.category = selectedCategory;
    });
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selProductIndex]) {
    if (!_productFormKey.currentState.validate()) {
      return;
    }
    _productFormKey.currentState.save();

    if (selProductIndex == -1) {
      addProduct(
        _productFormData.title,
        _productFormData.description,
        _productFormData.imageUrl,
        _productFormData.category,
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    } else {
      updateProduct(
        _productFormData.title,
        _productFormData.description,
        _productFormData.imageUrl,
        _productFormData.category,
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    }

    Navigator.pushReplacementNamed(context, '/products')
        .then((_) => setSelectedProduct(null));
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _productFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildNameTextField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildDescripionTextField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildCategoryField(),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget pageContent = _buildPageContent(context, model.selectedProduct);

        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Editar Producto'),
                ),
                //backgroundColor: Theme.of(context).primaryColor,
                body: pageContent,
              );
      },
    );
  }
}
