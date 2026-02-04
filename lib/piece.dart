import 'dart:ui';

import 'package:tetris/board.dart';
import 'package:tetris/values.dart';

class Piece {
  // type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // the piece is just a list of integers
  List<int> position = [];

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF); //default white
  }

  // generate the integers
  void initializePiece() {
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
    }
  }

  // move piece in a direction
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
    }
  }

  // rotate piece
  int rotationState = 1;

  void rotatePiece() {
    // new positions after rotation
    List<int> newPosition = [];

    // rotate the piece based on its type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*
          o
          o
          o o
          */
            // get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // assign new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // assign new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // assign new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
              o
              o
            o o
            */
            // get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // assign new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // assign new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // assign new position
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            // vertical to horizontal
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // vertical to horizontal
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // horizontal to vertical
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // horizontal to vertical
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.O:
        // O piece does not rotate
        return;
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
              o o
            o o
            */
            // get the new position
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // assign new position
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // assign new position
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // assign new position
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
          default:
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
            o o
              o o
            */
            // get the new position
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // assign new position
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // assign new position
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // assign new position
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
              o
              o o
              o
            */
            // get the new position
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            // assign new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            // assign new position
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            // assign new position
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
      default:
    }
  }

  // check if valid position
  bool positionIsValid(int position) {
    // get the row and column of the position
    int row = position ~/ rowLength;
    int col = position % rowLength;

    // if the position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    // otherwise position is valid so return true
    return true;
  }

  // check if the piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      // get the col of position
      int col = pos % rowLength;

      // check if first column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      // check if last column is occupied
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
