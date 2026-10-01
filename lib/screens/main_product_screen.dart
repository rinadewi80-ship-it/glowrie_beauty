import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';

class MainProductScreen extends StatefulWidget {
  const MainProductScreen({Key? key}) : super(key: key);

  @override
  State<MainProductScreen> createState() => _MainProductScreenState();
}

class _MainProductScreenState extends State<MainProductScreen> {
  // Daftar Produk Awal
  List<Product> products = [
    Product(
      id: '1',
      name: 'Mascara',
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?q=80&w=400',
    ),
    Product(
      id: '2',
      name: 'Perfect Powder',
      price: 75000,
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400',
    ),
    Product(
      id: '3',
      name: 'Perfect Blush',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400',
    ),
    Product(
      id: '4',
      name: 'Serum Cushion',
      price: 95000,
      imageUrl: 'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?q=80&w=400',
    ),
    Product(
      id: '5',
      name: 'Eyeshadow',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?q=80&w=400',
    ),
    Product(
      id: '6',
      name: 'Lipcream',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=400',
    ),
  ];

  List<CartItem> cartItems = [];

  // Menambah item ke keranjang
  void _addToCart(Product product) {
    setState(() {
      int index = cartItems.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  // Fungsi Menghapus Produk
  void _deleteProduct(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD39EA0)),
            onPressed: () {
              setState(() {
                products.removeWhere((p) => p.id == id);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Pop-Up Tambah Produk Baru
  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Foto Produk',
                    hintText: 'Masukkan link gambar/foto',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC48B92)),
              onPressed: () {
                final name = nameController.text.trim();
                final priceText = priceController.text.trim();
                final imageUrl = imageUrlController.text.trim();

                if (name.isNotEmpty && priceText.isNotEmpty) {
                  final price = int.tryParse(priceText) ?? 0;
                  final newProduct = Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    price: price,
                    imageUrl: imageUrl.isNotEmpty
                        ? imageUrl
                        : 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400',
                  );

                  setState(() {
                    products.add(newProduct);
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  int get totalCartCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 500 ? 3 : 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glowrie Beauty'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cartItems: cartItems,
                        onCartUpdated: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD39EA0),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$totalCartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${product.price}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _addToCart(product),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5C8CA),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.add, size: 20, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () => _deleteProduct(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFD39EA0),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: const Color(0xFFC48B92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}