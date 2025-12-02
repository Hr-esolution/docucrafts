import 'package:get/get.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  final RxList<Product> _products = <Product>[].obs;

  List<Product> get products => _products.toList();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _products.value = await _repository.getProducts();
  }

  Future<void> addProduct(Product product) async {
    await _repository.saveProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _repository.saveProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _repository.deleteProduct(id);
    await loadProducts();
  }

  Product? getProductById(String id) {
    return _products.firstWhere((p) => p.id == id, orElse: () => null);
  }

  // Method to add a default set of products for demonstration
  Future<void> addDefaultProducts() async {
    final defaultProducts = [
      Product(
        id: '1',
        name: 'Service Consulting',
        description: 'Professional consulting services',
        price: 150.0,
        unit: 'hour',
        taxRate: 20.0,
        category: 'Services',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Software Development',
        description: 'Custom software development',
        price: 200.0,
        unit: 'hour',
        taxRate: 20.0,
        category: 'Services',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'Basic Product',
        description: 'Basic product item',
        price: 50.0,
        unit: 'unit',
        taxRate: 10.0,
        category: 'Products',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '4',
        name: 'Premium Product',
        description: 'Premium quality product',
        price: 120.0,
        unit: 'unit',
        taxRate: 20.0,
        category: 'Products',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (final product in defaultProducts) {
      await addProduct(product);
    }
  }
}