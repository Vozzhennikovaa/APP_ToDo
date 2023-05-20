import 'package:flutter/material.dart';
import 'package:todo_app/layout/Login.dart';
import 'package:todo_app/shared/components/task_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewTasksScreen extends StatefulWidget {
  @override
  _NewTasksScreenState createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  late String _username = "";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    print('Access token: $accessToken');
 // обращаемся
    var url = Uri.parse('http://10.0.2.2:5000/getuser');
    // отправка токена 
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() { 
        _username = json.decode(response.body)["username"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).newTasks;
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                      Text(
                        "Добро пожаловать : ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        _username.toUpperCase(), // пользователь
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text("Выйти"),
                      ),
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
                  'Сделать',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: tasks.length > 0
                    ? Text(
                        'Новые задачи',
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TaskItem(
                          tasks: tasks[index],
                        );
                      },
                      itemCount: tasks.length,
                    )
                  : Container(
                      child: Center(
                        child: Image.asset(
                          'images/nodata2.png',
                          height: 350,
                          width: 350,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );  
  }
}
