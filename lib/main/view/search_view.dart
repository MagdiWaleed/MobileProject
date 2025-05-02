import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/external/widget/custom_item_card.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/widget/custom_shop_card.dart';
import 'package:stores_app/main/provider/search_provider.dart';
import 'package:stores_app/main/view/item_shop_view.dart';
import 'package:stores_app/main/view/single_shop_view.dart';
import 'package:stores_app/external/theme/app_colors.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  String _dropdownValue = 'Shop';
  final TextEditingController _searchController = TextEditingController();

  // final List<Map<String, dynamic>> shops = [
  //   {
  //     'name': 'R/C name',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.6',
  //     'items': ['Latte', 'Cappuccino', 'Mocha'],
  //   },
  //   {
  //     'name': 'Coffee House',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.7',
  //     'items': ['Americano', 'Espresso'],
  //   },
  //   {
  //     'name': 'Burger King',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.2',
  //     'items': ['Whopper'],
  //   },
  //   {
  //     'name': 'Pizza Corner',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.8',
  //     'items': ['Margherita', 'Pepperoni', 'Veggie', 'BBQ Chicken'],
  //   },
  //   {
  //     'name': 'Sushi Spot',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.5',
  //     'items': ['California Roll', 'Nigiri', 'Sashimi', 'Maki', 'Uramaki'],
  //   },
  //   {
  //     'name': 'Taco Bell',
  //     'image': 'assets/images/logo.png',
  //     'rating': '4.3',
  //     'items': ['Crunchy Taco', 'Soft Taco', 'Burrito'],
  //   },
  // ];

  // final List<Map<String, String>> items = [
  //   {
  //     'shop': 'R/C name',
  //     'item': 'Espresso',
  //     'description': 'Strong and bold single shot espresso.',
  //     'image': 'assets/images/logo.png',
  //   },
  //   {
  //     'shop': 'Coffee House',
  //     'item': 'Iced Latte',
  //     'description': 'Smooth espresso with chilled milk and ice.',
  //     'image': 'assets/images/logo.png',
  //   },
  //   {
  //     'shop': 'Burger King',
  //     'item': 'Whopper',
  //     'description': 'Flame-grilled beef patty with fresh veggies.',
  //     'image': 'assets/images/logo.png',
  //   },
  //   {
  //     'shop': 'Pizza Corner',
  //     'item': 'Margherita',
  //     'description': 'Classic pizza with tomato, mozzarella, basil.',
  //     'image': 'assets/images/logo.png',
  //   },
  //   {
  //     'shop': 'Sushi Spot',
  //     'item': 'California Roll',
  //     'description': 'Crab, avocado, cucumber rolled in rice.',
  //     'image': 'assets/images/logo.png',
  //   },
  //   {
  //     'shop': 'Taco Bell',
  //     'item': 'Crunchwrap Supreme',
  //     'description': 'Taco filling wrapped in a crispy tostada shell.',
  //     'image': 'assets/images/logo.png',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (_dropdownValue == 'Item')
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _dropdownValue,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(value: 'Shop', child: Text('Shop')),
                          DropdownMenuItem(value: 'Item', child: Text('Item')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _dropdownValue = value);
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText:
                                _dropdownValue == 'Shop'
                                    ? 'Search by Shop...'
                                    : 'Search for items, cafés, restaurants...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: search logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Search'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Content
        Expanded(
          child: _dropdownValue == 'Shop' ? 
          searchState.when(data: (data)=>Stack(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SingleShopView(shop: data[index]),
                    ),
                  );
                },
                child: CustomShopCard(shop: data[index]),
              );
            },
          ),
        ),
        // map view button
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () {
              //TODO: map view logic  <<-- this is Rama's part
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.map, color: Colors.white, size: 18),
            label: const Text(
              'Map View',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ), error: (e,eTree)=>Center(
      child: Text("an Error Occure"),
      ), loading: ()=>Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
            CustomLoading()
          ],),
        ],
      ))
          : _buildItemUI(),
        ),
      ],
    );
  }


  Widget _buildItemUI() {
    return Container();
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(
    //       height: 100,
    //       child: ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         itemCount: items.length,
    //         itemBuilder: (context, index) {
    //           Map item = items[index];
    //           return Container(
    //             width: 80,
    //             margin: const EdgeInsets.only(right: 15),
    //             child: Column(
    //               children: [
    //                 Container(
    //                   height: 60,
    //                   width: 60,
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(30),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.grey.withOpacity(0.3),
    //                         blurRadius: 5,
    //                       ),
    //                     ],
    //                   ),
    //                   child: const Icon(Icons.fastfood),
    //                 ),
    //                 const SizedBox(height: 6),
    //                 Text(
    //                   item['item'],
    //                   style: const TextStyle(fontSize: 12),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ),

    //     const SizedBox(height: 10),
    //     Expanded(
    //       child: ListView.builder(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         itemCount: items.length,
    //         itemBuilder: (context, index) {
    //           return InkWell(
    //             onTap: () async {
    //               await Navigator.of(context).push(
    //                 MaterialPageRoute(
    //                   builder:
    //                       (context) =>
    //                           ItemShopsView(item: items[index], shops: shops),
    //                 ),
    //               );
    //             },
    //             child: CustomItemCard(item: items[index]),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
