// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seach_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Search on _SearchBase, Store {
  Computed<ObservableStream<List<dynamic>>>? _$todosComputed;

  @override
  ObservableStream<List<Todo>> get todos => (_$todosComputed ??=
          Computed<ObservableStream<List<Todo>>>(() => super.todos,
              name: '_SearchBase.todos'))
      .value as ObservableStream<List<Todo>>;

  final _$filtersAtom = Atom(name: '_SearchBase.filters');

  @override
  ObservableList<Where<dynamic>> get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(ObservableList<Where<dynamic>> value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

  final _$_SearchBaseActionController = ActionController(name: '_SearchBase');

  @override
  void setWheres(Iterable<Where<dynamic>> Function(Todos) fn) {
    final _$actionInfo = _$_SearchBaseActionController.startAction(
        name: '_SearchBase.setWheres');
    try {
      return super.setWheres(fn);
    } finally {
      _$_SearchBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeWheres(Iterable<Where<dynamic>> Function(Todos) fn) {
    final _$actionInfo = _$_SearchBaseActionController.startAction(
        name: '_SearchBase.removeWheres');
    try {
      return super.removeWheres(fn);
    } finally {
      _$_SearchBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addWheres(Iterable<Where<dynamic>> Function(Todos) fn) {
    final _$actionInfo = _$_SearchBaseActionController.startAction(
        name: '_SearchBase.addWheres');
    try {
      return super.addWheres(fn);
    } finally {
      _$_SearchBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filters: ${filters},
todos: ${todos}
    ''';
  }
}
