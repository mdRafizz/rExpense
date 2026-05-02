import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../data/repositories/sync_repository_impl.dart';
import '../../data/repositories/member_repository_impl.dart';

import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/repositories/member_repository.dart';

import '../../domain/usecases/manage_categories.dart';
import '../../domain/usecases/calculate_variance.dart';
import '../../domain/usecases/detect_spending_leaks.dart';
import '../../domain/usecases/get_period_summary.dart';

import '../../application/dashboard/dashboard_cubit.dart';
import '../../application/transaction/transaction_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../application/analytics/analytics_bloc.dart';
import '../../application/sync/sync_cubit.dart';
import '../../application/member/member_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── External ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(scopes: [DriveApi.driveAppdataScope]),
  );

  // ── Database ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(googleSignIn: sl(), db: sl()),
  );
  sl.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => ManageCategories(sl()));
  sl.registerLazySingleton(() => GetPeriodSummary(sl()));
  sl.registerLazySingleton(() => CalculateVariance(sl(), sl()));
  sl.registerLazySingleton(() => DetectSpendingLeaks(sl(), sl(), sl()));

  // ── BLoC / Cubits ─────────────────────────────────────────────────────────
  sl.registerFactory(() => DashboardCubit(sl()));
  sl.registerFactory(() => TransactionCubit(sl()));
  sl.registerFactory(() => CategoryCubit(sl()));
  sl.registerFactory(
    () => AnalyticsBloc(
      getPeriodSummary: sl(),
      calculateVariance: sl(),
      detectSpendingLeaks: sl(),
      transactionRepository: sl(),
      memberRepository: sl(),
    ),
  );
  sl.registerLazySingleton(() => SyncCubit(sl()));

  // Singleton so member selection persists across screens
  sl.registerLazySingleton(() => MemberCubit(sl()));
}
