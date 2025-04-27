import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stores_app/main/services/main_stores_service/repo/store_repo.dart';
import 'package:stores_app/external/model/store_model.dart';

part 'stores_event.dart';
part 'stores_state.dart';

class StoresBloc extends Bloc<StoresEvent, StoresState> {
  StoresBloc() : super(StoresInitial()) {
    on<StoresGetDataEvent>(storesGetData);
  }

  FutureOr<void> storesGetData(
    StoresGetDataEvent event,
    Emitter<StoresState> emit,
  ) async {

    emit(StoresGetDataLoadingState());
    final Map<String, dynamic> response = await StoreRepo.getStoresData();
    if (response['status']) {
      final List<dynamic> storesList =
          response['data'].map((e) => StoreModel.fromMap(e)).toList();
      emit(StoresGetDataSuccessState(storesList: storesList));
    } else {
      emit(StoresGetDataFailedState());
    }
  }
}
