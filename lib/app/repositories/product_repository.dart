import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductRepository extends GetxService {
  static const String _productsKey = 'products';

  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_productsKey) ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Product.fromMap(json)).toList();
  }

  Future<Product> saveProduct(Product product) async {
    final products = await getProducts();
    final existingIndex = products.indexWhere((p) => p.id == product.id);

    if (existingIndex != -1) {
      products[existingIndex] = product.copyWith(
        updatedAt: DateTime.now(),
      );
    } else {
      products.add(product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }

    await _saveProducts(products);
    return product;
  }

  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(products.map((p) => p.toMap()).toList());
    await prefs.setString(_productsKey, jsonString);
  }

  Future<void> deleteProduct(String id) async {
    final products = await getProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }

  Future<Product?> getProductById(String id) async {
    final products = await getProducts();
    // ignore: cast_from_null_always_fails
    return products.firstWhere((p) => p.id == id,
        // ignore: cast_from_null_always_fails
        orElse: () => null as Product);
  }
}
