import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductSelectionWidget extends StatelessWidget {
  final List<Product> selectedProducts;
  final Function(Product) onAddProduct;
  final Function(Product) onRemoveProduct;
  final Function(Product) onProductUpdated;
  final bool showManualEntry;

  const ProductSelectionWidget({
    Key? key,
    required this.selectedProducts,
    required this.onAddProduct,
    required this.onRemoveProduct,
    required this.onProductUpdated,
    this.showManualEntry = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product selection section
        const Text(
          'Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Dropdown to select existing products
        Obx(
          () => productController.products.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<Product>(
                    isExpanded: true,
                    hint: const Text('Select a product'),
                    value: null,
                    items: productController.products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text('${product.name} - \$${product.price} (${product.unit})'),
                      );
                    }).toList(),
                    onChanged: (Product? selectedProduct) {
                      if (selectedProduct != null) {
                        onAddProduct(selectedProduct);
                      }
                    },
                  ),
                )
              : const Text('No products available. Add some products first.'),
        ),
        const SizedBox(height: 16),

        // Manual product entry section
        if (showManualEntry) ...[
          ElevatedButton.icon(
            onPressed: () {
              _showManualProductDialog(context, onAddProduct);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Manual Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Selected products list
        if (selectedProducts.isNotEmpty) ...[
          const Text(
            'Selected Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...selectedProducts.asMap().entries.map((entry) {
            int index = entry.key;
            Product product = entry.value;
            return _buildProductItem(product, index, onRemoveProduct, onProductUpdated);
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildProductItem(
    Product product,
    int index,
    Function(Product) onRemoveProduct,
    Function(Product) onProductUpdated,
  ) {
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController(text: product.price.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unit: ${product.unit} | Tax: ${product.taxRate}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemoveProduct(product),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final quantity = double.tryParse(value) ?? 1;
                      final price = double.tryParse(priceController.text) ?? product.price;
                      final updatedProduct = product.copyWith(
                        price: price * quantity,
                      );
                      onProductUpdated(updatedProduct);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Unit Price',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final quantity = double.tryParse(quantityController.text) ?? 1;
                      final price = double.tryParse(value) ?? product.price;
                      final updatedProduct = product.copyWith(
                        price: price * quantity,
                      );
                      onProductUpdated(updatedProduct);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showManualProductDialog(
    BuildContext context,
    Function(Product) onAddProduct,
  ) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController(text: '0.0');
    final unitController = TextEditingController(text: 'unit');
    final taxController = TextEditingController(text: '0.0');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Manual Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit (e.g., hour, unit, kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: taxController,
                decoration: const InputDecoration(
                  labelText: 'Tax Rate (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final description = descriptionController.text;
              final price = double.tryParse(priceController.text) ?? 0.0;
              final unit = unitController.text;
              final taxRate = double.tryParse(taxController.text) ?? 0.0;

              if (name.isNotEmpty) {
                final manualProduct = Product(
                  id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
                  name: name,
                  description: description,
                  price: price,
                  unit: unit,
                  taxRate: taxRate,
                  category: 'Manual',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                onAddProduct(manualProduct);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    // Clean up controllers
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    unitController.dispose();
    taxController.dispose();
  }
}