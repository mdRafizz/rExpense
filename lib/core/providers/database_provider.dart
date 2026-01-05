import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_expense/core/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  ref.onDispose(() {
    db.close();
  });

  return db;
});
