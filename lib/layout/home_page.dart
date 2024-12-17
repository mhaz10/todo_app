import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:my_todo_app/modules/done_tasks/done_tasks.dart';
import 'package:my_todo_app/modules/new_tasks/new_tasks.dart';
import 'package:my_todo_app/shard/cubit/cubit.dart';
import 'package:my_todo_app/shard/cubit/states.dart';
import '../shard/components/components.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();

  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBade(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState){
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          };
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.deepPurple[300],
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Todo App',
              ),
            ),
            floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.add, color: Colors.deepPurple[300],),
                onPressed: () async {
                  if (AppCubit.get(context).isBottomSheetShown){
                     if (formKey.currentState!.validate()) {
                       AppCubit.get(context).insertToDatabase(
                           title: titleController.text,
                           time: timeController.text,
                           date: dateController.text);
                     }
                  } else {
                    scaffoldKey.currentState!.showBottomSheet(
                          (context) => Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              color: Colors.deepPurple.shade300
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    label: 'Title',
                                    icon: Icons.title
                                  ),
                                  const SizedBox(height: 10,),
                                  defaultFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.none,
                                      validator: (value){
                                        if (value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: (){
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()).then((value) {
                                              timeController.text = value!.format(context).toString();
                                            },);
                                      },
                                      label: 'Time',
                                      icon: Icons.watch_later_outlined),
                                  const SizedBox(height: 10,),
                                  defaultFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.none,
                                      validator: (value){
                                        if (value.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2040)).then((value) {
                                              dateController.text = DateFormat.yMMMd().format(value!);
                                        },);
                                      },
                                      label: 'Date',
                                      icon: Icons.calendar_month),
                                ],),
                            ),
                          ),).closed.then((value) {
                            AppCubit.get(context).isBottomSheetShown = false;
                          },);
                    AppCubit.get(context).changeBottomSheetState(true);
                  }
                }),
            bottomNavigationBar: AnimatedNotchBottomBar(
              color: Colors.deepPurple,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              notchColor: Colors.deepPurple.shade300,
              notchBottomBarController: _controller,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.menu, color: Colors.deepPurple[300],),
                  activeItem: Icon(Icons.menu, color: Colors.deepPurple),),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.check, color: Colors.deepPurple[300],),
                  activeItem: Icon(Icons.check, color: Colors.deepPurple),),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.archive, color: Colors.deepPurple[300],),
                  activeItem: Icon(Icons.archive, color: Colors.deepPurple),),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
              kBottomRadius: 28.0,
            ),
            body: PageView(
              controller: _pageController,
              children: [
                NewTasks(),
                const DoneTasks(),
                const ArchivedTasks(),
              ],
            ),
          );
        },
      ),
    );
  }
}

