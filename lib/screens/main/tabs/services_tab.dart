import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sasco Services'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildServiceItem(
              icon: Icons.local_gas_station,
              title: 'Fuel Stations',
              onTap: () {},
            ),
            _buildServiceItem(
              icon: Icons.car_repair,
              title: 'Car Services',
              onTap: () {},
            ),
            _buildServiceItem(
              icon: Icons.local_car_wash,
              title: 'Car Wash',
              onTap: () {},
            ),
            _buildServiceItem(
              icon: Icons.shopping_cart,
              title: 'Mini Market',
              onTap: () {},
            ),
            _buildServiceItem(
              icon: Icons.coffee,
              title: 'Coffee Shop',
              onTap: () {},
            ),
            _buildServiceItem(
              icon: Icons.mosque,
              title: 'Prayer Room',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}