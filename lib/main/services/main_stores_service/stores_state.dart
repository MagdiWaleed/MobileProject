part of 'stores_bloc.dart';

abstract class StoresState {}

final class StoresInitial extends StoresState {}

class StoresGetDataLoadingState extends StoresState {}

class StoresGetDataSuccessState extends StoresState {
  final List storesList;
  StoresGetDataSuccessState({required this.storesList});
}

class StoresGetDataFailedState extends StoresState {}
