import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/layout/Register.dart';
import 'package:todo_app/layout/home_layout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Введите ваш адрес электронной почты';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Неверный адрес электронной почты';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Введите ваш email',
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: 300,
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Введите ваш пароль';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Введите ваш пароль',
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {


                  // Подтверждение входа пользователя
                  if (_formKey.currentState?.validate() ?? false) {
                    // Отправка запроса на вход в API
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    var response = await http.post(
                      // обращение к route /login методом пост
                      Uri.parse('http://10.0.2.2:5000/login'),
                      headers: {'Content-Type': 'application/json'},
                      // отправляем email и password 
                      body: jsonEncode({'email': email, 'password': password}),
                    );

                    // Обработка ответа от API
                    if (response.statusCode == 200) {
                      String token = jsonDecode(response.body)['access_token'];
                      print(token);
                      if (token.isNotEmpty) {
                        // сохраняем токен в локальной памяти телефона
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('accessToken', token);
                        // отправка пользователю главной старницы
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeLayout()),
                        );
                      }
                    } else {
                      setState(() {
                        _errorMessage =
                            'Неправильный адрес электронной почты или пароль';
                      });
                    }
                  }
                },
                child: Text('Авторизоваться'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Новый пользователь? Нажмите здесь.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
