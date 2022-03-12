import 'package:chess_lib/src/threat-detection.dart';

import 'castling.dart';
import 'chess-move.dart';
import 'chess-piece.dart';
import 'copy-board.dart';
import 'forsyth-edwards-notation.dart';
import 'known-board-positions.dart';
import 'move-executor.dart';
import 'player.dart';
import 'valid-move-calculator.dart';

/// Immutable Chess Game State. Can load from a fen with
/// [ChessGameState.fromFen], or create a new board with
/// [ChessGameState.initialBoardPosition]. From and position, get
/// valid moves with the [moves] accessor.
class ChessGameState {
  final ChessMove? lastMove;
  final List<List<ChessPiece>> board;
  final Player currentPlayer;
  final Set<Castling> availableCastling;
  final int moveCount; // counts up for both black and white

  List<ChessMove>? _moves;
  String? _fenPositionId;

  ChessGameState(
      {this.lastMove,
      required this.board,
      required this.currentPlayer,
      required this.availableCastling,
      required this.moveCount});

  factory ChessGameState.initialBoardPosition() {
    return ChessGameState(
        board: startingBoard,
        currentPlayer: Player.white,
        availableCastling: {
          Castling.white_long,
          Castling.white_short,
          Castling.black_long,
          Castling.black_short
        },
        moveCount: 0);
  }

  factory ChessGameState.fromFen(String fen) {
    return fromFen(fen);
  }

  bool get check => isCheck(currentPlayer, board);

  List<ChessMove> get moves {
    if (_moves == null) {
      _moves = getValidMoves(lastMove, currentPlayer, board, availableCastling);
    }
    return [..._moves!];
  }

  ChessGameState playMove(ChessMove move) {
    List<List<ChessPiece>> newBoard = copyBoard(board);
    doMove(move, newBoard);
    Set<Castling> newAvailableCastling = {};
    for (Castling c in availableCastling) {
      if (c.isEventuallyPossible(newBoard)) {
        newAvailableCastling.add(c);
      }
    }
    return ChessGameState(
        lastMove: move,
        board: newBoard,
        currentPlayer: currentPlayer.opposite,
        availableCastling: newAvailableCastling,
        moveCount: moveCount + 1);
  }

  ChessGameState copyGameState() {
    List<List<ChessPiece>> newBoard = copyBoard(board);
    return ChessGameState(
        lastMove: lastMove,
        board: newBoard,
        currentPlayer: currentPlayer,
        availableCastling: availableCastling,
        moveCount: moveCount);
  }

  String get forsythEdwardsNotation => getForsythEdwardsNotation(this);
  String get fenPositionId {
    if (_fenPositionId == null) {
      _fenPositionId = getFenPositionId(this);
    }
    return _fenPositionId!;
  }

  String get fenBoard {
    return getFenBoard(board);
  }
}
