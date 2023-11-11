import 'dart:ui';
import 'board.dart';
import 'values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  int rotationState = 1;

  Color get color {
    return tetrominoColors[type] ??
        const Color(0xFFFFFFFF); 
  }

  void initalizePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }