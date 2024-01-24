import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/background.png'), // Replace with your image asset
            fit: BoxFit.cover, // You can adjust the BoxFit property as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your other UI components here
              TicTacToeBoard(),
            ],
          ),
        ),
      ),
    );
  }
}

class TicTacToeBoard extends StatefulWidget {
  @override
  _TicTacToeBoardState createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));

  bool isPlayerX = true; // true if it's player X's turn, false for player O
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Player: ${isPlayerX ? 'X' : 'O'}',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ 3;
                  int col = index % 3;

                  return GestureDetector(
                    onTap: () => _onTilePressed(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                              fontSize: 40,
                              color: board[row][col] == 'X'
                                  ? Colors.orange
                                  : Colors.indigoAccent,
                              //Color(0xff753a88),
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 40,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xffFEB809), Color(0xffFDEA2B)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _resetBoard,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onSurface: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Reset Board",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onTilePressed(int row, int col) {
    if (board[row][col].isEmpty && winner.isEmpty) {
      setState(() {
        board[row][col] = isPlayerX ? 'X' : 'O';
        isPlayerX = !isPlayerX;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    if (_checkRowWin() || _checkColumnWin() || _checkDiagonalWin()) {
      _showWinnerScreen();
    } else if (_isBoardFull()) {
      _showDrawScreen();
    }
  }

  bool _checkRowWin() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0].isNotEmpty) {
        winner = board[i][0];
        return true;
      }
    }
    return false;
  }

  bool _checkColumnWin() {
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i].isNotEmpty) {
        winner = board[0][i];
        return true;
      }
    }
    return false;
  }

  bool _checkDiagonalWin() {
    if ((board[0][0] == board[1][1] &&
            board[1][1] == board[2][2] &&
            board[0][0].isNotEmpty) ||
        (board[0][2] == board[1][1] &&
            board[1][1] == board[2][0] &&
            board[0][2].isNotEmpty)) {
      winner = board[1][1];
      return true;
    }
    return false;
  }

  bool _isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _resetBoard() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      isPlayerX = true;
      winner = '';
    });
  }

  void _showWinnerScreen() {
    _showCustomAlertDialog(
        context, 'images/winner.png', 'Player $winner Wins!');
  }

  void _showDrawScreen() {
    _showCustomAlertDialog(context, 'images/draw.png', "It's Draw!");
  }
}

void _showCustomAlertDialog(BuildContext context, String image, String title) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          height: 400,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffcaa1e6), Color(0xffa054d2)],
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              Image.asset(image),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Color(0xffFEB809), Color(0xffFDEA2B)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Exit"),
                              content: new Text("Do you really want to exit?"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Yes"),
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                ),
                                new TextButton(
                                  child: new Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Exit",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Color(0xffFEB809), Color(0xffFDEA2B)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicTacToeApp(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Play Again",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
