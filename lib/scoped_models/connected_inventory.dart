import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'package:Inventarios/models/place.dart';
import 'package:Inventarios/models/product.dart';

mixin ConnectedInventoryModel on Model {
  List<Place> _places = [];
  List<Product> _products = [];
  String _selPlaceId;
  String _selProductId;
  bool _isLoading = false;
}

mixin PlacesModel on ConnectedInventoryModel {
  List<Place> get allPlaces {
    return List.from(_places);
  }

  int get selectedPlaceIndex {
    return _places.indexWhere((Place place) {
      return place.id == _selPlaceId;
    });
  }

  Place get selectedPlace {
    if (selectedPlaceIndex == -1) {
      return null;
    }
    return _places.firstWhere((Place place) {
      return place.id == _selPlaceId;
    });
  }

  void setSelectedPlace(String index) {
    _selPlaceId = index;
    notifyListeners();
  }

  Future<Null> addPlace(String title, String address) {
    final Map<String, dynamic> placeData = {
      'title': title,
      'address': address,
    };

    _isLoading = true;
    notifyListeners();

    return http
        .post('https://iventory-9a893.firebaseio.com/places.json',
            body: json.encode(placeData))
        .then(
      (http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Place newPlace = Place(
          id: responseData['name'],
          title: title,
          address: address,
        );
        _places.add(newPlace);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<Null> fetchPlaces() {
    _isLoading = true;
    return http
        .get('https://iventory-9a893.firebaseio.com/places.json')
        .then((http.Response response) {
      final List<Place> fetchedPlaceList = [];
      final Map<String, dynamic> placeListData = json.decode(response.body);
      if (placeListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      placeListData.forEach((String placeId, dynamic placeData) {
        final Place place = Place(
          id: placeId,
          title: placeData['title'],
          address: placeData['address'],
        );
        fetchedPlaceList.add(place);
      });
      _places = fetchedPlaceList;
      _isLoading = false;
      notifyListeners();
      _selPlaceId = null;
    });
  }

  Future<Null> updatePlace(String title, String address) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'address': address
    };

    return http
        .put(
            'https://iventory-9a893.firebaseio.com/places/${selectedPlace.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;

      final Place updatedPlace = Place(
        id: selectedPlace.id,
        title: title,
        address: address,
      );
      _places[selectedPlaceIndex] = updatedPlace;
      notifyListeners();
    });
  }
}

mixin ProductsModel on ConnectedInventoryModel {
  List<Product> get allProducts {
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _places.indexWhere((Place place) {
      return place.id == _selPlaceId;
    });
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  void setSelectedProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  Future<Null> addProduct(
      String title, String description, String imageUrl, String category) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category
    };
    _isLoading = true;
    notifyListeners();

    return http
        .post('https://iventory-9a893.firebaseio.com/products.json',
            body: json.encode(productData))
        .then(
      (http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Product newProduct = Product(
            id: responseData['name'],
            title: title,
            category: category,
            description: description,
            imageUrl: imageUrl);

        _products.add(newProduct);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<Null> fetchProducts() {
    _isLoading = true;

    return http
        .get('https://iventory-9a893.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          category: productData['category'],
          imageUrl: productData['imageurl'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    });
  }

  void updateProduct(
      String name, String description, String imageUrl, String category) {
    // final Product updatedProduct = Product(
    //     title: name,
    //     description: description,
    //     imageUrl: imageUrl,
    //     category: category);

    // _products[selProductIndex] = updatedProduct;
    // notifyListeners();
  }
}

mixin UtilityModel on ConnectedInventoryModel {
  bool get isLoading {
    return _isLoading;
  }
}
