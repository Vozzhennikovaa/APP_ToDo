import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/default_form_field.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();
var formKey = GlobalKey<FormState>();

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
//cubit.titles[cubit.bottomNavigtionIndex],
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              key: scaffoldKey,
              body: cubit.screens[cubit.bottomNavigtionIndex],
              floatingActionButton: FloatingActionButton(
                backgroundColor: kThemeColorLight,
                child: cubit.floatingButtonIcon,
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .inserToDatabase(
                              title: titleController.text,
                              time: timeController.text,
                              date: dateController.text)
                          .then((value) {
                        Navigator.pop(context);
                        titleController.clear();
                        timeController.clear();
                        dateController.clear();

                        cubit.changeBottomSheetState(
                            false,
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ));
                      });
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                            (context) => SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          color: Colors.white10,
                                        ),
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 25,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Отмена',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 225, 71, 60),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 105,
                                            ),
                                            Text(
                                              'Добавить задачу',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15)),
                                          color: kThemeColorLight,
                                        ),
                                        child: Form(
                                          key: formKey,
                                          child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            child: Column(
                                              //mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                DefaultFormField(
                                                  controller: titleController,
                                                  label: 'Добавить задачу',
                                                  type: TextInputType.text,
                                                  validate: (String? value) {
                                                    if (value!.isEmpty) {
                                                      return 'Заголовок не должен быть пустым';
                                                    }
                                                    return null;
                                                  },
                                                  prefix: Icons.title,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DefaultFormField(
                                                    onTap: () {
                                                      showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now())
                                                          .then((value) =>
                                                              timeController
                                                                      .text =
                                                                  value!.format(
                                                                      context));
                                                    },
                                                    controller: timeController,
                                                    label: 'Время задачи',
                                                    type:
                                                        TextInputType.datetime,
                                                    validate: (String? value) {
                                                      if (value!.isEmpty) {
                                                        return 'Время не должно быть пустым';
                                                      }
                                                      return null;
                                                    },
                                                    prefix: Icons
                                                        .watch_later_outlined),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DefaultFormField(
                                                    onTap: () {
                                                      print('Tapped');
                                                      showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate: DateTime
                                                                  .parse(
                                                                      '2023-27-04'))
                                                          .then((value) =>
                                                              dateController
                                                                  .text = DateFormat
                                                                      .yMMMd()
                                                                  .format(
                                                                      value!));
                                                    },
                                                    controller: dateController,
                                                    label:
                                                        'Крайний срок задачи',
                                                    type:
                                                        TextInputType.datetime,
                                                    validate: (String? value) {
                                                      if (value!.isEmpty) {
                                                        return 'Необходимо указать дату';
                                                      }

                                                      return null;
                                                    },
                                                    prefix:
                                                        Icons.calendar_today),
                                                SizedBox(
                                                  height: 320,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            backgroundColor: kThemeColorLight)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          false, Icon(Icons.edit, color: Colors.white));
                    });

                    cubit.changeBottomSheetState(
                        true, Icon(Icons.add, color: Colors.blue[700]));
                  }
                },
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.white10, width: 1))),
                child: BottomNavigationBar(
                    unselectedItemColor: Colors.white,
                    backgroundColor: Color(0x95171717),
                    selectedItemColor: Colors.blue[700],
                    currentIndex: cubit.bottomNavigtionIndex,
                    onTap: (index) {
                      cubit.changeIndex(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.menu), label: 'Задания'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.check_circle_outline),
                          label: 'Выполненные'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.archive_outlined),
                          label: 'В архиве'),
                    ]),
              ),
            );
          }),
    );
  }
}
