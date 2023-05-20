import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/layout/Login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
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
                  controller: _usernameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Введите имя пользователя';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Введите имя пользователя',
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
                    if ((value?.length ?? 0) < 6) {
                      return 'Пароль должен содержать не менее 6 символов';
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
                    // Отправить запрос на регистрацию API
                    String username = _usernameController.text.trim();
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    var response = await http.post(
                      // обращаемся к роутеру методом пост
                      Uri.parse('http://10.0.2.2:5000/register'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'username': username,
                        'email': email,
                        'password': password
                      }),
                    );

                    // Обработка ответа API
                    if (response.statusCode == 200) {
                      String message = jsonDecode(response.body)['message'];
                      if (message == "Пользователь зарегистрирован успешно") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    } else {
                      setState(() {
                        _errorMessage = 'Регистрация не удалась';
                      });
                    }
                  }
                },
                child: Text('Pегистрироваться'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'У вас уже есть аккаунт? Войдите здесь.',
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
