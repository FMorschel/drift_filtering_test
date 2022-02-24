import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_table.g.dart';

enum Condition {
  equals,
  different,
  bigger,
  biggerOrEqual,
  smaller,
  smallerOrEqual,
  contains,
  valueIn,
  valueNotIn,
}

class Where<T> {
  const Where({
    required this.column,
    required this.condition,
    required this.value,
  });

  final GeneratedColumn<T> column;
  final Condition condition;
  final T value;

  Where<T> copyWith({
    GeneratedColumn<T>? column,
    Condition? condition,
    T? value,
  }) {
    return Where(
      column: column ?? this.column,
      condition: condition ?? this.condition,
      value: value ?? this.value,
    );
  }

  Expression<bool?> filter(_) {
    switch (condition) {
      case Condition.equals:
        return column.equals(value);
      case Condition.different:
        return column.equals(value).not();
      case Condition.bigger:
        final _column = column as GeneratedColumn<num?>;
        final _value = value as num?;
        return _column.isBiggerThanValue(_value);
      case Condition.biggerOrEqual:
        final _column = column as GeneratedColumn<num?>;
        final _value = value as num?;
        return _column.isBiggerOrEqualValue(_value);
      case Condition.smaller:
        final _column = column as GeneratedColumn<num?>;
        final _value = value as num?;
        return _column.isSmallerThanValue(_value);
      case Condition.smallerOrEqual:
        final _column = column as GeneratedColumn<num?>;
        final _value = value as num?;
        return _column.isSmallerOrEqualValue(_value);
      case Condition.valueIn:
        final values = value as Iterable<T>;
        return column.isIn(values);
      case Condition.valueNotIn:
        final values = value as Iterable<T>;
        return column.isNotIn(values);
      case Condition.contains:
        final _column = column as GeneratedColumn<String?>;
        final _value = value as String?;
        return _column.contains(_value ?? '');
    }
  }
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  DateTimeColumn get creation => dateTime().withDefault(currentDateAndTime)();
  TextColumn get content => text().named('body')();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    });
  }

  Future<int> insert(Insertable<Todo> todo) {
    return into(todos).insert(todo);
  }

  Stream<List<Todo>> watchEntries([
    List<Where> wheres = const [],
  ]) {
    SimpleSelectStatement<$TodosTable, Todo> selection = select(todos);
    for (int i = 0; i < (wheres.length); i++) {
      final where = wheres[i];
      selection = selection..where(where.filter);
    }
    return selection.watch();
  }
}
