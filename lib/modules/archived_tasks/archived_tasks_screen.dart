import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/Login.dart';
import 'package:todo_app/shared/components/task_item.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return SafeArea(
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text("Выйти")),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Архив',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: tasks.length > 0
                        ? Text(
                            'Архивные задачи',
                            style: TextStyle(
                              color: Color.fromARGB(255, 34, 218, 255),
                              fontSize: 13,
                              fontFamily: 'NotoSans',
                            ),
                          )
                        : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  tasks.length > 0
                      ? ListView.builder(
                          //scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            //print(index);
                            return TaskItem(
                              tasks: tasks[index],
                            );
                          },
                          // separatorBuilder: (context, index) => Padding(
                          //       padding: const EdgeInsets.only(left: 20),
                          //       child: Container(
                          //         width: double.infinity,
                          //         height: 1.0,
                          //         color: Colors.grey[200],
                          //       ),
                          //     ),
                          itemCount: tasks.length)
                      : Container(
                          child: Center(
                              child: Image.asset(
                          'images/nodata2.png',
                          height: 350,
                          width: 350,
                        ))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
