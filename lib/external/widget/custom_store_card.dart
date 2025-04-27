import 'package:flutter/material.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/model/store_model.dart';

class CustomStoreCard extends StatelessWidget {
  CustomStoreCard({super.key, required this.storeModel});

  final StoreModel storeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [BoxShadow(blurRadius: 0.5, color: Colors.black26)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              storeModel.image,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.storesCardColor.withOpacity(0.6),
            ),
          ),
          Positioned(
            bottom: 9,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeModel.name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      storeModel.review.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 13),
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
