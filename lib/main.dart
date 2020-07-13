import 'package:flutter/material.dart';

void main() => runApp(ScreenWidget());

// класс ScreenWidget корневой, возвращает основу приложения и выводит класс BoardPage на домашней странице home

class ScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Крестики-нолики flutter',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BoardPage());
  }
}

//  класс BoardPage - класс с состоянием

class BoardPage extends StatefulWidget {
  @override // переписываем метод createState() у родительского класса и создаем состояние для нашего класса BoardPage
  _BoardPageState createState() {
    return new _BoardPageState();
  }
}

class _BoardPageState extends State<BoardPage> {
  String _lastChar; // переменная, определяющая кто последний ходил.

  List<List> _matrix; // объявляем переменную массив в массиве

  _BoardPageState() {
    _initMatrix();
  }

// инициализация - заполняем пробелами массив 3х3
  _initMatrix() {
    _matrix = List<List>(3);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
    _lastChar = 'O'; // На старте равно 'O', т.к первый ходит 'X'.
  }

// переписываем метод build() в котором выводим Scaffold(встроенный класс) с заготовком и телом
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Крестики-нолики flutter'),
        ),
        body: Center(
          // в теле выводим класс Center, который центрирует содержимое
          child: Column(
            //  выводим класс Column, который принимает массив children и распологает их вертикально
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // выводится будет 3 ряда, каждый из которых содержит массив из трех children
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(0,
                      0), // функция постройки элемента - клетки поля. Всего 9 клеток. В функцию передаем координаты каждой клетки.
                  _buildElement(0, 1),
                  _buildElement(0, 2),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(1, 0),
                  _buildElement(1, 1),
                  _buildElement(1, 2),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(2, 0),
                  _buildElement(2, 1),
                  _buildElement(2, 2),
                ],
              ),
            ],
          ),
        ));
  }

  _buildElement(int i, int j) {
    // функция постройки клетки
    return GestureDetector(
      // встроенный класс , дающий возможность привязывать обработчики к событиям.
      onTap: () {
        _changeMatrixField(i,
            j); // при событии onTap, выполняется функция _changeMatrixField, изменяющая состояние класса

        if (_checkWinner(i, j)) {
          // проверка на победу
          _showDialog(_matrix[i][j]);
        } else {
          if (_checkDraw()) {
            // проверка на ничью
            _showDialog(null);
          }
        }
      },
      child: Container(
        // встроенный класс Container, изображение клетки доски
        width: 90.0,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, border: Border.all(color: Colors.black)),
        child: Center(
          child: Text(
            _matrix[i]
                [j], // выводит значение массива с переданными координатами
            style: TextStyle(fontSize: 92.0),
          ),
        ),
      ),
    );
  }

  _changeMatrixField(int i, int j) {
    // метод/функция изменяющая состояние класса черех setState, после чего происходит перерисовка
    setState(() {
      if (_matrix[i][j] == ' ') {
        // проверка на пустоту клетки
        if (_lastChar == 'O')
          _matrix[i][j] = 'X'; // записывает в массив значение либо 'X'
        else
          _matrix[i][j] = 'O'; // либо 'O'

        _lastChar = _matrix[i][j]; // и меняет очередь хода
      }
    });
  }

  _checkDraw() {
    // метод проверки на ничью
    var draw = true;
    _matrix.forEach((i) {
      i.forEach((j) {
        if (j == ' ') draw = false; // есть ли пустые ' ' клетки, то нет ничьи
      });
    });
    return draw;
  }

  _checkWinner(int x, int y) {
    // метод проверки на победу
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = _matrix.length - 1;
    var player = _matrix[x][y];

    for (int i = 0; i < _matrix.length; i++) {
      if (_matrix[x][i] == player)
        col++; // проверка колонки на количество 'X'или 'O', смотря чей ход
      if (_matrix[i][y] == player)
        row++; // проверка ряда на количество 'X'или 'O', смотря чей ход
      if (_matrix[i][i] == player)
        diag++; // проверка диагонали на количество 'X'или 'O', смотря чей ход
      if (_matrix[i][n - i] == player)
        rdiag++; // проверка обратной диагонали на количество 'X'или 'O', смотря чей ход
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      // если хотя бы где-то равно 3, то победа
      return true;
    }
    return false;
  }

  _showDialog(String winner) {
    // метод вывода сообщений о победе или ничьей
    String dialogText;
    if (winner == null) {
      dialogText = 'Ничья';
    } else {
      dialogText = 'Игрок $winner победил';
    }

    showDialog(
        // встроенный метод showDialog, возвращающий AlertDialog окно с сообщениями и кнопкой
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Игра окончена'),
            content: Text(dialogText), // сообщение о победе или ничьей
            actions: <Widget>[
              FlatButton(
                // кнопка
                child: Text('Начать заново'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // возврат на домашнюю страницу home - на класс BoardPage
                  setState(() {
                    _initMatrix(); // по нажатию на кнопку вызов метода инициализация матрицы
                  });
                },
              )
            ],
          );
        });
  }
}
