import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  VoidCallback? onTap,
  required TextInputType keyboardType,
  required FormFieldValidator validator,
  required String label,
  required IconData icon,
  }){
  return TextFormField(
    controller: controller,
    onTap: onTap,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(20)
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20)),
    ),
  );
}

Widget buildTodoItem({required Map task,VoidCallback? onPressed,DismissDirectionCallback? onDismissed}){
  return Dismissible(
    key: Key(task['id'].toString()),
    background: Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.archive, color: Colors.white, size: 50,),
      ),
    ),
    secondaryBackground: Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 50,),
      ),
    ),
    onDismissed: onDismissed,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.check_circle,
                  color: Colors.deepPurple[300])),
            Expanded(
              child: Text(
                  '${task['title']}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${task['time']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,)
                ),
                Text(
                    '${task['date']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,)
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget tasksBuilder({required List<Map> tasks}){
  return ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) {
          return buildTodoItem(
              task: tasks[index],
              onPressed: (){
                AppCubit.get(context).updateDataBase(status: 'done', id: tasks[index]['id']);
              },
              onDismissed: (direction){
                if (direction == DismissDirection.startToEnd){
                  AppCubit.get(context).updateDataBase(status: 'archived', id: tasks[index]['id']);
                }else{
                  AppCubit.get(context).deleteFromDataBase(id: tasks[index]['id']);
                }
              }
          );
        },
        itemCount: tasks.length,
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notes_outlined,
              size: 80,
              color: Colors.white,),
            SizedBox(height: 5,),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),],),));
}