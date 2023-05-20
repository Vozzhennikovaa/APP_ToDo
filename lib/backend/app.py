from datetime import datetime, timedelta
from flask import Flask, jsonify, request, make_response
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from werkzeug.security import generate_password_hash, check_password_hash
import sqlite3

app = Flask(__name__)


app.config['SECRET_KEY'] = 'super-secret-key'
app.config['JWT_SECRET_KEY'] = 'jwt-super-secret-key'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=24)


# Создание базы данных 
# Инициализация JWT
jwt = JWTManager(app)

# Создание подключения с базой данных
conn = sqlite3.connect('users.db')
c = conn.cursor()

# Создаём таблицу пользователей 
c.execute('''CREATE TABLE IF NOT EXISTS users
             (id INTEGER PRIMARY KEY AUTOINCREMENT,
             username TEXT NOT NULL,
             email TEXT NOT NULL UNIQUE,
             password TEXT NOT NULL)''')

# Завершение подключения
conn.close()

#Регистрация пользователей
@app.route('/register', methods=['POST'])
def register():
    # получаем данные
    data = request.get_json()
    username = data.get('username') 
    email = data.get('email') 
    password = data.get('password') 

    # Хэширование пароля 
    hashed_password = generate_password_hash(password, method='sha256')

    # Сохраняем пользователя в базу данных
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("INSERT INTO users (username, email, password) VALUES (?, ?, ?)", (username, email, hashed_password))
    conn.commit()
    conn.close()

   
    return jsonify({'message': 'Пользователь зарегистрирован успешно'})


# Авторизация
@app.route('/login', methods=['POST'])
def login():
    # получаем данные из запроса
    data = request.get_json()
    email = data.get('email') 
    password = data.get('password')

    # Поиск пользователя
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("SELECT * FROM users WHERE email=?", (email,))
    user = c.fetchone()
    conn.close()

    # Проверка пользователя на существование и пароля
    if user and check_password_hash(user[3], password):
        # Создание  токена
        access_token = create_access_token(identity=user[0], expires_delta=app.config['JWT_ACCESS_TOKEN_EXPIRES'])
        return jsonify({'access_token': access_token})
    else:
        return make_response('Логин или пароль неверный', 401)


@app.route('/getuser', methods=['GET'])
@jwt_required()
def protected():
    # Получаем пользователя из токена который сохранили во фронт
    user_id = get_jwt_identity()

    # Получаем данные о пользователе
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("SELECT * FROM users WHERE id=?", (user_id,))
    user = c.fetchone()
    conn.close()

    return jsonify({'id': user[0], 'username': user[1], 'email': user[2]})


if __name__ == '__main__':
    app.run(debug=True)