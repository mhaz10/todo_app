import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shard/components/components.dart';
import '../../shard/cubit/cubit.dart';
import '../../shard/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks ({super.key});

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit
        .get(context)
        .archivedTasks;

    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {

      },
      child: tasksBuilder(tasks: tasks),
    );
  }
}
