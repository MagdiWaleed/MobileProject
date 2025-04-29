// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$testHash() => r'65bfb0620cd7abb003dd74e5e35edd080118026a';

/// See also [Test].
@ProviderFor(Test)
final testProvider = AutoDisposeNotifierProvider<Test, int>.internal(
  Test.new,
  name: r'testProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$testHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Test = AutoDisposeNotifier<int>;
String _$getStoresDataTestHash() => r'b50eb0087ed0fbecd7864fb407c9ec0c75801888';

/// See also [GetStoresDataTest].
@ProviderFor(GetStoresDataTest)
final getStoresDataTestProvider = AutoDisposeAsyncNotifierProvider<
  GetStoresDataTest,
  List<StoreModel>
>.internal(
  GetStoresDataTest.new,
  name: r'getStoresDataTestProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getStoresDataTestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GetStoresDataTest = AutoDisposeAsyncNotifier<List<StoreModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
