import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stores_app/external/widget/custom_item_card.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/widget/custom_shop_card.dart';
import 'package:stores_app/main/provider/search_provider.dart';
import 'package:stores_app/store_details/single_shop_view.dart';
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
    return CustomScrollView(
      slivers: [
        // Search bar
       SliverAppBar(
        floating: true,
        snap: true,
        flexibleSpace:  Padding(
          padding: const EdgeInsets.only(left: 10,right: 10, top:5),
          child: Column(
            children: [
              Row(
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
                               if(value =="Shop"){
                                ref.read(searchProvider.notifier).getInitialStoresList();
                               }
                               else if(value == "Item"){
                                  ref.read(searchProvider.notifier).getInitialItemsList();
                                }

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
                              onSubmitted: (value){
                                 if(_dropdownValue=="Shop"){
                                  ref.read(searchProvider.notifier).getStoresSearch(value);
                                }
                                else if(_dropdownValue =="Item"){
                                ref.read(searchProvider.notifier).getItemsSearch(value);
                                }
                              },
                              onChanged: (value){
                                 if(_dropdownValue=="Shop"){
                                  ref.read(searchProvider.notifier).getStoresSearch(value);
                                }
                                else if(_dropdownValue =="Item"){
                                ref.read(searchProvider.notifier).getItemsSearch(value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                       if(_dropdownValue=="Shop"){
                        ref.read(searchProvider.notifier).getStoresSearch(_searchController.text);
                      }
                      else if(_dropdownValue =="Item"){
                      ref.read(searchProvider.notifier).getItemsSearch(_searchController.text);
                      }
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
            
            ],
          ),
        ),
       ),

        // Content
        _dropdownValue == 'Shop' ? 
        searchState.when(data: (data){

          return  data.length!=0?
          SliverGrid.builder(
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
          ):SliverToBoxAdapter(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Text("There are no Product with: "+_searchController.text),
              
            ],
          ));
          
          }, error: (e,eTree)=>Center(
              child: SliverToBoxAdapter(child: Text("an Error Occure")),
              ), loading: ()=>SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          CustomLoading()
                        ],),
                  ],
                ),
              ))
        : 
        searchState.when(data: (combinedData) {
        final data = combinedData[0]['unique product'];
        // print(data);

        return    
        SliverToBoxAdapter(
          child: SizedBox(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return 
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _searchController.text =data[index]['product'];
                      });
                      ref.read(searchProvider.notifier).getItemsSearch(_searchController.text);
                      
                    },
                    child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child:   Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    
        
                    ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data[index]['product'],
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                                    ),
                  );
                },
              ),
          ),
        );
          },
          loading: ()=>SliverToBoxAdapter(child: CustomLoading(),),
          error: (error, stackTrace) => SliverToBoxAdapter(child:Text(error.toString())),
          ),


          if(_dropdownValue == 'Item' )
          searchState.when(
            
            data: (combinedData){
              
              final data = combinedData[0]["data"];

              return data.length!=0?
          SliverList.builder(
            itemCount: data.length,
            itemBuilder:(context,i)=>
             InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SingleShopView( shop: data[i]["store"],),
                    ),
                  );
                },
                child: CustomItemCard(item: data[i]["product"],storeName: data[i]["store"].name,),
              )
              ):SliverToBoxAdapter(child: Center(child: Text("There are no Product with: "+_searchController.text),));
              },
           error: (error,_)=>SliverToBoxAdapter(child: Text("an Error Occur"),),
            loading:()=>SliverToBoxAdapter(child: CustomLoading()))

        ,
    //     Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
      

    //     const SizedBox(height: 10),
    //     Expanded(
    //       child: ListView.builder(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         
    //   ],
    // );,
      ],
    );
  }

}