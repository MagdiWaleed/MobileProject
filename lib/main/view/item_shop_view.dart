import 'package:flutter/material.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_item_card.dart';

class ItemShopsView extends StatelessWidget {
  final Map<String, String> item;
  final List<Map<String, dynamic>> shops;

  const ItemShopsView({required this.item, required this.shops, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset('assets/images/logo.png', height: 50),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomItemCard(item: item),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: shops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return CustomItemShopCard(shop: shops[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomItemShopCard extends StatelessWidget {
  final Map<String, dynamic> shop;

  const CustomItemShopCard({required this.shop, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black26)],
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              shop['image'] ?? 'assets/images/logo.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),

          // Dark overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.storesCardColor.withOpacity(0.6),
            ),
          ),

          // Text content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      shop['rating'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
