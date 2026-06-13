import 'package:drift/drift.dart';
import '../app_database.dart';

class ContributorDao {
  final AppDatabase _db;

  const ContributorDao(this._db);

  // Get all contributors
  Stream<List<ContributorTableData>> watchAllContributors() {
    return (_db.select(_db.contributorTable)
          ..where((t) => t.isActive.equals(true)))
        .watch();
  }

  Future<List<ContributorTableData>> getAllContributors() {
    return (_db.select(_db.contributorTable)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  // Get contributor by id
  Future<ContributorTableData?> getContributorById(int id) {
    return (_db.select(_db.contributorTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Insert contributor
  Future<int> insertContributor({
    required String name,
    String? notes,
    int? colorInt,
  }) {
    return _db.into(_db.contributorTable).insert(
          ContributorTableCompanion.insert(
            name: name,
            notes: Value(notes),
            colorInt: Value(colorInt),
          ),
        );
  }

  // Update contributor
  Future<bool> updateContributor({
    required int id,
    String? name,
    String? notes,
    int? colorInt,
    bool? isActive,
  }) {
    return _db.update(_db.contributorTable).replace(
          ContributorTableData(
            id: id,
            name: name ?? '',
            notes: notes,
            colorInt: colorInt,
            isActive: isActive ?? true,
          ),
        );
  }

  // Delete contributor (soft delete)
  Future<int> deleteContributor(int id) {
    return (_db.update(_db.contributorTable)..where((t) => t.id.equals(id)))
        .write(const ContributorTableCompanion(isActive: Value(false)));
  }

  // Hard delete contributor
  Future<int> hardDeleteContributor(int id) {
    return (_db.delete(_db.contributorTable)..where((t) => t.id.equals(id)))
        .go();
  }
}
