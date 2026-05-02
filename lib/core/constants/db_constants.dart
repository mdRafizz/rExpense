/// Database table and column name constants.
class DbConstants {
  DbConstants._();

  // Table names
  static const String categoriesTable = 'categories';
  static const String transactionsTable = 'transactions';
  static const String budgetsTable = 'budgets';

  // Shared columns
  static const String colId = 'id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  // Category columns
  static const String colName = 'name';
  static const String colColor = 'color';
  static const String colIcon = 'icon';
  static const String colIsUnnecessary = 'is_unnecessary';

  // Transaction columns
  static const String colAmount = 'amount';
  static const String colType = 'type'; // 'income' | 'expense'
  static const String colCategoryId = 'category_id';
  static const String colNote = 'note';
  static const String colDate = 'date';

  // Budget columns
  static const String colCategoryIdRef = 'category_id';
  static const String colMonthlyLimit = 'monthly_limit';
  static const String colMonth = 'month'; // YYYY-MM
}
