import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/domain/auth_provider.dart';
import '../../product/domain/product_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _toIdr(double price) {
    final idr = (price * 17000).round();
    final str = idr.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final products = Provider.of<ProductProvider>(context);
    final user = auth.currentUser;

    // Total nilai semua produk
    final totalNilai = products.all.fold(0.0, (sum, p) => sum + p.price);
    // Rata-rata rating
    final avgRating = products.all.isEmpty
        ? 0.0
        : products.all.fold(0.0, (sum, p) => sum + p.rating) / products.all.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner selamat datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[700]!, Colors.green[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85), fontSize: 13),
                        ),
                        Text(
                          user?.fullName ?? user?.username ?? 'User',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user?.username ?? ''}  •  ${user?.email ?? ''}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text('Ringkasan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Total Produk',
                  value: '${products.all.length}',
                  color: Colors.blue[600]!,
                ),
                _StatCard(
                  icon: Icons.category_outlined,
                  label: 'Kategori',
                  value: '4',
                  color: Colors.purple[600]!,
                ),
                _StatCard(
                  icon: Icons.star_outline,
                  label: 'Avg Rating',
                  value: avgRating.toStringAsFixed(1),
                  color: Colors.amber[700]!,
                ),
                _StatCard(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Total Pesanan',
                  value: '12',
                  color: Colors.green[700]!,
                  note: 'dummy',
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text('Aktivitas',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Activity cards
            _ActivityCard(
              icon: Icons.favorite_border,
              color: Colors.red[400]!,
              title: 'Wishlist',
              subtitle: '5 produk disimpan',
              trailing: 'Lihat',
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _ActivityCard(
              icon: Icons.local_shipping_outlined,
              color: Colors.orange[600]!,
              title: 'Pesanan Aktif',
              subtitle: '2 pesanan dalam pengiriman',
              trailing: 'Lacak',
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _ActivityCard(
              icon: Icons.history,
              color: Colors.blue[600]!,
              title: 'Riwayat Belanja',
              subtitle: '10 transaksi selesai',
              trailing: 'Detail',
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _ActivityCard(
              icon: Icons.discount_outlined,
              color: Colors.green[600]!,
              title: 'Voucher Saya',
              subtitle: '3 voucher tersedia',
              trailing: 'Pakai',
              onTap: () {},
            ),

            const SizedBox(height: 20),
            // Nilai total produk (info dari API)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Nilai Katalog',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    _toIdr(totalNilai),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700]),
                  ),
                  const SizedBox(height: 4),
                  Text('Dari ${products.all.length} produk di katalog',
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Tombol logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[600],
                  side: BorderSide(color: Colors.red[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                onPressed: () => _confirmLogout(context),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (_) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? note;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  if (note != null) ...[
                    const SizedBox(width: 4),
                    Text('($note)',
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ],
              ),
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: Text(trailing,
            style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
                fontWeight: FontWeight.w600)),
        onTap: onTap,
      ),
    );
  }
}
