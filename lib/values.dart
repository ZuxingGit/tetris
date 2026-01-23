import 'dart:ui';

// grid dimensions
int rowLength = 10;
int colLength = 15;

enum Direction { left, right, down }

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,

  /*
samples
  o
  o
  o o
  -----
    o
    o
  o o
  -----
  o
  o
  o
  o
  -----
  o o
  o o
  -----
    o o
  o o
  -----
  o o
    o o
  -----
    o
  o o o
*/
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFFA500), // Orange
  Tetromino.J: Color.fromARGB(255, 34, 113, 231), // Blue
  Tetromino.I: Color.fromARGB(255, 242, 0, 255), // Pink
  Tetromino.O: Color(0xFFFFFF00), // Yellow
  Tetromino.S: Color.fromARGB(255, 11, 237, 11), // Green
  Tetromino.Z: Color(0xFFFF0000), // Red
  Tetromino.T: Color.fromARGB(255, 147, 19, 245), // Purple
};
