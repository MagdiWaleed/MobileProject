import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/widget/custom_store_card.dart';
import 'package:stores_app/main/services/main_stores_service/stores_bloc.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/single_store/view/single_store_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StoresView extends StatelessWidget {
  final StoresBloc storesBloc;
  StoresView({required this.storesBloc});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoresBloc, StoresState>(
      bloc: storesBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case StoresGetDataLoadingState:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomLoading()],
            );
          case StoresGetDataSuccessState:
            state = state as StoresGetDataSuccessState;
            AppData.allStores = state.storesList;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverGrid.builder(
                    itemCount: AppData.allStores!.length,
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
                                  (context) => SingleStoreView(
                                    storeModel: AppData.allStores![i],
                                  ),
                            ),
                          );
                        },
                        child: CustomStoreCard(
                          storeModel: AppData.allStores![i],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          case StoresGetDataFailedState:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomLoading()],
            );
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomLoading()],
            );
        }
      },
    );
  }
}
