import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/external/theme/app_colors.dart';

class CustomItemCard extends StatelessWidget {
  final ProductModel item;
  final String storeName;

  const CustomItemCard({Key? key, required this.item, required this.storeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/logo.png');
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      return LoadingIndicator(
                        indicatorType:Indicator.ballRotate,
                          colors: const [
                            AppColors.mainColor,
                            AppColors.mainColor,
                            AppColors.mainColor,
                      ], 
                      );
                    },
        
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texts
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.descrption,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    AppColors.mainColor,
                    AppColors.mainColor.withOpacity(0.8),
                    AppColors.mainColor.withOpacity(0.6),
                    AppColors.mainColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                storeName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
