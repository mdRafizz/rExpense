import 'package:drift/drift.dart';
import '../app_database.dart';

class BeneficiaryDao {
  final AppDatabase _db;

  const BeneficiaryDao(this._db);

  // Get all beneficiaries
  Stream<List<BeneficiaryTableData>> watchAllBeneficiaries() {
    return (_db.select(_db.beneficiaryTable)
          ..where((t) => t.isActive.equals(true)))
        .watch();
  }

  Future<List<BeneficiaryTableData>> getAllBeneficiaries() {
    return (_db.select(_db.beneficiaryTable)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  // Get beneficiary by id
  Future<BeneficiaryTableData?> getBeneficiaryById(int id) {
    return (_db.select(_db.beneficiaryTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Insert beneficiary
  Future<int> insertBeneficiary({
    required String name,
    String? relationship,
    int? colorInt,
  }) {
    return _db.into(_db.beneficiaryTable).insert(
          BeneficiaryTableCompanion.insert(
            name: name,
            relationship: Value(relationship),
            colorInt: Value(colorInt),
          ),
        );
  }

  // Update beneficiary
  Future<bool> updateBeneficiary({
    required int id,
    String? name,
    String? relationship,
    int? colorInt,
    bool? isActive,
  }) {
    return _db.update(_db.beneficiaryTable).replace(
          BeneficiaryTableData(
            id: id,
            name: name ?? '',
            relationship: relationship,
            colorInt: colorInt,
            isActive: isActive ?? true,
          ),
        );
  }

  // Delete beneficiary (soft delete)
  Future<int> deleteBeneficiary(int id) {
    return (_db.update(_db.beneficiaryTable)..where((t) => t.id.equals(id)))
        .write(const BeneficiaryTableCompanion(isActive: Value(false)));
  }

  // Hard delete beneficiary
  Future<int> hardDeleteBeneficiary(int id) {
    return (_db.delete(_db.beneficiaryTable)..where((t) => t.id.equals(id)))
        .go();
  }
}
