// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storeDetailsHash() => r'087d186b5c307f3bcfe7006fd5aaef3401735a72';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$StoreDetails
    extends BuildlessAutoDisposeAsyncNotifier<StoreModel> {
  late final StoreModel store;

  FutureOr<StoreModel> build(StoreModel store);
}

/// See also [StoreDetails].
@ProviderFor(StoreDetails)
const storeDetailsProvider = StoreDetailsFamily();

/// See also [StoreDetails].
class StoreDetailsFamily extends Family<AsyncValue<StoreModel>> {
  /// See also [StoreDetails].
  const StoreDetailsFamily();

  /// See also [StoreDetails].
  StoreDetailsProvider call(StoreModel store) {
    return StoreDetailsProvider(store);
  }

  @override
  StoreDetailsProvider getProviderOverride(
    covariant StoreDetailsProvider provider,
  ) {
    return call(provider.store);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storeDetailsProvider';
}

/// See also [StoreDetails].
class StoreDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<StoreDetails, StoreModel> {
  /// See also [StoreDetails].
  StoreDetailsProvider(StoreModel store)
    : this._internal(
        () => StoreDetails()..store = store,
        from: storeDetailsProvider,
        name: r'storeDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$storeDetailsHash,
        dependencies: StoreDetailsFamily._dependencies,
        allTransitiveDependencies:
            StoreDetailsFamily._allTransitiveDependencies,
        store: store,
      );

  StoreDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.store,
  }) : super.internal();

  final StoreModel store;

  @override
  FutureOr<StoreModel> runNotifierBuild(covariant StoreDetails notifier) {
    return notifier.build(store);
  }

  @override
  Override overrideWith(StoreDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: StoreDetailsProvider._internal(
        () => create()..store = store,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        store: store,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<StoreDetails, StoreModel>
  createElement() {
    return _StoreDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreDetailsProvider && other.store == store;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, store.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoreDetailsRef on AutoDisposeAsyncNotifierProviderRef<StoreModel> {
  /// The parameter `store` of this provider.
  StoreModel get store;
}

class _StoreDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StoreDetails, StoreModel>
    with StoreDetailsRef {
  _StoreDetailsProviderElement(super.provider);

  @override
  StoreModel get store => (origin as StoreDetailsProvider).store;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
