import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/shard/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super (AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;

  void changeBottomSheetState(bool isBottomSheetShown) {
    this.isBottomSheetShown = isBottomSheetShown;
    emit(AppChangeBottomSheetState());
  }
  
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDataBade()async{
    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('DataBase Is Created');
        db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        ).then((value) {
          print('TABLE Is Created');
        }).catchError((error){
          print('Error When Creating Table ${error.toString()}');
        });
      },

      onOpen: (db) {
        print('DataBase Opened');
        getDataFromDatabase(db: db);
      },
    ).then((value) {
      database =  value;
      emit(AppCreateDatabaseState());
    },);
  }

  void insertToDatabase({required String title,required String time,required String date}) async{
    await database.transaction (
      (txn) async{
        await txn.rawInsert(
          'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")'
        ).then((value) {
          print('$value Inserted Successfully');
          getDataFromDatabase(db: database);
          emit(AppInsertDatabaseState());
        },).catchError((error){
          print('Error When Inserting New Record ${error.toString()}');
        });
      },
    );
  }

  void getDataFromDatabase({required Database db}) async{
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    await db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach(
        (element) {
          switch(element['status']){
            case 'new':
              newTasks.add(element);
              break;
            case 'done':
              doneTasks.add(element);
              break;
            case 'archived':
              archivedTasks.add(element);
              break;
          }
        },
      );
      emit(AppGetDatabaseState());
    },);
  }

  void updateDataBase({required String status,required int id}) async{
    await database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      print('DataBase Is Updated');
      getDataFromDatabase(db: database);
      emit(AppUpdateDatabaseState());
    },);
  }

  void deleteFromDataBase({required int id}){
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFromDatabase(db: database);
      emit(AppDeleteDatabaseState());
    },);
  }
}

