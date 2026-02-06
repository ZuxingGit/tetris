import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/effects/bird_fly_effect.dart';
import 'package:tetris/effects/bubble_fly_effect.dart';
import 'package:tetris/effects/clear_effect_type.dart';
import 'package:tetris/effects/cloud_fly_effect.dart';
import 'package:tetris/effects/effect_layer.dart';
import 'package:tetris/effects/effect_widget.dart';
import 'package:tetris/effects/heart_fly_effect.dart';
import 'package:tetris/effects/particle/particle_effect.dart';
import 'package:tetris/effects/smoke/smoke_clear_effect.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

/*
GAME BOARD

This is a 2x2 grid with null representing empty spaces.
A non-empty space will have the color to represent the landed pieces

*/

// create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(rowLength, (j) => null),
);

class ClearedCell {
  final int row;
  final int col;
  final Tetromino type;

  ClearedCell(this.row, this.col, this.type);
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  // current score
  int currentScore = 0;

  // game over status
  bool gameOver = false;

  final Random _random = Random();

  final Map<int, GlobalKey> pixelKeys = {};

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // clear lines
        final List<int> clearedRows = [];
        final List<ClearedCell> clearedCells = []; // to store cleared cells
        clearLines(clearedRows, clearedCells);
        if (clearedRows.isNotEmpty && clearedCells.isNotEmpty) {
          playClearEffect(
            clearedRows,
            clearedCells,
            effect: randomClearEffect(),
          );
        }

        // check if piece has landed
        checkLanding();

        // check if game is over
        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
          return;
        }

        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  ClearEffectType randomClearEffect() {
    final effects = ClearEffectType.values;
    final list = effects.toList(growable: false);
    // return list[_random.nextInt(list.length)];
    return ClearEffectType.bubble;
  }

  // game over message
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over', textAlign: TextAlign.center),
        content: Text(
          'Your score: $currentScore',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // reset the game
              resetGame();

              Navigator.pop(context);
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  // reset game
  void resetGame() {
    // clear game board
    setState(() {
      gameBoard = List.generate(
        colLength,
        (i) => List.generate(rowLength, (j) => null),
      );

      // new game
      gameOver = false;
      currentScore = 0;

      // restart game loop
      startGame();
    });
  }

  // check for collision in a future position
  // return true -> there is a collision
  // return false -> no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the piece
      int row = currentPiece.position[i] ~/ rowLength;
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far to left/right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    return false;
  }

  void checkLanding() {
    // if going down will cause a collision
    if (checkCollision(Direction.down)) {
      // lock piece in place
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = currentPiece.position[i] ~/ rowLength;
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, generate a new piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
    Since our game over condition is if there is a piece at the top row, you want
    to check if the game is over when you create a new piece. Instead of checking every frame,
    because new pieces are allowed to go through the top level, but if there is 
    already a piece in the top level when a new piece is created, then the game is over.
    */
    if (isGameOver()) {
      setState(() {
        gameOver = true;
      });
    }
  }

  // move left
  void moveLeft() {
    // make sure the move is valid before moving
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    // make sure the move is valid before moving
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  /** clear lines */
  void clearLines(List<int> clearedRows, List<ClearedCell> clearedCells) {
    // step 1: Loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row is full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: If the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // add cleared row to the list
        clearedRows.add(row);
        // store cleared cells
        for (int col = 0; col < rowLength; col++) {
          clearedCells.add(ClearedCell(row, col, gameBoard[row][col]!));
        }
        // step 5: move all rows above down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(rowLength, (index) => null);

        // step 7: Increase the score!
        currentScore++;
        row++; // recheck the same row since rows have shifted down
      }
    }
  }

  void playClearEffect(
    List<int> clearedRows,
    List<ClearedCell> clearedCells, {
    ClearEffectType effect = ClearEffectType.heart,
  }) {
    if (clearedRows.isEmpty || clearedCells.isEmpty) return;

    // Particle should run once per cleared cell (not multiplied by row/col loops).
    if (effect == ClearEffectType.particle) {
      final first = clearedCells.first;
      final firstIndex = first.row * rowLength + first.col;
      final firstKey = pixelKeys[firstIndex];
      final fallbackSize = (firstKey?.currentContext != null)
          ? (firstKey!.currentContext!.findRenderObject() as RenderBox)
                .size
                .width
          : 22.0;

      for (final cell in clearedCells) {
        final color = tetrominoColors[cell.type]!;
        EffectLayer.of(context).play(
          ParticleClearEffect(
            startPosition: getCellPosition(cell.row, cell.col),
            size: fallbackSize,
            color: color,
          ),
        );
      }
      return;
    }

    // Non-particle effects: one effect per cleared cell.
    for (final cell in clearedCells) {
      final index = cell.row * rowLength + cell.col;
      final key = pixelKeys[index];
      if (key?.currentContext == null) continue;

      final box = key!.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      final EffectWidget effectWidget;
      switch (effect) {
        case ClearEffectType.heart:
          effectWidget = HeartFlyEffect(
            startPosition: position,
            size: box.size.width,
          );
          break;
        case ClearEffectType.bird:
          effectWidget = BirdFlyEffect(
            startPosition: position,
            size: box.size.width,
          );
          break;
        case ClearEffectType.cloud:
          effectWidget = CloudFlyEffect(
            startPosition: position,
            size: box.size.width,
          );
          break;
        case ClearEffectType.smoke:
          effectWidget = SmokeClearEffect(
            startPosition: position,
            size: box.size.width,
            color: tetrominoColors[cell.type]!,
          );
          break;
        case ClearEffectType.particle:
          continue;
        case ClearEffectType.bubble:
          effectWidget = BubbleFlyEffect(
            startPosition: position,
            size: box.size.width,
          );
          break;
      }

      EffectLayer.of(context).play(effectWidget);
    }
  }

  // GAME OVER METHOD
  bool isGameOver() {
    // if any piece in the top row is filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // GAME GRID
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                pixelKeys.putIfAbsent(index, () => GlobalKey());

                // get row and col of each index
                int row = index ~/ rowLength;
                int col = index % rowLength;

                // current moving piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    key: pixelKeys[index],
                    color: currentPiece.color,
                    child: index,
                  );
                }
                // landed piece
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    key: pixelKeys[index],
                    color: tetrominoColors[tetrominoType]!,
                    child: '',
                  ); // you can change color based on type
                }
                // blank pixel
                else {
                  return Pixel(
                    key: pixelKeys[index],
                    color: Colors.grey[900]!,
                    child: index,
                  );
                }
              },
            ),
          ),

          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),

          // GAME CONTROLS
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // left
                SizedBox.square(
                  dimension: 92,
                  child: ElevatedButton(
                    onPressed: moveLeft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_ios, size: 34),
                  ),
                ),

                // rotate
                SizedBox.square(
                  dimension: 92,
                  child: ElevatedButton(
                    onPressed: rotatePiece,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.rotate_right, size: 36),
                  ),
                ),

                // right
                SizedBox.square(
                  dimension: 92,
                  child: ElevatedButton(
                    onPressed: moveRight,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward_ios, size: 34),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Offset getCellPosition(int row, int col) {
    final index = row * rowLength + col;
    final key = pixelKeys[index];

    if (key?.currentContext == null) {
      return Offset.zero;
    }

    final box = key!.currentContext!.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    return position;
  }
}
