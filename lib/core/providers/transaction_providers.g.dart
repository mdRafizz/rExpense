// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayTransactionsHash() => r'219b3ab83d4882e4f0954d881b6daa88ae69b838';

/// See also [todayTransactions].
@ProviderFor(todayTransactions)
final todayTransactionsProvider =
    AutoDisposeStreamProvider<List<TransactionWithDetails>>.internal(
  todayTransactions,
  name: r'todayTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTransactionsRef
    = AutoDisposeStreamProviderRef<List<TransactionWithDetails>>;
String _$allTransactionsHash() => r'25c2093eaff5d7e3b0c51483dd94e46949d2bde1';

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

/// See also [allTransactions].
@ProviderFor(allTransactions)
const allTransactionsProvider = AllTransactionsFamily();

/// See also [allTransactions].
class AllTransactionsFamily
    extends Family<AsyncValue<List<TransactionWithDetails>>> {
  /// See also [allTransactions].
  const AllTransactionsFamily();

  /// See also [allTransactions].
  AllTransactionsProvider call({
    DateTime? startDate,
    DateTime? endDate,
    String? transactionType,
    int? categoryId,
  }) {
    return AllTransactionsProvider(
      startDate: startDate,
      endDate: endDate,
      transactionType: transactionType,
      categoryId: categoryId,
    );
  }

  @override
  AllTransactionsProvider getProviderOverride(
    covariant AllTransactionsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      transactionType: provider.transactionType,
      categoryId: provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allTransactionsProvider';
}

/// See also [allTransactions].
class AllTransactionsProvider
    extends AutoDisposeStreamProvider<List<TransactionWithDetails>> {
  /// See also [allTransactions].
  AllTransactionsProvider({
    DateTime? startDate,
    DateTime? endDate,
    String? transactionType,
    int? categoryId,
  }) : this._internal(
          (ref) => allTransactions(
            ref as AllTransactionsRef,
            startDate: startDate,
            endDate: endDate,
            transactionType: transactionType,
            categoryId: categoryId,
          ),
          from: allTransactionsProvider,
          name: r'allTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allTransactionsHash,
          dependencies: AllTransactionsFamily._dependencies,
          allTransitiveDependencies:
              AllTransactionsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          transactionType: transactionType,
          categoryId: categoryId,
        );

  AllTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.transactionType,
    required this.categoryId,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final String? transactionType;
  final int? categoryId;

  @override
  Override overrideWith(
    Stream<List<TransactionWithDetails>> Function(AllTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllTransactionsProvider._internal(
        (ref) => create(ref as AllTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        transactionType: transactionType,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionWithDetails>>
      createElement() {
    return _AllTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllTransactionsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.transactionType == transactionType &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, transactionType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllTransactionsRef
    on AutoDisposeStreamProviderRef<List<TransactionWithDetails>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `transactionType` of this provider.
  String? get transactionType;

  /// The parameter `categoryId` of this provider.
  int? get categoryId;
}

class _AllTransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionWithDetails>>
    with AllTransactionsRef {
  _AllTransactionsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as AllTransactionsProvider).startDate;
  @override
  DateTime? get endDate => (origin as AllTransactionsProvider).endDate;
  @override
  String? get transactionType =>
      (origin as AllTransactionsProvider).transactionType;
  @override
  int? get categoryId => (origin as AllTransactionsProvider).categoryId;
}

String _$netBalanceHash() => r'93599dbd554aa735213a143ce412cc11fbbeee1f';

/// See also [netBalance].
@ProviderFor(netBalance)
const netBalanceProvider = NetBalanceFamily();

/// See also [netBalance].
class NetBalanceFamily extends Family<AsyncValue<double>> {
  /// See also [netBalance].
  const NetBalanceFamily();

  /// See also [netBalance].
  NetBalanceProvider call({
    DateTime? start,
    DateTime? end,
  }) {
    return NetBalanceProvider(
      start: start,
      end: end,
    );
  }

  @override
  NetBalanceProvider getProviderOverride(
    covariant NetBalanceProvider provider,
  ) {
    return call(
      start: provider.start,
      end: provider.end,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'netBalanceProvider';
}

/// See also [netBalance].
class NetBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [netBalance].
  NetBalanceProvider({
    DateTime? start,
    DateTime? end,
  }) : this._internal(
          (ref) => netBalance(
            ref as NetBalanceRef,
            start: start,
            end: end,
          ),
          from: netBalanceProvider,
          name: r'netBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$netBalanceHash,
          dependencies: NetBalanceFamily._dependencies,
          allTransitiveDependencies:
              NetBalanceFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  NetBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime? start;
  final DateTime? end;

  @override
  Override overrideWith(
    FutureOr<double> Function(NetBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NetBalanceProvider._internal(
        (ref) => create(ref as NetBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _NetBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NetBalanceProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NetBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `start` of this provider.
  DateTime? get start;

  /// The parameter `end` of this provider.
  DateTime? get end;
}

class _NetBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double> with NetBalanceRef {
  _NetBalanceProviderElement(super.provider);

  @override
  DateTime? get start => (origin as NetBalanceProvider).start;
  @override
  DateTime? get end => (origin as NetBalanceProvider).end;
}

String _$monthlyIncomeHash() => r'df20b0906b2844c493a842c63c76dac00e27017e';

/// See also [monthlyIncome].
@ProviderFor(monthlyIncome)
final monthlyIncomeProvider = AutoDisposeFutureProvider<double>.internal(
  monthlyIncome,
  name: r'monthlyIncomeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyIncomeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyIncomeRef = AutoDisposeFutureProviderRef<double>;
String _$monthlyExpenseHash() => r'e1e1c73080e23ab62f25dc82eaec313929f49f99';

/// See also [monthlyExpense].
@ProviderFor(monthlyExpense)
final monthlyExpenseProvider = AutoDisposeFutureProvider<double>.internal(
  monthlyExpense,
  name: r'monthlyExpenseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyExpenseRef = AutoDisposeFutureProviderRef<double>;
String _$expensesByCategoryHash() =>
    r'8cbdffe6e02d545bcc40d96bb7d7cb39932def4b';

/// See also [expensesByCategory].
@ProviderFor(expensesByCategory)
const expensesByCategoryProvider = ExpensesByCategoryFamily();

/// See also [expensesByCategory].
class ExpensesByCategoryFamily extends Family<AsyncValue<Map<int, double>>> {
  /// See also [expensesByCategory].
  const ExpensesByCategoryFamily();

  /// See also [expensesByCategory].
  ExpensesByCategoryProvider call({
    DateTime? start,
    DateTime? end,
  }) {
    return ExpensesByCategoryProvider(
      start: start,
      end: end,
    );
  }

  @override
  ExpensesByCategoryProvider getProviderOverride(
    covariant ExpensesByCategoryProvider provider,
  ) {
    return call(
      start: provider.start,
      end: provider.end,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByCategoryProvider';
}

/// See also [expensesByCategory].
class ExpensesByCategoryProvider
    extends AutoDisposeFutureProvider<Map<int, double>> {
  /// See also [expensesByCategory].
  ExpensesByCategoryProvider({
    DateTime? start,
    DateTime? end,
  }) : this._internal(
          (ref) => expensesByCategory(
            ref as ExpensesByCategoryRef,
            start: start,
            end: end,
          ),
          from: expensesByCategoryProvider,
          name: r'expensesByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expensesByCategoryHash,
          dependencies: ExpensesByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ExpensesByCategoryFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  ExpensesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime? start;
  final DateTime? end;

  @override
  Override overrideWith(
    FutureOr<Map<int, double>> Function(ExpensesByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByCategoryProvider._internal(
        (ref) => create(ref as ExpensesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<int, double>> createElement() {
    return _ExpensesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByCategoryProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByCategoryRef on AutoDisposeFutureProviderRef<Map<int, double>> {
  /// The parameter `start` of this provider.
  DateTime? get start;

  /// The parameter `end` of this provider.
  DateTime? get end;
}

class _ExpensesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, double>>
    with ExpensesByCategoryRef {
  _ExpensesByCategoryProviderElement(super.provider);

  @override
  DateTime? get start => (origin as ExpensesByCategoryProvider).start;
  @override
  DateTime? get end => (origin as ExpensesByCategoryProvider).end;
}

String _$dailyExpensesHash() => r'8215b422473d46f836d2e8d71c25295751e84fff';

/// See also [dailyExpenses].
@ProviderFor(dailyExpenses)
const dailyExpensesProvider = DailyExpensesFamily();

/// See also [dailyExpenses].
class DailyExpensesFamily extends Family<AsyncValue<Map<DateTime, double>>> {
  /// See also [dailyExpenses].
  const DailyExpensesFamily();

  /// See also [dailyExpenses].
  DailyExpensesProvider call({
    required DateTime start,
    required DateTime end,
  }) {
    return DailyExpensesProvider(
      start: start,
      end: end,
    );
  }

  @override
  DailyExpensesProvider getProviderOverride(
    covariant DailyExpensesProvider provider,
  ) {
    return call(
      start: provider.start,
      end: provider.end,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyExpensesProvider';
}

/// See also [dailyExpenses].
class DailyExpensesProvider
    extends AutoDisposeFutureProvider<Map<DateTime, double>> {
  /// See also [dailyExpenses].
  DailyExpensesProvider({
    required DateTime start,
    required DateTime end,
  }) : this._internal(
          (ref) => dailyExpenses(
            ref as DailyExpensesRef,
            start: start,
            end: end,
          ),
          from: dailyExpensesProvider,
          name: r'dailyExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyExpensesHash,
          dependencies: DailyExpensesFamily._dependencies,
          allTransitiveDependencies:
              DailyExpensesFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  DailyExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<Map<DateTime, double>> Function(DailyExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyExpensesProvider._internal(
        (ref) => create(ref as DailyExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<DateTime, double>> createElement() {
    return _DailyExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyExpensesProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyExpensesRef on AutoDisposeFutureProviderRef<Map<DateTime, double>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _DailyExpensesProviderElement
    extends AutoDisposeFutureProviderElement<Map<DateTime, double>>
    with DailyExpensesRef {
  _DailyExpensesProviderElement(super.provider);

  @override
  DateTime get start => (origin as DailyExpensesProvider).start;
  @override
  DateTime get end => (origin as DailyExpensesProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
