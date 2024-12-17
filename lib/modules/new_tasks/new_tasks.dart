import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/shard/components/components.dart';
import 'package:my_todo_app/shard/cubit/cubit.dart';
import 'package:my_todo_app/shard/cubit/states.dart';

class NewTasks extends StatelessWidget {
  NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit
        .get(context)
        .newTasks;

    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {

      },
      child: tasksBuilder(tasks: tasks),
    );
  }
}
