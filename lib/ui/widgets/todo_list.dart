import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_event.dart';
import 'package:flutter_todo/models/models.dart';
import 'package:flutter_todo/sevices/services.dart';
import 'package:flutter_todo/ui/common/snack_bar.dart';
import 'package:flutter_todo/ui/screens/screens.dart';

import 'todo_item.dart';

class ListTodo extends StatefulWidget {
  final List<Todo> listTodo;
  final RefreshCallback onRefresh;
  final ScrollController controller;

  const ListTodo(
      {@required this.onRefresh, Key key, this.listTodo, this.controller})
      : super(key: key);

  @override
  _ListTodoState createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var todo = widget.listTodo[index];
              return TodoItem(
                todo: todo,
                onChanged: (todo) {
                  BlocProvider.of<TodoBloc>(context).add(TodoUpdateEvent(todo));

                  showUndoSnackBar(context, onUndo: () {
                    todo.done = !todo.done;
                    BlocProvider.of<TodoBloc>(context)
                        .add(TodoUpdateEvent(todo));
                  }, label: todo.done ? "1 completed" : "1 marked incomplete");
                },
                onPressed: () {
                  locator<NavigationService>()
                      .push(TodoDetailScreen.routeName, arguments: todo);
                },
              );
            },
            childCount: widget.listTodo.length,
          ),
        ),
      ],
    );
  }
}
