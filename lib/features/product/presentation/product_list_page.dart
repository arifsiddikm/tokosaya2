import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/product_provider.dart';
import '../data/models/product_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_drawer.dart';
import 'widgets/section_title.dart';
import 'widgets/product_horizontal_list.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  void _goToDetail(BuildContext context, Product product) {
    Navigator.pushNamed(context, AppRoutes.detail, arguments: product);
  }

  List<Product> _getSearchResults(List<Product> all) {
    if (_searchQuery.isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    return all
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  String _idrFormat(double price) {
    final idr = (price * 17000).round();
    return 'Rp ${idr.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => _isSearching
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (_) => false),
                child: const Text('🛍️ Toko Saya',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
        centerTitle: false,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _isSearching = false;
                _searchQuery = '';
                _searchController.clear();
              }),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
          ],
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(provider.error!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _onRefresh, child: const Text('Coba Lagi')),
                ],
              ),
            );
          }

          // Search mode
          if (_isSearching && _searchQuery.isNotEmpty) {
            final results = _getSearchResults(provider.all);
            return results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text('"$_searchQuery" tidak ditemukan',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final p = results[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Image.network(p.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image)),
                            ),
                          ),
                          title: Text(p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13)),
                          subtitle: Text(_idrFormat(p.price),
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold)),
                          onTap: () => _goToDetail(context, p),
                        ),
                      );
                    },
                  );
          }

          // Normal homepage
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belanja Mudah & Hemat',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Produk pilihan terbaik untuk kamu',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                SectionTitle(title: '🔥 Produk Terpopuler'),
                ProductHorizontalList(
                  products: provider.popular.take(10).toList(),
                  onTap: (p) => _goToDetail(context, p),
                ),

                SectionTitle(title: '🆕 Produk Terbaru'),
                ProductHorizontalList(
                  products: provider.newest.take(10).toList(),
                  onTap: (p) => _goToDetail(context, p),
                ),

                SectionTitle(title: '👔 Pakaian Pria'),
                ProductHorizontalList(
                  products: provider.byCategory(AppConstants.catMensClothing),
                  onTap: (p) => _goToDetail(context, p),
                ),

                SectionTitle(title: '👗 Pakaian Wanita'),
                ProductHorizontalList(
                  products: provider.byCategory(AppConstants.catWomensClothing),
                  onTap: (p) => _goToDetail(context, p),
                ),

                SectionTitle(title: '💍 Perhiasan & Aksesoris'),
                ProductHorizontalList(
                  products: provider.byCategory(AppConstants.catJewelery),
                  onTap: (p) => _goToDetail(context, p),
                ),

                SectionTitle(title: '📱 Elektronik'),
                ProductHorizontalList(
                  products: provider.byCategory(AppConstants.catElectronics),
                  onTap: (p) => _goToDetail(context, p),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
