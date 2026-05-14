// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, CategoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'CHECK (type IN ("income","expense"))');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorIntMeta =
      const VerificationMeta('colorInt');
  @override
  late final GeneratedColumn<int> colorInt = GeneratedColumn<int>(
      'color_int', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, note, colorInt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('color_int')) {
      context.handle(_colorIntMeta,
          colorInt.isAcceptableOrUnknown(data['color_int']!, _colorIntMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      colorInt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_int']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class CategoryTableData extends DataClass
    implements Insertable<CategoryTableData> {
  final int id;
  final String name;
  final String type;
  final String? note;
  final int? colorInt;
  final bool isActive;
  const CategoryTableData(
      {required this.id,
      required this.name,
      required this.type,
      this.note,
      this.colorInt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || colorInt != null) {
      map['color_int'] = Variable<int>(colorInt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      colorInt: colorInt == null && nullToAbsent
          ? const Value.absent()
          : Value(colorInt),
      isActive: Value(isActive),
    );
  }

  factory CategoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
      colorInt: serializer.fromJson<int?>(json['colorInt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
      'colorInt': serializer.toJson<int?>(colorInt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CategoryTableData copyWith(
          {int? id,
          String? name,
          String? type,
          Value<String?> note = const Value.absent(),
          Value<int?> colorInt = const Value.absent(),
          bool? isActive}) =>
      CategoryTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        note: note.present ? note.value : this.note,
        colorInt: colorInt.present ? colorInt.value : this.colorInt,
        isActive: isActive ?? this.isActive,
      );
  CategoryTableData copyWithCompanion(CategoryTableCompanion data) {
    return CategoryTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      colorInt: data.colorInt.present ? data.colorInt.value : this.colorInt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, note, colorInt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.note == this.note &&
          other.colorInt == this.colorInt &&
          other.isActive == this.isActive);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> note;
  final Value<int?> colorInt;
  final Value<bool> isActive;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.note = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<CategoryTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? note,
    Expression<int>? colorInt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (colorInt != null) 'color_int': colorInt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String?>? note,
      Value<int?>? colorInt,
      Value<bool>? isActive}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      note: note ?? this.note,
      colorInt: colorInt ?? this.colorInt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (colorInt.present) {
      map['color_int'] = Variable<int>(colorInt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ContributorTableTable extends ContributorTable
    with TableInfo<$ContributorTableTable, ContributorTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContributorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorIntMeta =
      const VerificationMeta('colorInt');
  @override
  late final GeneratedColumn<int> colorInt = GeneratedColumn<int>(
      'color_int', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, notes, colorInt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contributor_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContributorTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('color_int')) {
      context.handle(_colorIntMeta,
          colorInt.isAcceptableOrUnknown(data['color_int']!, _colorIntMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContributorTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContributorTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      colorInt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_int']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ContributorTableTable createAlias(String alias) {
    return $ContributorTableTable(attachedDatabase, alias);
  }
}

class ContributorTableData extends DataClass
    implements Insertable<ContributorTableData> {
  final int id;
  final String name;
  final String? notes;
  final int? colorInt;
  final bool isActive;
  const ContributorTableData(
      {required this.id,
      required this.name,
      this.notes,
      this.colorInt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || colorInt != null) {
      map['color_int'] = Variable<int>(colorInt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ContributorTableCompanion toCompanion(bool nullToAbsent) {
    return ContributorTableCompanion(
      id: Value(id),
      name: Value(name),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      colorInt: colorInt == null && nullToAbsent
          ? const Value.absent()
          : Value(colorInt),
      isActive: Value(isActive),
    );
  }

  factory ContributorTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContributorTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      colorInt: serializer.fromJson<int?>(json['colorInt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'colorInt': serializer.toJson<int?>(colorInt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ContributorTableData copyWith(
          {int? id,
          String? name,
          Value<String?> notes = const Value.absent(),
          Value<int?> colorInt = const Value.absent(),
          bool? isActive}) =>
      ContributorTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        notes: notes.present ? notes.value : this.notes,
        colorInt: colorInt.present ? colorInt.value : this.colorInt,
        isActive: isActive ?? this.isActive,
      );
  ContributorTableData copyWithCompanion(ContributorTableCompanion data) {
    return ContributorTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      colorInt: data.colorInt.present ? data.colorInt.value : this.colorInt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContributorTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes, colorInt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContributorTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.colorInt == this.colorInt &&
          other.isActive == this.isActive);
}

class ContributorTableCompanion extends UpdateCompanion<ContributorTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<int?> colorInt;
  final Value<bool> isActive;
  const ContributorTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ContributorTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ContributorTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<int>? colorInt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (colorInt != null) 'color_int': colorInt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ContributorTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? notes,
      Value<int?>? colorInt,
      Value<bool>? isActive}) {
    return ContributorTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      colorInt: colorInt ?? this.colorInt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (colorInt.present) {
      map['color_int'] = Variable<int>(colorInt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContributorTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $BeneficiaryTableTable extends BeneficiaryTable
    with TableInfo<$BeneficiaryTableTable, BeneficiaryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeneficiaryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _relationshipMeta =
      const VerificationMeta('relationship');
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
      'relationship', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorIntMeta =
      const VerificationMeta('colorInt');
  @override
  late final GeneratedColumn<int> colorInt = GeneratedColumn<int>(
      'color_int', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, relationship, colorInt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beneficiary_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BeneficiaryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
          _relationshipMeta,
          relationship.isAcceptableOrUnknown(
              data['relationship']!, _relationshipMeta));
    }
    if (data.containsKey('color_int')) {
      context.handle(_colorIntMeta,
          colorInt.isAcceptableOrUnknown(data['color_int']!, _colorIntMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BeneficiaryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BeneficiaryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      relationship: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relationship']),
      colorInt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_int']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $BeneficiaryTableTable createAlias(String alias) {
    return $BeneficiaryTableTable(attachedDatabase, alias);
  }
}

class BeneficiaryTableData extends DataClass
    implements Insertable<BeneficiaryTableData> {
  final int id;
  final String name;
  final String? relationship;
  final int? colorInt;
  final bool isActive;
  const BeneficiaryTableData(
      {required this.id,
      required this.name,
      this.relationship,
      this.colorInt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || relationship != null) {
      map['relationship'] = Variable<String>(relationship);
    }
    if (!nullToAbsent || colorInt != null) {
      map['color_int'] = Variable<int>(colorInt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  BeneficiaryTableCompanion toCompanion(bool nullToAbsent) {
    return BeneficiaryTableCompanion(
      id: Value(id),
      name: Value(name),
      relationship: relationship == null && nullToAbsent
          ? const Value.absent()
          : Value(relationship),
      colorInt: colorInt == null && nullToAbsent
          ? const Value.absent()
          : Value(colorInt),
      isActive: Value(isActive),
    );
  }

  factory BeneficiaryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BeneficiaryTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      relationship: serializer.fromJson<String?>(json['relationship']),
      colorInt: serializer.fromJson<int?>(json['colorInt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'relationship': serializer.toJson<String?>(relationship),
      'colorInt': serializer.toJson<int?>(colorInt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  BeneficiaryTableData copyWith(
          {int? id,
          String? name,
          Value<String?> relationship = const Value.absent(),
          Value<int?> colorInt = const Value.absent(),
          bool? isActive}) =>
      BeneficiaryTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        relationship:
            relationship.present ? relationship.value : this.relationship,
        colorInt: colorInt.present ? colorInt.value : this.colorInt,
        isActive: isActive ?? this.isActive,
      );
  BeneficiaryTableData copyWithCompanion(BeneficiaryTableCompanion data) {
    return BeneficiaryTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      colorInt: data.colorInt.present ? data.colorInt.value : this.colorInt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiaryTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, relationship, colorInt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BeneficiaryTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.relationship == this.relationship &&
          other.colorInt == this.colorInt &&
          other.isActive == this.isActive);
}

class BeneficiaryTableCompanion extends UpdateCompanion<BeneficiaryTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> relationship;
  final Value<int?> colorInt;
  final Value<bool> isActive;
  const BeneficiaryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.relationship = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  BeneficiaryTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.relationship = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<BeneficiaryTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? relationship,
    Expression<int>? colorInt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (relationship != null) 'relationship': relationship,
      if (colorInt != null) 'color_int': colorInt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  BeneficiaryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? relationship,
      Value<int?>? colorInt,
      Value<bool>? isActive}) {
    return BeneficiaryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      colorInt: colorInt ?? this.colorInt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (colorInt.present) {
      map['color_int'] = Variable<int>(colorInt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiaryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('colorInt: $colorInt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AccountTableTable extends AccountTable
    with TableInfo<$AccountTableTable, AccountTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'CHECK (accountType IN ("cash","bank","mobile_wallet","other"))');
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _colorIntMeta =
      const VerificationMeta('colorInt');
  @override
  late final GeneratedColumn<int> colorInt = GeneratedColumn<int>(
      'color_int', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 4),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('৳'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, accountType, initialBalance, colorInt, currency, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_table';
  @override
  VerificationContext validateIntegrity(Insertable<AccountTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    }
    if (data.containsKey('color_int')) {
      context.handle(_colorIntMeta,
          colorInt.isAcceptableOrUnknown(data['color_int']!, _colorIntMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type'])!,
      initialBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_balance'])!,
      colorInt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_int']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AccountTableTable createAlias(String alias) {
    return $AccountTableTable(attachedDatabase, alias);
  }
}

class AccountTableData extends DataClass
    implements Insertable<AccountTableData> {
  final int id;
  final String name;
  final String accountType;
  final double initialBalance;
  final int? colorInt;
  final String currency;
  final bool isActive;
  const AccountTableData(
      {required this.id,
      required this.name,
      required this.accountType,
      required this.initialBalance,
      this.colorInt,
      required this.currency,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['account_type'] = Variable<String>(accountType);
    map['initial_balance'] = Variable<double>(initialBalance);
    if (!nullToAbsent || colorInt != null) {
      map['color_int'] = Variable<int>(colorInt);
    }
    map['currency'] = Variable<String>(currency);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AccountTableCompanion toCompanion(bool nullToAbsent) {
    return AccountTableCompanion(
      id: Value(id),
      name: Value(name),
      accountType: Value(accountType),
      initialBalance: Value(initialBalance),
      colorInt: colorInt == null && nullToAbsent
          ? const Value.absent()
          : Value(colorInt),
      currency: Value(currency),
      isActive: Value(isActive),
    );
  }

  factory AccountTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountType: serializer.fromJson<String>(json['accountType']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      colorInt: serializer.fromJson<int?>(json['colorInt']),
      currency: serializer.fromJson<String>(json['currency']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'accountType': serializer.toJson<String>(accountType),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'colorInt': serializer.toJson<int?>(colorInt),
      'currency': serializer.toJson<String>(currency),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  AccountTableData copyWith(
          {int? id,
          String? name,
          String? accountType,
          double? initialBalance,
          Value<int?> colorInt = const Value.absent(),
          String? currency,
          bool? isActive}) =>
      AccountTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        accountType: accountType ?? this.accountType,
        initialBalance: initialBalance ?? this.initialBalance,
        colorInt: colorInt.present ? colorInt.value : this.colorInt,
        currency: currency ?? this.currency,
        isActive: isActive ?? this.isActive,
      );
  AccountTableData copyWithCompanion(AccountTableCompanion data) {
    return AccountTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      colorInt: data.colorInt.present ? data.colorInt.value : this.colorInt,
      currency: data.currency.present ? data.currency.value : this.currency,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('colorInt: $colorInt, ')
          ..write('currency: $currency, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, accountType, initialBalance, colorInt, currency, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountType == this.accountType &&
          other.initialBalance == this.initialBalance &&
          other.colorInt == this.colorInt &&
          other.currency == this.currency &&
          other.isActive == this.isActive);
}

class AccountTableCompanion extends UpdateCompanion<AccountTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> accountType;
  final Value<double> initialBalance;
  final Value<int?> colorInt;
  final Value<String> currency;
  final Value<bool> isActive;
  const AccountTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountType = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.currency = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AccountTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String accountType,
    this.initialBalance = const Value.absent(),
    this.colorInt = const Value.absent(),
    this.currency = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        accountType = Value(accountType);
  static Insertable<AccountTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? accountType,
    Expression<double>? initialBalance,
    Expression<int>? colorInt,
    Expression<String>? currency,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountType != null) 'account_type': accountType,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (colorInt != null) 'color_int': colorInt,
      if (currency != null) 'currency': currency,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AccountTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? accountType,
      Value<double>? initialBalance,
      Value<int?>? colorInt,
      Value<String>? currency,
      Value<bool>? isActive}) {
    return AccountTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      initialBalance: initialBalance ?? this.initialBalance,
      colorInt: colorInt ?? this.colorInt,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (colorInt.present) {
      map['color_int'] = Variable<int>(colorInt.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('colorInt: $colorInt, ')
          ..write('currency: $currency, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, TransactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> transactionDate =
      GeneratedColumn<int>('transaction_date', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DateTime>(
              $TransactionTableTable.$convertertransactionDate);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transactionTypeMeta =
      const VerificationMeta('transactionType');
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
      'transaction_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (transactionType IN ("income","expense"))');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'));
  static const VerificationMeta _contributorIdMeta =
      const VerificationMeta('contributorId');
  @override
  late final GeneratedColumn<int> contributorId = GeneratedColumn<int>(
      'contributor_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contributor_table (id)'));
  static const VerificationMeta _beneficiaryIdMeta =
      const VerificationMeta('beneficiaryId');
  @override
  late final GeneratedColumn<int> beneficiaryId = GeneratedColumn<int>(
      'beneficiary_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES beneficiary_table (id)'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES account_table (id)'));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              clientDefault: () => DateTime.now().millisecondsSinceEpoch)
          .withConverter<DateTime>($TransactionTableTable.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        transactionDate,
        notes,
        transactionType,
        categoryId,
        contributorId,
        beneficiaryId,
        accountId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
          _transactionTypeMeta,
          transactionType.isAcceptableOrUnknown(
              data['transaction_type']!, _transactionTypeMeta));
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('contributor_id')) {
      context.handle(
          _contributorIdMeta,
          contributorId.isAcceptableOrUnknown(
              data['contributor_id']!, _contributorIdMeta));
    }
    if (data.containsKey('beneficiary_id')) {
      context.handle(
          _beneficiaryIdMeta,
          beneficiaryId.isAcceptableOrUnknown(
              data['beneficiary_id']!, _beneficiaryIdMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      transactionDate: $TransactionTableTable.$convertertransactionDate.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}transaction_date'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      transactionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transaction_type'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      contributorId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}contributor_id']),
      beneficiaryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}beneficiary_id']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      createdAt: $TransactionTableTable.$convertercreatedAt.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!),
    );
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertertransactionDate =
      const DateTimeConverter();
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
}

class TransactionTableData extends DataClass
    implements Insertable<TransactionTableData> {
  final int id;
  final double amount;
  final DateTime transactionDate;
  final String? notes;
  final String transactionType;
  final int categoryId;
  final int? contributorId;
  final int? beneficiaryId;
  final int accountId;
  final DateTime createdAt;
  const TransactionTableData(
      {required this.id,
      required this.amount,
      required this.transactionDate,
      this.notes,
      required this.transactionType,
      required this.categoryId,
      this.contributorId,
      this.beneficiaryId,
      required this.accountId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    {
      map['transaction_date'] = Variable<int>($TransactionTableTable
          .$convertertransactionDate
          .toSql(transactionDate));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || contributorId != null) {
      map['contributor_id'] = Variable<int>(contributorId);
    }
    if (!nullToAbsent || beneficiaryId != null) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId);
    }
    map['account_id'] = Variable<int>(accountId);
    {
      map['created_at'] = Variable<int>(
          $TransactionTableTable.$convertercreatedAt.toSql(createdAt));
    }
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      id: Value(id),
      amount: Value(amount),
      transactionDate: Value(transactionDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      transactionType: Value(transactionType),
      categoryId: Value(categoryId),
      contributorId: contributorId == null && nullToAbsent
          ? const Value.absent()
          : Value(contributorId),
      beneficiaryId: beneficiaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryId),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTableData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      contributorId: serializer.fromJson<int?>(json['contributorId']),
      beneficiaryId: serializer.fromJson<int?>(json['beneficiaryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'notes': serializer.toJson<String?>(notes),
      'transactionType': serializer.toJson<String>(transactionType),
      'categoryId': serializer.toJson<int>(categoryId),
      'contributorId': serializer.toJson<int?>(contributorId),
      'beneficiaryId': serializer.toJson<int?>(beneficiaryId),
      'accountId': serializer.toJson<int>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionTableData copyWith(
          {int? id,
          double? amount,
          DateTime? transactionDate,
          Value<String?> notes = const Value.absent(),
          String? transactionType,
          int? categoryId,
          Value<int?> contributorId = const Value.absent(),
          Value<int?> beneficiaryId = const Value.absent(),
          int? accountId,
          DateTime? createdAt}) =>
      TransactionTableData(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        transactionDate: transactionDate ?? this.transactionDate,
        notes: notes.present ? notes.value : this.notes,
        transactionType: transactionType ?? this.transactionType,
        categoryId: categoryId ?? this.categoryId,
        contributorId:
            contributorId.present ? contributorId.value : this.contributorId,
        beneficiaryId:
            beneficiaryId.present ? beneficiaryId.value : this.beneficiaryId,
        accountId: accountId ?? this.accountId,
        createdAt: createdAt ?? this.createdAt,
      );
  TransactionTableData copyWithCompanion(TransactionTableCompanion data) {
    return TransactionTableData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      contributorId: data.contributorId.present
          ? data.contributorId.value
          : this.contributorId,
      beneficiaryId: data.beneficiaryId.present
          ? data.beneficiaryId.value
          : this.beneficiaryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('transactionType: $transactionType, ')
          ..write('categoryId: $categoryId, ')
          ..write('contributorId: $contributorId, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amount,
      transactionDate,
      notes,
      transactionType,
      categoryId,
      contributorId,
      beneficiaryId,
      accountId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTableData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.transactionDate == this.transactionDate &&
          other.notes == this.notes &&
          other.transactionType == this.transactionType &&
          other.categoryId == this.categoryId &&
          other.contributorId == this.contributorId &&
          other.beneficiaryId == this.beneficiaryId &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt);
}

class TransactionTableCompanion extends UpdateCompanion<TransactionTableData> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> transactionDate;
  final Value<String?> notes;
  final Value<String> transactionType;
  final Value<int> categoryId;
  final Value<int?> contributorId;
  final Value<int?> beneficiaryId;
  final Value<int> accountId;
  final Value<DateTime> createdAt;
  const TransactionTableCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.contributorId = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    required DateTime transactionDate,
    this.notes = const Value.absent(),
    required String transactionType,
    required int categoryId,
    this.contributorId = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    required int accountId,
    this.createdAt = const Value.absent(),
  })  : transactionDate = Value(transactionDate),
        transactionType = Value(transactionType),
        categoryId = Value(categoryId),
        accountId = Value(accountId);
  static Insertable<TransactionTableData> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? transactionDate,
    Expression<String>? notes,
    Expression<String>? transactionType,
    Expression<int>? categoryId,
    Expression<int>? contributorId,
    Expression<int>? beneficiaryId,
    Expression<int>? accountId,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (notes != null) 'notes': notes,
      if (transactionType != null) 'transaction_type': transactionType,
      if (categoryId != null) 'category_id': categoryId,
      if (contributorId != null) 'contributor_id': contributorId,
      if (beneficiaryId != null) 'beneficiary_id': beneficiaryId,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<DateTime>? transactionDate,
      Value<String?>? notes,
      Value<String>? transactionType,
      Value<int>? categoryId,
      Value<int?>? contributorId,
      Value<int?>? beneficiaryId,
      Value<int>? accountId,
      Value<DateTime>? createdAt}) {
    return TransactionTableCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      contributorId: contributorId ?? this.contributorId,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<int>($TransactionTableTable
          .$convertertransactionDate
          .toSql(transactionDate.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (contributorId.present) {
      map['contributor_id'] = Variable<int>(contributorId.value);
    }
    if (beneficiaryId.present) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $TransactionTableTable.$convertercreatedAt.toSql(createdAt.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('transactionType: $transactionType, ')
          ..write('categoryId: $categoryId, ')
          ..write('contributorId: $contributorId, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $ContributorTableTable contributorTable =
      $ContributorTableTable(this);
  late final $BeneficiaryTableTable beneficiaryTable =
      $BeneficiaryTableTable(this);
  late final $AccountTableTable accountTable = $AccountTableTable(this);
  late final $TransactionTableTable transactionTable =
      $TransactionTableTable(this);
  late final Index idxTransactionsDate = Index('idx_transactions_date',
      'CREATE INDEX idx_transactions_date ON transaction_table (transaction_date)');
  late final Index idxTransactionsCategory = Index('idx_transactions_category',
      'CREATE INDEX idx_transactions_category ON transaction_table (category_id)');
  late final Index idxTransactionsBeneficiary = Index(
      'idx_transactions_beneficiary',
      'CREATE INDEX idx_transactions_beneficiary ON transaction_table (beneficiary_id)');
  late final Index idxTransactionsTypeDate = Index('idx_transactions_type_date',
      'CREATE INDEX idx_transactions_type_date ON transaction_table (transaction_type, transaction_date)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categoryTable,
        contributorTable,
        beneficiaryTable,
        accountTable,
        transactionTable,
        idxTransactionsDate,
        idxTransactionsCategory,
        idxTransactionsBeneficiary,
        idxTransactionsTypeDate
      ];
}

typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String type,
  Value<String?> note,
  Value<int?> colorInt,
  Value<bool> isActive,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<String?> note,
  Value<int?> colorInt,
  Value<bool> isActive,
});

final class $$CategoryTableTableReferences extends BaseReferences<_$AppDatabase,
    $CategoryTableTable, CategoryTableData> {
  $$CategoryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
      _transactionTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionTable,
              aliasName: $_aliasNameGenerator(
                  db.categoryTable.id, db.transactionTable.categoryId));

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager =
        $$TransactionTableTableTableManager($_db, $_db.transactionTable)
            .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionTableRefs(
      Expression<bool> Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableFilterComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CategoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get colorInt =>
      $composableBuilder(column: $table.colorInt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> transactionTableRefs<T extends Object>(
      Expression<T> Function($$TransactionTableTableAnnotationComposer a) f) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryTableTable,
    CategoryTableData,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (CategoryTableData, $$CategoryTableTableReferences),
    CategoryTableData,
    PrefetchHooks Function({bool transactionTableRefs})> {
  $$CategoryTableTableTableManager(_$AppDatabase db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            type: type,
            note: note,
            colorInt: colorInt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String type,
            Value<String?> note = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            note: note,
            colorInt: colorInt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<CategoryTableData,
                            $CategoryTableTable, TransactionTableData>(
                        currentTable: table,
                        referencedTable: $$CategoryTableTableReferences
                            ._transactionTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoryTableTableReferences(db, table, p0)
                                .transactionTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoryTableTable,
    CategoryTableData,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (CategoryTableData, $$CategoryTableTableReferences),
    CategoryTableData,
    PrefetchHooks Function({bool transactionTableRefs})>;
typedef $$ContributorTableTableCreateCompanionBuilder
    = ContributorTableCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> notes,
  Value<int?> colorInt,
  Value<bool> isActive,
});
typedef $$ContributorTableTableUpdateCompanionBuilder
    = ContributorTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> notes,
  Value<int?> colorInt,
  Value<bool> isActive,
});

final class $$ContributorTableTableReferences extends BaseReferences<
    _$AppDatabase, $ContributorTableTable, ContributorTableData> {
  $$ContributorTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
      _transactionTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionTable,
              aliasName: $_aliasNameGenerator(
                  db.contributorTable.id, db.transactionTable.contributorId));

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager = $$TransactionTableTableTableManager(
            $_db, $_db.transactionTable)
        .filter((f) => f.contributorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ContributorTableTableFilterComposer
    extends Composer<_$AppDatabase, $ContributorTableTable> {
  $$ContributorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionTableRefs(
      Expression<bool> Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.contributorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableFilterComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContributorTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ContributorTableTable> {
  $$ContributorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ContributorTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContributorTableTable> {
  $$ContributorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get colorInt =>
      $composableBuilder(column: $table.colorInt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> transactionTableRefs<T extends Object>(
      Expression<T> Function($$TransactionTableTableAnnotationComposer a) f) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.contributorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContributorTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContributorTableTable,
    ContributorTableData,
    $$ContributorTableTableFilterComposer,
    $$ContributorTableTableOrderingComposer,
    $$ContributorTableTableAnnotationComposer,
    $$ContributorTableTableCreateCompanionBuilder,
    $$ContributorTableTableUpdateCompanionBuilder,
    (ContributorTableData, $$ContributorTableTableReferences),
    ContributorTableData,
    PrefetchHooks Function({bool transactionTableRefs})> {
  $$ContributorTableTableTableManager(
      _$AppDatabase db, $ContributorTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContributorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContributorTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContributorTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ContributorTableCompanion(
            id: id,
            name: name,
            notes: notes,
            colorInt: colorInt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> notes = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ContributorTableCompanion.insert(
            id: id,
            name: name,
            notes: notes,
            colorInt: colorInt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ContributorTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<ContributorTableData,
                            $ContributorTableTable, TransactionTableData>(
                        currentTable: table,
                        referencedTable: $$ContributorTableTableReferences
                            ._transactionTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContributorTableTableReferences(db, table, p0)
                                .transactionTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.contributorId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ContributorTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContributorTableTable,
    ContributorTableData,
    $$ContributorTableTableFilterComposer,
    $$ContributorTableTableOrderingComposer,
    $$ContributorTableTableAnnotationComposer,
    $$ContributorTableTableCreateCompanionBuilder,
    $$ContributorTableTableUpdateCompanionBuilder,
    (ContributorTableData, $$ContributorTableTableReferences),
    ContributorTableData,
    PrefetchHooks Function({bool transactionTableRefs})>;
typedef $$BeneficiaryTableTableCreateCompanionBuilder
    = BeneficiaryTableCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> relationship,
  Value<int?> colorInt,
  Value<bool> isActive,
});
typedef $$BeneficiaryTableTableUpdateCompanionBuilder
    = BeneficiaryTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> relationship,
  Value<int?> colorInt,
  Value<bool> isActive,
});

final class $$BeneficiaryTableTableReferences extends BaseReferences<
    _$AppDatabase, $BeneficiaryTableTable, BeneficiaryTableData> {
  $$BeneficiaryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
      _transactionTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionTable,
              aliasName: $_aliasNameGenerator(
                  db.beneficiaryTable.id, db.transactionTable.beneficiaryId));

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager = $$TransactionTableTableTableManager(
            $_db, $_db.transactionTable)
        .filter((f) => f.beneficiaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BeneficiaryTableTableFilterComposer
    extends Composer<_$AppDatabase, $BeneficiaryTableTable> {
  $$BeneficiaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionTableRefs(
      Expression<bool> Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.beneficiaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableFilterComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BeneficiaryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BeneficiaryTableTable> {
  $$BeneficiaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationship => $composableBuilder(
      column: $table.relationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$BeneficiaryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeneficiaryTableTable> {
  $$BeneficiaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => column);

  GeneratedColumn<int> get colorInt =>
      $composableBuilder(column: $table.colorInt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> transactionTableRefs<T extends Object>(
      Expression<T> Function($$TransactionTableTableAnnotationComposer a) f) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.beneficiaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BeneficiaryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BeneficiaryTableTable,
    BeneficiaryTableData,
    $$BeneficiaryTableTableFilterComposer,
    $$BeneficiaryTableTableOrderingComposer,
    $$BeneficiaryTableTableAnnotationComposer,
    $$BeneficiaryTableTableCreateCompanionBuilder,
    $$BeneficiaryTableTableUpdateCompanionBuilder,
    (BeneficiaryTableData, $$BeneficiaryTableTableReferences),
    BeneficiaryTableData,
    PrefetchHooks Function({bool transactionTableRefs})> {
  $$BeneficiaryTableTableTableManager(
      _$AppDatabase db, $BeneficiaryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeneficiaryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeneficiaryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeneficiaryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> relationship = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              BeneficiaryTableCompanion(
            id: id,
            name: name,
            relationship: relationship,
            colorInt: colorInt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> relationship = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              BeneficiaryTableCompanion.insert(
            id: id,
            name: name,
            relationship: relationship,
            colorInt: colorInt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BeneficiaryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<BeneficiaryTableData,
                            $BeneficiaryTableTable, TransactionTableData>(
                        currentTable: table,
                        referencedTable: $$BeneficiaryTableTableReferences
                            ._transactionTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BeneficiaryTableTableReferences(db, table, p0)
                                .transactionTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.beneficiaryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BeneficiaryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BeneficiaryTableTable,
    BeneficiaryTableData,
    $$BeneficiaryTableTableFilterComposer,
    $$BeneficiaryTableTableOrderingComposer,
    $$BeneficiaryTableTableAnnotationComposer,
    $$BeneficiaryTableTableCreateCompanionBuilder,
    $$BeneficiaryTableTableUpdateCompanionBuilder,
    (BeneficiaryTableData, $$BeneficiaryTableTableReferences),
    BeneficiaryTableData,
    PrefetchHooks Function({bool transactionTableRefs})>;
typedef $$AccountTableTableCreateCompanionBuilder = AccountTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String accountType,
  Value<double> initialBalance,
  Value<int?> colorInt,
  Value<String> currency,
  Value<bool> isActive,
});
typedef $$AccountTableTableUpdateCompanionBuilder = AccountTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> accountType,
  Value<double> initialBalance,
  Value<int?> colorInt,
  Value<String> currency,
  Value<bool> isActive,
});

final class $$AccountTableTableReferences extends BaseReferences<_$AppDatabase,
    $AccountTableTable, AccountTableData> {
  $$AccountTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
      _transactionTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionTable,
              aliasName: $_aliasNameGenerator(
                  db.accountTable.id, db.transactionTable.accountId));

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager =
        $$TransactionTableTableTableManager($_db, $_db.transactionTable)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountTableTable> {
  $$AccountTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionTableRefs(
      Expression<bool> Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableFilterComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountTableTable> {
  $$AccountTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorInt => $composableBuilder(
      column: $table.colorInt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$AccountTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountTableTable> {
  $$AccountTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => column);

  GeneratedColumn<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance, builder: (column) => column);

  GeneratedColumn<int> get colorInt =>
      $composableBuilder(column: $table.colorInt, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> transactionTableRefs<T extends Object>(
      Expression<T> Function($$TransactionTableTableAnnotationComposer a) f) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountTableTable,
    AccountTableData,
    $$AccountTableTableFilterComposer,
    $$AccountTableTableOrderingComposer,
    $$AccountTableTableAnnotationComposer,
    $$AccountTableTableCreateCompanionBuilder,
    $$AccountTableTableUpdateCompanionBuilder,
    (AccountTableData, $$AccountTableTableReferences),
    AccountTableData,
    PrefetchHooks Function({bool transactionTableRefs})> {
  $$AccountTableTableTableManager(_$AppDatabase db, $AccountTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> accountType = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AccountTableCompanion(
            id: id,
            name: name,
            accountType: accountType,
            initialBalance: initialBalance,
            colorInt: colorInt,
            currency: currency,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String accountType,
            Value<double> initialBalance = const Value.absent(),
            Value<int?> colorInt = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AccountTableCompanion.insert(
            id: id,
            name: name,
            accountType: accountType,
            initialBalance: initialBalance,
            colorInt: colorInt,
            currency: currency,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AccountTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<AccountTableData,
                            $AccountTableTable, TransactionTableData>(
                        currentTable: table,
                        referencedTable: $$AccountTableTableReferences
                            ._transactionTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountTableTableReferences(db, table, p0)
                                .transactionTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountTableTable,
    AccountTableData,
    $$AccountTableTableFilterComposer,
    $$AccountTableTableOrderingComposer,
    $$AccountTableTableAnnotationComposer,
    $$AccountTableTableCreateCompanionBuilder,
    $$AccountTableTableUpdateCompanionBuilder,
    (AccountTableData, $$AccountTableTableReferences),
    AccountTableData,
    PrefetchHooks Function({bool transactionTableRefs})>;
typedef $$TransactionTableTableCreateCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  Value<double> amount,
  required DateTime transactionDate,
  Value<String?> notes,
  required String transactionType,
  required int categoryId,
  Value<int?> contributorId,
  Value<int?> beneficiaryId,
  required int accountId,
  Value<DateTime> createdAt,
});
typedef $$TransactionTableTableUpdateCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<DateTime> transactionDate,
  Value<String?> notes,
  Value<String> transactionType,
  Value<int> categoryId,
  Value<int?> contributorId,
  Value<int?> beneficiaryId,
  Value<int> accountId,
  Value<DateTime> createdAt,
});

final class $$TransactionTableTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionTableTable, TransactionTableData> {
  $$TransactionTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoryTable.createAlias($_aliasNameGenerator(
          db.transactionTable.categoryId, db.categoryTable.id));

  $$CategoryTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoryTableTableTableManager($_db, $_db.categoryTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ContributorTableTable _contributorIdTable(_$AppDatabase db) =>
      db.contributorTable.createAlias($_aliasNameGenerator(
          db.transactionTable.contributorId, db.contributorTable.id));

  $$ContributorTableTableProcessedTableManager? get contributorId {
    final $_column = $_itemColumn<int>('contributor_id');
    if ($_column == null) return null;
    final manager =
        $$ContributorTableTableTableManager($_db, $_db.contributorTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contributorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BeneficiaryTableTable _beneficiaryIdTable(_$AppDatabase db) =>
      db.beneficiaryTable.createAlias($_aliasNameGenerator(
          db.transactionTable.beneficiaryId, db.beneficiaryTable.id));

  $$BeneficiaryTableTableProcessedTableManager? get beneficiaryId {
    final $_column = $_itemColumn<int>('beneficiary_id');
    if ($_column == null) return null;
    final manager =
        $$BeneficiaryTableTableTableManager($_db, $_db.beneficiaryTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beneficiaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountTable.createAlias($_aliasNameGenerator(
          db.transactionTable.accountId, db.accountTable.id));

  $$AccountTableTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountTableTableTableManager($_db, $_db.accountTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get transactionDate =>
      $composableBuilder(
          column: $table.transactionDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CategoryTableTableFilterComposer get categoryId {
    final $$CategoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableTableFilterComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContributorTableTableFilterComposer get contributorId {
    final $$ContributorTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contributorId,
        referencedTable: $db.contributorTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContributorTableTableFilterComposer(
              $db: $db,
              $table: $db.contributorTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BeneficiaryTableTableFilterComposer get beneficiaryId {
    final $$BeneficiaryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.beneficiaryId,
        referencedTable: $db.beneficiaryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BeneficiaryTableTableFilterComposer(
              $db: $db,
              $table: $db.beneficiaryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountTableTableFilterComposer get accountId {
    final $$AccountTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accountTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountTableTableFilterComposer(
              $db: $db,
              $table: $db.accountTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CategoryTableTableOrderingComposer get categoryId {
    final $$CategoryTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContributorTableTableOrderingComposer get contributorId {
    final $$ContributorTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contributorId,
        referencedTable: $db.contributorTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContributorTableTableOrderingComposer(
              $db: $db,
              $table: $db.contributorTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BeneficiaryTableTableOrderingComposer get beneficiaryId {
    final $$BeneficiaryTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.beneficiaryId,
        referencedTable: $db.beneficiaryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BeneficiaryTableTableOrderingComposer(
              $db: $db,
              $table: $db.beneficiaryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountTableTableOrderingComposer get accountId {
    final $$AccountTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accountTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountTableTableOrderingComposer(
              $db: $db,
              $table: $db.accountTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get transactionDate =>
      $composableBuilder(
          column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
      column: $table.transactionType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoryTableTableAnnotationComposer get categoryId {
    final $$CategoryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContributorTableTableAnnotationComposer get contributorId {
    final $$ContributorTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contributorId,
        referencedTable: $db.contributorTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContributorTableTableAnnotationComposer(
              $db: $db,
              $table: $db.contributorTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BeneficiaryTableTableAnnotationComposer get beneficiaryId {
    final $$BeneficiaryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.beneficiaryId,
        referencedTable: $db.beneficiaryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BeneficiaryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.beneficiaryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountTableTableAnnotationComposer get accountId {
    final $$AccountTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accountTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountTableTableAnnotationComposer(
              $db: $db,
              $table: $db.accountTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionTableTable,
    TransactionTableData,
    $$TransactionTableTableFilterComposer,
    $$TransactionTableTableOrderingComposer,
    $$TransactionTableTableAnnotationComposer,
    $$TransactionTableTableCreateCompanionBuilder,
    $$TransactionTableTableUpdateCompanionBuilder,
    (TransactionTableData, $$TransactionTableTableReferences),
    TransactionTableData,
    PrefetchHooks Function(
        {bool categoryId,
        bool contributorId,
        bool beneficiaryId,
        bool accountId})> {
  $$TransactionTableTableTableManager(
      _$AppDatabase db, $TransactionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> transactionType = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int?> contributorId = const Value.absent(),
            Value<int?> beneficiaryId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionTableCompanion(
            id: id,
            amount: amount,
            transactionDate: transactionDate,
            notes: notes,
            transactionType: transactionType,
            categoryId: categoryId,
            contributorId: contributorId,
            beneficiaryId: beneficiaryId,
            accountId: accountId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            required DateTime transactionDate,
            Value<String?> notes = const Value.absent(),
            required String transactionType,
            required int categoryId,
            Value<int?> contributorId = const Value.absent(),
            Value<int?> beneficiaryId = const Value.absent(),
            required int accountId,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionTableCompanion.insert(
            id: id,
            amount: amount,
            transactionDate: transactionDate,
            notes: notes,
            transactionType: transactionType,
            categoryId: categoryId,
            contributorId: contributorId,
            beneficiaryId: beneficiaryId,
            accountId: accountId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              contributorId = false,
              beneficiaryId = false,
              accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionTableTableReferences._categoryIdTable(db),
                    referencedColumn: $$TransactionTableTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (contributorId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.contributorId,
                    referencedTable: $$TransactionTableTableReferences
                        ._contributorIdTable(db),
                    referencedColumn: $$TransactionTableTableReferences
                        ._contributorIdTable(db)
                        .id,
                  ) as T;
                }
                if (beneficiaryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.beneficiaryId,
                    referencedTable: $$TransactionTableTableReferences
                        ._beneficiaryIdTable(db),
                    referencedColumn: $$TransactionTableTableReferences
                        ._beneficiaryIdTable(db)
                        .id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$TransactionTableTableReferences._accountIdTable(db),
                    referencedColumn: $$TransactionTableTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionTableTable,
    TransactionTableData,
    $$TransactionTableTableFilterComposer,
    $$TransactionTableTableOrderingComposer,
    $$TransactionTableTableAnnotationComposer,
    $$TransactionTableTableCreateCompanionBuilder,
    $$TransactionTableTableUpdateCompanionBuilder,
    (TransactionTableData, $$TransactionTableTableReferences),
    TransactionTableData,
    PrefetchHooks Function(
        {bool categoryId,
        bool contributorId,
        bool beneficiaryId,
        bool accountId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$ContributorTableTableTableManager get contributorTable =>
      $$ContributorTableTableTableManager(_db, _db.contributorTable);
  $$BeneficiaryTableTableTableManager get beneficiaryTable =>
      $$BeneficiaryTableTableTableManager(_db, _db.beneficiaryTable);
  $$AccountTableTableTableManager get accountTable =>
      $$AccountTableTableTableManager(_db, _db.accountTable);
  $$TransactionTableTableTableManager get transactionTable =>
      $$TransactionTableTableTableManager(_db, _db.transactionTable);
}
