import 'package:flutter/material.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/external/theme/app_colors.dart';

class CustomShopCard extends StatelessWidget {
  final StoreModel shop;

  const CustomShopCard({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = shop.products;  
    final showItems = items.length > 2 ? items.sublist(0, 2) : items;
    final extraCount = items.length > 2 ? items.length - 2 : 0;
    return Stack(
      children: [
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(blurRadius: 5, color: const Color.fromARGB(255, 71, 71, 71))],
            color: Colors.white,
            
          ),
          margin: EdgeInsets.only(left: 2,right: 2, bottom: showItems.length ==1?10:0),
          padding: EdgeInsets.only(bottom: 2),
          child: Column(
            children: [
              Spacer(),

              if (items.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var item in showItems) ...[
                            Row(
                              children: [
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                              SizedBox(width: 8),
                                Image.network(
                                  shop.image,
                                  width: 16,
                                  height: 16,
                                  
                                ),
                                      SizedBox(width: 15),
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      ],),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                         child: Divider(height: 2,thickness: 0.9,color: Colors.black,))
                                    ],
                                  ),
                                ),
                            const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                        ],
                      ),
                    ),
                            
                  
                  ],
                ),
        
              ],
            ],
          ),
        ),
        if (extraCount!=0)
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 60,width: 55,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(12))
            ),
            child: Column(
              children: [
                Spacer(),
                Text("+${extraCount.toString()}",style: TextStyle(
                  color: Colors.white,fontWeight: FontWeight.w200,
                fontSize: 16),
                ),
                SizedBox(height: 18),
              ],
            ),
            )),

        Container(
            height: 180,
            // width: 200,

              decoration: BoxDecoration(
              borderRadius:  BorderRadius.circular(
                12,
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                     12,
                  ),
                  child: Image.network(
                    shop.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(
                      12,
                    ),
                    color: AppColors.storesCardColor.withOpacity(0.6),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
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
                            shop.review.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
