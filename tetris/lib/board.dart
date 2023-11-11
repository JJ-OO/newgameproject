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
