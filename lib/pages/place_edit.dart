import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Inventarios/widgets/helpers/ensure_visible.dart';

import 'package:Inventarios/scoped_models/main.dart';
import 'package:Inventarios/models/place.dart';

class PlaceEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaceEditPage();
}

class _PlaceEditPage extends State<PlaceEditPage> {
  Place _formData = new Place();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  Widget _buildNameTextField(Place place) {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Nombre del lugar',
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Debe tener al menos 5 letras';
          }
        },
        initialValue: place == null ? '' : place.title,
        onSaved: (String value) {
          _formData.title = value;
        },
      ),
    );
  }

  Widget _buildAddressTextField(Place place) {
    return EnsureVisibleWhenFocused(
      focusNode: _addressFocusNode,
      child: TextFormField(
        focusNode: _addressFocusNode,
        decoration: InputDecoration(
          labelText: 'Dirección',
        ),
        initialValue: place == null ? '' : place.address,
        onSaved: (String value) {
          _formData.address = value;
        },
      ),
    );
  }

  void _submitForm(
      Function addPlace, Function updatePlace, Function setSelectedPlace,
      [int selPlaceIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (selPlaceIndex == -1) {
      addPlace(
        _formData.title,
        _formData.address,
      ).then((_) => Navigator.pushReplacementNamed(context, '/places')
          .then((_) => setSelectedPlace(null)));
    } else {
      updatePlace(
        _formData.title,
        _formData.address,
      ).then((_) => Navigator.pushReplacementNamed(context, '/places')
          .then((_) => setSelectedPlace(null)));
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Guardar'),
          textColor: Colors.white,
          color: Theme.of(context).accentColor,
          onPressed: () => _submitForm(model.addPlace, model.updatePlace,
              model.setSelectedPlace, model.selectedPlaceIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Place place) {
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
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildNameTextField(place),
              SizedBox(
                height: 10.0,
              ),
              _buildAddressTextField(place),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
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
      Widget pageContent = _buildPageContent(context, model.selectedPlace);

      return model.selectedPlaceIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Editar Lugar'),
              ),
              body: pageContent,
            );
    });
  }
}
