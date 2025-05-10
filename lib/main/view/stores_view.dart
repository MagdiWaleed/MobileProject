import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/widget/custom_store_card.dart';
import 'package:stores_app/main/provider/stores_provider.dart';
import 'package:stores_app/store_details/single_shop_view.dart';

class StoresView extends ConsumerStatefulWidget {
  @override
  ConsumerState<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends ConsumerState<StoresView> {
  @override
  Widget build(BuildContext context) {
    final storesState = ref.watch(storesProvider);

    return storesState.when(
      data:
          (data) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverGrid.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => SingleShopView(
                                  getProducts: true,
                                  shop: data[i],
                                ),
                          ),
                        );
                      },
                      child: CustomStoreCard(storeModel: data[i]),
                    );
                  },
                ),
              ],
            ),
          ),
      error:
          (error, stackTrace) =>
              Center(child: Text('Error loading stores: $error')),
      loading: () => Center(child: CustomLoading()),
    );
  }
}
