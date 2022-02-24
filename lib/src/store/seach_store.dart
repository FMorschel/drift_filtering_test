import 'package:mobx/mobx.dart';

import '../drift table/drift_table.dart';

part 'seach_store.g.dart';

class Search = _SearchBase with _$Search;

abstract class _SearchBase with Store {
  _SearchBase(this.database);

  final MyDatabase database;

  @observable
  // ignore: prefer_final_fields
  ObservableList<Where> filters = <Where>[].asObservable();

  @computed
  ObservableStream<List<Todo>> get todos {
    final stream = database.watchEntries(filters).asObservable();
    return stream;
  }

  @action
  void setWheres(Iterable<Where> Function(Todos todos) fn) {
    filters.clear();
    filters.addAll(fn(database.todos));
  }

  @action
  void removeWheres(Iterable<Where> Function(Todos todos) fn) {
    final wheres = fn(database.todos);
    for (final where in wheres) {
      filters.remove(where);
    }
  }

  @action
  void addWheres(Iterable<Where> Function(Todos todos) fn) {
    filters.addAll(fn(database.todos));
  }
}
