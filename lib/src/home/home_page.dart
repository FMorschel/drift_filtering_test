import 'package:drift/drift.dart' show Value, GeneratedColumn;
import 'package:drift_filtering_test/src/store/seach_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../drift table/drift_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final database = MyDatabase();
  late final search = Search(database);

  String dateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drift Filtering Test'),
        actions: [
          IconButton(
            onPressed: () {
              filters(context);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newTodo(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Observer(
        builder: (context) {
          return StreamBuilder<List<Todo>>(
            initialData: search.todos.value ?? [],
            stream: search.todos,
            builder: (context, snapshot) {
              final rows = snapshot.data!.map(
                (todo) => DataRow(
                  cells: [
                    DataCell(Text(todo.id.toString())),
                    DataCell(Text(todo.title)),
                    DataCell(Text(dateTime(todo.creation))),
                    DataCell(Text(todo.content)),
                  ],
                ),
              );
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Creation')),
                      DataColumn(label: Text('Content')),
                    ],
                    rows: rows.toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<dynamic> filters(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filters'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterWidget<int?>(
                  column: database.todos.id,
                  title: const Text('Id'),
                  parse: int.parse,
                  onFilterChanged: (filter) {
                    if (filter != null) {
                      search.addWheres((_) => [filter]);
                    } else {
                      final filters = [
                        ...search.filters.where(
                          (where) => where.column == database.todos.id,
                        )
                      ];
                      search.removeWheres((_) => filters);
                    }
                    debugPrint(
                      '${filter?.condition.name ?? 'No Condition'} '
                      '${filter?.value ?? 'No Value'}',
                    );
                  },
                ),
                FilterWidget<String?>(
                  column: database.todos.title,
                  title: const Text('Title'),
                  parse: (value) => value,
                  onFilterChanged: (filter) {
                    if (filter != null) {
                      final filters = [
                        ...search.filters.where(
                          (where) => where.column == database.todos.title,
                        )
                      ];
                      search.removeWheres((_) => filters);
                      search.addWheres((_) => [filter]);
                    }
                    debugPrint(
                      '${filter?.condition.name ?? 'No Condition'} '
                      '${filter?.value ?? 'No Value'}',
                    );
                  },
                ),
                FilterWidget<DateTime?>(
                  column: database.todos.creation,
                  title: const Text('Creation'),
                  parse: DateTime.parse,
                  onFilterChanged: (filter) {
                    if (filter != null) {
                      search.addWheres((_) => [filter]);
                    } else {
                      final filters = [
                        ...search.filters.where(
                          (where) => where.column == database.todos.creation,
                        )
                      ];
                      search.removeWheres((_) => filters);
                    }
                    debugPrint(
                      '${filter?.condition.name ?? 'No Condition'} '
                      '${filter?.value ?? 'No Value'}',
                    );
                  },
                ),
                FilterWidget<String?>(
                  column: database.todos.content,
                  title: const Text('Content'),
                  parse: (value) => value,
                  onFilterChanged: (filter) {
                    if (filter != null) {
                      search.addWheres((_) => [filter]);
                    } else {
                      final filters = [
                        ...search.filters.where(
                          (where) => where.column == database.todos.content,
                        )
                      ];
                      search.removeWheres((_) => filters);
                    }
                    debugPrint(
                      '${filter?.condition.name ?? 'No Condition'} '
                      '${filter?.value ?? 'No Value'}',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> newTodo(BuildContext context) {
    final title = TextEditingController(text: 'New Todo');
    title.selection = TextSelection(
      baseOffset: 0,
      extentOffset: title.text.length,
    );
    final titleNode = FocusNode();
    titleNode.requestFocus();
    final content = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          child: AlertDialog(
            title: TextFormField(
              controller: title,
              focusNode: titleNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Title'),
              ),
              validator: (text) {
                if ((text == null) || (text.length > 32) || (text.length < 6)) {
                  return 'Between 6 and 32 characters';
                } else {
                  return null;
                }
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            content: TextFormField(
              controller: content,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Content'),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              Builder(builder: (context) {
                return OutlinedButton(
                  onPressed: () async {
                    if (Form.of(context)?.validate() ?? false) {
                      await database.insert(TodosCompanion(
                        title: Value(title.text),
                        content: Value(content.text),
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class FilterWidget<T> extends StatelessWidget {
  const FilterWidget({
    Key? key,
    required this.title,
    required this.onFilterChanged,
    required this.column,
    required this.parse,
  }) : super(key: key);

  final Widget title;
  final GeneratedColumn<T> column;
  final void Function(Where? filter) onFilterChanged;
  final T Function(String text) parse;

  @override
  Widget build(BuildContext context) {
    final usingCondition = ValueNotifier<bool>(false);
    final selectedCondition = ValueNotifier<Condition?>(null);
    final date = ValueNotifier<DateTime?>(null);
    final data = ValueNotifier<String?>(null);
    final where = (T is DateTime?)
        ? ValueNotifier<Where<DateTime?>?>(null)
        : ValueNotifier<Where<T>?>(null);
    return ExpansionTile(
      title: title,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: usingCondition,
          builder: (context, value, _) {
            return CheckboxListTile(
              value: value,
              onChanged: (value) {
                if (value != null) {
                  usingCondition.value = value;
                  where.value = newFilter(selectedCondition, date, data);
                  onChanged(where, usingCondition);
                }
              },
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (T is DateTime?)
                    IconButton(
                      onPressed: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(0),
                          lastDate: DateTime.now()
                              .add(DateTime.now().difference(DateTime(0))),
                        );
                        date.value = newDate;
                        if ((newDate != null) && (T is DateTime?)) {
                          where.value = where.value?.copyWith(
                                value: newDate,
                              ) ??
                              newFilter(selectedCondition, date, data);
                        } else {
                          where.value = null;
                        }
                        onChanged(where, usingCondition);
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  if (T is! DateTime?)
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Value'),
                      ),
                      onChanged: (text) {
                        data.value = text;
                        if (text.isNotEmpty) {
                          where.value = where.value?.copyWith(
                                value: parse(text),
                              ) ??
                              newFilter(selectedCondition, date, data);
                        } else {
                          where.value = null;
                        }
                        onChanged(where, usingCondition);
                      },
                    ),
                  ValueListenableBuilder<Condition?>(
                    valueListenable: selectedCondition,
                    builder: (context, condition, _) {
                      return FittedBox(
                        child: DropdownButton<Condition>(
                          hint: const Text("Select condition"),
                          value: condition,
                          onChanged: (newCondition) {
                            selectedCondition.value = newCondition;
                            if (newCondition != null) {
                              where.value = where.value?.copyWith(
                                    condition: newCondition,
                                  ) ??
                                  newFilter(selectedCondition, date, data);
                            } else {
                              where.value = null;
                            }
                            onChanged(where, usingCondition);
                          },
                          items: Condition.values.map((condition) {
                            return DropdownMenuItem<Condition>(
                              value: condition,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  condition.name
                                    ..toLowerCase()
                                        .characters
                                        .first
                                        .toUpperCase(),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void onChanged(ValueNotifier<Where?> where, ValueNotifier<bool> using) {
    if (using.value) {
      onFilterChanged(where.value);
    } else {
      onFilterChanged(null);
    }
  }

  Where? newFilter(
    ValueNotifier<Condition?> selectedCondition,
    ValueNotifier<DateTime?> date,
    ValueNotifier<String?> data,
  ) {
    if (selectedCondition.value != null) {
      if ((T is DateTime?) && (date.value != null)) {
        return Where<DateTime?>(
          column: column as GeneratedColumn<DateTime?>,
          condition: selectedCondition.value!,
          value: date.value,
        );
      } else if (data.value != null) {
        return Where<T>(
          column: column,
          condition: selectedCondition.value!,
          value: parse(data.value!),
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
