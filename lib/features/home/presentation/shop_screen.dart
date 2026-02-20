import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: AppColors.background,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          _ShopItem(
            name: 'Gold Pack',
            price: r'$2.99',
            icon: Icons.monetization_on,
          ),
          _ShopItem(name: 'Diamond Pack', price: r'$9.99', icon: Icons.diamond),
          _ShopItem(name: 'Special Avatar', price: r'$4.99', icon: Icons.face),
          _ShopItem(name: 'Premium Pass', price: r'$14.99', icon: Icons.star),
        ],
      ),
    );
  }
}

class _ShopItem extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;

  const _ShopItem({
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppColors.gold),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(price, style: const TextStyle(color: AppColors.accent)),
        ],
      ),
    );
  }
}
