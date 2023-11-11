import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';
import 'tile.dart';
import 'values.dart';

// dimensiones del tablero
int rowLength = 10;
int colLength = 15;

// crear tablero
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.T);

  int currentScore = 0;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.initalizePiece();

    Duration frameRate = const Duration(milliseconds: 400);

    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          clearLines();

          checkLanding();

          if (gameOver == true) {
            timer.cancel();
            showGameOverDialog();
          }

          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Has perdido!!'),
          content: Text('Tu puntaje final es: $currentScore'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                resetGame();

                Navigator.of(context).pop();
              },
              child: const Text('Jugar de nuevo'),
            ),
          ],
        );
      },
    );
  }
bool checkCollision({Direction? direction}) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    return false;
  }

  void checkLanding() {
    if (checkCollision(direction: Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initalizePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }


  void moveLeft() {
    if (!checkCollision(direction: Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
    checkLanding();
  }

  void moveRight() {
    if (!checkCollision(direction: Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
    checkLanding();
  }



  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
    checkLanding();
  }

  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );
    gameOver = false;
    currentScore = 0;
    createNewPiece();
    startGame();
  }

  @override

 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  if (currentPiece.position.contains(index)) {
                    return Tile(
                      color: currentPiece.color,
                    );
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Tile(
                      color: tetrominoColors[tetrominoType],
                    );
                  } else {
                    return Tile(
                      color: Colors.grey[900],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "SCORE: $currentScore",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: moveLeft,
                    color: Colors.grey,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: rotatePiece,
                    color: Colors.grey,
                    icon: const Icon(Icons.rotate_right),
                  ),
                  IconButton(
                    onPressed: moveRight,
                    color: Colors.grey,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
