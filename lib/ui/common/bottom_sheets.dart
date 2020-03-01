import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_state.dart';
import 'package:flutter_todo/generated/l10n.dart';
import 'package:flutter_todo/models/models.dart';
import 'package:flutter_todo/ui/common/show_date_time_picker.dart';
import 'package:flutter_todo/utils/formatter.dart';
import 'package:rxdart/rxdart.dart';

void showAddTodoBottomSheet(BuildContext context, Function(Todo) onAdded) {
  Todo todo = Todo();
  final BehaviorSubject<Todo> _todoSubject = BehaviorSubject<Todo>();
  DateTime date = DateTime.now();
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocListener<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoAddedState) {
                Navigator.of(context).pop();
              }
            },
            child: StreamBuilder<Todo>(
                stream: _todoSubject,
                initialData: todo,
                builder: (context, snapshot) {
                  var time =
                      Formatter.formatDateNotAgoFrom(snapshot.data.expired);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: S.of(context).titleHintText),
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            todo.title = value;
                            _todoSubject.add(todo);
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: S.of(context).descriptionHintText),
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            todo.description = value;
                            _todoSubject.add(todo);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  showDateTimePicker(
                                    context,
                                    current: date,
                                    onConfirm: (pick) {
                                      date = pick;
                                      todo.expired =
                                          pick.millisecondsSinceEpoch;
                                      _todoSubject.add(todo);
                                    },
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(time.isNotEmpty
                                        ? time
                                        : S.of(context).addTimeLabel)
                                  ],
                                ),
                              ),
                            ),
                            FlatButton(
                                onPressed: () {
                                  onAdded(todo);
                                },
                                child: Text(
                                  S.of(context).addLabel,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ))
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  );
                }),
          )).whenComplete(_todoSubject.close);
}
